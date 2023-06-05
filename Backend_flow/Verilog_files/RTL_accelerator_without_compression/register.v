module register (
	clk,
	arst_n_in,
	din,
	qout,
	we
);
	parameter integer WIDTH = 20;
	parameter integer RESET_VAL = 'b0;
	input wire clk;
	input wire arst_n_in;
	input wire [WIDTH - 1:0] din;
	output wire [WIDTH - 1:0] qout;
	input wire we;
	reg [WIDTH - 1:0] r;
	always @(posedge clk or negedge arst_n_in)
		if (arst_n_in == 0)
			r <= RESET_VAL;
		else if (we)
			r <= din;
	assign qout = r;
endmodule
