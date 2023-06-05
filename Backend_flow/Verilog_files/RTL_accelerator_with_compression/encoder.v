module encoder (
	clk,
	CE,
	to_encode,
	mask,
	encoded
);
	parameter signed [31:0] IO_DATA_WIDTH = 16;
	parameter signed [31:0] MEM_BW = 128;
	input wire clk;
	input wire CE;
	input wire [127:0] to_encode;
	output reg [15:0] mask;
	output reg [MEM_BW - 1:0] encoded;
	reg [7:0] counter;
	reg [4:0] count_ones;
	initial begin
		mask = 0;
		encoded = 0;
		counter = 8'd127;
		count_ones = 0;
	end
	integer i;
	integer j;
	integer k;
	always @(posedge clk)
		if (CE) begin
			mask = 0;
			encoded = 0;
			counter = 8'd127;
			count_ones = 0;
			for (k = 0; k <= 1; k = k + 1)
				for (i = 7; i >= 0; i = i - 1)
					if (((((((to_encode[((15 - (0 + (k * 8))) * 8) + i] || to_encode[((15 - (1 + (k * 8))) * 8) + i]) || to_encode[((15 - (2 + (k * 8))) * 8) + i]) || to_encode[((15 - (3 + (k * 8))) * 8) + i]) || to_encode[((15 - (4 + (k * 8))) * 8) + i]) || to_encode[((15 - (5 + (k * 8))) * 8) + i]) || to_encode[((15 - (6 + (k * 8))) * 8) + i]) || to_encode[((15 - (7 + (k * 8))) * 8) + i]) begin
						mask[i + (8 * (1 - k))] = 1;
						encoded[counter] = to_encode[((15 - (0 + (k * 8))) * 8) + i];
						encoded[counter - 1] = to_encode[((15 - (1 + (k * 8))) * 8) + i];
						encoded[counter - 2] = to_encode[((15 - (2 + (k * 8))) * 8) + i];
						encoded[counter - 3] = to_encode[((15 - (3 + (k * 8))) * 8) + i];
						encoded[counter - 4] = to_encode[((15 - (4 + (k * 8))) * 8) + i];
						encoded[counter - 5] = to_encode[((15 - (5 + (k * 8))) * 8) + i];
						encoded[counter - 6] = to_encode[((15 - (6 + (k * 8))) * 8) + i];
						encoded[counter - 7] = to_encode[((15 - (7 + (k * 8))) * 8) + i];
						counter = counter - 8;
					end
		end
endmodule
