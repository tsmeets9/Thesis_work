module top_chip #(
    parameter int IO_DATA_WIDTH = 8,
    parameter int ACCUMULATION_WIDTH = 32,
    parameter int FEATURE_MAP_WIDTH = 56,
    parameter int FEATURE_MAP_HEIGHT = 56,
    parameter int INPUT_NB_CHANNELS = 64,
    parameter int OUTPUT_NB_CHANNELS = 64,
    parameter int KERNEL_SIZE = 3,
    parameter int MEM_BW = 128,
    parameter int ADDR_WIDTH_ACT = 14,
    parameter int ADDR_WIDTH_WEIGHTS = 12
  )
  (input logic clk,
   input logic arst_n_in,  //asynchronous reset, active low

   //system inputs and outputs
   input logic [MEM_BW-1:0] activations_input,
   input logic activations_valid,
   output logic activations_ready,
   input logic [MEM_BW-1:0] weights_input,
   input logic weights_valid,
   output logic weights_ready,

   //output
   output logic [MEM_BW-1:0] out,
   output logic output_valid,

   input logic start,
   output logic running
  );
  
  // activations + weights registers
  logic write_activations_registers_first;
  logic write_activations_registers_second; 
  logic write_weights_registers; 
  logic shift; 

  //activations memory
  logic write_activations_memory;
  logic read_activations_memory;
  logic [ADDR_WIDTH_ACT-1:0] address_activations_writing;
  logic [ADDR_WIDTH_ACT-1:0] address_activations_reading;
  
  //weights memory 
  logic write_weights_memory;
  logic read_weights_memory;
  logic [ADDR_WIDTH_WEIGHTS-1:0] address_weights;

  logic mac_valid;
  logic mac_accumulate_internal;

  logic [3:0] mem_transfer_counter;

  //Extra word logic 
  logic extra_word_write_valid;
  logic extra_word_write_ready;
  logic extra_word_read_valid;
  logic extra_word_read_ready;
  logic write_extra_word_in_register;
  logic extra_word_from_FIFO;
  
  logic end_x_padding;
  logic reset_fifo;
  controller_fsm #(
  .FEATURE_MAP_WIDTH(FEATURE_MAP_WIDTH),
  .FEATURE_MAP_HEIGHT(FEATURE_MAP_HEIGHT),
  .INPUT_NB_CHANNELS(INPUT_NB_CHANNELS),
  .OUTPUT_NB_CHANNELS(OUTPUT_NB_CHANNELS),
  .KERNEL_SIZE(KERNEL_SIZE),
  .MEM_BW            (MEM_BW),
  .ADDR_WIDTH_ACT    (ADDR_WIDTH_ACT),
  .ADDR_WIDTH_WEIGHTS(ADDR_WIDTH_WEIGHTS)
  )
  controller
  (.clk(clk),
  .arst_n_in(arst_n_in),
  .start(start),
  .running(running),

  .activations_valid(activations_valid),
  .activations_ready(activations_ready),
  .weights_valid(weights_valid),
  .weights_ready(weights_ready),
  .write_activations_registers_first(write_activations_registers_first),
  .write_activations_registers_second(write_activations_registers_second),
  .shift(shift),
  .write_weights_registers(write_weights_registers),
  .mac_valid(mac_valid),
  .mac_accumulate_internal(mac_accumulate_internal),

  // Interfacing weights memory
  .write_weights_memory(write_weights_memory),
  .read_weights_memory(read_weights_memory),
  .address_weights(address_weights),

  // Interfacing activations memory
  .write_activations_memory(write_activations_memory),
  .read_activations_memory(read_activations_memory),
  .address_activations_writing(address_activations_writing),
  .address_activations_reading(address_activations_reading),

  .output_valid(output_valid),
  .outputs_transferred_to_memory(mem_transfer_counter),
  .outputs_to_memory_flag(outputs_to_memory_flag),

  //Extra word logic 

  .extra_word_write_valid(extra_word_write_valid),
  .extra_word_write_ready(extra_word_write_ready),
  .extra_word_read_valid(extra_word_read_valid),
  .extra_word_read_ready(extra_word_read_ready),
  .write_extra_word_in_register(write_extra_word_in_register),
  .extra_word_from_FIFO(extra_word_from_FIFO),
  .end_x_padding(end_x_padding),
  .reset_fifo(reset_fifo)
  );

  // Weights memory (consisting of 8 memory banks)

  logic [MEM_BW-1:0] weights_out_memory_internal [0:7];

  genvar k;
  generate
    for (k = 0; k < 8; k = k + 1) begin
      sky130_sram_1r1w_128x512_128 sram_weights_banks
      (.clk0(clk), 
      .csb0(write_weights_memory || !(k == address_weights[ADDR_WIDTH_WEIGHTS-1:ADDR_WIDTH_WEIGHTS-3])), 
      .addr0(address_weights[ADDR_WIDTH_WEIGHTS-1-3:0]), 
      .din0(weights_input), 
      .clk1(clk), 
      .csb1(read_weights_memory || !(k == address_weights[ADDR_WIDTH_WEIGHTS-1:ADDR_WIDTH_WEIGHTS-3])), 
      .addr1(address_weights[ADDR_WIDTH_WEIGHTS-1-3:0]), 
      .dout1(weights_out_memory_internal[k]));
    end
  endgenerate 
  
  `REG(3, address_weights_select_delay);
  assign address_weights_select_delay_next = address_weights[ADDR_WIDTH_WEIGHTS-1:ADDR_WIDTH_WEIGHTS-3];
  assign address_weights_select_delay_we   = 1;
  logic [MEM_BW-1:0] weights_out_memory;
  assign weights_out_memory = weights_out_memory_internal[address_weights_select_delay];

  // Weights driver
  logic [IO_DATA_WIDTH-1:0] weights_out_driver [0:MEM_BW/IO_DATA_WIDTH-1];

  driver_weights #(
    .IO_DATA_WIDTH(IO_DATA_WIDTH),
    .MEM_BW(MEM_BW)
  )
  driver_weights_0
  (.weights_input(weights_out_memory), 
  .weights_output(weights_out_driver));

  // Activations memory (consisting of 8 memory banks)

  logic [MEM_BW-1:0] activations_memory_input;
  logic [MEM_BW-1:0] activations_out_memory_internal [0:31];

  generate
    for (k = 0; k < 32; k = k + 1) begin
      sky130_sram_1r1w_128x512_128 sram_activations_banks
      (.clk0(clk), 
      .csb0(write_activations_memory || !(k == address_activations_writing[ADDR_WIDTH_ACT-1:ADDR_WIDTH_ACT-5])), 
      .addr0(address_activations_writing[ADDR_WIDTH_ACT-1-5:0]), 
      .din0(activations_memory_input), 
      .clk1(clk), 
      .csb1(read_activations_memory || !(k == address_activations_reading[ADDR_WIDTH_ACT-1:ADDR_WIDTH_ACT-5])), 
      .addr1(address_activations_reading[ADDR_WIDTH_ACT-1-5:0]), 
      .dout1(activations_out_memory_internal[k]));
    end
  endgenerate 

  `REG(5, address_activations_select_delay);
  assign address_activations_select_delay_next = address_activations_reading[ADDR_WIDTH_ACT-1:ADDR_WIDTH_ACT-5];
  assign address_activations_select_delay_we   = 1;
  logic [MEM_BW-1:0] activations_out_memory;
  assign activations_out_memory = activations_out_memory_internal[address_activations_select_delay];
  
  logic [IO_DATA_WIDTH-1:0] activations_out_driver [0:MEM_BW/IO_DATA_WIDTH-1];

  // Activations driver
  driver_activations #(
    .IO_DATA_WIDTH(IO_DATA_WIDTH),
    .MEM_BW(MEM_BW)
  )
  driver_activations_0
  (.activations_input(activations_out_memory), 
  .activations_output(activations_out_driver));

  // FIFO for extra word (padding)

  logic signed [IO_DATA_WIDTH-1:0] output_FIFO;

  logic total_reset_fifo;
  assign total_reset_fifo = arst_n_in && reset_fifo;
  fifo #(
    .WIDTH(IO_DATA_WIDTH),
    .LOG2_OF_DEPTH(10),
    .USE_AS_EXTERNAL_FIFO(0)
  )
  fifo_0
  (.clk(clk),
  .arst_n_in(total_reset_fifo),
  .din(activations_out_driver[15]),
  .input_valid(extra_word_write_valid),
  .input_ready(extra_word_write_ready),
  .qout(output_FIFO),
  .output_valid(extra_word_read_valid),
  .output_ready(extra_word_read_ready));
  
  logic signed [IO_DATA_WIDTH-1:0] extra_word;
  assign extra_word = extra_word_from_FIFO? output_FIFO : 0;

  // Activations registers

  logic signed [IO_DATA_WIDTH-1:0] activation_registers [0:1][0:15];
  genvar j,i;
  generate
  for (j = 1; j >= 0; j = j - 1) begin 
    for (i = 15; i >= 0; i = i - 1) begin
      if (j == 1) begin 
        if(i == 15) begin
          register #(
          .WIDTH(IO_DATA_WIDTH)
          )
          shift_reg
          (
          .clk(clk),
          .arst_n_in(arst_n_in),
          .din(end_x_padding? 8'h0 : (shift ? 8'h0 : activations_out_driver[i])),
          .qout(activation_registers[j][i]),
          .we(write_activations_registers_second)
          );
        end else if (i == 0) begin 
          register #(
          .WIDTH(IO_DATA_WIDTH)
          )
          shift_reg
          (
          .clk(clk),
          .arst_n_in(arst_n_in),
          .din(write_activations_registers_first ? (shift? activation_registers[j][i+1] : activations_out_driver[15]) : (end_x_padding? 8'h0 : activations_out_driver[i])),
          .qout(activation_registers[j][i]),
          .we(write_activations_registers_first || write_activations_registers_second)
          );
        end
        else begin 
          register #(
          .WIDTH(IO_DATA_WIDTH)
          )
          shift_reg
          (
          .clk(clk),
          .arst_n_in(arst_n_in),
          .din(end_x_padding? 8'h0 : (shift ? activation_registers[j][i+1] : activations_out_driver[i])),
          .qout(activation_registers[j][i]),
          .we(write_activations_registers_second)
          );
        end
      end 
      else begin 
        if(i == 15) begin
          register #(
          .WIDTH(IO_DATA_WIDTH)
          )
          shift_reg
          (
          .clk(clk),
          .arst_n_in(arst_n_in),
          .din(shift ? activation_registers[j+1][0] : activations_out_driver[i-1]),
          .qout(activation_registers[j][i]),
          .we(write_activations_registers_first)
          );
        end
        else if (i == 0) begin  
          register #(
          .WIDTH(IO_DATA_WIDTH)
          )
          shift_reg
          (
          .clk(clk),
          .arst_n_in(arst_n_in),
          .din(shift ? activation_registers[j][i+1] : extra_word),
          .qout(activation_registers[j][i]),
          .we(write_activations_registers_first || write_extra_word_in_register)
          );
        end else begin 
          register #(
          .WIDTH(IO_DATA_WIDTH)
          )
          shift_reg
          (
          .clk(clk),
          .arst_n_in(arst_n_in),
          .din(shift ? activation_registers[j][i+1] : activations_out_driver[i-1]),
          .qout(activation_registers[j][i]),
          .we(write_activations_registers_first)
          );
        end
      end
    end
  end
  endgenerate

  // Weights registers

  logic signed [IO_DATA_WIDTH-1:0] weights_registers [0:15];
  generate
    for (k = 0; k < 16; k = k + 1) begin
      register #(
      .WIDTH(IO_DATA_WIDTH)
      )
      reg_weights
      (
      .clk(clk),
      .arst_n_in(arst_n_in),
      .din(weights_out_driver[k]),
      .qout(weights_registers[k]),
      .we(write_weights_registers)
      );
    end
  endgenerate 

  // PE array 

  logic signed [IO_DATA_WIDTH-1:0] products_out [0:15][0:15];

  PE_array #(
    .A_WIDTH(IO_DATA_WIDTH),
    .B_WIDTH(IO_DATA_WIDTH),
    .ACCUMULATOR_WIDTH(ACCUMULATION_WIDTH),
    .OUTPUT_WIDTH(IO_DATA_WIDTH),
    .OUTPUT_SCALE(0)
  )
  PE_array
  (.clk(clk),
   .arst_n_in(arst_n_in),
   .input_valid(mac_valid),
   .accumulate_internal(mac_accumulate_internal),
   .activations(activation_registers[0][0:15]),
   .weights(weights_registers),
   .outs(products_out));

  // Relu implementation
  logic [IO_DATA_WIDTH-1:0] products_out_for_packer [0:15];
  assign products_out_for_packer[0] = (products_out[0][mem_transfer_counter][IO_DATA_WIDTH-1] == 0)? products_out[0][mem_transfer_counter] : 0;
  assign products_out_for_packer[1] = (products_out[1][mem_transfer_counter][IO_DATA_WIDTH-1] == 0)? products_out[1][mem_transfer_counter] : 0;
  assign products_out_for_packer[2] = (products_out[2][mem_transfer_counter][IO_DATA_WIDTH-1] == 0)? products_out[2][mem_transfer_counter] : 0;
  assign products_out_for_packer[3] = (products_out[3][mem_transfer_counter][IO_DATA_WIDTH-1] == 0)? products_out[3][mem_transfer_counter] : 0;
  assign products_out_for_packer[4] = (products_out[4][mem_transfer_counter][IO_DATA_WIDTH-1] == 0)? products_out[4][mem_transfer_counter] : 0;
  assign products_out_for_packer[5] = (products_out[5][mem_transfer_counter][IO_DATA_WIDTH-1] == 0)? products_out[5][mem_transfer_counter] : 0;
  assign products_out_for_packer[6] = (products_out[6][mem_transfer_counter][IO_DATA_WIDTH-1] == 0)? products_out[6][mem_transfer_counter] : 0;
  assign products_out_for_packer[7] = (products_out[7][mem_transfer_counter][IO_DATA_WIDTH-1] == 0)? products_out[7][mem_transfer_counter] : 0;
  assign products_out_for_packer[8] = (products_out[8][mem_transfer_counter][IO_DATA_WIDTH-1] == 0)? products_out[8][mem_transfer_counter] : 0;
  assign products_out_for_packer[9] = (products_out[9][mem_transfer_counter][IO_DATA_WIDTH-1] == 0)? products_out[9][mem_transfer_counter] : 0;
  assign products_out_for_packer[10] = (products_out[10][mem_transfer_counter][IO_DATA_WIDTH-1] == 0)? products_out[10][mem_transfer_counter] : 0;
  assign products_out_for_packer[11] = (products_out[11][mem_transfer_counter][IO_DATA_WIDTH-1] == 0)? products_out[11][mem_transfer_counter] : 0;
  assign products_out_for_packer[12] = (products_out[12][mem_transfer_counter][IO_DATA_WIDTH-1] == 0)? products_out[12][mem_transfer_counter] : 0;
  assign products_out_for_packer[13] = (products_out[13][mem_transfer_counter][IO_DATA_WIDTH-1] == 0)? products_out[13][mem_transfer_counter] : 0;
  assign products_out_for_packer[14] = (products_out[14][mem_transfer_counter][IO_DATA_WIDTH-1] == 0)? products_out[14][mem_transfer_counter] : 0;
  assign products_out_for_packer[15] = (products_out[15][mem_transfer_counter][IO_DATA_WIDTH-1] == 0)? products_out[15][mem_transfer_counter] : 0;

  // Packer

  logic [MEM_BW-1: 0] packed_data;
  packer #(
    .IO_DATA_WIDTH(IO_DATA_WIDTH),
    .MEM_BW(MEM_BW)
  )
  packer_0
  (.outputs_in(products_out_for_packer), 
  .outputs_out(packed_data));

  assign activations_memory_input = outputs_to_memory_flag ? packed_data : activations_input;
  assign out = activations_out_memory;


endmodule
