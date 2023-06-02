onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tbench_top/CLK_PERIOD
add wave -noupdate /tbench_top/clk
add wave -noupdate -expand -group loop -radix decimal /tbench_top/dut/top_chip_i/controller/y
add wave -noupdate -expand -group loop -radix decimal /tbench_top/dut/top_chip_i/controller/x
add wave -noupdate -expand -group loop -radix decimal /tbench_top/dut/top_chip_i/controller/ch_out
add wave -noupdate -expand -group loop -radix decimal /tbench_top/dut/top_chip_i/controller/ch_in
add wave -noupdate -expand -group loop /tbench_top/dut/top_chip_i/controller/k_v
add wave -noupdate -expand -group loop /tbench_top/dut/top_chip_i/controller/k_h
add wave -noupdate -group sram_weights /tbench_top/dut/top_chip_i/controller/address_weights_internal
add wave -noupdate -group sram_weights /tbench_top/dut/top_chip_i/sram_weights/addr1_reg
add wave -noupdate -group sram_weights /tbench_top/dut/top_chip_i/sram_weights/csb1_reg
add wave -noupdate -group sram_weights /tbench_top/dut/top_chip_i/controller/read_weights_memory
add wave -noupdate -group sram_weights /tbench_top/dut/top_chip_i/weights_input
add wave -noupdate -group sram_weights -radix decimal /tbench_top/dut/top_chip_i/address_weights
add wave -noupdate -group sram_weights /tbench_top/dut/top_chip_i/controller/CE_address_weights_internal
add wave -noupdate -group sram_weights /tbench_top/dut/top_chip_i/sram_weights/dout1
add wave -noupdate -group sram_weights /tbench_top/dut/weights_input
add wave -noupdate -group sram_weights /tbench_top/dut/top_chip_i/sram_weights/mem
add wave -noupdate -group sram_weights /tbench_top/dut/top_chip_i/sram_weights/csb0_reg
add wave -noupdate -group sram_weights /tbench_top/dut/top_chip_i/sram_weights/csb0
add wave -noupdate -expand -group control_fsm -radix decimal /tbench_top/dut/top_chip_i/controller/current_y_address_index_writing
add wave -noupdate -expand -group control_fsm /tbench_top/dut/top_chip_i/controller/prev_y_address
add wave -noupdate -expand -group control_fsm /tbench_top/dut/top_chip_i/controller/start_write_address
add wave -noupdate -expand -group control_fsm -radix decimal /tbench_top/dut/top_chip_i/controller/y_offset
add wave -noupdate -expand -group control_fsm -radix decimal /tbench_top/dut/top_chip_i/controller/activations_transferred_to_memory
add wave -noupdate -expand -group control_fsm -radix decimal /tbench_top/dut/top_chip_i/controller/y_address_offset
add wave -noupdate -expand -group control_fsm /tbench_top/dut/top_chip_i/controller/output_valid
add wave -noupdate -expand -group control_fsm /tbench_top/dut/top_chip_i/controller/current_state
add wave -noupdate -expand -group control_fsm -radix decimal /tbench_top/dut/top_chip_i/controller/y_address
add wave -noupdate -group control_signals /tbench_top/dut/activations_valid
add wave -noupdate -group control_signals /tbench_top/dut/activations_ready
add wave -noupdate -group control_signals /tbench_top/dut/weights_valid
add wave -noupdate -group control_signals /tbench_top/dut/weights_ready
add wave -noupdate -group sram_activations /tbench_top/dut/activations_input
add wave -noupdate -group sram_activations -radix decimal /tbench_top/dut/top_chip_i/sram_activations/addr0
add wave -noupdate -group sram_activations -radix decimal /tbench_top/dut/top_chip_i/sram_activations/addr1
add wave -noupdate -group sram_activations -radix decimal /tbench_top/dut/top_chip_i/controller/address_activations_writing_internal
add wave -noupdate -group sram_activations /tbench_top/dut/top_chip_i/controller/address_activations_reading
add wave -noupdate -group sram_activations -radix decimal /tbench_top/dut/top_chip_i/controller/address_activations_writing
add wave -noupdate -group sram_activations -radix decimal -childformat {{{/tbench_top/dut/top_chip_i/controller/address_activations_writing[13]} -radix decimal} {{/tbench_top/dut/top_chip_i/controller/address_activations_writing[12]} -radix decimal} {{/tbench_top/dut/top_chip_i/controller/address_activations_writing[11]} -radix decimal} {{/tbench_top/dut/top_chip_i/controller/address_activations_writing[10]} -radix decimal} {{/tbench_top/dut/top_chip_i/controller/address_activations_writing[9]} -radix decimal} {{/tbench_top/dut/top_chip_i/controller/address_activations_writing[8]} -radix decimal} {{/tbench_top/dut/top_chip_i/controller/address_activations_writing[7]} -radix decimal} {{/tbench_top/dut/top_chip_i/controller/address_activations_writing[6]} -radix decimal} {{/tbench_top/dut/top_chip_i/controller/address_activations_writing[5]} -radix decimal} {{/tbench_top/dut/top_chip_i/controller/address_activations_writing[4]} -radix decimal} {{/tbench_top/dut/top_chip_i/controller/address_activations_writing[3]} -radix decimal} {{/tbench_top/dut/top_chip_i/controller/address_activations_writing[2]} -radix decimal} {{/tbench_top/dut/top_chip_i/controller/address_activations_writing[1]} -radix decimal} {{/tbench_top/dut/top_chip_i/controller/address_activations_writing[0]} -radix decimal}} -subitemconfig {{/tbench_top/dut/top_chip_i/controller/address_activations_writing[13]} {-height 16 -radix decimal} {/tbench_top/dut/top_chip_i/controller/address_activations_writing[12]} {-height 16 -radix decimal} {/tbench_top/dut/top_chip_i/controller/address_activations_writing[11]} {-height 16 -radix decimal} {/tbench_top/dut/top_chip_i/controller/address_activations_writing[10]} {-height 16 -radix decimal} {/tbench_top/dut/top_chip_i/controller/address_activations_writing[9]} {-height 16 -radix decimal} {/tbench_top/dut/top_chip_i/controller/address_activations_writing[8]} {-height 16 -radix decimal} {/tbench_top/dut/top_chip_i/controller/address_activations_writing[7]} {-height 16 -radix decimal} {/tbench_top/dut/top_chip_i/controller/address_activations_writing[6]} {-height 16 -radix decimal} {/tbench_top/dut/top_chip_i/controller/address_activations_writing[5]} {-height 16 -radix decimal} {/tbench_top/dut/top_chip_i/controller/address_activations_writing[4]} {-height 16 -radix decimal} {/tbench_top/dut/top_chip_i/controller/address_activations_writing[3]} {-height 16 -radix decimal} {/tbench_top/dut/top_chip_i/controller/address_activations_writing[2]} {-height 16 -radix decimal} {/tbench_top/dut/top_chip_i/controller/address_activations_writing[1]} {-height 16 -radix decimal} {/tbench_top/dut/top_chip_i/controller/address_activations_writing[0]} {-height 16 -radix decimal}} /tbench_top/dut/top_chip_i/controller/address_activations_writing
add wave -noupdate -group sram_activations /tbench_top/dut/top_chip_i/sram_activations/mem
add wave -noupdate -group sram_activations /tbench_top/dut/activations_input
add wave -noupdate -group sram_activations /tbench_top/dut/top_chip_i/driver_activations_0/activations_input
add wave -noupdate -group output_to_monitor /tbench_top/dut/top_chip_i/controller/outputs_to_monitor_counter
add wave -noupdate -group output_to_monitor /tbench_top/dut/top_chip_i/controller/address_activations_reading
add wave -noupdate -group outputs_to_memory -radix decimal /tbench_top/dut/top_chip_i/controller/outputs_to_memory_counter
add wave -noupdate -group outputs_to_memory -radix decimal -childformat {{{/tbench_top/dut/top_chip_i/products_out[0]} -radix decimal -childformat {{{/tbench_top/dut/top_chip_i/products_out[0][0]} -radix decimal} {{/tbench_top/dut/top_chip_i/products_out[0][1]} -radix decimal} {{/tbench_top/dut/top_chip_i/products_out[0][2]} -radix decimal} {{/tbench_top/dut/top_chip_i/products_out[0][3]} -radix decimal} {{/tbench_top/dut/top_chip_i/products_out[0][4]} -radix decimal} {{/tbench_top/dut/top_chip_i/products_out[0][5]} -radix decimal} {{/tbench_top/dut/top_chip_i/products_out[0][6]} -radix decimal} {{/tbench_top/dut/top_chip_i/products_out[0][7]} -radix decimal} {{/tbench_top/dut/top_chip_i/products_out[0][8]} -radix decimal} {{/tbench_top/dut/top_chip_i/products_out[0][9]} -radix decimal} {{/tbench_top/dut/top_chip_i/products_out[0][10]} -radix decimal} {{/tbench_top/dut/top_chip_i/products_out[0][11]} -radix decimal} {{/tbench_top/dut/top_chip_i/products_out[0][12]} -radix decimal} {{/tbench_top/dut/top_chip_i/products_out[0][13]} -radix decimal} {{/tbench_top/dut/top_chip_i/products_out[0][14]} -radix decimal} {{/tbench_top/dut/top_chip_i/products_out[0][15]} -radix decimal}}} {{/tbench_top/dut/top_chip_i/products_out[1]} -radix decimal} {{/tbench_top/dut/top_chip_i/products_out[2]} -radix decimal} {{/tbench_top/dut/top_chip_i/products_out[3]} -radix decimal} {{/tbench_top/dut/top_chip_i/products_out[4]} -radix decimal} {{/tbench_top/dut/top_chip_i/products_out[5]} -radix decimal} {{/tbench_top/dut/top_chip_i/products_out[6]} -radix decimal} {{/tbench_top/dut/top_chip_i/products_out[7]} -radix decimal} {{/tbench_top/dut/top_chip_i/products_out[8]} -radix decimal} {{/tbench_top/dut/top_chip_i/products_out[9]} -radix decimal} {{/tbench_top/dut/top_chip_i/products_out[10]} -radix decimal} {{/tbench_top/dut/top_chip_i/products_out[11]} -radix decimal} {{/tbench_top/dut/top_chip_i/products_out[12]} -radix decimal} {{/tbench_top/dut/top_chip_i/products_out[13]} -radix decimal} {{/tbench_top/dut/top_chip_i/products_out[14]} -radix decimal} {{/tbench_top/dut/top_chip_i/products_out[15]} -radix decimal}} -expand -subitemconfig {{/tbench_top/dut/top_chip_i/products_out[0]} {-height 16 -radix decimal -childformat {{{/tbench_top/dut/top_chip_i/products_out[0][0]} -radix decimal} {{/tbench_top/dut/top_chip_i/products_out[0][1]} -radix decimal} {{/tbench_top/dut/top_chip_i/products_out[0][2]} -radix decimal} {{/tbench_top/dut/top_chip_i/products_out[0][3]} -radix decimal} {{/tbench_top/dut/top_chip_i/products_out[0][4]} -radix decimal} {{/tbench_top/dut/top_chip_i/products_out[0][5]} -radix decimal} {{/tbench_top/dut/top_chip_i/products_out[0][6]} -radix decimal} {{/tbench_top/dut/top_chip_i/products_out[0][7]} -radix decimal} {{/tbench_top/dut/top_chip_i/products_out[0][8]} -radix decimal} {{/tbench_top/dut/top_chip_i/products_out[0][9]} -radix decimal} {{/tbench_top/dut/top_chip_i/products_out[0][10]} -radix decimal} {{/tbench_top/dut/top_chip_i/products_out[0][11]} -radix decimal} {{/tbench_top/dut/top_chip_i/products_out[0][12]} -radix decimal} {{/tbench_top/dut/top_chip_i/products_out[0][13]} -radix decimal} {{/tbench_top/dut/top_chip_i/products_out[0][14]} -radix decimal} {{/tbench_top/dut/top_chip_i/products_out[0][15]} -radix decimal}}} {/tbench_top/dut/top_chip_i/products_out[0][0]} {-height 16 -radix decimal} {/tbench_top/dut/top_chip_i/products_out[0][1]} {-height 16 -radix decimal} {/tbench_top/dut/top_chip_i/products_out[0][2]} {-height 16 -radix decimal} {/tbench_top/dut/top_chip_i/products_out[0][3]} {-height 16 -radix decimal} {/tbench_top/dut/top_chip_i/products_out[0][4]} {-height 16 -radix decimal} {/tbench_top/dut/top_chip_i/products_out[0][5]} {-height 16 -radix decimal} {/tbench_top/dut/top_chip_i/products_out[0][6]} {-height 16 -radix decimal} {/tbench_top/dut/top_chip_i/products_out[0][7]} {-height 16 -radix decimal} {/tbench_top/dut/top_chip_i/products_out[0][8]} {-height 16 -radix decimal} {/tbench_top/dut/top_chip_i/products_out[0][9]} {-height 16 -radix decimal} {/tbench_top/dut/top_chip_i/products_out[0][10]} {-height 16 -radix decimal} {/tbench_top/dut/top_chip_i/products_out[0][11]} {-height 16 -radix decimal} {/tbench_top/dut/top_chip_i/products_out[0][12]} {-height 16 -radix decimal} {/tbench_top/dut/top_chip_i/products_out[0][13]} {-height 16 -radix decimal} {/tbench_top/dut/top_chip_i/products_out[0][14]} {-height 16 -radix decimal} {/tbench_top/dut/top_chip_i/products_out[0][15]} {-height 16 -radix decimal} {/tbench_top/dut/top_chip_i/products_out[1]} {-height 16 -radix decimal} {/tbench_top/dut/top_chip_i/products_out[2]} {-height 16 -radix decimal} {/tbench_top/dut/top_chip_i/products_out[3]} {-height 16 -radix decimal} {/tbench_top/dut/top_chip_i/products_out[4]} {-height 16 -radix decimal} {/tbench_top/dut/top_chip_i/products_out[5]} {-height 16 -radix decimal} {/tbench_top/dut/top_chip_i/products_out[6]} {-height 16 -radix decimal} {/tbench_top/dut/top_chip_i/products_out[7]} {-height 16 -radix decimal} {/tbench_top/dut/top_chip_i/products_out[8]} {-height 16 -radix decimal} {/tbench_top/dut/top_chip_i/products_out[9]} {-height 16 -radix decimal} {/tbench_top/dut/top_chip_i/products_out[10]} {-height 16 -radix decimal} {/tbench_top/dut/top_chip_i/products_out[11]} {-height 16 -radix decimal} {/tbench_top/dut/top_chip_i/products_out[12]} {-height 16 -radix decimal} {/tbench_top/dut/top_chip_i/products_out[13]} {-height 16 -radix decimal} {/tbench_top/dut/top_chip_i/products_out[14]} {-height 16 -radix decimal} {/tbench_top/dut/top_chip_i/products_out[15]} {-height 16 -radix decimal}} /tbench_top/dut/top_chip_i/products_out
add wave -noupdate -group outputs_to_memory /tbench_top/intf_i/output_data
add wave -noupdate -expand -group weights -radix decimal {/tbench_top/dut/top_chip_i/genblk2[0]/reg_weights/qout}
add wave -noupdate -expand -group weights -radix decimal {/tbench_top/dut/top_chip_i/genblk2[1]/reg_weights/qout}
add wave -noupdate -expand -group weights -radix decimal {/tbench_top/dut/top_chip_i/genblk2[2]/reg_weights/qout}
add wave -noupdate -expand -group weights -radix decimal {/tbench_top/dut/top_chip_i/genblk2[3]/reg_weights/qout}
add wave -noupdate -expand -group weights -radix decimal {/tbench_top/dut/top_chip_i/genblk2[4]/reg_weights/qout}
add wave -noupdate -expand -group weights -radix decimal {/tbench_top/dut/top_chip_i/genblk2[5]/reg_weights/qout}
add wave -noupdate -expand -group weights -radix decimal {/tbench_top/dut/top_chip_i/genblk2[6]/reg_weights/qout}
add wave -noupdate -expand -group weights -radix decimal {/tbench_top/dut/top_chip_i/genblk2[7]/reg_weights/qout}
add wave -noupdate -expand -group weights -radix decimal {/tbench_top/dut/top_chip_i/genblk2[8]/reg_weights/qout}
add wave -noupdate -expand -group weights -radix decimal {/tbench_top/dut/top_chip_i/genblk2[9]/reg_weights/qout}
add wave -noupdate -expand -group weights -radix decimal {/tbench_top/dut/top_chip_i/genblk2[10]/reg_weights/qout}
add wave -noupdate -expand -group weights -radix decimal {/tbench_top/dut/top_chip_i/genblk2[11]/reg_weights/qout}
add wave -noupdate -expand -group weights -radix decimal {/tbench_top/dut/top_chip_i/genblk2[12]/reg_weights/qout}
add wave -noupdate -expand -group weights -radix decimal {/tbench_top/dut/top_chip_i/genblk2[13]/reg_weights/qout}
add wave -noupdate -expand -group weights -radix decimal {/tbench_top/dut/top_chip_i/genblk2[14]/reg_weights/qout}
add wave -noupdate -expand -group weights -radix decimal {/tbench_top/dut/top_chip_i/genblk2[15]/reg_weights/qout}
add wave -noupdate -expand -group weights /tbench_top/dut/top_chip_i/write_weights_registers
add wave -noupdate -expand -group FIFO -radix decimal /tbench_top/dut/top_chip_i/fifo_0/din
add wave -noupdate -expand -group FIFO /tbench_top/dut/top_chip_i/fifo_0/input_valid
add wave -noupdate -expand -group FIFO /tbench_top/dut/top_chip_i/fifo_0/input_ready
add wave -noupdate -expand -group FIFO -radix decimal /tbench_top/dut/top_chip_i/fifo_0/qout
add wave -noupdate -expand -group FIFO /tbench_top/dut/top_chip_i/fifo_0/output_valid
add wave -noupdate -expand -group FIFO /tbench_top/dut/top_chip_i/fifo_0/output_ready
add wave -noupdate -expand -group FIFO /tbench_top/dut/top_chip_i/fifo_0/write_effective
add wave -noupdate -expand -group FIFO /tbench_top/dut/top_chip_i/fifo_0/write_addr
add wave -noupdate -expand -group FIFO /tbench_top/dut/top_chip_i/fifo_0/read_addr
add wave -noupdate -expand -group FIFO /tbench_top/dut/top_chip_i/fifo_0/read_effective
add wave -noupdate -expand -group activations -expand -group first_register -radix decimal {/tbench_top/dut/top_chip_i/genblk1[0]/genblk1[0]/genblk1/genblk1/shift_reg/qout}
add wave -noupdate -expand -group activations -expand -group first_register -radix decimal {/tbench_top/dut/top_chip_i/genblk1[0]/genblk1[1]/genblk1/genblk1/shift_reg/qout}
add wave -noupdate -expand -group activations -expand -group first_register -radix decimal {/tbench_top/dut/top_chip_i/genblk1[0]/genblk1[2]/genblk1/genblk1/shift_reg/qout}
add wave -noupdate -expand -group activations -expand -group first_register -radix decimal {/tbench_top/dut/top_chip_i/genblk1[0]/genblk1[3]/genblk1/genblk1/shift_reg/qout}
add wave -noupdate -expand -group activations -expand -group first_register -radix decimal {/tbench_top/dut/top_chip_i/genblk1[0]/genblk1[4]/genblk1/genblk1/shift_reg/qout}
add wave -noupdate -expand -group activations -expand -group first_register -radix decimal {/tbench_top/dut/top_chip_i/genblk1[0]/genblk1[5]/genblk1/genblk1/shift_reg/qout}
add wave -noupdate -expand -group activations -expand -group first_register -radix decimal {/tbench_top/dut/top_chip_i/genblk1[0]/genblk1[6]/genblk1/genblk1/shift_reg/qout}
add wave -noupdate -expand -group activations -expand -group first_register -radix decimal {/tbench_top/dut/top_chip_i/genblk1[0]/genblk1[7]/genblk1/genblk1/shift_reg/qout}
add wave -noupdate -expand -group activations -expand -group first_register -radix decimal {/tbench_top/dut/top_chip_i/genblk1[0]/genblk1[8]/genblk1/genblk1/shift_reg/qout}
add wave -noupdate -expand -group activations -expand -group first_register -radix decimal {/tbench_top/dut/top_chip_i/genblk1[0]/genblk1[9]/genblk1/genblk1/shift_reg/qout}
add wave -noupdate -expand -group activations -expand -group first_register -radix decimal {/tbench_top/dut/top_chip_i/genblk1[0]/genblk1[10]/genblk1/genblk1/shift_reg/qout}
add wave -noupdate -expand -group activations -expand -group first_register -radix decimal {/tbench_top/dut/top_chip_i/genblk1[0]/genblk1[11]/genblk1/genblk1/shift_reg/qout}
add wave -noupdate -expand -group activations -expand -group first_register -radix decimal {/tbench_top/dut/top_chip_i/genblk1[0]/genblk1[12]/genblk1/genblk1/shift_reg/qout}
add wave -noupdate -expand -group activations -expand -group first_register -radix decimal {/tbench_top/dut/top_chip_i/genblk1[0]/genblk1[13]/genblk1/genblk1/shift_reg/qout}
add wave -noupdate -expand -group activations -expand -group first_register -radix decimal {/tbench_top/dut/top_chip_i/genblk1[0]/genblk1[14]/genblk1/genblk1/shift_reg/qout}
add wave -noupdate -expand -group activations -expand -group first_register -radix decimal {/tbench_top/dut/top_chip_i/genblk1[0]/genblk1[15]/genblk1/genblk1/shift_reg/qout}
add wave -noupdate -expand -group activations -expand -group second_register {/tbench_top/dut/top_chip_i/genblk1[1]/genblk1[0]/genblk1/genblk1/shift_reg/qout}
add wave -noupdate -expand -group activations -expand -group second_register {/tbench_top/dut/top_chip_i/genblk1[1]/genblk1[1]/genblk1/genblk1/shift_reg/qout}
add wave -noupdate -expand -group activations -expand -group second_register {/tbench_top/dut/top_chip_i/genblk1[1]/genblk1[2]/genblk1/genblk1/shift_reg/qout}
add wave -noupdate -expand -group activations -expand -group second_register {/tbench_top/dut/top_chip_i/genblk1[1]/genblk1[3]/genblk1/genblk1/shift_reg/qout}
add wave -noupdate -expand -group activations -expand -group second_register {/tbench_top/dut/top_chip_i/genblk1[1]/genblk1[4]/genblk1/genblk1/shift_reg/qout}
add wave -noupdate -expand -group activations -expand -group second_register {/tbench_top/dut/top_chip_i/genblk1[1]/genblk1[5]/genblk1/genblk1/shift_reg/qout}
add wave -noupdate -expand -group activations -expand -group second_register {/tbench_top/dut/top_chip_i/genblk1[1]/genblk1[6]/genblk1/genblk1/shift_reg/qout}
add wave -noupdate -expand -group activations -expand -group second_register {/tbench_top/dut/top_chip_i/genblk1[1]/genblk1[7]/genblk1/genblk1/shift_reg/qout}
add wave -noupdate -expand -group activations -expand -group second_register {/tbench_top/dut/top_chip_i/genblk1[1]/genblk1[8]/genblk1/genblk1/shift_reg/qout}
add wave -noupdate -expand -group activations -expand -group second_register {/tbench_top/dut/top_chip_i/genblk1[1]/genblk1[9]/genblk1/genblk1/shift_reg/qout}
add wave -noupdate -expand -group activations -expand -group second_register {/tbench_top/dut/top_chip_i/genblk1[1]/genblk1[10]/genblk1/genblk1/shift_reg/qout}
add wave -noupdate -expand -group activations -expand -group second_register {/tbench_top/dut/top_chip_i/genblk1[1]/genblk1[11]/genblk1/genblk1/shift_reg/qout}
add wave -noupdate -expand -group activations -expand -group second_register {/tbench_top/dut/top_chip_i/genblk1[1]/genblk1[12]/genblk1/genblk1/shift_reg/qout}
add wave -noupdate -expand -group activations -expand -group second_register {/tbench_top/dut/top_chip_i/genblk1[1]/genblk1[13]/genblk1/genblk1/shift_reg/qout}
add wave -noupdate -expand -group activations -expand -group second_register {/tbench_top/dut/top_chip_i/genblk1[1]/genblk1[14]/genblk1/genblk1/shift_reg/qout}
add wave -noupdate -expand -group activations -expand -group second_register {/tbench_top/dut/top_chip_i/genblk1[1]/genblk1[15]/genblk1/genblk1/shift_reg/qout}
add wave -noupdate -group first_PE {/tbench_top/dut/top_chip_i/PE_array/genblk1[0]/genblk1[0]/mac_unit/a}
add wave -noupdate -group first_PE {/tbench_top/dut/top_chip_i/PE_array/genblk1[0]/genblk1[0]/mac_unit/b}
add wave -noupdate -group first_PE -radix decimal {/tbench_top/dut/top_chip_i/PE_array/genblk1[0]/genblk1[0]/mac_unit/accumulator_value}
add wave -noupdate -group first_PE {/tbench_top/dut/top_chip_i/PE_array/genblk1[0]/genblk1[0]/mac_unit/product}
add wave -noupdate {/tbench_top/dut/top_chip_i/genblk1[1]/genblk1[15]/genblk1/genblk1/shift_reg/din}
add wave -noupdate {/tbench_top/dut/top_chip_i/genblk1[1]/genblk1[15]/genblk1/genblk1/shift_reg/WIDTH}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2354267 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 443
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {2354266 ps} {2354268 ps}
