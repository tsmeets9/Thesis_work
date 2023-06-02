//wraps both top_chip and an external memory
//bandwidth to be counted is all bandwidth in and out of top_chip
module top_system #(
    parameter int IO_DATA_WIDTH = 8,
    parameter int ACCUMULATION_WIDTH = 32,
    parameter int FEATURE_MAP_WIDTH = 1024,
    parameter int FEATURE_MAP_HEIGHT = 1024,
    parameter int INPUT_NB_CHANNELS = 64,
    parameter int OUTPUT_NB_CHANNELS = 64,
    parameter int KERNEL_SIZE = 3,
    parameter int MEM_BW = 128,
    parameter int ADDR_WIDTH_ACT = 11,
    parameter int ADDR_WIDTH_WEIGHTS = 9
  ) (input logic clk,
     input logic arst_n_in,  //asynchronous reset, active low

     //system inputs and outputs
     input logic [MEM_BW-1:0] activations_input,
     input logic activations_valid,
     output logic activations_ready,
     input logic [MEM_BW-1:0] weights_input,
     input logic weights_valid,
     output logic weights_ready,

     //output
     output logic signed [MEM_BW-1:0] out,
     output logic output_valid,

     input logic start,
     output logic running
    );

  top_chip #(
  .IO_DATA_WIDTH(IO_DATA_WIDTH),
  .ACCUMULATION_WIDTH(ACCUMULATION_WIDTH),
  .FEATURE_MAP_WIDTH(FEATURE_MAP_WIDTH),
  .FEATURE_MAP_HEIGHT(FEATURE_MAP_HEIGHT),
  .INPUT_NB_CHANNELS(INPUT_NB_CHANNELS),
  .OUTPUT_NB_CHANNELS(OUTPUT_NB_CHANNELS),
  .KERNEL_SIZE(KERNEL_SIZE),
  .MEM_BW            (MEM_BW),
  .ADDR_WIDTH_ACT    (ADDR_WIDTH_ACT),
  .ADDR_WIDTH_WEIGHTS(ADDR_WIDTH_WEIGHTS)
  ) top_chip_i
   (
    .clk(clk),
    .arst_n_in(arst_n_in),

    .activations_input(activations_input),
    .activations_valid(activations_valid),
    .activations_ready(activations_ready),
    .weights_input(weights_input),
    .weights_valid(weights_valid),
    .weights_ready(weights_ready),

    .out(out),
    .output_valid(output_valid),

    .start(start),
    .running(running)
  );
endmodule
