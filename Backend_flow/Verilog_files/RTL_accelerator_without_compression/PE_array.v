module PE_array (
	clk,
	arst_n_in,
	input_valid,
	accumulate_internal,
	activations,
	weights,
	outs
);
	parameter signed [31:0] A_WIDTH = 8;
	parameter signed [31:0] B_WIDTH = 8;
	parameter signed [31:0] ACCUMULATOR_WIDTH = 32;
	parameter signed [31:0] OUTPUT_WIDTH = 8;
	parameter signed [31:0] OUTPUT_SCALE = 0;
	input wire clk;
	input wire arst_n_in;
	input wire input_valid;
	input wire accumulate_internal;
	input wire signed [(16 * A_WIDTH) - 1:0] activations;
	input wire signed [(16 * B_WIDTH) - 1:0] weights;
	output wire signed [(256 * OUTPUT_WIDTH) - 1:0] outs;
	wire signed [(256 * OUTPUT_WIDTH) - 1:0] products;
	genvar i;
	genvar j;
	generate
		for (i = 0; i < 16; i = i + 1) begin : genblk1
			for (j = 0; j < 16; j = j + 1) begin : genblk1
				mac #(
					.A_WIDTH(A_WIDTH),
					.B_WIDTH(B_WIDTH),
					.ACCUMULATOR_WIDTH(ACCUMULATOR_WIDTH),
					.OUTPUT_WIDTH(OUTPUT_WIDTH),
					.OUTPUT_SCALE(0)
				) mac_unit(
					.clk(clk),
					.arst_n_in(arst_n_in),
					.input_valid(input_valid),
					.accumulate_internal(accumulate_internal),
					.a(activations[(15 - i) * A_WIDTH+:A_WIDTH]),
					.b(weights[(15 - j) * B_WIDTH+:B_WIDTH]),
					.out(products[(((15 - i) * 16) + (15 - j)) * OUTPUT_WIDTH+:OUTPUT_WIDTH])
				);
			end
		end
	endgenerate
	assign outs = products;
endmodule
