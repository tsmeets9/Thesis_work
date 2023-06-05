module fifo (
	clk,
	arst_n_in,
	din,
	input_valid,
	input_ready,
	qout,
	output_valid,
	output_ready
);
	parameter signed [31:0] WIDTH = 0;
	parameter signed [31:0] LOG2_OF_DEPTH = 0;
	parameter [0:0] USE_AS_EXTERNAL_FIFO = 0;
	input wire clk;
	input wire arst_n_in;
	input wire [WIDTH - 1:0] din;
	input wire input_valid;
	output wire input_ready;
	output wire [WIDTH - 1:0] qout;
	output wire output_valid;
	input wire output_ready;
	wire write_effective;
	assign write_effective = input_valid && input_ready;
	wire [LOG2_OF_DEPTH + 0:0] write_addr;
	wire [LOG2_OF_DEPTH + 0:0] write_addr_next;
	wire write_addr_we;
	register #(.WIDTH(LOG2_OF_DEPTH + 1)) write_addr_r(
		.clk(clk),
		.arst_n_in(arst_n_in),
		.din(write_addr_next),
		.qout(write_addr),
		.we(write_addr_we)
	);
	assign write_addr_we = write_effective;
	assign write_addr_next = write_addr + 1;
	wire read_effective;
	assign read_effective = output_valid && output_ready;
	wire [LOG2_OF_DEPTH + 0:0] read_addr_next;
	wire [LOG2_OF_DEPTH + 0:0] read_addr;
	wire read_addr_we;
	register #(.WIDTH(LOG2_OF_DEPTH + 1)) read_addr_r(
		.clk(clk),
		.arst_n_in(arst_n_in),
		.din(read_addr_next),
		.qout(read_addr),
		.we(read_addr_we)
	);
	assign read_addr_we = read_effective;
	assign read_addr_next = read_addr + 1;
	wire [LOG2_OF_DEPTH + 0:0] write_addr_limit;
	assign write_addr_limit = read_addr + (1 << LOG2_OF_DEPTH);
	assign input_ready = write_addr != write_addr_limit;
	assign output_valid = read_addr != write_addr;
	sky130_sram_fifo_1r1w_8x1024_8 fifo_mem_0(
		.clk0(clk),
		.csb0(!write_effective),
		.addr0(write_addr),
		.din0(din),
		.clk1(clk),
		.csb1(!output_ready),
		.addr1(read_addr),
		.dout1(qout)
	);
endmodule
