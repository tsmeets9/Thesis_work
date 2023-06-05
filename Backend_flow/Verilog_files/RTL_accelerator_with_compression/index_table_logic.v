module index_table_logic (
	clk,
	arst_n_in,
	masks,
	CE_signal,
	masks_transferred,
	activation_rows_total,
	delayed_CE,
	delayed_masks_transferred
);
	parameter signed [31:0] MEM_BW = 128;
	parameter signed [31:0] ADDR_WIDTH_ACT = 14;
	parameter signed [31:0] ADDR_WIDTH_MASKS = 11;
	input wire clk;
	input wire arst_n_in;
	input wire [MEM_BW - 1:0] masks;
	input wire CE_signal;
	input wire [31:0] masks_transferred;
	output wire [31:0] activation_rows_total;
	output wire delayed_CE;
	output wire [ADDR_WIDTH_MASKS - 1:0] delayed_masks_transferred;
	wire [MEM_BW - 1:0] masks_reg_1_next;
	wire [MEM_BW - 1:0] masks_reg_1;
	wire masks_reg_1_we;
	register #(.WIDTH(MEM_BW)) masks_reg_1_r(
		.clk(clk),
		.arst_n_in(arst_n_in),
		.din(masks_reg_1_next),
		.qout(masks_reg_1),
		.we(masks_reg_1_we)
	);
	wire [0:0] CE_signal_reg_1_next;
	wire [0:0] CE_signal_reg_1;
	wire CE_signal_reg_1_we;
	register #(.WIDTH(1)) CE_signal_reg_1_r(
		.clk(clk),
		.arst_n_in(arst_n_in),
		.din(CE_signal_reg_1_next),
		.qout(CE_signal_reg_1),
		.we(CE_signal_reg_1_we)
	);
	wire [31:0] masks_transferred_reg_1_next;
	wire [31:0] masks_transferred_reg_1;
	wire masks_transferred_reg_1_we;
	register #(.WIDTH(32)) masks_transferred_reg_1_r(
		.clk(clk),
		.arst_n_in(arst_n_in),
		.din(masks_transferred_reg_1_next),
		.qout(masks_transferred_reg_1),
		.we(masks_transferred_reg_1_we)
	);
	assign masks_reg_1_next = masks;
	assign CE_signal_reg_1_next = CE_signal;
	assign masks_transferred_reg_1_next = masks_transferred;
	assign masks_reg_1_we = CE_signal;
	assign CE_signal_reg_1_we = 1;
	assign masks_transferred_reg_1_we = 1;
	wire [$clog2(MEM_BW):0] output_count;
	count_ones #(.MEM_BW(MEM_BW)) count_ones_0(
		.input_word(masks_reg_1),
		.output_count(output_count)
	);
	wire [$clog2(MEM_BW) + 1:0] sum_1;
	wire [$clog2(MEM_BW) + 1:0] accumulator_reg_1_next;
	wire [$clog2(MEM_BW) + 1:0] accumulator_reg_1;
	wire accumulator_reg_1_we;
	register #(.WIDTH($clog2(MEM_BW) + 2)) accumulator_reg_1_r(
		.clk(clk),
		.arst_n_in(arst_n_in),
		.din(accumulator_reg_1_next),
		.qout(accumulator_reg_1),
		.we(accumulator_reg_1_we)
	);
	assign accumulator_reg_1_next = sum_1;
	assign accumulator_reg_1_we = CE_signal_reg_1;
	assign sum_1 = ((masks_transferred_reg_1 % 2) == 0 ? {1'b0, output_count} : output_count + accumulator_reg_1);
	wire [0:0] CE_signal_reg_2_next;
	wire [0:0] CE_signal_reg_2;
	wire CE_signal_reg_2_we;
	register #(.WIDTH(1)) CE_signal_reg_2_r(
		.clk(clk),
		.arst_n_in(arst_n_in),
		.din(CE_signal_reg_2_next),
		.qout(CE_signal_reg_2),
		.we(CE_signal_reg_2_we)
	);
	wire [31:0] masks_transferred_reg_2_next;
	wire [31:0] masks_transferred_reg_2;
	wire masks_transferred_reg_2_we;
	register #(.WIDTH(32)) masks_transferred_reg_2_r(
		.clk(clk),
		.arst_n_in(arst_n_in),
		.din(masks_transferred_reg_2_next),
		.qout(masks_transferred_reg_2),
		.we(masks_transferred_reg_2_we)
	);
	assign CE_signal_reg_2_next = CE_signal_reg_1;
	assign masks_transferred_reg_2_next = masks_transferred_reg_1;
	assign CE_signal_reg_2_we = 1;
	assign masks_transferred_reg_2_we = 1;
	wire [31:0] number_of_rows;
	assign number_of_rows = ((accumulator_reg_1 - 1) >> 4) + 1;
	wire [31:0] sum_2;
	wire [31:0] accumulator_reg_2_next;
	wire [31:0] accumulator_reg_2;
	wire accumulator_reg_2_we;
	register #(.WIDTH(32)) accumulator_reg_2_r(
		.clk(clk),
		.arst_n_in(arst_n_in),
		.din(accumulator_reg_2_next),
		.qout(accumulator_reg_2),
		.we(accumulator_reg_2_we)
	);
	assign accumulator_reg_2_next = sum_2;
	assign accumulator_reg_2_we = CE_signal_reg_2 && ((masks_transferred_reg_2 % 2) == 1);
	assign sum_2 = number_of_rows + accumulator_reg_2;
	assign activation_rows_total = sum_2;
	assign delayed_CE = CE_signal_reg_2;
	assign delayed_masks_transferred = masks_transferred_reg_2;
endmodule
