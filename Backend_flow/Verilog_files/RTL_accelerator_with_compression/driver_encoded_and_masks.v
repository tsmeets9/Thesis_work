module driver_encoded_and_masks (
	clk,
	arst_n_in,
	encoded_input,
	masks_input,
	write_masks_registers,
	start_driver,
	reset_driver,
	fx,
	fy,
	start_address_encoded,
	ready_driver,
	driver_read_control,
	read_activations_memory_extra,
	address_activations_reading_extra,
	encoded_output,
	masks_output,
	zero_padding
);
	parameter signed [31:0] IO_DATA_WIDTH = 8;
	parameter signed [31:0] MEM_BW = 128;
	parameter signed [31:0] ADDR_WIDTH_ACT = 14;
	input wire clk;
	input wire arst_n_in;
	input wire [MEM_BW - 1:0] encoded_input;
	input wire [MEM_BW - 1:0] masks_input;
	input wire [11:0] write_masks_registers;
	input wire start_driver;
	input wire reset_driver;
	input wire [1:0] fx;
	input wire [1:0] fy;
	input wire [31:0] start_address_encoded;
	output reg ready_driver;
	output reg driver_read_control;
	output reg read_activations_memory_extra;
	output wire [ADDR_WIDTH_ACT - 1:0] address_activations_reading_extra;
	output wire [MEM_BW - 1:0] encoded_output;
	output wire [15:0] masks_output;
	input wire zero_padding;
	reg shift_masks;
	reg shift_encoded;
	reg [4:0] shift_encoded_number;
	reg [3:0] shift_keeper [0:1][0:2];
	reg [31:0] activations_fetch_counter [0:1][0:2];
	reg write_encoded_registers_extra [0:1][0:2][0:1];
	reg shift_encoded_select [0:1][0:2][0:1];
	genvar l;
	genvar k;
	genvar j;
	genvar i;
	initial begin : sv2v_autoblock_1
		reg signed [31:0] i;
		for (i = 0; i < 2; i = i + 1)
			begin : sv2v_autoblock_2
				reg signed [31:0] j;
				for (j = 0; j < 3; j = j + 1)
					begin
						shift_keeper[i][j] = 0;
						activations_fetch_counter[i][j] = 2;
					end
			end
	end
	wire [1:0] fx_reg_next;
	wire [1:0] fx_reg;
	reg fx_reg_we;
	register #(.WIDTH(2)) fx_reg_r(
		.clk(clk),
		.arst_n_in(arst_n_in),
		.din(fx_reg_next),
		.qout(fx_reg),
		.we(fx_reg_we)
	);
	wire [1:0] fy_reg_next;
	wire [1:0] fy_reg;
	reg fy_reg_we;
	register #(.WIDTH(2)) fy_reg_r(
		.clk(clk),
		.arst_n_in(arst_n_in),
		.din(fy_reg_next),
		.qout(fy_reg),
		.we(fy_reg_we)
	);
	assign fx_reg_next = fx;
	assign fy_reg_next = fy;
	wire [(2 * IO_DATA_WIDTH) - 1:0] splitted_masks_input [0:7];
	generate
		for (i = 0; i < (MEM_BW / (2 * IO_DATA_WIDTH)); i = i + 1) begin : genblk1
			assign splitted_masks_input[i] = masks_input[(MEM_BW - 1) - (16 * i):(MEM_BW - 16) - (16 * i)];
		end
	endgenerate
	wire [IO_DATA_WIDTH - 1:0] splitted_encoded_input [0:15];
	generate
		for (i = 0; i < (MEM_BW / IO_DATA_WIDTH); i = i + 1) begin : genblk2
			assign splitted_encoded_input[i] = encoded_input[(MEM_BW - 1) - (8 * i):(MEM_BW - 8) - (8 * i)];
		end
	endgenerate
	wire signed [(2 * IO_DATA_WIDTH) - 1:0] masks_registers [0:1][0:2][0:1][0:7];
	generate
		for (l = 0; l < 2; l = l + 1) begin : genblk3
			for (k = 0; k < 3; k = k + 1) begin : genblk1
				for (j = 1; j >= 0; j = j - 1) begin : genblk1
					for (i = 7; i >= 0; i = i - 1) begin : genblk1
						if (j == 1) begin : genblk1
							if (i == 7) begin : genblk1
								register #(.WIDTH(2 * IO_DATA_WIDTH)) shift_reg(
									.clk(clk),
									.arst_n_in(arst_n_in),
									.din((zero_padding ? 16'h0000 : (shift_masks ? 16'h0000 : splitted_masks_input[i]))),
									.qout(masks_registers[l][k][j][i]),
									.we(write_masks_registers[((((1 - l) * 3) + (2 - k)) * 2) + (1 - j)] || ((shift_masks && (l == fx_reg)) && (k == fy_reg)))
								);
							end
							else begin : genblk1
								register #(.WIDTH(2 * IO_DATA_WIDTH)) shift_reg(
									.clk(clk),
									.arst_n_in(arst_n_in),
									.din((zero_padding ? 16'h0000 : (shift_masks ? masks_registers[l][k][j][i + 1] : splitted_masks_input[i]))),
									.qout(masks_registers[l][k][j][i]),
									.we(write_masks_registers[((((1 - l) * 3) + (2 - k)) * 2) + (1 - j)] || ((shift_masks && (l == fx_reg)) && (k == fy_reg)))
								);
							end
						end
						else begin : genblk1
							if (i == 7) begin : genblk1
								register #(.WIDTH(2 * IO_DATA_WIDTH)) shift_reg(
									.clk(clk),
									.arst_n_in(arst_n_in),
									.din((zero_padding ? 16'h0000 : (shift_masks ? masks_registers[l][k][j + 1][0] : splitted_masks_input[i]))),
									.qout(masks_registers[l][k][j][i]),
									.we(write_masks_registers[((((1 - l) * 3) + (2 - k)) * 2) + (1 - j)] || ((shift_masks && (l == fx_reg)) && (k == fy_reg)))
								);
							end
							else begin : genblk1
								register #(.WIDTH(2 * IO_DATA_WIDTH)) shift_reg(
									.clk(clk),
									.arst_n_in(arst_n_in),
									.din((zero_padding ? 16'h0000 : (shift_masks ? masks_registers[l][k][j][i + 1] : splitted_masks_input[i]))),
									.qout(masks_registers[l][k][j][i]),
									.we(write_masks_registers[((((1 - l) * 3) + (2 - k)) * 2) + (1 - j)] || ((shift_masks && (l == fx_reg)) && (k == fy_reg)))
								);
							end
						end
					end
				end
			end
		end
	endgenerate
	genvar q;
	genvar r;
	genvar s;
	wire [IO_DATA_WIDTH - 1:0] encoded_registers [0:1][0:2][0:31];
	generate
		for (q = 0; q < 2; q = q + 1) begin : genblk4
			for (r = 0; r < 3; r = r + 1) begin : genblk1
				for (s = 0; s < 32; s = s + 1) begin : genblk1
					localparam integer sv2v_uu_shift_reg_WIDTH = IO_DATA_WIDTH;
					localparam [IO_DATA_WIDTH - 1:0] sv2v_uu_shift_reg_ext_din_0 = 1'sb0;
					register #(.WIDTH(IO_DATA_WIDTH)) shift_reg(
						.clk(clk),
						.arst_n_in(arst_n_in),
						.din((shift_encoded_select[q][r][s / 16] ? ((s + shift_encoded_number) > 31 ? sv2v_uu_shift_reg_ext_din_0 : encoded_registers[q][r][s + shift_encoded_number]) : (zero_padding ? 8'h00 : splitted_encoded_input[s % 16]))),
						.qout(encoded_registers[q][r][s]),
						.we((write_masks_registers[((((1 - q) * 3) + (2 - r)) * 2) + (1 - (s / 16))] || write_encoded_registers_extra[q][r][s / 16]) || shift_encoded_select[q][r][s / 16])
					);
				end
			end
		end
	endgenerate
	wire [31:0] start_address_encoded_reg_next;
	wire [31:0] start_address_encoded_reg;
	reg start_address_encoded_reg_we;
	register #(.WIDTH(32)) start_address_encoded_reg_r(
		.clk(clk),
		.arst_n_in(arst_n_in),
		.din(start_address_encoded_reg_next),
		.qout(start_address_encoded_reg),
		.we(start_address_encoded_reg_we)
	);
	assign start_address_encoded_reg_next = start_address_encoded;
	wire [4:0] ones_in_masks;
	count_ones #(.MEM_BW(16)) count_ones_0(
		.input_word(masks_registers[fx_reg][fy_reg][0][0]),
		.output_count(ones_in_masks)
	);
	reg subtraction_ones_in_masks;
	wire [4:0] ones_in_masks_reg_next;
	wire [4:0] ones_in_masks_reg;
	reg ones_in_masks_reg_we;
	register #(.WIDTH(5)) ones_in_masks_reg_r(
		.clk(clk),
		.arst_n_in(arst_n_in),
		.din(ones_in_masks_reg_next),
		.qout(ones_in_masks_reg),
		.we(ones_in_masks_reg_we)
	);
	assign ones_in_masks_reg_next = (subtraction_ones_in_masks ? (ones_in_masks_reg + shift_keeper[fx_reg][fy_reg]) - 16 : ones_in_masks);
	wire [15:0] masks_out_reg_next;
	wire [15:0] masks_out_reg;
	reg masks_out_reg_we;
	register #(.WIDTH(16)) masks_out_reg_r(
		.clk(clk),
		.arst_n_in(arst_n_in),
		.din(masks_out_reg_next),
		.qout(masks_out_reg),
		.we(masks_out_reg_we)
	);
	assign masks_out_reg_next = masks_registers[fx_reg][fy_reg][0][0];
	wire [127:0] encoded_out_reg_next;
	wire [127:0] encoded_out_reg;
	reg encoded_out_reg_we;
	register #(.WIDTH(128)) encoded_out_reg_r(
		.clk(clk),
		.arst_n_in(arst_n_in),
		.din(encoded_out_reg_next),
		.qout(encoded_out_reg),
		.we(encoded_out_reg_we)
	);
	assign encoded_out_reg_next = (ones_in_masks == 'd0 ? 128'd0 : (ones_in_masks == 'd1 ? {encoded_registers[fx_reg][fy_reg][0], 120'd0} : (ones_in_masks == 'd2 ? {encoded_registers[fx_reg][fy_reg][0], encoded_registers[fx_reg][fy_reg][1], 112'd0} : (ones_in_masks == 'd3 ? {encoded_registers[fx_reg][fy_reg][0], encoded_registers[fx_reg][fy_reg][1], encoded_registers[fx_reg][fy_reg][2], 104'd0} : (ones_in_masks == 'd4 ? {encoded_registers[fx_reg][fy_reg][0], encoded_registers[fx_reg][fy_reg][1], encoded_registers[fx_reg][fy_reg][2], encoded_registers[fx_reg][fy_reg][3], 96'd0} : (ones_in_masks == 'd5 ? {encoded_registers[fx_reg][fy_reg][0], encoded_registers[fx_reg][fy_reg][1], encoded_registers[fx_reg][fy_reg][2], encoded_registers[fx_reg][fy_reg][3], encoded_registers[fx_reg][fy_reg][4], 88'd0} : (ones_in_masks == 'd6 ? {encoded_registers[fx_reg][fy_reg][0], encoded_registers[fx_reg][fy_reg][1], encoded_registers[fx_reg][fy_reg][2], encoded_registers[fx_reg][fy_reg][3], encoded_registers[fx_reg][fy_reg][4], encoded_registers[fx_reg][fy_reg][5], 80'd0} : (ones_in_masks == 'd7 ? {encoded_registers[fx_reg][fy_reg][0], encoded_registers[fx_reg][fy_reg][1], encoded_registers[fx_reg][fy_reg][2], encoded_registers[fx_reg][fy_reg][3], encoded_registers[fx_reg][fy_reg][4], encoded_registers[fx_reg][fy_reg][5], encoded_registers[fx_reg][fy_reg][6], 72'd0} : (ones_in_masks == 'd8 ? {encoded_registers[fx_reg][fy_reg][0], encoded_registers[fx_reg][fy_reg][1], encoded_registers[fx_reg][fy_reg][2], encoded_registers[fx_reg][fy_reg][3], encoded_registers[fx_reg][fy_reg][4], encoded_registers[fx_reg][fy_reg][5], encoded_registers[fx_reg][fy_reg][6], encoded_registers[fx_reg][fy_reg][7], 64'd0} : (ones_in_masks == 'd9 ? {encoded_registers[fx_reg][fy_reg][0], encoded_registers[fx_reg][fy_reg][1], encoded_registers[fx_reg][fy_reg][2], encoded_registers[fx_reg][fy_reg][3], encoded_registers[fx_reg][fy_reg][4], encoded_registers[fx_reg][fy_reg][5], encoded_registers[fx_reg][fy_reg][6], encoded_registers[fx_reg][fy_reg][7], encoded_registers[fx_reg][fy_reg][8], 56'd0} : (ones_in_masks == 'd10 ? {encoded_registers[fx_reg][fy_reg][0], encoded_registers[fx_reg][fy_reg][1], encoded_registers[fx_reg][fy_reg][2], encoded_registers[fx_reg][fy_reg][3], encoded_registers[fx_reg][fy_reg][4], encoded_registers[fx_reg][fy_reg][5], encoded_registers[fx_reg][fy_reg][6], encoded_registers[fx_reg][fy_reg][7], encoded_registers[fx_reg][fy_reg][8], encoded_registers[fx_reg][fy_reg][9], 48'd0} : (ones_in_masks == 'd11 ? {encoded_registers[fx_reg][fy_reg][0], encoded_registers[fx_reg][fy_reg][1], encoded_registers[fx_reg][fy_reg][2], encoded_registers[fx_reg][fy_reg][3], encoded_registers[fx_reg][fy_reg][4], encoded_registers[fx_reg][fy_reg][5], encoded_registers[fx_reg][fy_reg][6], encoded_registers[fx_reg][fy_reg][7], encoded_registers[fx_reg][fy_reg][8], encoded_registers[fx_reg][fy_reg][9], encoded_registers[fx_reg][fy_reg][10], 40'd0} : (ones_in_masks == 'd12 ? {encoded_registers[fx_reg][fy_reg][0], encoded_registers[fx_reg][fy_reg][1], encoded_registers[fx_reg][fy_reg][2], encoded_registers[fx_reg][fy_reg][3], encoded_registers[fx_reg][fy_reg][4], encoded_registers[fx_reg][fy_reg][5], encoded_registers[fx_reg][fy_reg][6], encoded_registers[fx_reg][fy_reg][7], encoded_registers[fx_reg][fy_reg][8], encoded_registers[fx_reg][fy_reg][9], encoded_registers[fx_reg][fy_reg][10], encoded_registers[fx_reg][fy_reg][11], 32'd0} : (ones_in_masks == 'd13 ? {encoded_registers[fx_reg][fy_reg][0], encoded_registers[fx_reg][fy_reg][1], encoded_registers[fx_reg][fy_reg][2], encoded_registers[fx_reg][fy_reg][3], encoded_registers[fx_reg][fy_reg][4], encoded_registers[fx_reg][fy_reg][5], encoded_registers[fx_reg][fy_reg][6], encoded_registers[fx_reg][fy_reg][7], encoded_registers[fx_reg][fy_reg][8], encoded_registers[fx_reg][fy_reg][9], encoded_registers[fx_reg][fy_reg][10], encoded_registers[fx_reg][fy_reg][11], encoded_registers[fx_reg][fy_reg][12], 24'd0} : (ones_in_masks == 'd14 ? {encoded_registers[fx_reg][fy_reg][0], encoded_registers[fx_reg][fy_reg][1], encoded_registers[fx_reg][fy_reg][2], encoded_registers[fx_reg][fy_reg][3], encoded_registers[fx_reg][fy_reg][4], encoded_registers[fx_reg][fy_reg][5], encoded_registers[fx_reg][fy_reg][6], encoded_registers[fx_reg][fy_reg][7], encoded_registers[fx_reg][fy_reg][8], encoded_registers[fx_reg][fy_reg][9], encoded_registers[fx_reg][fy_reg][10], encoded_registers[fx_reg][fy_reg][11], encoded_registers[fx_reg][fy_reg][12], encoded_registers[fx_reg][fy_reg][13], 16'd0} : (ones_in_masks == 'd15 ? {encoded_registers[fx_reg][fy_reg][0], encoded_registers[fx_reg][fy_reg][1], encoded_registers[fx_reg][fy_reg][2], encoded_registers[fx_reg][fy_reg][3], encoded_registers[fx_reg][fy_reg][4], encoded_registers[fx_reg][fy_reg][5], encoded_registers[fx_reg][fy_reg][6], encoded_registers[fx_reg][fy_reg][7], encoded_registers[fx_reg][fy_reg][8], encoded_registers[fx_reg][fy_reg][9], encoded_registers[fx_reg][fy_reg][10], encoded_registers[fx_reg][fy_reg][11], encoded_registers[fx_reg][fy_reg][12], encoded_registers[fx_reg][fy_reg][13], encoded_registers[fx_reg][fy_reg][14], 8'd0} : (ones_in_masks == 'd16 ? {encoded_registers[fx_reg][fy_reg][0], encoded_registers[fx_reg][fy_reg][1], encoded_registers[fx_reg][fy_reg][2], encoded_registers[fx_reg][fy_reg][3], encoded_registers[fx_reg][fy_reg][4], encoded_registers[fx_reg][fy_reg][5], encoded_registers[fx_reg][fy_reg][6], encoded_registers[fx_reg][fy_reg][7], encoded_registers[fx_reg][fy_reg][8], encoded_registers[fx_reg][fy_reg][9], encoded_registers[fx_reg][fy_reg][10], encoded_registers[fx_reg][fy_reg][11], encoded_registers[fx_reg][fy_reg][12], encoded_registers[fx_reg][fy_reg][13], encoded_registers[fx_reg][fy_reg][14], encoded_registers[fx_reg][fy_reg][15]} : 128'd0)))))))))))))))));
	assign masks_output = masks_out_reg;
	assign encoded_output = encoded_out_reg;
	always @(posedge clk)
		if (reset_driver) begin : sv2v_autoblock_3
			reg signed [31:0] i;
			for (i = 0; i < 2; i = i + 1)
				begin : sv2v_autoblock_4
					reg signed [31:0] j;
					for (j = 0; j < 3; j = j + 1)
						begin
							shift_keeper[i][j] <= 0;
							activations_fetch_counter[i][j] <= 2;
						end
				end
		end
		else if (shift_encoded) begin
			shift_keeper[fx_reg][fy_reg] <= shift_keeper[fx_reg][fy_reg] + shift_encoded_number;
			if (((shift_keeper[fx_reg][fy_reg] + shift_encoded_number) % 16) == 0)
				activations_fetch_counter[fx_reg][fy_reg] <= activations_fetch_counter[fx_reg][fy_reg] + 1;
			else
				activations_fetch_counter[fx_reg][fy_reg] <= activations_fetch_counter[fx_reg][fy_reg];
		end
	wire new_fetch_needed;
	assign new_fetch_needed = (ones_in_masks_reg >= (16 - shift_keeper[fx_reg][fy_reg])) && (ones_in_masks_reg != 0);
	assign address_activations_reading_extra = start_address_encoded_reg + activations_fetch_counter[fx_reg][fy_reg];
	reg [31:0] current_state;
	reg [31:0] next_state;
	always @(posedge clk or negedge arst_n_in)
		if (arst_n_in == 0)
			current_state <= 32'd0;
		else
			current_state <= next_state;
	always @(*) begin
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
		begin : sv2v_autoblock_5
			reg signed [31:0] a;
			for (a = 0; a < 2; a = a + 1)
				begin : sv2v_autoblock_6
					reg signed [31:0] b;
					for (b = 0; b < 3; b = b + 1)
						begin : sv2v_autoblock_7
							reg signed [31:0] c;
							for (c = 0; c < 2; c = c + 1)
								write_encoded_registers_extra[a][b][c] = 0;
						end
				end
		end
		begin : sv2v_autoblock_8
			reg signed [31:0] a;
			for (a = 0; a < 2; a = a + 1)
				begin : sv2v_autoblock_9
					reg signed [31:0] b;
					for (b = 0; b < 3; b = b + 1)
						begin : sv2v_autoblock_10
							reg signed [31:0] c;
							for (c = 0; c < 2; c = c + 1)
								shift_encoded_select[a][b][c] = 0;
						end
				end
		end
		case (current_state)
			32'd0: begin
				fx_reg_we = 1;
				fy_reg_we = 1;
				start_address_encoded_reg_we = 1;
				next_state = (start_driver ? 32'd1 : 32'd0);
			end
			32'd1: begin
				masks_out_reg_we = 1;
				encoded_out_reg_we = 1;
				ones_in_masks_reg_we = 1;
				next_state = 32'd2;
			end
			32'd2: begin
				driver_read_control = 1;
				shift_masks = 1;
				shift_encoded = ones_in_masks_reg != 0;
				shift_encoded_select[fx_reg][fy_reg][0] = ones_in_masks_reg != 0;
				shift_encoded_select[fx_reg][fy_reg][1] = ones_in_masks_reg != 0;
				shift_encoded_number = (new_fetch_needed ? 16 - shift_keeper[fx_reg][fy_reg] : ones_in_masks_reg);
				ones_in_masks_reg_we = new_fetch_needed;
				read_activations_memory_extra = !new_fetch_needed;
				subtraction_ones_in_masks = new_fetch_needed;
				ready_driver = 1;
				next_state = (new_fetch_needed ? 32'd3 : 32'd0);
			end
			32'd3: begin
				write_encoded_registers_extra[fx_reg][fy_reg][1] = 1;
				next_state = (ones_in_masks_reg > 0 ? 32'd4 : 32'd0);
			end
			32'd4: begin
				shift_encoded = 1;
				shift_encoded_select[fx_reg][fy_reg][0] = 1;
				shift_encoded_select[fx_reg][fy_reg][1] = 1;
				shift_encoded_number = ones_in_masks_reg;
				next_state = 32'd0;
			end
		endcase
	end
endmodule
