
set ::env(STD_CELL_LIBRARY) "sky130_fd_sc_hd"

set ::env(DESIGN_NAME) top_chip
set ::env(VERILOG_FILES) ../Verilog/RTL_accelerator_without_compression/*.v

set ::env(CLOCK_PORT) "clk"
set ::env(CLOCK_NET) "clk"
set ::env(CLOCK_PERIOD) 100
set ::env(CLOCK_TREE_SYNTH) 1

# # Option-1: Auto DIE Area selection
# set ::env(FP_SIZING) relative
# # Option-2: Manual DIE Area config
set ::env(FP_SIZING) absolute
set ::env(DIE_AREA) "0 0 11300 11300"

set ::env(DESIGN_IS_CORE) 1      
set ::env(SYNTH_MAX_FANOUT) 30
set ::env(SYNTH_NO_FLAT) 1
set ::env(SYNTH_STRATEGY) "AREA 3"

set ::env(GRT_MACRO_EXTENSION) 0

# SRAM config
set ::env(VDD_NETS) "vccd1"
set ::env(GND_NETS) "vssd1"
# set ::env(FP_PDN_MACRO_HOOKS) "\
#"
set ::env(FP_PDN_MACRO_HOOKS) "\
genblk1\[0\].sram_weights_banks      vccd1 vssd1 vccd1 vssd1,\ 
genblk1\[1\].sram_weights_banks      vccd1 vssd1 vccd1 vssd1,\
genblk1\[2\].sram_weights_banks      vccd1 vssd1 vccd1 vssd1,\
genblk1\[3\].sram_weights_banks      vccd1 vssd1 vccd1 vssd1,\
genblk1\[4\].sram_weights_banks      vccd1 vssd1 vccd1 vssd1,\
genblk1\[5\].sram_weights_banks      vccd1 vssd1 vccd1 vssd1,\
genblk1\[6\].sram_weights_banks      vccd1 vssd1 vccd1 vssd1,\
genblk1\[7\].sram_weights_banks      vccd1 vssd1 vccd1 vssd1,\
genblk2\[0\].sram_activations_banks      vccd1 vssd1 vccd1 vssd1,\
genblk2\[1\].sram_activations_banks      vccd1 vssd1 vccd1 vssd1,\
genblk2\[2\].sram_activations_banks      vccd1 vssd1 vccd1 vssd1,\
genblk2\[3\].sram_activations_banks      vccd1 vssd1 vccd1 vssd1,\
genblk2\[4\].sram_activations_banks      vccd1 vssd1 vccd1 vssd1,\
genblk2\[5\].sram_activations_banks      vccd1 vssd1 vccd1 vssd1,\
genblk2\[6\].sram_activations_banks      vccd1 vssd1 vccd1 vssd1,\
genblk2\[7\].sram_activations_banks      vccd1 vssd1 vccd1 vssd1,\
genblk2\[8\].sram_activations_banks      vccd1 vssd1 vccd1 vssd1,\
genblk2\[9\].sram_activations_banks      vccd1 vssd1 vccd1 vssd1,\
genblk2\[10\].sram_activations_banks      vccd1 vssd1 vccd1 vssd1,\
genblk2\[11\].sram_activations_banks      vccd1 vssd1 vccd1 vssd1,\
genblk2\[12\].sram_activations_banks      vccd1 vssd1 vccd1 vssd1,\
genblk2\[13\].sram_activations_banks      vccd1 vssd1 vccd1 vssd1,\
genblk2\[14\].sram_activations_banks      vccd1 vssd1 vccd1 vssd1,\
genblk2\[15\].sram_activations_banks      vccd1 vssd1 vccd1 vssd1,\
genblk2\[16\].sram_activations_banks      vccd1 vssd1 vccd1 vssd1,\
genblk2\[17\].sram_activations_banks      vccd1 vssd1 vccd1 vssd1,\
genblk2\[18\].sram_activations_banks      vccd1 vssd1 vccd1 vssd1,\
genblk2\[19\].sram_activations_banks      vccd1 vssd1 vccd1 vssd1,\
genblk2\[20\].sram_activations_banks      vccd1 vssd1 vccd1 vssd1,\
genblk2\[21\].sram_activations_banks      vccd1 vssd1 vccd1 vssd1,\
genblk2\[22\].sram_activations_banks      vccd1 vssd1 vccd1 vssd1,\
genblk2\[23\].sram_activations_banks      vccd1 vssd1 vccd1 vssd1,\
genblk2\[24\].sram_activations_banks      vccd1 vssd1 vccd1 vssd1,\
genblk2\[25\].sram_activations_banks      vccd1 vssd1 vccd1 vssd1,\
genblk2\[26\].sram_activations_banks      vccd1 vssd1 vccd1 vssd1,\
genblk2\[27\].sram_activations_banks      vccd1 vssd1 vccd1 vssd1,\
genblk2\[28\].sram_activations_banks      vccd1 vssd1 vccd1 vssd1,\
genblk2\[29\].sram_activations_banks      vccd1 vssd1 vccd1 vssd1,\
genblk2\[30\].sram_activations_banks      vccd1 vssd1 vccd1 vssd1,\
genblk2\[31\].sram_activations_banks      vccd1 vssd1 vccd1 vssd1,\
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
