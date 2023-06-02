//wraps both top_chip and an external memory
//bandwidth to be counted is all bandwidth in and out of top_chip
module top_system #(
    parameter int IO_DATA_WIDTH = 8,
    parameter int ACCUMULATION_WIDTH = 32,
    parameter int FEATURE_MAP_WIDTH = 56,
    parameter int FEATURE_MAP_HEIGHT = 56,
    parameter int INPUT_NB_CHANNELS = 64,
    parameter int OUTPUT_NB_CHANNELS = 64,
    parameter int KERNEL_SIZE = 3,
    parameter int MEM_BW = 128,
    parameter int ADDR_WIDTH_ACT = 14,
    parameter int ADDR_WIDTH_MASKS = 11, 
    parameter int ADDR_WIDTH_WEIGHTS = 12
  ) (input logic clk,
     input logic arst_n_in,  //asynchronous reset, active low

     //system inputs and outputs
     input logic [MEM_BW-1:0] activations_input,
     input logic activations_valid,
     output logic activations_ready,
     input logic [MEM_BW-1:0] masks_input,
     input logic masks_valid,
     output logic masks_ready,
     input logic [MEM_BW-1:0] weights_input,
     input logic weights_valid,
     output logic weights_ready,

     //output
     output logic signed [MEM_BW-1:0] out_encoded,
     output logic signed [MEM_BW-1:0] out_masks,
     output logic output_valid_encoded,
     output logic output_valid_masks,

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
  .ADDR_WIDTH_MASKS  (ADDR_WIDTH_MASKS),
  .ADDR_WIDTH_WEIGHTS(ADDR_WIDTH_WEIGHTS)
  ) top_chip_i
   (
    .clk(clk),
    .arst_n_in(arst_n_in),

    .activations_input(activations_input),
    .activations_valid(activations_valid),
    .activations_ready(activations_ready),
    .masks_input(masks_input),
    .masks_valid(masks_valid),
    .masks_ready(masks_ready),
    .weights_input(weights_input),
    .weights_valid(weights_valid),
    .weights_ready(weights_ready),

    .out_encoded(out_encoded),
    .out_masks(out_masks),
    .output_valid_encoded(output_valid_encoded),
    .output_valid_masks(output_valid_masks),

    .start(start),
    .running(running)
  );
endmodule
