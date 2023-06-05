module adder (
	a,
	b,
	out
);
	parameter signed [31:0] A_WIDTH = 32;
	parameter signed [31:0] B_WIDTH = 32;
	parameter signed [31:0] OUT_SCALE = 0;
	parameter signed [31:0] OUT_WIDTH = (A_WIDTH > B_WIDTH ? A_WIDTH : B_WIDTH) + 1;
	input wire signed [A_WIDTH - 1:0] a;
	input wire signed [B_WIDTH - 1:0] b;
	output wire signed [OUT_WIDTH - 1:0] out;
	localparam INTERMEDIATE_WIDTH = A_WIDTH + B_WIDTH;
	wire signed [INTERMEDIATE_WIDTH - 1:0] a_extended;
	assign a_extended = a;
	wire signed [INTERMEDIATE_WIDTH - 1:0] b_extended;
	assign b_extended = b;
	wire signed [INTERMEDIATE_WIDTH - 1:0] unscaled_out;
	assign unscaled_out = a + b;
	assign out = unscaled_out >>> OUT_SCALE;
endmodule
