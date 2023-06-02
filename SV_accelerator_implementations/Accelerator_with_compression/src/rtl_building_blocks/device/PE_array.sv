module PE_array #(
  parameter int A_WIDTH = 8,
  parameter int B_WIDTH = 8,
  parameter int ACCUMULATOR_WIDTH = 32,
  parameter int OUTPUT_WIDTH = 8,
  parameter int OUTPUT_SCALE = 0
  )
  (
  input logic clk,
  input logic arst_n_in, //asynchronous reset, active low

  //input interface
  input logic input_valid,
  input logic accumulate_internal, //accumulate (accumulator <= a*b + accumulator) if high (1) or restart accumulation (accumulator <= a*b+0) if low (0)
  input logic signed [A_WIDTH-1:0] activations [0:15],
  input logic signed [B_WIDTH-1:0] weights [0:15],

  //output
  output logic signed [OUTPUT_WIDTH-1:0] outs [0:15][0:15]
  );

  logic signed [OUTPUT_WIDTH-1:0] products [0:15][0:15];
  genvar i,j;
  generate
    for (i = 0; i < 16; i = i + 1) begin
      for (j = 0; j < 16; j = j + 1) begin
        mac #(.A_WIDTH(A_WIDTH),
              .B_WIDTH(B_WIDTH),
              .ACCUMULATOR_WIDTH(ACCUMULATOR_WIDTH),
              .OUTPUT_WIDTH(OUTPUT_WIDTH),
              .OUTPUT_SCALE(0))
        mac_unit(
        .clk(clk),
        .arst_n_in(arst_n_in),
        .input_valid(input_valid),
        .accumulate_internal(accumulate_internal),
        .a(activations[i]),
        .b(weights[j]),
        .out(products[i][j])
        );
      end
    end
  endgenerate
  assign outs = products;
endmodule