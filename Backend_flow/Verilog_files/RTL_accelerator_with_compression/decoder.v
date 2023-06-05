module decoder (
	clk,
	CE,
	mask,
	to_decode,
	decoded
);
	parameter signed [31:0] IO_DATA_WIDTH = 8;
	parameter signed [31:0] MEM_BW = 128;
	input wire clk;
	input wire CE;
	input wire [(2 * IO_DATA_WIDTH) - 1:0] mask;
	input wire [MEM_BW - 1:0] to_decode;
	output reg [127:0] decoded;
	reg [7:0] counter;
	initial begin
		decoded = {16 {8'b00000000}};
		counter = 8'd127;
	end
	integer i;
	integer j;
	always @(posedge clk)
		if (CE) begin
			decoded = {16 {8'b00000000}};
			counter = 8'd127;
			for (j = 0; j <= 1; j = j + 1)
				for (i = 7; i >= 0; i = i - 1)
					if (mask[i + (8 * (1 - j))] != 0) begin
						decoded[((15 - (0 + (j * 8))) * 8) + i] = to_decode[counter];
						decoded[((15 - (1 + (j * 8))) * 8) + i] = to_decode[counter - 1];
						decoded[((15 - (2 + (j * 8))) * 8) + i] = to_decode[counter - 2];
						decoded[((15 - (3 + (j * 8))) * 8) + i] = to_decode[counter - 3];
						decoded[((15 - (4 + (j * 8))) * 8) + i] = to_decode[counter - 4];
						decoded[((15 - (5 + (j * 8))) * 8) + i] = to_decode[counter - 5];
						decoded[((15 - (6 + (j * 8))) * 8) + i] = to_decode[counter - 6];
						decoded[((15 - (7 + (j * 8))) * 8) + i] = to_decode[counter - 7];
						counter = counter - 8;
					end
		end
endmodule
