
module tbench_top;
  //change this according to your critical path length.
  //The code will error* if it too short, but you will get no feedback if it is longer than necessary
  //* if 1) you use the adder and multiplier modules for datapath adders and multipliers and not the plain verilog + and * operators
  // and 2) enough calculations are going on, with non-x data (this will be the case for functionally working code)
  localparam int CLK_PERIOD = 2;
  // localparam SMALL_TEST = 0;



  localparam int DATA_WIDTH         = 8;
  localparam int ACCUMULATION_WIDTH = 32;
  localparam int FEATURE_MAP_WIDTH  = 56;
  localparam int FEATURE_MAP_HEIGHT = 56; //56
  localparam int INPUT_NB_CHANNELS  = 64; //64;
  localparam int OUTPUT_NB_CHANNELS = 64; //64;
  localparam int KERNEL_SIZE        = 3;
  localparam int MEM_BW             = 128;
  localparam int ADDR_WIDTH_ACT     = 14;
  localparam int ADDR_WIDTH_MASKS   = 11;
  localparam int ADDR_WIDTH_WEIGHTS = 12;

  // initialize config_t structure, which is used to parameterize all other classes of the testbench
  localparam config_t cfg= '{
    DATA_WIDTH        ,
    ACCUMULATION_WIDTH,
    FEATURE_MAP_WIDTH ,
    FEATURE_MAP_HEIGHT,
    INPUT_NB_CHANNELS ,
    OUTPUT_NB_CHANNELS,
    KERNEL_SIZE,
    MEM_BW,
    ADDR_WIDTH_ACT,
    ADDR_WIDTH_MASKS,
    ADDR_WIDTH_WEIGHTS
  };

  initial $timeformat(-9, 3, "ns", 1);


  //clock
  bit clk;
  always #(CLK_PERIOD*1.0/2.0) clk = !clk;

  //interface
  intf #(cfg) intf_i (clk);

  testprogram #(cfg) t1(intf_i.tb);

  //DUT
  top_system #(
  .IO_DATA_WIDTH     (DATA_WIDTH),
  .ACCUMULATION_WIDTH(ACCUMULATION_WIDTH),
  .FEATURE_MAP_WIDTH (FEATURE_MAP_WIDTH),
  .FEATURE_MAP_HEIGHT(FEATURE_MAP_HEIGHT),
  .INPUT_NB_CHANNELS (INPUT_NB_CHANNELS),
  .OUTPUT_NB_CHANNELS(OUTPUT_NB_CHANNELS),
  .KERNEL_SIZE       (KERNEL_SIZE),
  .MEM_BW            (MEM_BW),
  .ADDR_WIDTH_ACT    (ADDR_WIDTH_ACT),
  .ADDR_WIDTH_MASKS  (ADDR_WIDTH_MASKS),
  .ADDR_WIDTH_WEIGHTS(ADDR_WIDTH_WEIGHTS)
  ) dut (
   .clk         (intf_i.clk),
   .arst_n_in   (intf_i.arst_n),

   .activations_input     (intf_i.activations_input),
   .masks_input     (intf_i.masks_input),
   .weights_input     (intf_i.weights_input),
   .activations_valid     (intf_i.activations_valid),
   .masks_valid     (intf_i.masks_valid),
   .weights_valid     (intf_i.weights_valid),
   .activations_ready     (intf_i.activations_ready),
   .masks_ready     (intf_i.masks_ready),
   .weights_ready     (intf_i.weights_ready),

   .out_encoded         (intf_i.output_data_encoded),
   .out_masks         (intf_i.output_data_masks),

   .output_valid_encoded(intf_i.output_valid_encoded),
   .output_valid_masks(intf_i.output_valid_masks),


   .start       (intf_i.start),
   .running     (intf_i.running)
  );


  // //area logging init
  // longint area;
  // initial begin
  //   area = 0;
  //   #0;
  //   #0;
  //   $display("\n\n------------\nAREA: %0d\n------------\n\n", area);
  // end
  //energy loggin init;
  real energy;
  initial begin
    energy = 0;
  end



endmodule
