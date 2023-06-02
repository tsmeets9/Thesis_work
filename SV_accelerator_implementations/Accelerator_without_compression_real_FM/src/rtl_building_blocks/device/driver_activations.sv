module driver_activations #(
  parameter int IO_DATA_WIDTH = 8,
  parameter int MEM_BW = 128
  )
  (
  input logic [MEM_BW-1:0] activations_input,
  output logic [IO_DATA_WIDTH-1:0] activations_output [0:MEM_BW/IO_DATA_WIDTH-1]
  );

  logic [IO_DATA_WIDTH-1:0] activations_output_internal [0:MEM_BW/IO_DATA_WIDTH-1];
  genvar i;
  generate
  for (i = 0; i < MEM_BW/IO_DATA_WIDTH; i = i + 1) begin
    assign activations_output_internal[i] = activations_input[MEM_BW - 1 - 8*i: MEM_BW - 8 - 8*i];
  end
  endgenerate
  assign activations_output = activations_output_internal;
endmodule