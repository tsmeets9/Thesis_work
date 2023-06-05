module packer (
	outputs_in,
	outputs_out
);
	parameter signed [31:0] IO_DATA_WIDTH = 8;
	parameter signed [31:0] MEM_BW = 128;
	input wire [(16 * IO_DATA_WIDTH) - 1:0] outputs_in;
	output wire [127:0] outputs_out;
	wire [MEM_BW - 1:0] outputs_out_internal;
	assign outputs_out_internal[MEM_BW - 1:MEM_BW - 8] = outputs_in[15 * IO_DATA_WIDTH+:IO_DATA_WIDTH];
	assign outputs_out_internal[MEM_BW - 9:MEM_BW - 16] = outputs_in[14 * IO_DATA_WIDTH+:IO_DATA_WIDTH];
	assign outputs_out_internal[MEM_BW - 17:MEM_BW - 24] = outputs_in[13 * IO_DATA_WIDTH+:IO_DATA_WIDTH];
	assign outputs_out_internal[MEM_BW - 25:MEM_BW - 32] = outputs_in[12 * IO_DATA_WIDTH+:IO_DATA_WIDTH];
	assign outputs_out_internal[MEM_BW - 33:MEM_BW - 40] = outputs_in[11 * IO_DATA_WIDTH+:IO_DATA_WIDTH];
	assign outputs_out_internal[MEM_BW - 41:MEM_BW - 48] = outputs_in[10 * IO_DATA_WIDTH+:IO_DATA_WIDTH];
	assign outputs_out_internal[MEM_BW - 49:MEM_BW - 56] = outputs_in[9 * IO_DATA_WIDTH+:IO_DATA_WIDTH];
	assign outputs_out_internal[MEM_BW - 57:MEM_BW - 64] = outputs_in[8 * IO_DATA_WIDTH+:IO_DATA_WIDTH];
	assign outputs_out_internal[MEM_BW - 65:MEM_BW - 72] = outputs_in[7 * IO_DATA_WIDTH+:IO_DATA_WIDTH];
	assign outputs_out_internal[MEM_BW - 73:MEM_BW - 80] = outputs_in[6 * IO_DATA_WIDTH+:IO_DATA_WIDTH];
	assign outputs_out_internal[MEM_BW - 81:MEM_BW - 88] = outputs_in[5 * IO_DATA_WIDTH+:IO_DATA_WIDTH];
	assign outputs_out_internal[MEM_BW - 89:MEM_BW - 96] = outputs_in[4 * IO_DATA_WIDTH+:IO_DATA_WIDTH];
	assign outputs_out_internal[MEM_BW - 97:MEM_BW - 104] = outputs_in[3 * IO_DATA_WIDTH+:IO_DATA_WIDTH];
	assign outputs_out_internal[MEM_BW - 105:MEM_BW - 112] = outputs_in[2 * IO_DATA_WIDTH+:IO_DATA_WIDTH];
	assign outputs_out_internal[MEM_BW - 113:MEM_BW - 120] = outputs_in[IO_DATA_WIDTH+:IO_DATA_WIDTH];
	assign outputs_out_internal[MEM_BW - 121:MEM_BW - 128] = outputs_in[0+:IO_DATA_WIDTH];
	assign outputs_out = outputs_out_internal;
endmodule
