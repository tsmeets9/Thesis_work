
set ::env(STD_CELL_LIBRARY) "sky130_fd_sc_hd"

set ::env(DESIGN_NAME) top_chip
set ::env(VERILOG_FILES) ../Verilog/RTL_accelerator_with_compression/*.v

set ::env(CLOCK_PORT) "clk"
set ::env(CLOCK_NET) "clk"
set ::env(CLOCK_PERIOD) 100
set ::env(CLOCK_TREE_SYNTH) 1

# # Option-1: Auto DIE Area selection
# set ::env(FP_SIZING) relative
# # Option-2: Manual DIE Area config
set ::env(FP_SIZING) absolute
set ::env(DIE_AREA) "0 0 11300 13300"

set ::env(DESIGN_IS_CORE) 1      
set ::env(SYNTH_MAX_FANOUT) 30
set ::env(SYNTH_NO_FLAT) 1
set ::env(SYNTH_STRATEGY) "AREA 3"
set ::env(IO_PCT) 0

set ::env(GRT_MACRO_EXTENSION) 0

# SRAM config
set ::env(VDD_NETS) "vccd1"
set ::env(GND_NETS) "vssd1"
set ::env(FP_PDN_MACRO_HOOKS) "\
genblk1\[0\].sram_weights_banks      vccd1 vssd1 vccd1 vssd1,\ 
genblk1\[1\].sram_weights_banks      vccd1 vssd1 vccd1 vssd1,\
genblk1\[2\].sram_weights_banks      vccd1 vssd1 vccd1 vssd1,\
genblk1\[3\].sram_weights_banks      vccd1 vssd1 vccd1 vssd1,\
genblk1\[4\].sram_weights_banks      vccd1 vssd1 vccd1 vssd1,\
genblk1\[5\].sram_weights_banks      vccd1 vssd1 vccd1 vssd1,\
genblk1\[6\].sram_weights_banks      vccd1 vssd1 vccd1 vssd1,\
genblk1\[7\].sram_weights_banks      vccd1 vssd1 vccd1 vssd1,\
genblk2\[0\].sram_masks_banks      vccd1 vssd1 vccd1 vssd1,\
genblk2\[1\].sram_masks_banks      vccd1 vssd1 vccd1 vssd1,\
genblk2\[2\].sram_masks_banks      vccd1 vssd1 vccd1 vssd1,\
genblk2\[3\].sram_masks_banks      vccd1 vssd1 vccd1 vssd1,\
genblk3\[0\].sram_encoded_data_banks      vccd1 vssd1 vccd1 vssd1,\
genblk3\[1\].sram_encoded_data_banks      vccd1 vssd1 vccd1 vssd1,\
genblk3\[2\].sram_encoded_data_banks      vccd1 vssd1 vccd1 vssd1,\
genblk3\[3\].sram_encoded_data_banks      vccd1 vssd1 vccd1 vssd1,\
genblk3\[4\].sram_encoded_data_banks      vccd1 vssd1 vccd1 vssd1,\
genblk3\[5\].sram_encoded_data_banks      vccd1 vssd1 vccd1 vssd1,\
genblk3\[6\].sram_encoded_data_banks      vccd1 vssd1 vccd1 vssd1,\
genblk3\[7\].sram_encoded_data_banks      vccd1 vssd1 vccd1 vssd1,\
genblk3\[8\].sram_encoded_data_banks      vccd1 vssd1 vccd1 vssd1,\
genblk3\[9\].sram_encoded_data_banks      vccd1 vssd1 vccd1 vssd1,\
genblk3\[10\].sram_encoded_data_banks      vccd1 vssd1 vccd1 vssd1,\
genblk3\[11\].sram_encoded_data_banks      vccd1 vssd1 vccd1 vssd1,\
genblk3\[12\].sram_encoded_data_banks      vccd1 vssd1 vccd1 vssd1,\
genblk3\[13\].sram_encoded_data_banks      vccd1 vssd1 vccd1 vssd1,\
genblk3\[14\].sram_encoded_data_banks      vccd1 vssd1 vccd1 vssd1,\
genblk3\[15\].sram_encoded_data_banks      vccd1 vssd1 vccd1 vssd1,\
genblk3\[16\].sram_encoded_data_banks      vccd1 vssd1 vccd1 vssd1,\
genblk3\[17\].sram_encoded_data_banks      vccd1 vssd1 vccd1 vssd1,\
genblk3\[18\].sram_encoded_data_banks      vccd1 vssd1 vccd1 vssd1,\
genblk3\[19\].sram_encoded_data_banks      vccd1 vssd1 vccd1 vssd1,\
genblk3\[20\].sram_encoded_data_banks      vccd1 vssd1 vccd1 vssd1,\
genblk3\[21\].sram_encoded_data_banks      vccd1 vssd1 vccd1 vssd1,\
genblk3\[22\].sram_encoded_data_banks      vccd1 vssd1 vccd1 vssd1,\
genblk3\[23\].sram_encoded_data_banks      vccd1 vssd1 vccd1 vssd1,\
genblk3\[24\].sram_encoded_data_banks      vccd1 vssd1 vccd1 vssd1,\
genblk3\[25\].sram_encoded_data_banks      vccd1 vssd1 vccd1 vssd1,\
genblk3\[26\].sram_encoded_data_banks      vccd1 vssd1 vccd1 vssd1,\
genblk3\[27\].sram_encoded_data_banks      vccd1 vssd1 vccd1 vssd1,\
genblk3\[28\].sram_encoded_data_banks      vccd1 vssd1 vccd1 vssd1,\
genblk3\[29\].sram_encoded_data_banks      vccd1 vssd1 vccd1 vssd1,\
genblk3\[30\].sram_encoded_data_banks      vccd1 vssd1 vccd1 vssd1,\
genblk3\[31\].sram_encoded_data_banks      vccd1 vssd1 vccd1 vssd1,\
fifo_0.fifo_mem_0      vccd1 vssd1 vccd1 vssd1"

# Option-1: Auto Macro Placement
#set ::env(PL_MACRO_CHANNEL) [list 500 500]
# # Option-2: Manual Macro Placement 
set ::env(MACRO_PLACEMENT_CFG) macro_placement.cfg
set ::env(PL_TARGET_DENSITY) 0.05
set ::env(PL_MACRO_HALO) [list 90 90]
set ::env(FP_CORE_UTIL) 30

# Connect the layout files and abstracts
# Connect the blackbox information and timing data
set ::env(EXTRA_LEFS)      [list OpenRAM_output/sky130_sram_1r1w_128x512_128.lef OpenRAM_output/sky130_sram_fifo_1r1w_8x1024_8.lef]
set ::env(EXTRA_GDS_FILES) [list OpenRAM_output/sky130_sram_1r1w_128x512_128.gds OpenRAM_output/sky130_sram_fifo_1r1w_8x1024_8.gds]
set ::env(EXTRA_LIBS)      [list OpenRAM_output/sky130_sram_1r1w_128x512_128_TT_1p8V_25C.lib OpenRAM_output/sky130_sram_fifo_1r1w_8x1024_8_TT_1p8V_25C.lib]

# other config
set ::env(ROUTING_CORES) 48
set ::env(RUN_KLAYOUT_XOR) 0
set ::env(MAGIC_DRC_USE_GDS) 0
set ::env(QUIT_ON_MAGIC_DRC) 0   

set ::env(DIODE_INSERTION_STRATEGY) 3

# disable klayout because of https://github.com/hdl/conda-eda/issues/175
set ::env(RUN_KLAYOUT) 0
# disable CVC because of https://github.com/hdl/conda-eda/issues/174
set ::env(RUN_CVC) 0
