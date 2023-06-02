module packer #(
  parameter int IO_DATA_WIDTH = 16,
  parameter int MEM_BW = 128,
  parameter int ADDR_WIDTH_ACT = 14,
  parameter int ADDR_WIDTH_MASKS = 11
  )
  (input logic clk,
  input logic arst_n_in, //asynchronous reset, active low

  input logic [15:0] masks_in,
  input logic [MEM_BW-1:0] encoded_in,
  input logic [3:0] encoder_to_packer_counter,
  
  input logic start_packer,
  output logic ready_packer,

  output logic packer_write_control,
  output logic write_activations_memory_extra,
  output logic write_masks_memory_extra,

  output logic [MEM_BW-1:0] output_encoded,
  output logic [MEM_BW-1:0] output_masks,

  output logic [ADDR_WIDTH_ACT-1:0] outputs_encoded_to_memory_counter,
  output logic [ADDR_WIDTH_MASKS-1:0] outputs_masks_to_memory_counter


  );
    logic load_shift_registers;
    logic shift_encoded;


    `REG(4, encoder_to_packer_counter_reg);
    assign encoder_to_packer_counter_reg_next = encoder_to_packer_counter;

    logic [4:0] ones_in_masks;
    logic [4:0] shift_encoded_number;

    //Update shiftkeeper 
    `REG(4, shift_keeper_reg);
    assign shift_keeper_reg_next = shift_keeper_reg + shift_encoded_number;
    assign shift_keeper_reg_we = shift_encoded;
    count_ones #(
    .MEM_BW            (16)
    )
    count_ones_0
    (.input_word(masks_in),
    .output_count(ones_in_masks));
    
    logic subtraction_ones_in_masks;
    `REG(5, ones_in_masks_reg);
    assign ones_in_masks_reg_next = subtraction_ones_in_masks? (ones_in_masks_reg + shift_keeper_reg - 16): ones_in_masks ;


    // Outputs encoded to memory counter

    `REG(32, outputs_encoded_to_memory_counter_internal);
    assign outputs_encoded_to_memory_counter_internal_next = outputs_encoded_to_memory_counter_internal + 1;
    assign outputs_encoded_to_memory_counter = outputs_encoded_to_memory_counter_internal[ADDR_WIDTH_ACT-1:0];

    // Outputs masks to memory counter
    
    `REG(32, outputs_masks_to_memory_counter_internal);
    assign outputs_masks_to_memory_counter_internal_next = outputs_masks_to_memory_counter_internal + 1;
    assign outputs_masks_to_memory_counter = outputs_masks_to_memory_counter_internal[ADDR_WIDTH_MASKS-1:0];
  
    // Generate the mask registers 

    logic [2*IO_DATA_WIDTH-1:0] masks_registers [0:15];
    genvar l,k,j,i;
    generate
      for (i = 0; i <= 15; i = i + 1) begin
        register #(
        .WIDTH(2*IO_DATA_WIDTH)
        )
        shift_reg
        (
        .clk(clk),
        .arst_n_in(arst_n_in),
        .din(masks_in),
        .qout(masks_registers[i]),
        .we((load_shift_registers && encoder_to_packer_counter_reg == i))
        );
      end
    endgenerate

    logic nb_of_mask_transfer;
    assign nb_of_mask_transfer = outputs_masks_to_memory_counter%2;
    
    assign output_masks[MEM_BW - 1 - 16*0: MEM_BW - 16 - 16*0] = masks_registers[0 + 8*nb_of_mask_transfer];
    assign output_masks[MEM_BW - 1 - 16*1: MEM_BW - 16 - 16*1] = masks_registers[1 + 8*nb_of_mask_transfer];
    assign output_masks[MEM_BW - 1 - 16*2: MEM_BW - 16 - 16*2] = masks_registers[2 + 8*nb_of_mask_transfer];
    assign output_masks[MEM_BW - 1 - 16*3: MEM_BW - 16 - 16*3] = masks_registers[3 + 8*nb_of_mask_transfer];
    assign output_masks[MEM_BW - 1 - 16*4: MEM_BW - 16 - 16*4] = masks_registers[4 + 8*nb_of_mask_transfer];
    assign output_masks[MEM_BW - 1 - 16*5: MEM_BW - 16 - 16*5] = masks_registers[5 + 8*nb_of_mask_transfer];
    assign output_masks[MEM_BW - 1 - 16*6: MEM_BW - 16 - 16*6] = masks_registers[6 + 8*nb_of_mask_transfer];
    assign output_masks[MEM_BW - 1 - 16*7: MEM_BW - 16 - 16*7] = masks_registers[7 + 8*nb_of_mask_transfer];
    
    //Split the encoded_input into 16 groups of 8 bits. 

    logic [IO_DATA_WIDTH-1:0] splitted_encoded_input [0:15];
    generate
    for (i = 0; i < MEM_BW/(IO_DATA_WIDTH); i = i + 1) begin
    assign splitted_encoded_input[i] = encoded_in[MEM_BW - 1 - 8*i: MEM_BW - 8 - 8*i];
    end
    endgenerate

    // Generate the encoded registers 

    logic [IO_DATA_WIDTH-1:0] pack_encoded_registers [0:31];
    generate
      for (i = 31; i >= 0; i = i - 1) begin
        register #(
        .WIDTH(IO_DATA_WIDTH)
        )
        shift_reg
        (
        .clk(clk),
        .arst_n_in(arst_n_in),
        .din(!shift_encoded ? splitted_encoded_input[i%16] : (
                (shift_encoded_number == 'd0)? pack_encoded_registers[i] : 
                (shift_encoded_number == 'd1)? ((i+1 > 31)? '0 : pack_encoded_registers[i+1]) : 
                (shift_encoded_number == 'd2)? ((i+2 > 31)? '0 : pack_encoded_registers[i+2]) : 
                (shift_encoded_number == 'd3)? ((i+3 > 31)? '0 : pack_encoded_registers[i+3]) :
                (shift_encoded_number == 'd4)? ((i+4 > 31)? '0 : pack_encoded_registers[i+4]) :
                (shift_encoded_number == 'd5)? ((i+5 > 31)? '0 : pack_encoded_registers[i+5]) :
                (shift_encoded_number == 'd6)? ((i+6 > 31)? '0 : pack_encoded_registers[i+6]) :
                (shift_encoded_number == 'd7)? ((i+7 > 31)? '0 : pack_encoded_registers[i+7]) : 
                (shift_encoded_number == 'd8)? ((i+8 > 31)? '0 : pack_encoded_registers[i+8]) :
                (shift_encoded_number == 'd9)? ((i+9 > 31)? '0 : pack_encoded_registers[i+9]) :
                (shift_encoded_number == 'd10)? ((i+10 > 31)? '0 : pack_encoded_registers[i+10]) : 
                (shift_encoded_number == 'd11)? ((i+11 > 31)? '0 : pack_encoded_registers[i+11]) :
                (shift_encoded_number == 'd12)? ((i+12 > 31)? '0 : pack_encoded_registers[i+12]) : 
                (shift_encoded_number == 'd13)? ((i+13 > 31)? '0 : pack_encoded_registers[i+13]) : 
                (shift_encoded_number == 'd14)? ((i+14 > 31)? '0 : pack_encoded_registers[i+14]) : 
                (shift_encoded_number == 'd15)? ((i+15 > 31)? '0 : pack_encoded_registers[i+15]) :
                (shift_encoded_number == 'd16)? ((i+16 > 31)? '0 : pack_encoded_registers[i+16]) : pack_encoded_registers[i])),
        .qout(pack_encoded_registers[i]),
        .we(((load_shift_registers && (i/16 == 1)) || shift_encoded))
        );
    end
    endgenerate

    assign output_encoded[MEM_BW - 1 - 8*0: MEM_BW - 8 - 8*0] = pack_encoded_registers[0];
    assign output_encoded[MEM_BW - 1 - 8*1: MEM_BW - 8 - 8*1] = pack_encoded_registers[1];
    assign output_encoded[MEM_BW - 1 - 8*2: MEM_BW - 8 - 8*2] = pack_encoded_registers[2];
    assign output_encoded[MEM_BW - 1 - 8*3: MEM_BW - 8 - 8*3] = pack_encoded_registers[3];
    assign output_encoded[MEM_BW - 1 - 8*4: MEM_BW - 8 - 8*4] = pack_encoded_registers[4];
    assign output_encoded[MEM_BW - 1 - 8*5: MEM_BW - 8 - 8*5] = pack_encoded_registers[5];
    assign output_encoded[MEM_BW - 1 - 8*6: MEM_BW - 8 - 8*6] = pack_encoded_registers[6];
    assign output_encoded[MEM_BW - 1 - 8*7: MEM_BW - 8 - 8*7] = pack_encoded_registers[7];
    assign output_encoded[MEM_BW - 1 - 8*8: MEM_BW - 8 - 8*8] = pack_encoded_registers[8];
    assign output_encoded[MEM_BW - 1 - 8*9: MEM_BW - 8 - 8*9] = pack_encoded_registers[9];
    assign output_encoded[MEM_BW - 1 - 8*10: MEM_BW - 8 - 8*10] = pack_encoded_registers[10];
    assign output_encoded[MEM_BW - 1 - 8*11: MEM_BW - 8 - 8*11] = pack_encoded_registers[11];
    assign output_encoded[MEM_BW - 1 - 8*12: MEM_BW - 8 - 8*12] = pack_encoded_registers[12];
    assign output_encoded[MEM_BW - 1 - 8*13: MEM_BW - 8 - 8*13] = pack_encoded_registers[13];
    assign output_encoded[MEM_BW - 1 - 8*14: MEM_BW - 8 - 8*14] = pack_encoded_registers[14];
    assign output_encoded[MEM_BW - 1 - 8*15: MEM_BW - 8 - 8*15] = pack_encoded_registers[15];


    typedef enum {IDLE, LOAD_MASKS_AND_ENCODED, SHIFT_1, WRITE_TO_MEMORY, SHIFT_2, SHIFT_LAST, WRITE_TO_MEMORY_LAST_NO_SHIFT_2, WRITE_TO_MEMORY_LAST, WRITE_TO_MEMORY_LAST_2} fsm_state;
    fsm_state current_state;
    fsm_state next_state;

    always @ (posedge clk or negedge arst_n_in) begin
        if(arst_n_in==0) begin
        current_state <= IDLE;
        end else begin
        current_state <= next_state;
        end
    end

    always_comb begin 
    
    encoder_to_packer_counter_reg_we = 0;
    load_shift_registers = 0;
    ones_in_masks_reg_we = 0;

    shift_encoded = 0;

    subtraction_ones_in_masks = 0;

    ready_packer = 0;
    shift_encoded_number = 0;
    packer_write_control = 0;
    outputs_masks_to_memory_counter_internal_we = 0;
    outputs_encoded_to_memory_counter_internal_we = 0;
    write_activations_memory_extra = 1;
    write_masks_memory_extra = 1;
    case (current_state)
        IDLE: begin
            encoder_to_packer_counter_reg_we = 1;
            next_state = start_packer? LOAD_MASKS_AND_ENCODED : IDLE;            
        end
        LOAD_MASKS_AND_ENCODED: begin 
            load_shift_registers = 1;
            ones_in_masks_reg_we = 1;
            next_state = SHIFT_1;
        end 
        SHIFT_1: begin
          shift_encoded = (ones_in_masks_reg != 0);
          shift_encoded_number = (ones_in_masks_reg >= (16-shift_keeper_reg))? (16-shift_keeper_reg) : ones_in_masks_reg;
          ones_in_masks_reg_we = (ones_in_masks_reg >= (16-shift_keeper_reg));
          subtraction_ones_in_masks = (ones_in_masks_reg >= (16-shift_keeper_reg)); 
          ready_packer = ((ones_in_masks_reg < (16-shift_keeper_reg)) && (encoder_to_packer_counter_reg != 15));
          next_state = (ones_in_masks_reg >= (16-shift_keeper_reg))? WRITE_TO_MEMORY : ((encoder_to_packer_counter_reg != 15)? IDLE : SHIFT_LAST);
        end 
        WRITE_TO_MEMORY: begin 
          packer_write_control = 1;
          outputs_encoded_to_memory_counter_internal_we = 1;
          write_activations_memory_extra = 0; 
          ready_packer = ((ones_in_masks_reg == 0) && (encoder_to_packer_counter_reg != 15));
          next_state = (ones_in_masks_reg == 0)? ((encoder_to_packer_counter_reg == 15)? WRITE_TO_MEMORY_LAST_NO_SHIFT_2 : IDLE) : (SHIFT_2); 
        end 
        SHIFT_2: begin 
            shift_encoded = 1;
            shift_encoded_number = ones_in_masks_reg;
            ready_packer = (encoder_to_packer_counter_reg != 15);
            next_state = (encoder_to_packer_counter_reg == 15)? SHIFT_LAST : IDLE;
        end 
        SHIFT_LAST: begin 
            shift_encoded = (shift_keeper_reg != 0);
            shift_encoded_number = (16-shift_keeper_reg);
            next_state = (ones_in_masks_reg == 0 && shift_keeper_reg == 0)? WRITE_TO_MEMORY_LAST_NO_SHIFT_2 : WRITE_TO_MEMORY_LAST;
        end 
        WRITE_TO_MEMORY_LAST: begin
            packer_write_control = 1;
            outputs_encoded_to_memory_counter_internal_we = 1;
            outputs_masks_to_memory_counter_internal_we = 1;
            write_activations_memory_extra = 0;
            write_masks_memory_extra = 0;
            next_state = WRITE_TO_MEMORY_LAST_2;
        end
        WRITE_TO_MEMORY_LAST_NO_SHIFT_2: begin 
            packer_write_control = 1;
            outputs_masks_to_memory_counter_internal_we = 1;
            write_masks_memory_extra = 0;
            next_state = WRITE_TO_MEMORY_LAST_2;
        end
        WRITE_TO_MEMORY_LAST_2: begin
            packer_write_control = 1;
            outputs_masks_to_memory_counter_internal_we = 1;
            write_masks_memory_extra = 0;
            ready_packer = 1;
            next_state = IDLE;
        end 
    endcase
  end 
endmodule