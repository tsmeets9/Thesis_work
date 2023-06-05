module mac (
	clk,
	arst_n_in,
	input_valid,
	accumulate_internal,
	a,
	b,
	out
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
	input wire signed [A_WIDTH - 1:0] a;
	input wire signed [B_WIDTH - 1:0] b;
	output wire signed [OUTPUT_WIDTH - 1:0] out;
	wire signed [ACCUMULATOR_WIDTH - 1:0] product;
	multiplier #(
		.A_WIDTH(A_WIDTH),
		.B_WIDTH(B_WIDTH),
		.OUT_WIDTH(ACCUMULATOR_WIDTH),
		.OUT_SCALE(0)
	) mul(
		.a(a),
		.b(b),
		.out(product)
	);
	wire [ACCUMULATOR_WIDTH - 1:0] accumulator_value_next;
	wire [ACCUMULATOR_WIDTH - 1:0] accumulator_value;
	wire accumulator_value_we;
	register #(.WIDTH(ACCUMULATOR_WIDTH)) accumulator_value_r(
		.clk(clk),
		.arst_n_in(arst_n_in),
		.din(accumulator_value_next),
		.qout(accumulator_value),
		.we(accumulator_value_we)
	);
	assign accumulator_value_we = input_valid;
	wire signed [ACCUMULATOR_WIDTH - 1:0] sum;
	assign accumulator_value_next = sum;
	wire signed [ACCUMULATOR_WIDTH - 1:0] adder_b;
	assign adder_b = (accumulate_internal ? accumulator_value : {ACCUMULATOR_WIDTH {1'sb0}});
	adder #(
		.A_WIDTH(ACCUMULATOR_WIDTH),
		.B_WIDTH(ACCUMULATOR_WIDTH),
		.OUT_WIDTH(ACCUMULATOR_WIDTH),
		.OUT_SCALE(0)
	) add(
		.a(product),
		.b(adder_b),
		.out(sum)
	);
	assign out = accumulator_value >>> OUTPUT_SCALE;
endmodule
