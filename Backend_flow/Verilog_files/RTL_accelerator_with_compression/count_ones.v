module count_ones (
	input_word,
	output_count
);
	parameter signed [31:0] MEM_BW = 128;
	input wire [MEM_BW - 1:0] input_word;
	output reg [$clog2(MEM_BW):0] output_count;
	reg signed [31:0] count;
	always @(*) begin
		count = 0;
		begin : sv2v_autoblock_1
			reg signed [31:0] i;
			for (i = 0; i < MEM_BW; i = i + 1)
				count = count + input_word[i];
		end
		output_count = count;
	end
endmodule
