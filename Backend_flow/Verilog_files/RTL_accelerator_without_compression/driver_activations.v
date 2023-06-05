module driver_activations (
	activations_input,
	activations_output
);
	parameter signed [31:0] IO_DATA_WIDTH = 8;
	parameter signed [31:0] MEM_BW = 128;
	input wire [MEM_BW - 1:0] activations_input;
	output wire [((MEM_BW / IO_DATA_WIDTH) * IO_DATA_WIDTH) - 1:0] activations_output;
	wire [((MEM_BW / IO_DATA_WIDTH) * IO_DATA_WIDTH) - 1:0] activations_output_internal;
	genvar i;
	generate
		for (i = 0; i < (MEM_BW / IO_DATA_WIDTH); i = i + 1) begin : genblk1
			assign activations_output_internal[(((MEM_BW / IO_DATA_WIDTH) - 1) - i) * IO_DATA_WIDTH+:IO_DATA_WIDTH] = activations_input[(MEM_BW - 1) - (8 * i):(MEM_BW - 8) - (8 * i)];
		end
	endgenerate
	assign activations_output = activations_output_internal;
endmodule
