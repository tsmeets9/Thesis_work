module driver_weights #(
  parameter int IO_DATA_WIDTH = 8,
  parameter int MEM_BW = 128
  )
  (
  input logic [MEM_BW-1:0] weights_input,
  output logic [IO_DATA_WIDTH-1:0] weights_output [0:MEM_BW/IO_DATA_WIDTH-1]
  );

  logic [IO_DATA_WIDTH-1:0] weights_output_internal [0:MEM_BW/IO_DATA_WIDTH-1];
  genvar i;
  generate
  for (i = 0; i < MEM_BW/IO_DATA_WIDTH; i = i + 1) begin
    assign weights_output_internal[i] = weights_input[MEM_BW - 1 - 8*i: MEM_BW - 8 - 8*i];
  end
  endgenerate
  assign weights_output = weights_output_internal;
endmodule