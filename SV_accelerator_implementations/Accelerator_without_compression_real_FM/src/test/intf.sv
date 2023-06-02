interface intf #(
    config_t cfg
  )
  (
    input logic clk
  );
  logic arst_n;




  /*#############################
  WHEN ADJUSTING THIS INTERFACE, ADJUST THE ENERGY ADDITIONS AT THE BOTTOM ACCORDINGLY!
  ################################*/

  // input interface
  logic [cfg.MEM_BW - 1 : 0] activations_input;
  logic activations_valid;
  logic activations_ready;

  logic [cfg.MEM_BW - 1 : 0] weights_input;
  logic weights_valid;
  logic weights_ready;

  // output interface
  logic [cfg.MEM_BW-1:0] output_data;
  logic output_valid;

  logic start;
  logic running;

  default clocking cb @(posedge clk);
    default input #0.01 output #0.01;
    output arst_n;
    output activations_input;
    output activations_valid;
    input  activations_ready;

    output weights_input;
    output weights_valid;
    input  weights_ready;

    input output_data;
    input output_valid;


    output start;
    input  running;
  endclocking

  modport tb (clocking cb); // testbench's view of the interface


  //ENERGY ESTIMATION:
  always @ (posedge clk) begin
    if(activations_valid && activations_ready) begin
      tbench_top.energy_activations_data_input_off_chip += 1;
    end
  end
  always @ (posedge clk) begin
    if(weights_valid && weights_ready) begin
      tbench_top.energy_weights_off_chip += 1;
    end
  end
  always @ (posedge clk) begin
    if(output_valid && 1) begin //no ready here, set to 1
      tbench_top.energy_activations_data_output_off_chip += 1;
    end
  end

endinterface
