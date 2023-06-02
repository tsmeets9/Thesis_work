module driver_encoded_and_masks #(
  parameter int IO_DATA_WIDTH = 8,
  parameter int MEM_BW = 128,
  parameter int ADDR_WIDTH_ACT = 14

  )
  ( input logic clk,
    input logic arst_n_in, //asynchronous reset, active low
    input logic [MEM_BW-1:0] encoded_input,
    input logic [MEM_BW-1:0] masks_input, 
    input logic write_masks_registers[0:1][0:2][0:1],
    
    // SIGNALS FOR WHEN DRIVER IS ENABLED
    input logic start_driver,
    input logic reset_driver,
    input logic [1:0] fx,
    input logic [1:0] fy,
    input logic [31:0] start_address_encoded,
    output logic ready_driver,
    output logic driver_read_control,
    output logic read_activations_memory_extra,
    output logic [ADDR_WIDTH_ACT-1:0] address_activations_reading_extra,
    output logic [MEM_BW-1:0] encoded_output,
    output logic [15:0] masks_output,

    //padding
    input logic zero_padding
  );
    logic shift_masks;
    logic shift_encoded;
    logic [4:0] shift_encoded_number;

    logic [3:0] shift_keeper [0:1][0:2];  
    logic [31:0] activations_fetch_counter [0:1][0:2];
    logic write_encoded_registers_extra [0:1][0:2][0:1];
    logic shift_encoded_select [0:1][0:2][0:1];

    genvar l,k,j,i;

    initial begin
        for (int i=0; i<2; i++) begin 
            for (int j=0; j<3; j++) begin 
                shift_keeper[i][j] = 0;
                activations_fetch_counter[i][j] = 2;
            end
        end 
    end

    `REG(2, fx_reg);
    `REG(2, fy_reg);
    assign fx_reg_next = fx;
    assign fy_reg_next = fy;
    
    //Split the masks_input into 8 groups of 16 bits. 
    logic [(2*IO_DATA_WIDTH-1):0] splitted_masks_input [0:7];
    generate
    for (i = 0; i < MEM_BW/(2*IO_DATA_WIDTH); i = i + 1) begin
    assign splitted_masks_input[i] = masks_input[MEM_BW - 1 - 16*i: MEM_BW - 16 - 16*i];
    end
    endgenerate

    //Split the encoded_input into 16 groups of 8 bits. 
    logic [IO_DATA_WIDTH-1:0] splitted_encoded_input [0:15];
    generate
    for (i = 0; i < MEM_BW/(IO_DATA_WIDTH); i = i + 1) begin
    assign splitted_encoded_input[i] = encoded_input[MEM_BW - 1 - 8*i: MEM_BW - 8 - 8*i];
    end
    endgenerate

    
    // Generate the mask registers 
    logic [2*IO_DATA_WIDTH-1:0] masks_registers [0:1][0:2][0:1][0:7];
    generate
    for (l = 0; l < 2; l = l + 1) begin 
        for (k = 0; k < 3; k = k + 1) begin  
            for (j = 1; j >= 0; j = j - 1) begin 
                for (i = 7; i >= 0; i = i - 1) begin
                    if (j == 1) begin 
                        if(i == 7) begin
                        register #(
                        .WIDTH(2*IO_DATA_WIDTH)
                        )
                        shift_reg
                        (
                        .clk(clk),
                        .arst_n_in(arst_n_in),
                        .din(zero_padding? 16'h0 : (shift_masks ? 16'h0 : splitted_masks_input[i])),
                        .qout(masks_registers[l][k][j][i]),
                        .we(write_masks_registers[l][k][j] || (shift_masks && (l == fx_reg) && (k == fy_reg)))
                        );
                        end
                        else begin 
                        register #(
                        .WIDTH(2*IO_DATA_WIDTH)
                        )
                        shift_reg
                        (
                        .clk(clk),
                        .arst_n_in(arst_n_in),
                        .din(zero_padding? 16'h0 : (shift_masks ? masks_registers[l][k][j][i+1] : splitted_masks_input[i])),
                        .qout(masks_registers[l][k][j][i]),
                        .we(write_masks_registers[l][k][j] || (shift_masks && (l == fx_reg) && (k == fy_reg)))
                        );
                        end
                    end 
                    else begin 
                        if(i == 7) begin
                        register #(
                        .WIDTH(2*IO_DATA_WIDTH)
                        )
                        shift_reg
                        (
                        .clk(clk),
                        .arst_n_in(arst_n_in),
                        .din(zero_padding? 16'h0 : (shift_masks ? masks_registers[l][k][j+1][0] : splitted_masks_input[i])),
                        .qout(masks_registers[l][k][j][i]),
                        .we(write_masks_registers[l][k][j] || (shift_masks && (l == fx_reg) && (k == fy_reg)))
                        );
                        end
                        else begin 
                        register #(
                        .WIDTH(2*IO_DATA_WIDTH)
                        )
                        shift_reg
                        (
                        .clk(clk),
                        .arst_n_in(arst_n_in),
                        .din(zero_padding? 16'h0 : (shift_masks ? masks_registers[l][k][j][i+1] : splitted_masks_input[i])),
                        .qout(masks_registers[l][k][j][i]),
                        .we(write_masks_registers[l][k][j] || (shift_masks && (l == fx_reg) && (k == fy_reg)))
                        );
                        end
                    end
                end
            end
        end
    end 
    endgenerate

    genvar q, r, s;
    // Generate the encoded registers 
    logic [IO_DATA_WIDTH-1:0] encoded_registers [0:1][0:2][0:31];
    generate
    for (q = 0; q < 2; q = q + 1) begin 
        for (r = 0; r < 3; r = r + 1) begin  
            for (s = 0; s < 32; s = s + 1) begin
                register #(
                .WIDTH(IO_DATA_WIDTH)
                )
                shift_reg
                (
                .clk(clk),
                .arst_n_in(arst_n_in),
                .din(shift_encoded_select[q][r][s/16] ? (((s+shift_encoded_number) > 31)? '0 : encoded_registers[q][r][s+shift_encoded_number]) : (zero_padding ? 8'h0 : splitted_encoded_input[s%16])),
                .qout(encoded_registers[q][r][s]),
                .we((write_masks_registers[q][r][s/16] || write_encoded_registers_extra[q][r][s/16] || shift_encoded_select[q][r][s/16]))
                );
            end
        end
    end
    endgenerate

    `REG(32, start_address_encoded_reg);
    assign start_address_encoded_reg_next = start_address_encoded;
    logic [4:0] ones_in_masks;
    count_ones #(
    .MEM_BW            (16)
    )
    count_ones_0
    (.input_word(masks_registers[fx_reg][fy_reg][0][0]),
    .output_count(ones_in_masks));
    logic subtraction_ones_in_masks;
    `REG(5, ones_in_masks_reg);

    assign ones_in_masks_reg_next = subtraction_ones_in_masks? (ones_in_masks_reg + shift_keeper[fx_reg][fy_reg] - 16): ones_in_masks ;

    `REG(16, masks_out_reg);
    assign masks_out_reg_next = masks_registers[fx_reg][fy_reg][0][0];

    `REG(128, encoded_out_reg);
    assign encoded_out_reg_next = (
        (ones_in_masks == 'd0)? 128'd0 : 
        (ones_in_masks == 'd1)? {encoded_registers[fx_reg][fy_reg][0], 120'd0} :
        (ones_in_masks == 'd2)? {encoded_registers[fx_reg][fy_reg][0], encoded_registers[fx_reg][fy_reg][1], 112'd0} : 
        (ones_in_masks == 'd3)? {encoded_registers[fx_reg][fy_reg][0], encoded_registers[fx_reg][fy_reg][1], encoded_registers[fx_reg][fy_reg][2], 104'd0} :
        (ones_in_masks == 'd4)? {encoded_registers[fx_reg][fy_reg][0], encoded_registers[fx_reg][fy_reg][1], encoded_registers[fx_reg][fy_reg][2], encoded_registers[fx_reg][fy_reg][3], 96'd0} :
        (ones_in_masks == 'd5)? {encoded_registers[fx_reg][fy_reg][0], encoded_registers[fx_reg][fy_reg][1], encoded_registers[fx_reg][fy_reg][2], encoded_registers[fx_reg][fy_reg][3], encoded_registers[fx_reg][fy_reg][4], 88'd0} :
        (ones_in_masks == 'd6)? {encoded_registers[fx_reg][fy_reg][0], encoded_registers[fx_reg][fy_reg][1], encoded_registers[fx_reg][fy_reg][2], encoded_registers[fx_reg][fy_reg][3], encoded_registers[fx_reg][fy_reg][4], encoded_registers[fx_reg][fy_reg][5], 80'd0} :
        (ones_in_masks == 'd7)? {encoded_registers[fx_reg][fy_reg][0], encoded_registers[fx_reg][fy_reg][1], encoded_registers[fx_reg][fy_reg][2], encoded_registers[fx_reg][fy_reg][3], encoded_registers[fx_reg][fy_reg][4], encoded_registers[fx_reg][fy_reg][5], encoded_registers[fx_reg][fy_reg][6],72'd0} : 
        (ones_in_masks == 'd8)? {encoded_registers[fx_reg][fy_reg][0], encoded_registers[fx_reg][fy_reg][1], encoded_registers[fx_reg][fy_reg][2], encoded_registers[fx_reg][fy_reg][3], encoded_registers[fx_reg][fy_reg][4], encoded_registers[fx_reg][fy_reg][5], encoded_registers[fx_reg][fy_reg][6], encoded_registers[fx_reg][fy_reg][7], 64'd0} :
        (ones_in_masks == 'd9)? {encoded_registers[fx_reg][fy_reg][0], encoded_registers[fx_reg][fy_reg][1], encoded_registers[fx_reg][fy_reg][2], encoded_registers[fx_reg][fy_reg][3], encoded_registers[fx_reg][fy_reg][4], encoded_registers[fx_reg][fy_reg][5], encoded_registers[fx_reg][fy_reg][6], encoded_registers[fx_reg][fy_reg][7], encoded_registers[fx_reg][fy_reg][8], 56'd0} :
        (ones_in_masks == 'd10)? {encoded_registers[fx_reg][fy_reg][0], encoded_registers[fx_reg][fy_reg][1], encoded_registers[fx_reg][fy_reg][2], encoded_registers[fx_reg][fy_reg][3], encoded_registers[fx_reg][fy_reg][4], encoded_registers[fx_reg][fy_reg][5], encoded_registers[fx_reg][fy_reg][6], encoded_registers[fx_reg][fy_reg][7], encoded_registers[fx_reg][fy_reg][8], encoded_registers[fx_reg][fy_reg][9], 48'd0} :
        (ones_in_masks == 'd11)? {encoded_registers[fx_reg][fy_reg][0], encoded_registers[fx_reg][fy_reg][1], encoded_registers[fx_reg][fy_reg][2], encoded_registers[fx_reg][fy_reg][3], encoded_registers[fx_reg][fy_reg][4], encoded_registers[fx_reg][fy_reg][5], encoded_registers[fx_reg][fy_reg][6], encoded_registers[fx_reg][fy_reg][7], encoded_registers[fx_reg][fy_reg][8], encoded_registers[fx_reg][fy_reg][9], encoded_registers[fx_reg][fy_reg][10], 40'd0} : 
        (ones_in_masks == 'd12)? {encoded_registers[fx_reg][fy_reg][0], encoded_registers[fx_reg][fy_reg][1], encoded_registers[fx_reg][fy_reg][2], encoded_registers[fx_reg][fy_reg][3], encoded_registers[fx_reg][fy_reg][4], encoded_registers[fx_reg][fy_reg][5], encoded_registers[fx_reg][fy_reg][6], encoded_registers[fx_reg][fy_reg][7], encoded_registers[fx_reg][fy_reg][8], encoded_registers[fx_reg][fy_reg][9], encoded_registers[fx_reg][fy_reg][10], encoded_registers[fx_reg][fy_reg][11], 32'd0} :
        (ones_in_masks == 'd13)? {encoded_registers[fx_reg][fy_reg][0], encoded_registers[fx_reg][fy_reg][1], encoded_registers[fx_reg][fy_reg][2], encoded_registers[fx_reg][fy_reg][3], encoded_registers[fx_reg][fy_reg][4], encoded_registers[fx_reg][fy_reg][5], encoded_registers[fx_reg][fy_reg][6], encoded_registers[fx_reg][fy_reg][7], encoded_registers[fx_reg][fy_reg][8], encoded_registers[fx_reg][fy_reg][9], encoded_registers[fx_reg][fy_reg][10], encoded_registers[fx_reg][fy_reg][11], encoded_registers[fx_reg][fy_reg][12], 24'd0} :
        (ones_in_masks == 'd14)? {encoded_registers[fx_reg][fy_reg][0], encoded_registers[fx_reg][fy_reg][1], encoded_registers[fx_reg][fy_reg][2], encoded_registers[fx_reg][fy_reg][3], encoded_registers[fx_reg][fy_reg][4], encoded_registers[fx_reg][fy_reg][5], encoded_registers[fx_reg][fy_reg][6], encoded_registers[fx_reg][fy_reg][7], encoded_registers[fx_reg][fy_reg][8], encoded_registers[fx_reg][fy_reg][9], encoded_registers[fx_reg][fy_reg][10], encoded_registers[fx_reg][fy_reg][11], encoded_registers[fx_reg][fy_reg][12], encoded_registers[fx_reg][fy_reg][13], 16'd0} :
        (ones_in_masks == 'd15)? {encoded_registers[fx_reg][fy_reg][0], encoded_registers[fx_reg][fy_reg][1], encoded_registers[fx_reg][fy_reg][2], encoded_registers[fx_reg][fy_reg][3], encoded_registers[fx_reg][fy_reg][4], encoded_registers[fx_reg][fy_reg][5], encoded_registers[fx_reg][fy_reg][6], encoded_registers[fx_reg][fy_reg][7], encoded_registers[fx_reg][fy_reg][8], encoded_registers[fx_reg][fy_reg][9], encoded_registers[fx_reg][fy_reg][10], encoded_registers[fx_reg][fy_reg][11], encoded_registers[fx_reg][fy_reg][12], encoded_registers[fx_reg][fy_reg][13], encoded_registers[fx_reg][fy_reg][14], 8'd0} :
        (ones_in_masks == 'd16)? {encoded_registers[fx_reg][fy_reg][0], encoded_registers[fx_reg][fy_reg][1], encoded_registers[fx_reg][fy_reg][2], encoded_registers[fx_reg][fy_reg][3], encoded_registers[fx_reg][fy_reg][4], encoded_registers[fx_reg][fy_reg][5], encoded_registers[fx_reg][fy_reg][6], encoded_registers[fx_reg][fy_reg][7], encoded_registers[fx_reg][fy_reg][8], encoded_registers[fx_reg][fy_reg][9], encoded_registers[fx_reg][fy_reg][10], encoded_registers[fx_reg][fy_reg][11], encoded_registers[fx_reg][fy_reg][12], encoded_registers[fx_reg][fy_reg][13], encoded_registers[fx_reg][fy_reg][14], encoded_registers[fx_reg][fy_reg][15]} : 128'd0);

    assign masks_output = masks_out_reg;
    assign encoded_output = encoded_out_reg;

    //Update shiftkeeper 
    always @(posedge clk) begin 
        if(reset_driver) begin 
            for (int i=0; i<2; i++) begin 
                for (int j=0; j<3; j++) begin 
                    shift_keeper[i][j] <= 0;
                    activations_fetch_counter[i][j] <= 2;
                end
            end  
        end
        else if (shift_encoded) begin 
            shift_keeper[fx_reg][fy_reg] <= shift_keeper[fx_reg][fy_reg] + shift_encoded_number;
            if ((shift_keeper[fx_reg][fy_reg] + shift_encoded_number)%16 == 0) begin 
                activations_fetch_counter[fx_reg][fy_reg] <= activations_fetch_counter[fx_reg][fy_reg] + 1;
            end else begin 
                activations_fetch_counter[fx_reg][fy_reg] <= activations_fetch_counter[fx_reg][fy_reg];
            end
        end
    end 

    logic new_fetch_needed;
    assign new_fetch_needed = ((ones_in_masks_reg >= (16-shift_keeper[fx_reg][fy_reg])) && ones_in_masks_reg != 0);

    assign address_activations_reading_extra = start_address_encoded_reg + activations_fetch_counter[fx_reg][fy_reg];
    typedef enum {IDLE, SELECT_MASKS_AND_ENCODED, SHIFT_1, FETCH_NEW, SHIFT_2} fsm_state;
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
    
    fx_reg_we = 0;
    fy_reg_we = 0;

    masks_out_reg_we = 0;
    encoded_out_reg_we = 0;
    ones_in_masks_reg_we = 0;
    ready_driver = 0;
    
    driver_read_control = 0;
    shift_masks = 0;
    shift_encoded = 0;
    shift_encoded_number = 0;
    read_activations_memory_extra = 1;
    subtraction_ones_in_masks = 0;

    start_address_encoded_reg_we = 0;

    for (int a=0; a<2; a++) begin 
      for (int b=0; b<3; b++) begin 
        for (int c=0; c<2; c++) begin 
          write_encoded_registers_extra[a][b][c] = 0;
        end
      end
    end

    for (int a=0; a<2; a++) begin 
      for (int b=0; b<3; b++) begin 
        for (int c=0; c<2; c++) begin 
            shift_encoded_select[a][b][c] = 0;
        end
      end
    end

    case (current_state)
        IDLE: begin
            fx_reg_we = 1;
            fy_reg_we = 1;
            start_address_encoded_reg_we = 1;
            next_state = start_driver? SELECT_MASKS_AND_ENCODED : IDLE;            
        end
        SELECT_MASKS_AND_ENCODED: begin 
            masks_out_reg_we = 1;
            encoded_out_reg_we = 1;
            ones_in_masks_reg_we = 1;
            next_state = SHIFT_1;
        end 
        SHIFT_1: begin
            driver_read_control = 1;
            shift_masks = 1;
            shift_encoded = (ones_in_masks_reg != 0);
            shift_encoded_select[fx_reg][fy_reg][0] = (ones_in_masks_reg != 0);
            shift_encoded_select[fx_reg][fy_reg][1] = (ones_in_masks_reg != 0);
            shift_encoded_number = new_fetch_needed? (16-shift_keeper[fx_reg][fy_reg]) : ones_in_masks_reg;
            ones_in_masks_reg_we = new_fetch_needed;
            read_activations_memory_extra = !new_fetch_needed;
            subtraction_ones_in_masks = new_fetch_needed; 
            ready_driver = 1;
            next_state = new_fetch_needed? FETCH_NEW : IDLE;
        end 
        FETCH_NEW: begin 
            write_encoded_registers_extra[fx_reg][fy_reg][1] = 1;
            next_state = (ones_in_masks_reg > 0)? SHIFT_2 : IDLE;
        end 
        SHIFT_2: begin 
            shift_encoded = 1;
            shift_encoded_select[fx_reg][fy_reg][0] = 1;
            shift_encoded_select[fx_reg][fy_reg][1] = 1;
            shift_encoded_number = ones_in_masks_reg;
            next_state = IDLE;
        end 
    endcase
  end 
endmodule 