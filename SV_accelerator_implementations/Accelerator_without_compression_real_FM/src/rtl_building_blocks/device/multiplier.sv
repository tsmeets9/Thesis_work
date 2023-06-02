module multiplier #(
  parameter int A_WIDTH = 8,
  parameter int B_WIDTH = 8,
  parameter int OUT_WIDTH = A_WIDTH + B_WIDTH,
  parameter int OUT_SCALE = 16
  )
  (
  input logic [A_WIDTH-1:0] a,
  input logic signed [B_WIDTH-1:0] b,
  output logic signed [OUT_WIDTH-1:0] out);

  localparam INTERMEDIATE_WIDTH = A_WIDTH + B_WIDTH;

  logic signed [INTERMEDIATE_WIDTH-1:0] a_extended;
  assign a_extended = $signed({1'b0,a});
  logic signed [INTERMEDIATE_WIDTH-1:0] b_extended;
  assign b_extended = b;
  logic signed [INTERMEDIATE_WIDTH-1:0] unscaled_out;
  assign unscaled_out = a_extended*b_extended;


  assign out = unscaled_out >>> OUT_SCALE;;


endmodule
