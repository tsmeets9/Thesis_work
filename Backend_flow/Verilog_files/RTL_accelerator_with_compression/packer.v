module packer (
	clk,
	arst_n_in,
	masks_in,
	encoded_in,
	encoder_to_packer_counter,
	start_packer,
	ready_packer,
	packer_write_control,
	write_activations_memory_extra,
	write_masks_memory_extra,
	output_encoded,
	output_masks,
	outputs_encoded_to_memory_counter,
	outputs_masks_to_memory_counter
);
	parameter signed [31:0] IO_DATA_WIDTH = 16;
	parameter signed [31:0] MEM_BW = 128;
	parameter signed [31:0] ADDR_WIDTH_ACT = 14;
	parameter signed [31:0] ADDR_WIDTH_MASKS = 11;
	input wire clk;
	input wire arst_n_in;
	input wire [15:0] masks_in;
	input wire [MEM_BW - 1:0] encoded_in;
	input wire [3:0] encoder_to_packer_counter;
	input wire start_packer;
	output reg ready_packer;
	output reg packer_write_control;
	output reg write_activations_memory_extra;
	output reg write_masks_memory_extra;
	output wire [MEM_BW - 1:0] output_encoded;
	output wire [MEM_BW - 1:0] output_masks;
	output wire [ADDR_WIDTH_ACT - 1:0] outputs_encoded_to_memory_counter;
	output wire [ADDR_WIDTH_MASKS - 1:0] outputs_masks_to_memory_counter;
	reg load_shift_registers;
	reg shift_encoded;
	wire [3:0] encoder_to_packer_counter_reg_next;
	wire [3:0] encoder_to_packer_counter_reg;
	reg encoder_to_packer_counter_reg_we;
	register #(.WIDTH(4)) encoder_to_packer_counter_reg_r(
		.clk(clk),
		.arst_n_in(arst_n_in),
		.din(encoder_to_packer_counter_reg_next),
		.qout(encoder_to_packer_counter_reg),
		.we(encoder_to_packer_counter_reg_we)
	);
	assign encoder_to_packer_counter_reg_next = encoder_to_packer_counter;
	wire [4:0] ones_in_masks;
	reg [4:0] shift_encoded_number;
	wire [3:0] shift_keeper_reg_next;
	wire [3:0] shift_keeper_reg;
	wire shift_keeper_reg_we;
	register #(.WIDTH(4)) shift_keeper_reg_r(
		.clk(clk),
		.arst_n_in(arst_n_in),
		.din(shift_keeper_reg_next),
		.qout(shift_keeper_reg),
		.we(shift_keeper_reg_we)
	);
	assign shift_keeper_reg_next = shift_keeper_reg + shift_encoded_number;
	assign shift_keeper_reg_we = shift_encoded;
	count_ones #(.MEM_BW(16)) count_ones_0(
		.input_word(masks_in),
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
	assign ones_in_masks_reg_next = (subtraction_ones_in_masks ? (ones_in_masks_reg + shift_keeper_reg) - 16 : ones_in_masks);
	wire [31:0] outputs_encoded_to_memory_counter_internal_next;
	wire [31:0] outputs_encoded_to_memory_counter_internal;
	reg outputs_encoded_to_memory_counter_internal_we;
	register #(.WIDTH(32)) outputs_encoded_to_memory_counter_internal_r(
		.clk(clk),
		.arst_n_in(arst_n_in),
		.din(outputs_encoded_to_memory_counter_internal_next),
		.qout(outputs_encoded_to_memory_counter_internal),
		.we(outputs_encoded_to_memory_counter_internal_we)
	);
	assign outputs_encoded_to_memory_counter_internal_next = outputs_encoded_to_memory_counter_internal + 1;
	assign outputs_encoded_to_memory_counter = outputs_encoded_to_memory_counter_internal[ADDR_WIDTH_ACT - 1:0];
	wire [31:0] outputs_masks_to_memory_counter_internal_next;
	wire [31:0] outputs_masks_to_memory_counter_internal;
	reg outputs_masks_to_memory_counter_internal_we;
	register #(.WIDTH(32)) outputs_masks_to_memory_counter_internal_r(
		.clk(clk),
		.arst_n_in(arst_n_in),
		.din(outputs_masks_to_memory_counter_internal_next),
		.qout(outputs_masks_to_memory_counter_internal),
		.we(outputs_masks_to_memory_counter_internal_we)
	);
	assign outputs_masks_to_memory_counter_internal_next = outputs_masks_to_memory_counter_internal + 1;
	assign outputs_masks_to_memory_counter = outputs_masks_to_memory_counter_internal[ADDR_WIDTH_MASKS - 1:0];
	wire signed [(2 * IO_DATA_WIDTH) - 1:0] masks_registers [0:15];
	genvar l;
	genvar k;
	genvar j;
	genvar i;
	generate
		for (i = 0; i <= 15; i = i + 1) begin : genblk1
			register #(.WIDTH(2 * IO_DATA_WIDTH)) shift_reg(
				.clk(clk),
				.arst_n_in(arst_n_in),
				.din(masks_in),
				.qout(masks_registers[i]),
				.we(load_shift_registers && (encoder_to_packer_counter_reg == i))
			);
		end
	endgenerate
	wire nb_of_mask_transfer;
	assign nb_of_mask_transfer = outputs_masks_to_memory_counter % 2;
	assign output_masks[MEM_BW - 1:MEM_BW - 16] = masks_registers[0 + (8 * nb_of_mask_transfer)];
	assign output_masks[MEM_BW - 17:MEM_BW - 32] = masks_registers[1 + (8 * nb_of_mask_transfer)];
	assign output_masks[MEM_BW - 33:MEM_BW - 48] = masks_registers[2 + (8 * nb_of_mask_transfer)];
	assign output_masks[MEM_BW - 49:MEM_BW - 64] = masks_registers[3 + (8 * nb_of_mask_transfer)];
	assign output_masks[MEM_BW - 65:MEM_BW - 80] = masks_registers[4 + (8 * nb_of_mask_transfer)];
	assign output_masks[MEM_BW - 81:MEM_BW - 96] = masks_registers[5 + (8 * nb_of_mask_transfer)];
	assign output_masks[MEM_BW - 97:MEM_BW - 112] = masks_registers[6 + (8 * nb_of_mask_transfer)];
	assign output_masks[MEM_BW - 113:MEM_BW - 128] = masks_registers[7 + (8 * nb_of_mask_transfer)];
	wire [IO_DATA_WIDTH - 1:0] splitted_encoded_input [0:15];
	generate
		for (i = 0; i < (MEM_BW / IO_DATA_WIDTH); i = i + 1) begin : genblk2
			assign splitted_encoded_input[i] = encoded_in[(MEM_BW - 1) - (8 * i):(MEM_BW - 8) - (8 * i)];
		end
	endgenerate
	wire [IO_DATA_WIDTH - 1:0] pack_encoded_registers [0:31];
	generate
		for (i = 31; i >= 0; i = i - 1) begin : genblk3
			localparam integer sv2v_uu_shift_reg_WIDTH = IO_DATA_WIDTH;
			localparam [IO_DATA_WIDTH - 1:0] sv2v_uu_shift_reg_ext_din_0 = 1'sb0;
			register #(.WIDTH(IO_DATA_WIDTH)) shift_reg(
				.clk(clk),
				.arst_n_in(arst_n_in),
				.din((!shift_encoded ? splitted_encoded_input[i % 16] : (shift_encoded_number == 'd0 ? pack_encoded_registers[i] : (shift_encoded_number == 'd1 ? ((i + 1) > 31 ? sv2v_uu_shift_reg_ext_din_0 : pack_encoded_registers[i + 1]) : (shift_encoded_number == 'd2 ? ((i + 2) > 31 ? sv2v_uu_shift_reg_ext_din_0 : pack_encoded_registers[i + 2]) : (shift_encoded_number == 'd3 ? ((i + 3) > 31 ? sv2v_uu_shift_reg_ext_din_0 : pack_encoded_registers[i + 3]) : (shift_encoded_number == 'd4 ? ((i + 4) > 31 ? sv2v_uu_shift_reg_ext_din_0 : pack_encoded_registers[i + 4]) : (shift_encoded_number == 'd5 ? ((i + 5) > 31 ? sv2v_uu_shift_reg_ext_din_0 : pack_encoded_registers[i + 5]) : (shift_encoded_number == 'd6 ? ((i + 6) > 31 ? sv2v_uu_shift_reg_ext_din_0 : pack_encoded_registers[i + 6]) : (shift_encoded_number == 'd7 ? ((i + 7) > 31 ? sv2v_uu_shift_reg_ext_din_0 : pack_encoded_registers[i + 7]) : (shift_encoded_number == 'd8 ? ((i + 8) > 31 ? sv2v_uu_shift_reg_ext_din_0 : pack_encoded_registers[i + 8]) : (shift_encoded_number == 'd9 ? ((i + 9) > 31 ? sv2v_uu_shift_reg_ext_din_0 : pack_encoded_registers[i + 9]) : (shift_encoded_number == 'd10 ? ((i + 10) > 31 ? sv2v_uu_shift_reg_ext_din_0 : pack_encoded_registers[i + 10]) : (shift_encoded_number == 'd11 ? ((i + 11) > 31 ? sv2v_uu_shift_reg_ext_din_0 : pack_encoded_registers[i + 11]) : (shift_encoded_number == 'd12 ? ((i + 12) > 31 ? sv2v_uu_shift_reg_ext_din_0 : pack_encoded_registers[i + 12]) : (shift_encoded_number == 'd13 ? ((i + 13) > 31 ? sv2v_uu_shift_reg_ext_din_0 : pack_encoded_registers[i + 13]) : (shift_encoded_number == 'd14 ? ((i + 14) > 31 ? sv2v_uu_shift_reg_ext_din_0 : pack_encoded_registers[i + 14]) : (shift_encoded_number == 'd15 ? ((i + 15) > 31 ? sv2v_uu_shift_reg_ext_din_0 : pack_encoded_registers[i + 15]) : (shift_encoded_number == 'd16 ? ((i + 16) > 31 ? sv2v_uu_shift_reg_ext_din_0 : pack_encoded_registers[i + 16]) : pack_encoded_registers[i]))))))))))))))))))),
				.qout(pack_encoded_registers[i]),
				.we((load_shift_registers && ((i / 16) == 1)) || shift_encoded)
			);
		end
	endgenerate
	assign output_encoded[MEM_BW - 1:MEM_BW - 8] = pack_encoded_registers[0];
	assign output_encoded[MEM_BW - 9:MEM_BW - 16] = pack_encoded_registers[1];
	assign output_encoded[MEM_BW - 17:MEM_BW - 24] = pack_encoded_registers[2];
	assign output_encoded[MEM_BW - 25:MEM_BW - 32] = pack_encoded_registers[3];
	assign output_encoded[MEM_BW - 33:MEM_BW - 40] = pack_encoded_registers[4];
	assign output_encoded[MEM_BW - 41:MEM_BW - 48] = pack_encoded_registers[5];
	assign output_encoded[MEM_BW - 49:MEM_BW - 56] = pack_encoded_registers[6];
	assign output_encoded[MEM_BW - 57:MEM_BW - 64] = pack_encoded_registers[7];
	assign output_encoded[MEM_BW - 65:MEM_BW - 72] = pack_encoded_registers[8];
	assign output_encoded[MEM_BW - 73:MEM_BW - 80] = pack_encoded_registers[9];
	assign output_encoded[MEM_BW - 81:MEM_BW - 88] = pack_encoded_registers[10];
	assign output_encoded[MEM_BW - 89:MEM_BW - 96] = pack_encoded_registers[11];
	assign output_encoded[MEM_BW - 97:MEM_BW - 104] = pack_encoded_registers[12];
	assign output_encoded[MEM_BW - 105:MEM_BW - 112] = pack_encoded_registers[13];
	assign output_encoded[MEM_BW - 113:MEM_BW - 120] = pack_encoded_registers[14];
	assign output_encoded[MEM_BW - 121:MEM_BW - 128] = pack_encoded_registers[15];
	reg [31:0] current_state;
	reg [31:0] next_state;
	always @(posedge clk or negedge arst_n_in)
		if (arst_n_in == 0)
			current_state <= 32'd0;
		else
			current_state <= next_state;
	always @(*) begin
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
			32'd0: begin
				encoder_to_packer_counter_reg_we = 1;
				next_state = (start_packer ? 32'd1 : 32'd0);
			end
			32'd1: begin
				load_shift_registers = 1;
				ones_in_masks_reg_we = 1;
				next_state = 32'd2;
			end
			32'd2: begin
				shift_encoded = ones_in_masks_reg != 0;
				shift_encoded_number = (ones_in_masks_reg >= (16 - shift_keeper_reg) ? 16 - shift_keeper_reg : ones_in_masks_reg);
				ones_in_masks_reg_we = ones_in_masks_reg >= (16 - shift_keeper_reg);
				subtraction_ones_in_masks = ones_in_masks_reg >= (16 - shift_keeper_reg);
				ready_packer = (ones_in_masks_reg < (16 - shift_keeper_reg)) && (encoder_to_packer_counter_reg != 15);
				next_state = (ones_in_masks_reg >= (16 - shift_keeper_reg) ? 32'd3 : (encoder_to_packer_counter_reg != 15 ? 32'd0 : 32'd5));
			end
			32'd3: begin
				packer_write_control = 1;
				outputs_encoded_to_memory_counter_internal_we = 1;
				write_activations_memory_extra = 0;
				ready_packer = (ones_in_masks_reg == 0) && (encoder_to_packer_counter_reg != 15);
				next_state = (ones_in_masks_reg == 0 ? (encoder_to_packer_counter_reg == 15 ? 32'd6 : 32'd0) : 32'd4);
			end
			32'd4: begin
				shift_encoded = 1;
				shift_encoded_number = ones_in_masks_reg;
				ready_packer = encoder_to_packer_counter_reg != 15;
				next_state = (encoder_to_packer_counter_reg == 15 ? 32'd5 : 32'd0);
			end
			32'd5: begin
				shift_encoded = shift_keeper_reg != 0;
				shift_encoded_number = 16 - shift_keeper_reg;
				next_state = ((ones_in_masks_reg == 0) && (shift_keeper_reg == 0) ? 32'd6 : 32'd7);
			end
			32'd7: begin
				packer_write_control = 1;
				outputs_encoded_to_memory_counter_internal_we = 1;
				outputs_masks_to_memory_counter_internal_we = 1;
				write_activations_memory_extra = 0;
				write_masks_memory_extra = 0;
				next_state = 32'd8;
			end
			32'd6: begin
				packer_write_control = 1;
				outputs_masks_to_memory_counter_internal_we = 1;
				write_masks_memory_extra = 0;
				next_state = 32'd8;
			end
			32'd8: begin
				packer_write_control = 1;
				outputs_masks_to_memory_counter_internal_we = 1;
				write_masks_memory_extra = 0;
				ready_packer = 1;
				next_state = 32'd0;
			end
		endcase
	end
endmodule
