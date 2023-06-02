module index_table_logic #(
    parameter int MEM_BW = 128,
    parameter int ADDR_WIDTH_ACT = 14,
    parameter int ADDR_WIDTH_MASKS = 11
  )(
  input logic clk, 
  input logic arst_n_in,
  input logic [MEM_BW-1:0] masks,
  input logic CE_signal,
  input logic [32-1:0] masks_transferred,
  output logic [32-1:0] activation_rows_total,
  output logic delayed_CE,
  output logic [ADDR_WIDTH_MASKS-1:0]  delayed_masks_transferred
);
    //// Input registers

    `REG(MEM_BW, masks_reg_1);
    `REG(1, CE_signal_reg_1);
    `REG(32, masks_transferred_reg_1);
    assign masks_reg_1_next = masks;
    assign CE_signal_reg_1_next = CE_signal;
    assign masks_transferred_reg_1_next = masks_transferred;
    assign masks_reg_1_we = CE_signal;
    assign CE_signal_reg_1_we = 1;
    assign masks_transferred_reg_1_we = 1;

    logic [$clog2(MEM_BW):0] output_count;

    count_ones #(
    .MEM_BW            (MEM_BW)
    )
    count_ones_0
    (.input_word(masks_reg_1),
    .output_count(output_count));

    logic [$clog2(MEM_BW)+1:0] sum_1;

    `REG($clog2(MEM_BW)+2, accumulator_reg_1);
    assign accumulator_reg_1_next = sum_1;
    assign accumulator_reg_1_we = CE_signal_reg_1;

    assign sum_1 = (masks_transferred_reg_1 % 2 == 0)? {1'b0, output_count} : (output_count + accumulator_reg_1);

    `REG(1, CE_signal_reg_2);
    `REG(32, masks_transferred_reg_2);
    assign CE_signal_reg_2_next = CE_signal_reg_1;
    assign masks_transferred_reg_2_next = masks_transferred_reg_1;
    assign CE_signal_reg_2_we = 1;
    assign masks_transferred_reg_2_we = 1;

    logic [32-1:0] number_of_rows;
    assign number_of_rows = ((accumulator_reg_1 - 1) >> 4) + 1;

    logic [32-1:0] sum_2;

    `REG(32, accumulator_reg_2);
    assign accumulator_reg_2_next = sum_2;
    assign accumulator_reg_2_we = CE_signal_reg_2 && (masks_transferred_reg_2 % 2 == 1);

    //NOTE: accumular_reg_2 is only resetted at the start
    assign sum_2 = number_of_rows + accumulator_reg_2;

    assign activation_rows_total = sum_2;
    assign delayed_CE = CE_signal_reg_2;
    assign delayed_masks_transferred = masks_transferred_reg_2;
endmodule