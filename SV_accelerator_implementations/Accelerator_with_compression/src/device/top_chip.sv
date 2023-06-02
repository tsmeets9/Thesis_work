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
    parameter int ADDR_WIDTH_MASKS = 11,
    parameter int ADDR_WIDTH_WEIGHTS = 12
  )
  (input logic clk,
   input logic arst_n_in,  //asynchronous reset, active low

   //encoded data
   input logic [MEM_BW-1:0] activations_input,
   input logic activations_valid,
   output logic activations_ready,
   
   //masks data
   input logic [MEM_BW-1:0] masks_input,
   input logic masks_valid,
   output logic masks_ready,
   
   //weights data
   input logic [MEM_BW-1:0] weights_input,
   input logic weights_valid,
   output logic weights_ready,

   //output
   output logic [MEM_BW-1:0] out_encoded,
   output logic [MEM_BW-1:0] out_masks,
   output logic output_valid_encoded,
   output logic output_valid_masks,

   input logic start,
   output logic running
  );
  
  // activations + weights registers
  logic write_activations_registers_first;
  logic write_activations_registers_second; 
  logic write_weights_registers; 
  logic shift; 
  
  //activations (encoded data) memory
  logic write_activations_memory;
  logic read_activations_memory;
  logic [ADDR_WIDTH_ACT-1:0] address_activations_writing;
  logic [ADDR_WIDTH_ACT-1:0] address_activations_reading;

  //masks memory
  logic write_masks_memory;
  logic read_masks_memory;
  logic [ADDR_WIDTH_MASKS-1:0] address_masks_writing;
  logic [ADDR_WIDTH_MASKS-1:0] address_masks_reading;
  logic CE_address_masks_writing;
  logic [31:0] masks_transferred_to_memory;

  logic [32-1:0] activation_rows_total;
  logic delayed_CE_address_masks_writing;
  logic [ADDR_WIDTH_MASKS-1:0] delayed_masks_transferred;

  //weights memory
  logic write_weights_memory;
  logic read_weights_memory;
  logic [ADDR_WIDTH_WEIGHTS-1:0] address_weights;

  logic mac_valid;
  logic mac_accumulate_internal;

  logic write_masks_registers [0:1][0:2][0:1];
  logic start_driver;
  logic reset_driver;
  logic [1:0] fx; 
  logic [1:0] fy;
  logic [31:0] start_address_encoded;
  logic ready_driver;
  
  logic driver_read_control;
  logic read_activations_memory_extra;
  logic [ADDR_WIDTH_ACT-1:0] address_activations_reading_extra;
  logic [MEM_BW-1:0] encoded_activations_driver;
  logic [15:0] masks_activations_driver;

  logic CE_decoder;
  logic CE_encoder; 

  // Packer
  logic [31:0] x_reg_for_encoder;
  logic start_packer; 
  logic ready_packer;

  logic [3:0] encoder_to_packer_counter;
  logic packer_write_control;
  logic write_activations_memory_extra;
  logic write_masks_memory_extra;

  logic [MEM_BW-1:0] output_encoded;
  logic [MEM_BW-1:0] output_masks;

  logic [ADDR_WIDTH_ACT-1:0] outputs_encoded_to_memory_counter;
  logic [ADDR_WIDTH_MASKS-1:0] outputs_masks_to_memory_counter;

  //Extra word logic 
  logic extra_word_write_valid;
  logic extra_word_write_ready;
  logic extra_word_read_valid;
  logic extra_word_read_ready;
  logic write_extra_word_in_register;
  logic extra_word_from_FIFO;
  
  logic zero_padding;
  logic reset_fifo;
  
  controller_fsm #(
  .FEATURE_MAP_WIDTH(FEATURE_MAP_WIDTH),
  .FEATURE_MAP_HEIGHT(FEATURE_MAP_HEIGHT),
  .INPUT_NB_CHANNELS(INPUT_NB_CHANNELS),
  .OUTPUT_NB_CHANNELS(OUTPUT_NB_CHANNELS),
  .KERNEL_SIZE(KERNEL_SIZE),
  .MEM_BW            (MEM_BW),
  .ADDR_WIDTH_ACT    (ADDR_WIDTH_ACT),
  .ADDR_WIDTH_MASKS  (ADDR_WIDTH_MASKS),
  .ADDR_WIDTH_WEIGHTS(ADDR_WIDTH_WEIGHTS)
  )
  controller
  (.clk(clk),
  .arst_n_in(arst_n_in),
  .start(start),
  .running(running),

  .activations_valid(activations_valid),
  .activations_ready(activations_ready),
  .masks_valid(masks_valid),
  .masks_ready(masks_ready),
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

  // Interfacing masks memory
  .write_masks_memory(write_masks_memory),
  .read_masks_memory(read_masks_memory),
  .address_masks_writing(address_masks_writing),
  .address_masks_reading(address_masks_reading),
  .CE_address_masks_writing(CE_address_masks_writing),
  .masks_transferred_to_memory(masks_transferred_to_memory),

  .activation_rows_total(activation_rows_total),
  .delayed_CE_address_masks_writing(delayed_CE_address_masks_writing),
  .delayed_masks_transferred(delayed_masks_transferred),

  .output_valid_encoded(output_valid_encoded),
  .output_valid_masks(output_valid_masks),

  // Driver logic 
  .ready_driver(ready_driver),
  .write_masks_registers(write_masks_registers),
  .start_driver(start_driver),
  .reset_driver(reset_driver),
  .fx(fx),
  .fy(fy),
  .start_address_encoded(start_address_encoded),
  .CE_decoder(CE_decoder),
  .CE_encoder(CE_encoder),

  // Packer logic 
  .x_reg_for_encoder(x_reg_for_encoder),
  .ready_packer(ready_packer),
  .start_packer(start_packer),
  .encoder_to_packer_counter(encoder_to_packer_counter),

  .outputs_encoded_to_memory_counter(outputs_encoded_to_memory_counter),
  .outputs_masks_to_memory_counter(outputs_masks_to_memory_counter),

  //Extra word logic 

  .extra_word_write_valid(extra_word_write_valid),
  .extra_word_write_ready(extra_word_write_ready),
  .extra_word_read_valid(extra_word_read_valid),
  .extra_word_read_ready(extra_word_read_ready),
  .write_extra_word_in_register(write_extra_word_in_register),
  .extra_word_from_FIFO(extra_word_from_FIFO),
  .zero_padding(zero_padding),
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

  //Weights driver 

  logic [IO_DATA_WIDTH-1:0] weights_out_driver [0:MEM_BW/IO_DATA_WIDTH-1];

  driver_weights #(
    .IO_DATA_WIDTH(IO_DATA_WIDTH),
    .MEM_BW(MEM_BW)
  )
  driver_weights_0
  (.weights_input(weights_out_memory), 
  .weights_output(weights_out_driver));

  // Masks memory (consisting of 4 memory banks)

  logic [MEM_BW-1:0] masks_out_memory_internal [0:3];

  generate
    for (k = 0; k < 4; k = k + 1) begin
      sky130_sram_1r1w_128x512_128 sram_masks_banks
      (.clk0(clk), 
      .csb0(packer_write_control? (write_masks_memory_extra || !(k == outputs_masks_to_memory_counter[ADDR_WIDTH_MASKS-1:ADDR_WIDTH_MASKS-2])) : (write_masks_memory || !(k == address_masks_writing[ADDR_WIDTH_MASKS-1:ADDR_WIDTH_MASKS-2]))), 
      .addr0(packer_write_control? outputs_masks_to_memory_counter[ADDR_WIDTH_MASKS-1-2:0] : address_masks_writing[ADDR_WIDTH_MASKS-1-2:0]), 
      .din0(packer_write_control? output_masks : masks_input), 
      .clk1(clk), 
      .csb1(read_masks_memory || !(k == address_masks_reading[ADDR_WIDTH_MASKS-1:ADDR_WIDTH_MASKS-2])), 
      .addr1(address_masks_reading[ADDR_WIDTH_MASKS-1-2:0]), 
      .dout1(masks_out_memory_internal[k]));
    end
  endgenerate 
  
  `REG(2, address_masks_select_delay);
  assign address_masks_select_delay_next = address_masks_reading[ADDR_WIDTH_MASKS-1:ADDR_WIDTH_MASKS-2];
  assign address_masks_select_delay_we   = 1;
  logic [MEM_BW-1:0] masks_out_memory;
  assign masks_out_memory = masks_out_memory_internal[address_masks_select_delay];


  index_table_logic #(
  .MEM_BW            (MEM_BW),
  .ADDR_WIDTH_ACT    (ADDR_WIDTH_ACT),
  .ADDR_WIDTH_MASKS  (ADDR_WIDTH_MASKS)
  )
  index_table_logic_0
  (.clk(clk),
  .arst_n_in(arst_n_in),
  .masks(masks_input),
  .CE_signal(CE_address_masks_writing),
  .masks_transferred(masks_transferred_to_memory),
  .activation_rows_total(activation_rows_total),
  .delayed_CE(delayed_CE_address_masks_writing),
  .delayed_masks_transferred(delayed_masks_transferred)
  );
  
  //Encoded data memory (consisting of 32 memory banks ) 

  logic [MEM_BW-1:0] activations_out_memory_internal [0:31];

  generate
    for (k = 0; k < 31; k = k + 1) begin
      sky130_sram_1r1w_128x512_128 sram_encoded_data_banks
      (.clk0(clk), 
      .csb0(packer_write_control? (write_activations_memory_extra || !(k == outputs_encoded_to_memory_counter[ADDR_WIDTH_ACT-1:ADDR_WIDTH_ACT-5])) : (write_activations_memory || !(k == address_activations_writing[ADDR_WIDTH_ACT-1:ADDR_WIDTH_ACT-5]))), 
      .addr0(packer_write_control? outputs_encoded_to_memory_counter[ADDR_WIDTH_ACT-1-5:0] : address_activations_writing[ADDR_WIDTH_ACT-1-5:0]), 
      .din0(packer_write_control? output_encoded : activations_input), 
      .clk1(clk), 
      .csb1(driver_read_control? (read_activations_memory_extra || !(k == address_activations_reading_extra[ADDR_WIDTH_ACT-1:ADDR_WIDTH_ACT-5])) : (read_activations_memory || !(k == address_activations_reading[ADDR_WIDTH_ACT-1:ADDR_WIDTH_ACT-5]))), 
      .addr1(driver_read_control? address_activations_reading_extra[ADDR_WIDTH_ACT-1-5:0] : address_activations_reading[ADDR_WIDTH_ACT-1-5:0]), 
      .dout1(activations_out_memory_internal[k]));
    end
  endgenerate 
  
  `REG(5, address_activations_select_delay);
  assign address_activations_select_delay_next = driver_read_control? address_activations_reading_extra[ADDR_WIDTH_ACT-1:ADDR_WIDTH_ACT-5] : address_activations_reading[ADDR_WIDTH_ACT-1:ADDR_WIDTH_ACT-5];
  assign address_activations_select_delay_we   = 1;
  logic [MEM_BW-1:0] activations_out_memory;
  assign activations_out_memory = activations_out_memory_internal[address_activations_select_delay];

  // Driver encoded data and masks

  driver_encoded_and_masks #(
    .IO_DATA_WIDTH(IO_DATA_WIDTH),
    .MEM_BW(MEM_BW),
    .ADDR_WIDTH_ACT(ADDR_WIDTH_ACT)
  )
  driver_encoded_and_masks_0
  (.clk(clk),
  .arst_n_in(arst_n_in),
  .encoded_input(activations_out_memory),
  .masks_input(masks_out_memory),
  .write_masks_registers(write_masks_registers),
  .start_driver(start_driver),
  .reset_driver(reset_driver),
  .fx(fx),
  .fy(fy),
  .start_address_encoded(start_address_encoded),
  .ready_driver(ready_driver),
  .driver_read_control(driver_read_control),
  .read_activations_memory_extra(read_activations_memory_extra),
  .address_activations_reading_extra(address_activations_reading_extra),
  .encoded_output(encoded_activations_driver),
  .masks_output(masks_activations_driver),
  .zero_padding(zero_padding)
  );

  // Decoder

  logic [IO_DATA_WIDTH-1:0] activations_out_decoder [0:MEM_BW/IO_DATA_WIDTH-1];

  decoder #(
    .IO_DATA_WIDTH(IO_DATA_WIDTH),
    .MEM_BW(MEM_BW)
  )
  decoder_0(
    .clk(clk),
    .CE(CE_decoder),
    .mask(masks_activations_driver),
    .to_decode(encoded_activations_driver),
    .decoded(activations_out_decoder)
  );

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
  .din(activations_out_decoder[15]),
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
          .din(shift ? 8'h0 : activations_out_decoder[i]),
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
          .din(write_activations_registers_first ? (shift? activation_registers[j][i+1] : activations_out_decoder[15]) : activations_out_decoder[i]),
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
          .din(shift ? activation_registers[j][i+1] : activations_out_decoder[i]),
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
          .din(shift ? activation_registers[j+1][0] : activations_out_decoder[i-1]),
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
        end
        else begin 
          register #(
          .WIDTH(IO_DATA_WIDTH)
          )
          shift_reg
          (
          .clk(clk),
          .arst_n_in(arst_n_in),
          .din(shift ? activation_registers[j][i+1] : activations_out_decoder[i-1]),
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

  // Relu implementation + trick to  don't have too much elements for encoding
  logic [IO_DATA_WIDTH-1:0] products_out_for_encoder [0:15];
  assign products_out_for_encoder[0] = (products_out[0][encoder_to_packer_counter][IO_DATA_WIDTH-1] == 0) && ((x_reg_for_encoder*16 + 0) <= (FEATURE_MAP_WIDTH-1))? products_out[0][encoder_to_packer_counter] : 0;
  assign products_out_for_encoder[1] = (products_out[1][encoder_to_packer_counter][IO_DATA_WIDTH-1] == 0) && ((x_reg_for_encoder*16 + 1) <= (FEATURE_MAP_WIDTH-1))? products_out[1][encoder_to_packer_counter] : 0;
  assign products_out_for_encoder[2] = (products_out[2][encoder_to_packer_counter][IO_DATA_WIDTH-1] == 0) && ((x_reg_for_encoder*16 + 2) <= (FEATURE_MAP_WIDTH-1))? products_out[2][encoder_to_packer_counter] : 0;
  assign products_out_for_encoder[3] = (products_out[3][encoder_to_packer_counter][IO_DATA_WIDTH-1] == 0) && ((x_reg_for_encoder*16 + 3) <= (FEATURE_MAP_WIDTH-1))? products_out[3][encoder_to_packer_counter] : 0;
  assign products_out_for_encoder[4] = (products_out[4][encoder_to_packer_counter][IO_DATA_WIDTH-1] == 0) && ((x_reg_for_encoder*16 + 4) <= (FEATURE_MAP_WIDTH-1))? products_out[4][encoder_to_packer_counter] : 0;
  assign products_out_for_encoder[5] = (products_out[5][encoder_to_packer_counter][IO_DATA_WIDTH-1] == 0) && ((x_reg_for_encoder*16 + 5) <= (FEATURE_MAP_WIDTH-1))? products_out[5][encoder_to_packer_counter] : 0;
  assign products_out_for_encoder[6] = (products_out[6][encoder_to_packer_counter][IO_DATA_WIDTH-1] == 0) && ((x_reg_for_encoder*16 + 6) <= (FEATURE_MAP_WIDTH-1))? products_out[6][encoder_to_packer_counter] : 0;
  assign products_out_for_encoder[7] = (products_out[7][encoder_to_packer_counter][IO_DATA_WIDTH-1] == 0) && ((x_reg_for_encoder*16 + 7) <= (FEATURE_MAP_WIDTH-1))? products_out[7][encoder_to_packer_counter] : 0;
  assign products_out_for_encoder[8] = (products_out[8][encoder_to_packer_counter][IO_DATA_WIDTH-1] == 0) && ((x_reg_for_encoder*16 + 8) <= (FEATURE_MAP_WIDTH-1))? products_out[8][encoder_to_packer_counter] : 0;
  assign products_out_for_encoder[9] = (products_out[9][encoder_to_packer_counter][IO_DATA_WIDTH-1] == 0) && ((x_reg_for_encoder*16 + 9) <= (FEATURE_MAP_WIDTH-1))? products_out[9][encoder_to_packer_counter] : 0;
  assign products_out_for_encoder[10] = (products_out[10][encoder_to_packer_counter][IO_DATA_WIDTH-1] == 0) && ((x_reg_for_encoder*16 + 10) <= (FEATURE_MAP_WIDTH-1))? products_out[10][encoder_to_packer_counter] : 0;
  assign products_out_for_encoder[11] = (products_out[11][encoder_to_packer_counter][IO_DATA_WIDTH-1] == 0) && ((x_reg_for_encoder*16 + 11) <= (FEATURE_MAP_WIDTH-1))? products_out[11][encoder_to_packer_counter] : 0;
  assign products_out_for_encoder[12] = (products_out[12][encoder_to_packer_counter][IO_DATA_WIDTH-1] == 0) && ((x_reg_for_encoder*16 + 12) <= (FEATURE_MAP_WIDTH-1))? products_out[12][encoder_to_packer_counter] : 0;
  assign products_out_for_encoder[13] = (products_out[13][encoder_to_packer_counter][IO_DATA_WIDTH-1] == 0) && ((x_reg_for_encoder*16 + 13) <= (FEATURE_MAP_WIDTH-1))? products_out[13][encoder_to_packer_counter] : 0;
  assign products_out_for_encoder[14] = (products_out[14][encoder_to_packer_counter][IO_DATA_WIDTH-1] == 0) && ((x_reg_for_encoder*16 + 14) <= (FEATURE_MAP_WIDTH-1))? products_out[14][encoder_to_packer_counter] : 0;
  assign products_out_for_encoder[15] = (products_out[15][encoder_to_packer_counter][IO_DATA_WIDTH-1] == 0) && ((x_reg_for_encoder*16 + 15) <= (FEATURE_MAP_WIDTH-1))? products_out[15][encoder_to_packer_counter] : 0;

  //Encoder

  logic [MEM_BW-1:0] encoded_output_encoder;
  logic [15:0] masks_output_encoder;

  encoder #(
    .IO_DATA_WIDTH(IO_DATA_WIDTH),
    .MEM_BW(MEM_BW)
  )
  encoder_0(
    .clk(clk),
    .CE(CE_encoder),
    .to_encode(products_out_for_encoder),
    .mask(masks_output_encoder),
    .encoded(encoded_output_encoder)
  );

  // Packer

  packer #(
    .IO_DATA_WIDTH(IO_DATA_WIDTH),
    .MEM_BW(MEM_BW), 
    .ADDR_WIDTH_ACT(ADDR_WIDTH_ACT),
    .ADDR_WIDTH_MASKS(ADDR_WIDTH_MASKS)
  )
  packer_0
  (.clk(clk),
  .arst_n_in(arst_n_in),
  .masks_in(masks_output_encoder),
  .encoded_in(encoded_output_encoder),
  .encoder_to_packer_counter(encoder_to_packer_counter),
  
  .start_packer(start_packer),
  .ready_packer(ready_packer),
  
  .packer_write_control(packer_write_control),
  .write_activations_memory_extra(write_activations_memory_extra),
  .write_masks_memory_extra(write_masks_memory_extra),
  
  .output_encoded(output_encoded),
  .output_masks(output_masks),
  
  .outputs_encoded_to_memory_counter(outputs_encoded_to_memory_counter),
  .outputs_masks_to_memory_counter(outputs_masks_to_memory_counter));

  assign out_encoded = activations_out_memory;
  assign out_masks = masks_out_memory;


endmodule
