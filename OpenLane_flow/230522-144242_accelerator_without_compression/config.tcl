# Run configs
set ::env(PDK_ROOT) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk}
set ::env(BASE_SDC_FILE) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/openlane/scripts/base.sdc}
set ::env(BOTTOM_MARGIN_MULT) {4}
set ::env(CARRY_SELECT_ADDER_MAP) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.tech/openlane/sky130_fd_sc_hd/csa_map.v}
set ::env(CELLS_LEF) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/lef/sky130_fd_sc_hd.lef /users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/lef/sky130_ef_sc_hd.lef}
set ::env(CELLS_LEF_OPT) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/lef/sky130_fd_sc_hd.lef /users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/lef/sky130_ef_sc_hd.lef}
set ::env(CELL_CLK_PORT) {CLK}
set ::env(CELL_PAD_EXCLUDE) {sky130_fd_sc_hd__tap* sky130_fd_sc_hd__decap* sky130_ef_sc_hd__decap* sky130_fd_sc_hd__fill*}
set ::env(CLK_BUFFER) {sky130_fd_sc_hd__clkbuf_4}
set ::env(CLK_BUFFER_INPUT) {A}
set ::env(CLK_BUFFER_OUTPUT) {X}
set ::env(CLOCK_BUFFER_FANOUT) {16}
set ::env(CLOCK_NET) {clk}
set ::env(CLOCK_PERIOD) {100}
set ::env(CLOCK_PORT) {clk}
set ::env(CLOCK_TREE_SYNTH) {1}
set ::env(CLOCK_WIRE_RC_LAYER) {met5}
set ::env(CONFIGS) {general.tcl checkers.tcl synthesis.tcl floorplan.tcl cts.tcl placement.tcl routing.tcl extraction.tcl disable-missing-tools.tcl}
set ::env(CTS_CLK_BUFFER_LIST) {sky130_fd_sc_hd__clkbuf_8 sky130_fd_sc_hd__clkbuf_4 sky130_fd_sc_hd__clkbuf_2}
set ::env(CTS_CLK_MAX_WIRE_LENGTH) {0}
set ::env(CTS_DISABLE_POST_PROCESSING) {0}
set ::env(CTS_DISTANCE_BETWEEN_BUFFERS) {0}
set ::env(CTS_MAX_CAP) {1.53169}
set ::env(CTS_REPORT_TIMING) {1}
set ::env(CTS_ROOT_BUFFER) {sky130_fd_sc_hd__clkbuf_16}
set ::env(CTS_SINK_CLUSTERING_MAX_DIAMETER) {50}
set ::env(CTS_SINK_CLUSTERING_SIZE) {25}
set ::env(CTS_SQR_CAP) {0.258e-3}
set ::env(CTS_SQR_RES) {0.125}
set ::env(CTS_TARGET_SKEW) {200}
set ::env(CTS_TECH_DIR) {N/A}
set ::env(CTS_TOLERANCE) {100}
set ::env(CVC_SCRIPTS_DIR) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.tech/openlane/cvc}
set ::env(DATA_WIRE_RC_LAYER) {met2}
set ::env(DECAP_CELL) {sky130_ef_sc_hd__decap_12 sky130_fd_sc_hd__decap_8 sky130_fd_sc_hd__decap_6 sky130_fd_sc_hd__decap_4 sky130_fd_sc_hd__decap_3}
set ::env(DEFAULT_MAX_TRAN) {0.75}
set ::env(DEF_UNITS_PER_MICRON) {1000}
set ::env(DESIGN_CONFIG) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/config.tcl}
set ::env(DESIGN_IS_CORE) {1}
set ::env(DETAILED_ROUTER) {tritonroute}
set ::env(DIE_AREA) {0 0 11300 11300}
set ::env(DIODE_CELL) {sky130_fd_sc_hd__diode_2}
set ::env(DIODE_CELL_PIN) {DIODE}
set ::env(DIODE_INSERTION_STRATEGY) {3}
set ::env(DIODE_PADDING) {2}
set ::env(DPL_CELL_PADDING) {0}
set ::env(DRC_EXCLUDE_CELL_LIST) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.tech/openlane/sky130_fd_sc_hd/drc_exclude.cells}
set ::env(DRC_EXCLUDE_CELL_LIST_OPT) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.tech/openlane/sky130_fd_sc_hd/drc_exclude.cells}
set ::env(DRT_OPT_ITERS) {64}
set ::env(ECO_ENABLE) {0}
set ::env(ECO_FINISH) {0}
set ::env(ECO_ITER) {0}
set ::env(ECO_SKIP_PIN) {1}
set ::env(EXTRA_GDS_FILES) {OpenRAM_output/sky130_sram_1r1w_128x512_128.gds OpenRAM_output/sky130_sram_fifo_1r1w_8x1024_8.gds}
set ::env(EXTRA_LEFS) {OpenRAM_output/sky130_sram_1r1w_128x512_128.lef OpenRAM_output/sky130_sram_fifo_1r1w_8x1024_8.lef}
set ::env(EXTRA_LIBS) {OpenRAM_output/sky130_sram_1r1w_128x512_128_TT_1p8V_25C.lib OpenRAM_output/sky130_sram_fifo_1r1w_8x1024_8_TT_1p8V_25C.lib}
set ::env(FAKEDIODE_CELL) {sky130_ef_sc_hd__fakediode_2}
set ::env(FILL_CELL) {sky130_fd_sc_hd__fill*}
set ::env(FP_ASPECT_RATIO) {1}
set ::env(FP_CORE_UTIL) {30}
set ::env(FP_ENDCAP_CELL) {sky130_fd_sc_hd__decap_3}
set ::env(FP_IO_HEXTEND) {0}
set ::env(FP_IO_HLAYER) {met3}
set ::env(FP_IO_HLENGTH) {4}
set ::env(FP_IO_HTHICKNESS_MULT) {2}
set ::env(FP_IO_MIN_DISTANCE) {3}
set ::env(FP_IO_MODE) {1}
set ::env(FP_IO_UNMATCHED_ERROR) {1}
set ::env(FP_IO_VEXTEND) {0}
set ::env(FP_IO_VLAYER) {met2}
set ::env(FP_IO_VLENGTH) {4}
set ::env(FP_IO_VTHICKNESS_MULT) {2}
set ::env(FP_PDN_AUTO_ADJUST) {1}
set ::env(FP_PDN_CHECK_NODES) {1}
set ::env(FP_PDN_CORE_RING) {0}
set ::env(FP_PDN_CORE_RING_HOFFSET) {6}
set ::env(FP_PDN_CORE_RING_HSPACING) {1.7}
set ::env(FP_PDN_CORE_RING_HWIDTH) {1.6}
set ::env(FP_PDN_CORE_RING_VOFFSET) {6}
set ::env(FP_PDN_CORE_RING_VSPACING) {1.7}
set ::env(FP_PDN_CORE_RING_VWIDTH) {1.6}
set ::env(FP_PDN_ENABLE_GLOBAL_CONNECTIONS) {1}
set ::env(FP_PDN_ENABLE_MACROS_GRID) {1}
set ::env(FP_PDN_ENABLE_RAILS) {1}
set ::env(FP_PDN_HOFFSET) {16.65}
set ::env(FP_PDN_HORIZONTAL_HALO) {10}
set ::env(FP_PDN_HPITCH) {153.18}
set ::env(FP_PDN_HSPACING) {1.7}
set ::env(FP_PDN_HWIDTH) {1.6}
set ::env(FP_PDN_IRDROP) {1}
set ::env(FP_PDN_LOWER_LAYER) {met4}
set ::env(FP_PDN_MACRO_HOOKS) { genblk1[0].sram_weights_banks      vccd1 vssd1 vccd1 vssd1, 
genblk1[1].sram_weights_banks      vccd1 vssd1 vccd1 vssd1, genblk1[2].sram_weights_banks      vccd1 vssd1 vccd1 vssd1, genblk1[3].sram_weights_banks      vccd1 vssd1 vccd1 vssd1, genblk1[4].sram_weights_banks      vccd1 vssd1 vccd1 vssd1, genblk1[5].sram_weights_banks      vccd1 vssd1 vccd1 vssd1, genblk1[6].sram_weights_banks      vccd1 vssd1 vccd1 vssd1, genblk1[7].sram_weights_banks      vccd1 vssd1 vccd1 vssd1, genblk2[0].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[1].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[2].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[3].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[4].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[5].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[6].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[7].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[8].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[9].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[10].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[11].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[12].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[13].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[14].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[15].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[16].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[17].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[18].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[19].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[20].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[21].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[22].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[23].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[24].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[25].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[26].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[27].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[28].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[29].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[30].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[31].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, fifo_0.fifo_mem_0      vccd1 vssd1 vccd1 vssd1}
set ::env(FP_PDN_RAILS_LAYER) {met1}
set ::env(FP_PDN_RAIL_OFFSET) {0}
set ::env(FP_PDN_RAIL_WIDTH) {0.48}
set ::env(FP_PDN_SKIPTRIM) {0}
set ::env(FP_PDN_UPPER_LAYER) {met5}
set ::env(FP_PDN_VERTICAL_HALO) {10}
set ::env(FP_PDN_VOFFSET) {16.32}
set ::env(FP_PDN_VPITCH) {153.6}
set ::env(FP_PDN_VSPACING) {1.7}
set ::env(FP_PDN_VWIDTH) {1.6}
set ::env(FP_SIZING) {absolute}
set ::env(FP_TAPCELL_DIST) {13}
set ::env(FP_TAP_HORIZONTAL_HALO) {10}
set ::env(FP_TAP_VERTICAL_HALO) {10}
set ::env(FP_WELLTAP_CELL) {sky130_fd_sc_hd__tapvpwrvgnd_1}
set ::env(FULL_ADDER_MAP) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.tech/openlane/sky130_fd_sc_hd/fa_map.v}
set ::env(GDS_FILES) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/gds/sky130_fd_sc_hd.gds}
set ::env(GDS_FILES_OPT) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/gds/sky130_fd_sc_hd.gds}
set ::env(GENERATE_FINAL_SUMMARY_REPORT) {1}
set ::env(GLB_CFG_FILE) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/config.tcl}
set ::env(GLB_OPTIMIZE_MIRRORING) {1}
set ::env(GLB_RESIZER_ALLOW_SETUP_VIOS) {0}
set ::env(GLB_RESIZER_HOLD_MAX_BUFFER_PERCENT) {50}
set ::env(GLB_RESIZER_HOLD_SLACK_MARGIN) {0.05}
set ::env(GLB_RESIZER_MAX_CAP_MARGIN) {10}
set ::env(GLB_RESIZER_MAX_SLEW_MARGIN) {10}
set ::env(GLB_RESIZER_MAX_WIRE_LENGTH) {0}
set ::env(GLB_RESIZER_SETUP_MAX_BUFFER_PERCENT) {50}
set ::env(GLB_RESIZER_SETUP_SLACK_MARGIN) {0.025}
set ::env(GLB_RESIZER_TIMING_OPTIMIZATIONS) {1}
set ::env(GLOBAL_ROUTER) {fastroute}
set ::env(GND_NETS) {vssd1}
set ::env(GND_PIN) {VGND}
set ::env(GND_PIN_VOLTAGE) {0.00}
set ::env(GPIO_PADS_LEF) { /users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.ref/sky130_fd_io/lef/sky130_fd_io.lef /users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.ref/sky130_fd_io/lef/sky130_ef_io.lef }
set ::env(GPIO_PADS_LEF_CORE_SIDE) { /users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.tech/openlane/custom_cells/lef/sky130_fd_io_core.lef /users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.tech/openlane/custom_cells/lef/sky130_ef_io_core.lef }
set ::env(GPIO_PADS_PREFIX) {sky130_fd_io sky130_ef_io}
set ::env(GPIO_PADS_VERILOG) { /users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.ref/sky130_fd_io/verilog/sky130_ef_io.v
}
set ::env(GPL_CELL_PADDING) {0}
set ::env(GRT_ADJUSTMENT) {0.3}
set ::env(GRT_ALLOW_CONGESTION) {0}
set ::env(GRT_ANT_ITERS) {3}
set ::env(GRT_ESTIMATE_PARASITICS) {1}
set ::env(GRT_LAYER_ADJUSTMENTS) {0.99,0,0,0,0,0}
set ::env(GRT_MACRO_EXTENSION) {0}
set ::env(GRT_MAX_DIODE_INS_ITERS) {1}
set ::env(GRT_OVERFLOW_ITERS) {50}
set ::env(IO_PCT) {0.2}
set ::env(KLAYOUT_DEF_LAYER_MAP) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.tech/klayout/tech/sky130A.map}
set ::env(KLAYOUT_DRC_KLAYOUT_GDS) {0}
set ::env(KLAYOUT_DRC_TECH_SCRIPT) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.tech/klayout/drc/sky130A_mr.drc}
set ::env(KLAYOUT_PROPERTIES) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.tech/klayout/tech/sky130A.lyp}
set ::env(KLAYOUT_TECH) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.tech/klayout/tech/sky130A.lyt}
set ::env(KLAYOUT_XOR_GDS) {1}
set ::env(KLAYOUT_XOR_IGNORE_LAYERS) {81/14}
set ::env(KLAYOUT_XOR_THREADS) {1}
set ::env(KLAYOUT_XOR_XML) {1}
set ::env(LEC_ENABLE) {0}
set ::env(LEFT_MARGIN_MULT) {12}
set ::env(LIB_FASTEST) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__ff_n40C_1v95.lib}
set ::env(LIB_SLOWEST) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__ss_100C_1v60.lib}
set ::env(LIB_SLOWEST_OPT) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__ss_100C_1v60.lib}
set ::env(LIB_SYNTH) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib}
set ::env(LIB_TYPICAL) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib}
set ::env(LOGS_DIR) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/logs}
set ::env(LVS_CONNECT_BY_LABEL) {0}
set ::env(LVS_INSERT_POWER_PINS) {1}
set ::env(MACRO_BLOCKAGES_LAYER) {li1 met1 met2 met3 met4}
set ::env(MACRO_PLACEMENT_CFG) {macro_placement.cfg}
set ::env(MAGIC_CONVERT_DRC_TO_RDB) {1}
set ::env(MAGIC_DEF_LABELS) {1}
set ::env(MAGIC_DEF_NO_BLOCKAGES) {1}
set ::env(MAGIC_DISABLE_HIER_GDS) {1}
set ::env(MAGIC_DRC_USE_GDS) {0}
set ::env(MAGIC_EXT_USE_GDS) {0}
set ::env(MAGIC_GDS_ALLOW_ABSTRACT) {0}
set ::env(MAGIC_GDS_POLYGON_SUBCELLS) {0}
set ::env(MAGIC_GENERATE_GDS) {1}
set ::env(MAGIC_GENERATE_LEF) {1}
set ::env(MAGIC_GENERATE_MAGLEF) {1}
set ::env(MAGIC_INCLUDE_GDS_POINTERS) {0}
set ::env(MAGIC_MAGICRC) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.tech/magic/sky130A.magicrc}
set ::env(MAGIC_PAD) {0}
set ::env(MAGIC_TECH_FILE) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.tech/magic/sky130A.tech}
set ::env(MAGIC_WRITE_FULL_LEF) {0}
set ::env(MAGIC_ZEROIZE_ORIGIN) {0}
set ::env(NETGEN_SETUP_FILE) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.tech/netgen/sky130A_setup.tcl}
set ::env(NO_SYNTH_CELL_LIST) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.tech/openlane/sky130_fd_sc_hd/no_synth.cells}
set ::env(OPENLANE_VERBOSE) {0}
set ::env(PDKPATH) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A}
set ::env(PDN_CFG) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/openlane/scripts/openroad/common/pdn_cfg.tcl}
set ::env(PLACE_SITE) {unithd}
set ::env(PLACE_SITE_HEIGHT) {2.720}
set ::env(PLACE_SITE_WIDTH) {0.460}
set ::env(PL_BASIC_PLACEMENT) {0}
set ::env(PL_ESTIMATE_PARASITICS) {1}
set ::env(PL_LIB) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib}
set ::env(PL_MACRO_CHANNEL) {0 0}
set ::env(PL_MACRO_HALO) {90 90}
set ::env(PL_MAX_DISPLACEMENT_X) {500}
set ::env(PL_MAX_DISPLACEMENT_Y) {100}
set ::env(PL_OPTIMIZE_MIRRORING) {1}
set ::env(PL_RANDOM_GLB_PLACEMENT) {0}
set ::env(PL_RANDOM_INITIAL_PLACEMENT) {0}
set ::env(PL_RESIZER_ALLOW_SETUP_VIOS) {0}
set ::env(PL_RESIZER_BUFFER_INPUT_PORTS) {1}
set ::env(PL_RESIZER_BUFFER_OUTPUT_PORTS) {1}
set ::env(PL_RESIZER_DESIGN_OPTIMIZATIONS) {1}
set ::env(PL_RESIZER_HOLD_MAX_BUFFER_PERCENT) {50}
set ::env(PL_RESIZER_HOLD_SLACK_MARGIN) {0.1}
set ::env(PL_RESIZER_MAX_CAP_MARGIN) {20}
set ::env(PL_RESIZER_MAX_SLEW_MARGIN) {20}
set ::env(PL_RESIZER_MAX_WIRE_LENGTH) {0}
set ::env(PL_RESIZER_REPAIR_TIE_FANOUT) {1}
set ::env(PL_RESIZER_SETUP_MAX_BUFFER_PERCENT) {50}
set ::env(PL_RESIZER_SETUP_SLACK_MARGIN) {0.05}
set ::env(PL_RESIZER_TIE_SEPERATION) {0}
set ::env(PL_RESIZER_TIMING_OPTIMIZATIONS) {1}
set ::env(PL_ROUTABILITY_DRIVEN) {1}
set ::env(PL_SKIP_INITIAL_PLACEMENT) {0}
set ::env(PL_TARGET_DENSITY) {0.05}
set ::env(PL_TIME_DRIVEN) {1}
set ::env(PL_WIRELENGTH_COEF) {0.25}
set ::env(PRIMARY_SIGNOFF_TOOL) {magic}
set ::env(PROCESS) {130}
set ::env(QUIT_ON_ASSIGN_STATEMENTS) {0}
set ::env(QUIT_ON_HOLD_VIOLATIONS) {1}
set ::env(QUIT_ON_ILLEGAL_OVERLAPS) {1}
set ::env(QUIT_ON_LONG_WIRE) {0}
set ::env(QUIT_ON_LVS_ERROR) {1}
set ::env(QUIT_ON_MAGIC_DRC) {0}
set ::env(QUIT_ON_SETUP_VIOLATIONS) {1}
set ::env(QUIT_ON_SYNTH_CHECKS) {0}
set ::env(QUIT_ON_TIMING_VIOLATIONS) {1}
set ::env(QUIT_ON_TR_DRC) {1}
set ::env(QUIT_ON_UNMAPPED_CELLS) {1}
set ::env(QUIT_ON_XOR_ERROR) {1}
set ::env(RCX_CC_MODEL) {10}
set ::env(RCX_CONTEXT_DEPTH) {5}
set ::env(RCX_CORNER_COUNT) {1}
set ::env(RCX_COUPLING_THRESHOLD) {0.1}
set ::env(RCX_MAX_RESISTANCE) {50}
set ::env(RCX_MERGE_VIA_WIRE_RES) {1}
set ::env(RCX_RULES) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.tech/openlane/rules.openrcx.sky130A.nom.calibre}
set ::env(RCX_RULES_MAX) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.tech/openlane/rules.openrcx.sky130A.max.calibre}
set ::env(RCX_RULES_MIN) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.tech/openlane/rules.openrcx.sky130A.min.calibre}
set ::env(REPORTS_DIR) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/reports}
set ::env(RESULTS_DIR) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/results}
set ::env(RE_BUFFER_CELL) {sky130_fd_sc_hd__buf_4}
set ::env(RIGHT_MARGIN_MULT) {12}
set ::env(RIPPLE_CARRY_ADDER_MAP) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.tech/openlane/sky130_fd_sc_hd/rca_map.v}
set ::env(ROOT_CLK_BUFFER) {sky130_fd_sc_hd__clkbuf_16}
set ::env(ROUTING_CORES) {48}
set ::env(RSZ_DONT_TOUCH_RX) {$^}
set ::env(RSZ_USE_OLD_REMOVER) {0}
set ::env(RT_MAX_LAYER) {met5}
set ::env(RT_MIN_LAYER) {met1}
set ::env(RUN_CVC) {0}
set ::env(RUN_DIR) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression}
set ::env(RUN_DRT) {1}
set ::env(RUN_FILL_INSERTION) {1}
set ::env(RUN_IRDROP_REPORT) {1}
set ::env(RUN_KLAYOUT) {0}
set ::env(RUN_KLAYOUT_DRC) {0}
set ::env(RUN_KLAYOUT_XOR) {0}
set ::env(RUN_LVS) {1}
set ::env(RUN_MAGIC) {1}
set ::env(RUN_MAGIC_DRC) {1}
set ::env(RUN_SPEF_EXTRACTION) {1}
set ::env(RUN_TAG) {230522-144242_accelerator_without_compression}
set ::env(RUN_TAP_DECAP_INSERTION) {1}
set ::env(SCLPATH) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/sky130_fd_sc_hd}
set ::env(SPEF_EXTRACTOR) {openrcx}
set ::env(START_TIME) {2023.05.22_14.42.56}
set ::env(STA_REPORT_POWER) {1}
set ::env(STA_WRITE_LIB) {1}
set ::env(STD_CELL_GROUND_PINS) {VGND VNB}
set ::env(STD_CELL_LIBRARY_CDL) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/cdl/sky130_fd_sc_hd.cdl}
set ::env(STD_CELL_LIBRARY_OPT_CDL) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/cdl/sky130_fd_sc_hd.cdl}
set ::env(STD_CELL_POWER_PINS) {VPWR VPB}
set ::env(SYNTH_ADDER_TYPE) {YOSYS}
set ::env(SYNTH_BIN) {yosys}
set ::env(SYNTH_BUFFERING) {1}
set ::env(SYNTH_CAP_LOAD) {33.442}
set ::env(SYNTH_CLOCK_TRANSITION) {0.15}
set ::env(SYNTH_CLOCK_UNCERTAINTY) {0.25}
set ::env(SYNTH_DRIVING_CELL) {sky130_fd_sc_hd__inv_2}
set ::env(SYNTH_DRIVING_CELL_PIN) {Y}
set ::env(SYNTH_ELABORATE_ONLY) {0}
set ::env(SYNTH_EXTRA_MAPPING_FILE) {}
set ::env(SYNTH_FLAT_TOP) {0}
set ::env(SYNTH_LATCH_MAP) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.tech/openlane/sky130_fd_sc_hd/latch_map.v}
set ::env(SYNTH_MAX_FANOUT) {30}
set ::env(SYNTH_MIN_BUF_PORT) {sky130_fd_sc_hd__buf_2 A X}
set ::env(SYNTH_MUX4_MAP) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.tech/openlane/sky130_fd_sc_hd/mux4_map.v}
set ::env(SYNTH_MUX_MAP) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.tech/openlane/sky130_fd_sc_hd/mux2_map.v}
set ::env(SYNTH_NO_FLAT) {1}
set ::env(SYNTH_READ_BLACKBOX_LIB) {0}
set ::env(SYNTH_SCRIPT) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/openlane/scripts/yosys/synth.tcl}
set ::env(SYNTH_SHARE_RESOURCES) {1}
set ::env(SYNTH_SIZING) {0}
set ::env(SYNTH_STRATEGY) {AREA 3}
set ::env(SYNTH_TIEHI_PORT) {sky130_fd_sc_hd__conb_1 HI}
set ::env(SYNTH_TIELO_PORT) {sky130_fd_sc_hd__conb_1 LO}
set ::env(SYNTH_TIMING_DERATE) {0.05}
set ::env(TAKE_LAYOUT_SCROT) {0}
set ::env(TECH_LEF) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/techlef/sky130_fd_sc_hd__nom.tlef}
set ::env(TECH_LEF_MAX) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/techlef/sky130_fd_sc_hd__max.tlef}
set ::env(TECH_LEF_MIN) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/techlef/sky130_fd_sc_hd__min.tlef}
set ::env(TECH_LEF_OPT) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/techlef/sky130_fd_sc_hd__nom.tlef}
set ::env(TERMINAL_OUTPUT) {/dev/null}
set ::env(TMP_DIR) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/tmp}
set ::env(TOP_MARGIN_MULT) {4}
set ::env(TRACKS_INFO_FILE) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.tech/openlane/sky130_fd_sc_hd/tracks.info}
set ::env(TRISTATE_BUFFER_MAP) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.tech/openlane/sky130_fd_sc_hd/tribuff_map.v}
set ::env(USE_ARC_ANTENNA_CHECK) {1}
set ::env(USE_GPIO_PADS) {0}
set ::env(VDD_NETS) {vccd1}
set ::env(VDD_PIN) {VPWR}
set ::env(VDD_PIN_VOLTAGE) {1.80}
set ::env(VERILOG_FILES) {../Verilog/RTL_accelerator_without_compression/*.v}
set ::env(WIRE_RC_LAYER) {met1}
set ::env(YOSYS_REWRITE_VERILOG) {0}
set ::env(cts_logs) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/logs/cts}
set ::env(cts_reports) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/reports/cts}
set ::env(cts_results) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/results/cts}
set ::env(cts_tmpfiles) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/tmp/cts}
set ::env(eco_logs) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/logs/eco}
set ::env(eco_reports) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/reports/eco}
set ::env(eco_results) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/results/eco}
set ::env(eco_tmpfiles) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/tmp/eco}
set ::env(floorplan_logs) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/logs/floorplan}
set ::env(floorplan_reports) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/reports/floorplan}
set ::env(floorplan_results) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/results/floorplan}
set ::env(floorplan_tmpfiles) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/tmp/floorplan}
set ::env(placement_logs) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/logs/placement}
set ::env(placement_reports) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/reports/placement}
set ::env(placement_results) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/results/placement}
set ::env(placement_tmpfiles) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/tmp/placement}
set ::env(routing_logs) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/logs/routing}
set ::env(routing_reports) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/reports/routing}
set ::env(routing_results) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/results/routing}
set ::env(routing_tmpfiles) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/tmp/routing}
set ::env(signoff_logs) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/logs/signoff}
set ::env(signoff_reports) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/reports/signoff}
set ::env(signoff_results) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/results/signoff}
set ::env(signoff_tmpfiles) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/tmp/signoff}
set ::env(synthesis_logs) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/logs/synthesis}
set ::env(synthesis_reports) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/reports/synthesis}
set ::env(synthesis_results) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/results/synthesis}
set ::env(synthesis_tmpfiles) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/tmp/synthesis}
set ::env(SYNTH_MAX_TRAN) {0.75}
set ::env(CURRENT_INDEX) 13
set ::env(CURRENT_DEF) /esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/tmp/cts/12-top_chip.resized.def
set ::env(CURRENT_GUIDE) {0}
set ::env(CURRENT_NETLIST) /esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/tmp/cts/12-top_chip.resized.nl.v
set ::env(CURRENT_POWERED_NETLIST) {0}
set ::env(CURRENT_ODB) /esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/tmp/cts/12-top_chip.resized.odb
set ::env(PDK_ROOT) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk}
set ::env(BASE_SDC_FILE) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/openlane/scripts/base.sdc}
set ::env(BASH_FUNC__module_raw%%) {() {  unset _mlshdbg;
 if [ \"\${MODULES_SILENT_SHELL_DEBUG:-0}\" = '1' ]; then
 case \"\$-\" in 
 *v*x*)
 set +vx;
 _mlshdbg='vx'
 ;;
 *v*)
 set +v;
 _mlshdbg='v'
 ;;
 *x*)
 set +x;
 _mlshdbg='x'
 ;;
 *)
 _mlshdbg=''
 ;;
 esac;
 fi;
 unset _mlre _mlIFS;
 if [ -n \"\${IFS+x}\" ]; then
 _mlIFS=\$IFS;
 fi;
 IFS=' ';
 for _mlv in \${MODULES_RUN_QUARANTINE:-};
 do
 if [ \"\${_mlv}\" = \"\${_mlv##*[!A-Za-z0-9_]}\" -a \"\${_mlv}\" = \"\${_mlv#[0-9]}\" ]; then
 if [ -n \"`eval 'echo \${'\$_mlv'+x}'`\" ]; then
 _mlre=\"\${_mlre:-}\${_mlv}_modquar='`eval 'echo \${'\$_mlv'}'`' \";
 fi;
 _mlrv=\"MODULES_RUNENV_\${_mlv}\";
 _mlre=\"\${_mlre:-}\${_mlv}='`eval 'echo \${'\$_mlrv':-}'`' \";
 fi;
 done;
 if [ -n \"\${_mlre:-}\" ]; then
 eval `eval \${_mlre} /usr/bin/tclsh /usr/share/Modules/libexec/modulecmd.tcl bash '\"\$@\"'`;
 else
 eval `/usr/bin/tclsh /usr/share/Modules/libexec/modulecmd.tcl bash \"\$@\"`;
 fi;
 _mlstatus=\$?;
 if [ -n \"\${_mlIFS+x}\" ]; then
 IFS=\$_mlIFS;
 else
 unset IFS;
 fi;
 unset _mlre _mlv _mlrv _mlIFS;
 if [ -n \"\${_mlshdbg:-}\" ]; then
 set -\$_mlshdbg;
 fi;
 unset _mlshdbg;
 return \$_mlstatus
}}
set ::env(BASH_FUNC_ml%%) {() {  module ml \"\$@\"
}}
set ::env(BASH_FUNC_module%%) {() {  _module_raw \"\$@\" 2>&1
}}
set ::env(BASH_FUNC_scl%%) {() {  if [ \"\$1\" = \"load\" -o \"\$1\" = \"unload\" ]; then
 eval \"module \$@\";
 else
 /usr/bin/scl \"\$@\";
 fi
}}
set ::env(BASH_FUNC_switchml%%) {() {  typeset swfound=1;
 if [ \"\${MODULES_USE_COMPAT_VERSION:-0}\" = '1' ]; then
 typeset swname='main';
 if [ -e /usr/share/Modules/libexec/modulecmd.tcl ]; then
 typeset swfound=0;
 unset MODULES_USE_COMPAT_VERSION;
 fi;
 else
 typeset swname='compatibility';
 if [ -e /usr/share/Modules/libexec/modulecmd-compat ]; then
 typeset swfound=0;
 MODULES_USE_COMPAT_VERSION=1;
 export MODULES_USE_COMPAT_VERSION;
 fi;
 fi;
 if [ \$swfound -eq 0 ]; then
 echo \"Switching to Modules \$swname version\";
 source /usr/share/Modules/init/bash;
 else
 echo \"Cannot switch to Modules \$swname version, command not found\";
 return 1;
 fi
}}
set ::env(BASH_FUNC_which%%) {() {  ( alias;
 eval \${which_declare} ) | /usr/bin/which --tty-only --read-alias --read-functions --show-tilde --show-dot \$@
}}
set ::env(BASIC_PREP_COMPLETE) {1}
set ::env(BOTTOM_MARGIN_MULT) {4}
set ::env(CARRY_SELECT_ADDER_MAP) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.tech/openlane/sky130_fd_sc_hd/csa_map.v}
set ::env(CELLS_LEF) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/lef/sky130_fd_sc_hd.lef /users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/lef/sky130_ef_sc_hd.lef}
set ::env(CELLS_LEF_OPT) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/lef/sky130_fd_sc_hd.lef /users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/lef/sky130_ef_sc_hd.lef}
set ::env(CELL_CLK_PORT) {CLK}
set ::env(CELL_PAD_EXCLUDE) {sky130_fd_sc_hd__tap* sky130_fd_sc_hd__decap* sky130_ef_sc_hd__decap* sky130_fd_sc_hd__fill*}
set ::env(CLICOLOR) {1}
set ::env(CLK_BUFFER) {sky130_fd_sc_hd__clkbuf_4}
set ::env(CLK_BUFFER_INPUT) {A}
set ::env(CLK_BUFFER_OUTPUT) {X}
set ::env(CLOCK_BUFFER_FANOUT) {16}
set ::env(CLOCK_NET) {clk}
set ::env(CLOCK_PERIOD) {100}
set ::env(CLOCK_PORT) {clk}
set ::env(CLOCK_TREE_SYNTH) {1}
set ::env(CLOCK_WIRE_RC_LAYER) {met5}
set ::env(COLORTERM) {truecolor}
set ::env(CONDA_PREFIX) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env}
set ::env(CONFIGS) {general.tcl checkers.tcl synthesis.tcl floorplan.tcl cts.tcl placement.tcl routing.tcl extraction.tcl disable-missing-tools.tcl}
set ::env(CORE_AREA) {5.52 10.88 11294.38 11288.0}
set ::env(CORE_HEIGHT) {11277.12}
set ::env(CORE_NUM) {48}
set ::env(CORE_WIDTH) {11288.86}
set ::env(CTS_CLK_BUFFER_LIST) {sky130_fd_sc_hd__clkbuf_8 sky130_fd_sc_hd__clkbuf_4 sky130_fd_sc_hd__clkbuf_2}
set ::env(CTS_CLK_MAX_WIRE_LENGTH) {0}
set ::env(CTS_CURRENT_DEF) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/results/placement/top_chip.def}
set ::env(CTS_DISABLE_POST_PROCESSING) {0}
set ::env(CTS_DISTANCE_BETWEEN_BUFFERS) {0}
set ::env(CTS_MAX_CAP) {1.53169}
set ::env(CTS_REPORT_TIMING) {1}
set ::env(CTS_ROOT_BUFFER) {sky130_fd_sc_hd__clkbuf_16}
set ::env(CTS_SINK_CLUSTERING_MAX_DIAMETER) {50}
set ::env(CTS_SINK_CLUSTERING_SIZE) {25}
set ::env(CTS_SQR_CAP) {0.258e-3}
set ::env(CTS_SQR_RES) {0.125}
set ::env(CTS_TARGET_SKEW) {200}
set ::env(CTS_TECH_DIR) {N/A}
set ::env(CTS_TOLERANCE) {100}
set ::env(CURRENT_DEF) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/tmp/cts/12-top_chip.resized.def}
set ::env(CURRENT_GUIDE) {0}
set ::env(CURRENT_INDEX) {13}
set ::env(CURRENT_LIB) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/results/synthesis/top_chip.lib}
set ::env(CURRENT_NETLIST) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/tmp/cts/12-top_chip.resized.nl.v}
set ::env(CURRENT_ODB) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/tmp/cts/12-top_chip.resized.odb}
set ::env(CURRENT_POWERED_NETLIST) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/tmp/cts/12-top_chip.resized.pnl.v}
set ::env(CURRENT_SDC) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/tmp/cts/12-top_chip.resized.sdc}
set ::env(CURRENT_SDF) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/results/synthesis/top_chip.sdf}
set ::env(CURRENT_STEP) {routing}
set ::env(CVC_SCRIPTS_DIR) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.tech/openlane/cvc}
set ::env(DATA_WIRE_RC_LAYER) {met2}
set ::env(DBUS_SESSION_BUS_ADDRESS) {unix:abstract=/tmp/dbus-uuS73zyVxJ,guid=34fe75f003ac08e27f0a6ca06467a6fc}
set ::env(DEBUGINFOD_URLS) {https://debuginfod.centos.org/ }
set ::env(DECAP_CELL) {sky130_ef_sc_hd__decap_12 sky130_fd_sc_hd__decap_8 sky130_fd_sc_hd__decap_6 sky130_fd_sc_hd__decap_4 sky130_fd_sc_hd__decap_3}
set ::env(DEFAULT_MAX_TRAN) {0.75}
set ::env(DEF_UNITS_PER_MICRON) {1000}
set ::env(DESIGN_CONFIG) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/config.tcl}
set ::env(DESIGN_DIR) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend}
set ::env(DESIGN_IS_CORE) {1}
set ::env(DESIGN_NAME) {top_chip}
set ::env(DETAILED_ROUTER) {tritonroute}
set ::env(DIE_AREA) {0.0 0.0 11300.0 11300.0}
set ::env(DIODE_CELL) {sky130_fd_sc_hd__diode_2}
set ::env(DIODE_CELL_PIN) {DIODE}
set ::env(DIODE_INSERTION_STRATEGY) {3}
set ::env(DIODE_PADDING) {2}
set ::env(DISPLAY) {:5}
set ::env(DONT_USE_CELLS) {sky130_fd_sc_hd__a2111oi_0 sky130_fd_sc_hd__a21boi_0 sky130_fd_sc_hd__and2_0 sky130_fd_sc_hd__buf_16 sky130_fd_sc_hd__clkdlybuf4s15_1 sky130_fd_sc_hd__clkdlybuf4s18_1 sky130_fd_sc_hd__fa_4 sky130_fd_sc_hd__lpflow_bleeder_1 sky130_fd_sc_hd__lpflow_clkbufkapwr_1 sky130_fd_sc_hd__lpflow_clkbufkapwr_16 sky130_fd_sc_hd__lpflow_clkbufkapwr_2 sky130_fd_sc_hd__lpflow_clkbufkapwr_4 sky130_fd_sc_hd__lpflow_clkbufkapwr_8 sky130_fd_sc_hd__lpflow_clkinvkapwr_1 sky130_fd_sc_hd__lpflow_clkinvkapwr_16 sky130_fd_sc_hd__lpflow_clkinvkapwr_2 sky130_fd_sc_hd__lpflow_clkinvkapwr_4 sky130_fd_sc_hd__lpflow_clkinvkapwr_8 sky130_fd_sc_hd__lpflow_decapkapwr_12 sky130_fd_sc_hd__lpflow_decapkapwr_3 sky130_fd_sc_hd__lpflow_decapkapwr_4 sky130_fd_sc_hd__lpflow_decapkapwr_6 sky130_fd_sc_hd__lpflow_decapkapwr_8 sky130_fd_sc_hd__lpflow_inputiso0n_1 sky130_fd_sc_hd__lpflow_inputiso0p_1 sky130_fd_sc_hd__lpflow_inputiso1n_1 sky130_fd_sc_hd__lpflow_inputiso1p_1 sky130_fd_sc_hd__lpflow_inputisolatch_1 sky130_fd_sc_hd__lpflow_isobufsrc_1 sky130_fd_sc_hd__lpflow_isobufsrc_16 sky130_fd_sc_hd__lpflow_isobufsrc_2 sky130_fd_sc_hd__lpflow_isobufsrc_4 sky130_fd_sc_hd__lpflow_isobufsrc_8 sky130_fd_sc_hd__lpflow_isobufsrckapwr_16 sky130_fd_sc_hd__lpflow_lsbuf_lh_hl_isowell_tap_1 sky130_fd_sc_hd__lpflow_lsbuf_lh_hl_isowell_tap_2 sky130_fd_sc_hd__lpflow_lsbuf_lh_hl_isowell_tap_4 sky130_fd_sc_hd__lpflow_lsbuf_lh_isowell_4 sky130_fd_sc_hd__lpflow_lsbuf_lh_isowell_tap_1 sky130_fd_sc_hd__lpflow_lsbuf_lh_isowell_tap_2 sky130_fd_sc_hd__lpflow_lsbuf_lh_isowell_tap_4 sky130_fd_sc_hd__mux4_4 sky130_fd_sc_hd__o21ai_0 sky130_fd_sc_hd__o311ai_0 sky130_fd_sc_hd__or2_0 sky130_fd_sc_hd__probe_p_8 sky130_fd_sc_hd__probec_p_8 sky130_fd_sc_hd__xor3_1 sky130_fd_sc_hd__xor3_2 sky130_fd_sc_hd__xor3_4 sky130_fd_sc_hd__xnor3_1 sky130_fd_sc_hd__xnor3_2 sky130_fd_sc_hd__xnor3_4  }
set ::env(DPL_CELL_PADDING) {0}
set ::env(DRC_EXCLUDE_CELL_LIST) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.tech/openlane/sky130_fd_sc_hd/drc_exclude.cells}
set ::env(DRC_EXCLUDE_CELL_LIST_OPT) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.tech/openlane/sky130_fd_sc_hd/drc_exclude.cells}
set ::env(DRT_OPT_ITERS) {64}
set ::env(ECO_ENABLE) {0}
set ::env(ECO_FINISH) {0}
set ::env(ECO_ITER) {0}
set ::env(ECO_SKIP_PIN) {1}
set ::env(EDITOR) {vi}
set ::env(ESAT_ARCH) {linux-x86_64}
set ::env(EXTRA_GDS_FILES) {OpenRAM_output/sky130_sram_1r1w_128x512_128.gds OpenRAM_output/sky130_sram_fifo_1r1w_8x1024_8.gds}
set ::env(EXTRA_LEFS) {OpenRAM_output/sky130_sram_1r1w_128x512_128.lef OpenRAM_output/sky130_sram_fifo_1r1w_8x1024_8.lef}
set ::env(EXTRA_LIBS) {OpenRAM_output/sky130_sram_1r1w_128x512_128_TT_1p8V_25C.lib OpenRAM_output/sky130_sram_fifo_1r1w_8x1024_8_TT_1p8V_25C.lib}
set ::env(FAKEDIODE_CELL) {sky130_ef_sc_hd__fakediode_2}
set ::env(FILL_CELL) {sky130_fd_sc_hd__fill*}
set ::env(FP_ASPECT_RATIO) {1}
set ::env(FP_CORE_UTIL) {30}
set ::env(FP_ENDCAP_CELL) {sky130_fd_sc_hd__decap_3}
set ::env(FP_IO_HEXTEND) {0}
set ::env(FP_IO_HLAYER) {met3}
set ::env(FP_IO_HLENGTH) {4}
set ::env(FP_IO_HTHICKNESS_MULT) {2}
set ::env(FP_IO_MIN_DISTANCE) {3}
set ::env(FP_IO_MODE) {1}
set ::env(FP_IO_UNMATCHED_ERROR) {1}
set ::env(FP_IO_VEXTEND) {0}
set ::env(FP_IO_VLAYER) {met2}
set ::env(FP_IO_VLENGTH) {4}
set ::env(FP_IO_VTHICKNESS_MULT) {2}
set ::env(FP_PDN_AUTO_ADJUST) {1}
set ::env(FP_PDN_CHECK_NODES) {1}
set ::env(FP_PDN_CORE_RING) {0}
set ::env(FP_PDN_CORE_RING_HOFFSET) {6}
set ::env(FP_PDN_CORE_RING_HSPACING) {1.7}
set ::env(FP_PDN_CORE_RING_HWIDTH) {1.6}
set ::env(FP_PDN_CORE_RING_VOFFSET) {6}
set ::env(FP_PDN_CORE_RING_VSPACING) {1.7}
set ::env(FP_PDN_CORE_RING_VWIDTH) {1.6}
set ::env(FP_PDN_ENABLE_GLOBAL_CONNECTIONS) {1}
set ::env(FP_PDN_ENABLE_MACROS_GRID) {1}
set ::env(FP_PDN_ENABLE_RAILS) {1}
set ::env(FP_PDN_HOFFSET) {16.65}
set ::env(FP_PDN_HORIZONTAL_HALO) {10}
set ::env(FP_PDN_HPITCH) {153.18}
set ::env(FP_PDN_HSPACING) {1.7}
set ::env(FP_PDN_HWIDTH) {1.6}
set ::env(FP_PDN_IRDROP) {1}
set ::env(FP_PDN_LOWER_LAYER) {met4}
set ::env(FP_PDN_MACRO_HOOKS) { genblk1[0].sram_weights_banks      vccd1 vssd1 vccd1 vssd1, 
genblk1[1].sram_weights_banks      vccd1 vssd1 vccd1 vssd1, genblk1[2].sram_weights_banks      vccd1 vssd1 vccd1 vssd1, genblk1[3].sram_weights_banks      vccd1 vssd1 vccd1 vssd1, genblk1[4].sram_weights_banks      vccd1 vssd1 vccd1 vssd1, genblk1[5].sram_weights_banks      vccd1 vssd1 vccd1 vssd1, genblk1[6].sram_weights_banks      vccd1 vssd1 vccd1 vssd1, genblk1[7].sram_weights_banks      vccd1 vssd1 vccd1 vssd1, genblk2[0].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[1].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[2].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[3].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[4].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[5].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[6].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[7].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[8].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[9].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[10].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[11].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[12].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[13].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[14].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[15].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[16].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[17].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[18].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[19].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[20].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[21].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[22].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[23].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[24].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[25].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[26].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[27].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[28].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[29].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[30].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[31].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, fifo_0.fifo_mem_0      vccd1 vssd1 vccd1 vssd1}
set ::env(FP_PDN_RAILS_LAYER) {met1}
set ::env(FP_PDN_RAIL_OFFSET) {0}
set ::env(FP_PDN_RAIL_WIDTH) {0.48}
set ::env(FP_PDN_SKIPTRIM) {0}
set ::env(FP_PDN_UPPER_LAYER) {met5}
set ::env(FP_PDN_VERTICAL_HALO) {10}
set ::env(FP_PDN_VOFFSET) {16.32}
set ::env(FP_PDN_VPITCH) {153.6}
set ::env(FP_PDN_VSPACING) {1.7}
set ::env(FP_PDN_VWIDTH) {1.6}
set ::env(FP_SIZING) {absolute}
set ::env(FP_TAPCELL_DIST) {13}
set ::env(FP_TAP_HORIZONTAL_HALO) {10}
set ::env(FP_TAP_VERTICAL_HALO) {10}
set ::env(FP_WELLTAP_CELL) {sky130_fd_sc_hd__tapvpwrvgnd_1}
set ::env(FULL_ADDER_MAP) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.tech/openlane/sky130_fd_sc_hd/fa_map.v}
set ::env(GDS_FILES) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/gds/sky130_fd_sc_hd.gds}
set ::env(GDS_FILES_OPT) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/gds/sky130_fd_sc_hd.gds}
set ::env(GENERATE_FINAL_SUMMARY_REPORT) {1}
set ::env(GIT_PAGER) {cat}
set ::env(GJS_DEBUG_OUTPUT) {stderr}
set ::env(GJS_DEBUG_TOPICS) {JS ERROR;JS LOG}
set ::env(GLB_CFG_FILE) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/config.tcl}
set ::env(GLB_OPTIMIZE_MIRRORING) {1}
set ::env(GLB_RESIZER_ALLOW_SETUP_VIOS) {0}
set ::env(GLB_RESIZER_HOLD_MAX_BUFFER_PERCENT) {50}
set ::env(GLB_RESIZER_HOLD_SLACK_MARGIN) {0.05}
set ::env(GLB_RESIZER_MAX_CAP_MARGIN) {10}
set ::env(GLB_RESIZER_MAX_SLEW_MARGIN) {10}
set ::env(GLB_RESIZER_MAX_WIRE_LENGTH) {0}
set ::env(GLB_RESIZER_SETUP_MAX_BUFFER_PERCENT) {50}
set ::env(GLB_RESIZER_SETUP_SLACK_MARGIN) {0.025}
set ::env(GLB_RESIZER_TIMING_OPTIMIZATIONS) {1}
set ::env(GLOBAL_ROUTER) {fastroute}
set ::env(GND_NET) {vssd1}
set ::env(GND_NETS) {vssd1}
set ::env(GND_PIN) {vssd1}
set ::env(GND_PIN_VOLTAGE) {0.00}
set ::env(GNOME_DESKTOP_SESSION_ID) {this-is-deprecated}
set ::env(GNOME_TERMINAL_SCREEN) {/org/gnome/Terminal/screen/2fd7925c_9cd1_4e14_93a0_4a8623c89e25}
set ::env(GNOME_TERMINAL_SERVICE) {:1.75}
set ::env(GPIO_PADS_LEF) { /users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.ref/sky130_fd_io/lef/sky130_fd_io.lef /users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.ref/sky130_fd_io/lef/sky130_ef_io.lef }
set ::env(GPIO_PADS_LEF_CORE_SIDE) { /users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.tech/openlane/custom_cells/lef/sky130_fd_io_core.lef /users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.tech/openlane/custom_cells/lef/sky130_ef_io_core.lef }
set ::env(GPIO_PADS_PREFIX) {sky130_fd_io sky130_ef_io}
set ::env(GPIO_PADS_VERILOG) { /users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.ref/sky130_fd_io/verilog/sky130_ef_io.v
}
set ::env(GPL_CELL_PADDING) {0}
set ::env(GRT_ADJUSTMENT) {0.3}
set ::env(GRT_ALLOW_CONGESTION) {0}
set ::env(GRT_ANT_ITERS) {3}
set ::env(GRT_ESTIMATE_PARASITICS) {1}
set ::env(GRT_LAYER_ADJUSTMENTS) {0.99,0,0,0,0,0}
set ::env(GRT_MACRO_EXTENSION) {0}
set ::env(GRT_MAX_DIODE_INS_ITERS) {1}
set ::env(GRT_OVERFLOW_ITERS) {50}
set ::env(GS_OPTIONS) {-sPAPERSIZE=a4}
set ::env(HISTCONTROL) {ignoredups}
set ::env(HISTSIZE) {1000}
set ::env(HOME) {/users/students/r0755727}
set ::env(HOSTNAME) {amazone.esat.kuleuven.be}
set ::env(IO_PCT) {0.2}
set ::env(JPY_PARENT_PID) {248653}
set ::env(JPY_SESSION_NAME) {48722245-ddf0-4b5c-b49e-51fd404c5959}
set ::env(KDEDIRS) {/usr}
set ::env(KLAYOUT_DEF_LAYER_MAP) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.tech/klayout/tech/sky130A.map}
set ::env(KLAYOUT_DRC_KLAYOUT_GDS) {0}
set ::env(KLAYOUT_DRC_TECH_SCRIPT) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.tech/klayout/drc/sky130A_mr.drc}
set ::env(KLAYOUT_PROPERTIES) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.tech/klayout/tech/sky130A.lyp}
set ::env(KLAYOUT_TECH) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.tech/klayout/tech/sky130A.lyt}
set ::env(KLAYOUT_XOR_GDS) {1}
set ::env(KLAYOUT_XOR_IGNORE_LAYERS) {81/14}
set ::env(KLAYOUT_XOR_THREADS) {1}
set ::env(KLAYOUT_XOR_XML) {1}
set ::env(LANG) {en_US.UTF-8}
set ::env(LAST_TIMING_REPORT_TAG) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/reports/synthesis/2-syn_sta}
set ::env(LD_LIBRARY_PATH) {:/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/lib}
set ::env(LEC_ENABLE) {0}
set ::env(LEFT_MARGIN_MULT) {12}
set ::env(LESSOPEN) {||/usr/bin/lesspipe.sh %s}
set ::env(LIB_CTS) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/tmp/cts/cts.lib}
set ::env(LIB_FASTEST) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__ff_n40C_1v95.lib}
set ::env(LIB_SLOWEST) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__ss_100C_1v60.lib}
set ::env(LIB_SLOWEST_OPT) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__ss_100C_1v60.lib}
set ::env(LIB_SYNTH) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/tmp/synthesis/trimmed.lib}
set ::env(LIB_SYNTH_COMPLETE) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib}
set ::env(LIB_SYNTH_COMPLETE_NO_PG) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/tmp/synthesis/1-sky130_fd_sc_hd__tt_025C_1v80.no_pg.lib}
set ::env(LIB_SYNTH_MERGED) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/tmp/synthesis/merged.lib}
set ::env(LIB_SYNTH_NO_PG) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/tmp/synthesis/1-trimmed.no_pg.lib}
set ::env(LIB_TYPICAL) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib}
set ::env(LOADEDMODULES) {}
set ::env(LOGNAME) {r0755727}
set ::env(LOGS_DIR) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/logs}
set ::env(LPDEST) {ulstudent}
set ::env(LS_COLORS) {rs=0:di=38;5;33:ln=38;5;51:mh=00:pi=40;38;5;11:so=38;5;13:do=38;5;5:bd=48;5;232;38;5;11:cd=48;5;232;38;5;3:or=48;5;232;38;5;9:mi=01;05;37;41:su=48;5;196;38;5;15:sg=48;5;11;38;5;16:ca=48;5;196;38;5;226:tw=48;5;10;38;5;16:ow=48;5;10;38;5;21:st=48;5;21;38;5;15:ex=38;5;40:*.tar=38;5;9:*.tgz=38;5;9:*.arc=38;5;9:*.arj=38;5;9:*.taz=38;5;9:*.lha=38;5;9:*.lz4=38;5;9:*.lzh=38;5;9:*.lzma=38;5;9:*.tlz=38;5;9:*.txz=38;5;9:*.tzo=38;5;9:*.t7z=38;5;9:*.zip=38;5;9:*.z=38;5;9:*.dz=38;5;9:*.gz=38;5;9:*.lrz=38;5;9:*.lz=38;5;9:*.lzo=38;5;9:*.xz=38;5;9:*.zst=38;5;9:*.tzst=38;5;9:*.bz2=38;5;9:*.bz=38;5;9:*.tbz=38;5;9:*.tbz2=38;5;9:*.tz=38;5;9:*.deb=38;5;9:*.rpm=38;5;9:*.jar=38;5;9:*.war=38;5;9:*.ear=38;5;9:*.sar=38;5;9:*.rar=38;5;9:*.alz=38;5;9:*.ace=38;5;9:*.zoo=38;5;9:*.cpio=38;5;9:*.7z=38;5;9:*.rz=38;5;9:*.cab=38;5;9:*.wim=38;5;9:*.swm=38;5;9:*.dwm=38;5;9:*.esd=38;5;9:*.jpg=38;5;13:*.jpeg=38;5;13:*.mjpg=38;5;13:*.mjpeg=38;5;13:*.gif=38;5;13:*.bmp=38;5;13:*.pbm=38;5;13:*.pgm=38;5;13:*.ppm=38;5;13:*.tga=38;5;13:*.xbm=38;5;13:*.xpm=38;5;13:*.tif=38;5;13:*.tiff=38;5;13:*.png=38;5;13:*.svg=38;5;13:*.svgz=38;5;13:*.mng=38;5;13:*.pcx=38;5;13:*.mov=38;5;13:*.mpg=38;5;13:*.mpeg=38;5;13:*.m2v=38;5;13:*.mkv=38;5;13:*.webm=38;5;13:*.ogm=38;5;13:*.mp4=38;5;13:*.m4v=38;5;13:*.mp4v=38;5;13:*.vob=38;5;13:*.qt=38;5;13:*.nuv=38;5;13:*.wmv=38;5;13:*.asf=38;5;13:*.rm=38;5;13:*.rmvb=38;5;13:*.flc=38;5;13:*.avi=38;5;13:*.fli=38;5;13:*.flv=38;5;13:*.gl=38;5;13:*.dl=38;5;13:*.xcf=38;5;13:*.xwd=38;5;13:*.yuv=38;5;13:*.cgm=38;5;13:*.emf=38;5;13:*.ogv=38;5;13:*.ogx=38;5;13:*.aac=38;5;45:*.au=38;5;45:*.flac=38;5;45:*.m4a=38;5;45:*.mid=38;5;45:*.midi=38;5;45:*.mka=38;5;45:*.mp3=38;5;45:*.mpc=38;5;45:*.ogg=38;5;45:*.ra=38;5;45:*.wav=38;5;45:*.oga=38;5;45:*.opus=38;5;45:*.spx=38;5;45:*.xspf=38;5;45:}
set ::env(LVS_CONNECT_BY_LABEL) {0}
set ::env(LVS_INSERT_POWER_PINS) {1}
set ::env(MACRO_BLOCKAGES_LAYER) {li1 met1 met2 met3 met4}
set ::env(MACRO_PLACEMENT_CFG) {macro_placement.cfg}
set ::env(MAGIC_CONVERT_DRC_TO_RDB) {1}
set ::env(MAGIC_DEF_LABELS) {1}
set ::env(MAGIC_DEF_NO_BLOCKAGES) {1}
set ::env(MAGIC_DISABLE_HIER_GDS) {1}
set ::env(MAGIC_DRC_USE_GDS) {0}
set ::env(MAGIC_EXT_USE_GDS) {0}
set ::env(MAGIC_GDS_ALLOW_ABSTRACT) {0}
set ::env(MAGIC_GDS_POLYGON_SUBCELLS) {0}
set ::env(MAGIC_GENERATE_GDS) {1}
set ::env(MAGIC_GENERATE_LEF) {1}
set ::env(MAGIC_GENERATE_MAGLEF) {1}
set ::env(MAGIC_INCLUDE_GDS_POINTERS) {0}
set ::env(MAGIC_MAGICRC) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.tech/magic/sky130A.magicrc}
set ::env(MAGIC_PAD) {0}
set ::env(MAGIC_TECH_FILE) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.tech/magic/sky130A.tech}
set ::env(MAGIC_WRITE_FULL_LEF) {0}
set ::env(MAGIC_ZEROIZE_ORIGIN) {0}
set ::env(MAIL) {/var/spool/mail/r0755727}
set ::env(MAILCHECK) {0}
set ::env(MANPATH) {::/opt/puppetlabs/puppet/share/man:/freeware/man:/software/man}
set ::env(MAX_METAL_LAYER) {6}
set ::env(MERGED_LEF) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/tmp/merged.nom.lef}
set ::env(MERGED_LEF_MAX) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/tmp/merged.max.lef}
set ::env(MERGED_LEF_MIN) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/tmp/merged.min.lef}
set ::env(MICAS_LICENSE_FILE) {/users/micas/micas/license/license.dat}
set ::env(MODULEPATH) {/etc/scl/modulefiles:/usr/share/Modules/modulefiles:/etc/modulefiles:/usr/share/modulefiles}
set ::env(MODULEPATH_modshare) {/usr/share/Modules/modulefiles:2:/etc/modulefiles:2:/usr/share/modulefiles:2}
set ::env(MODULESHOME) {/usr/share/Modules}
set ::env(MODULES_CMD) {/usr/share/Modules/libexec/modulecmd.tcl}
set ::env(MODULES_RUN_QUARANTINE) {LD_LIBRARY_PATH LD_PRELOAD}
set ::env(MPLBACKEND) {module://matplotlib_inline.backend_inline}
set ::env(NETGEN_SETUP_FILE) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.tech/netgen/sky130A_setup.tcl}
set ::env(NO_SYNTH_CELL_LIST) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.tech/openlane/sky130_fd_sc_hd/no_synth.cells}
set ::env(OLDPWD) {/users/students/r0755727}
set ::env(OL_INSTALL_DIR) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/openlane/install}
set ::env(OPENLANE_LOCAL_INSTALL) {1}
set ::env(OPENLANE_ROOT) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/openlane}
set ::env(OPENLANE_VERBOSE) {0}
set ::env(OPENLANE_VERSION) {2023.03.01_0_ge10820ec-conda}
set ::env(OPENROAD_BIN) {openroad}
set ::env(PAGER) {cat}
set ::env(PATH) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/bin:/usr/share/Modules/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/opt/puppetlabs/bin:/freeware/bin/gnu-tools:/freeware/bin:/software/bin:/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/openlane:/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/openlane/scripts}
set ::env(PDK) {sky130A}
set ::env(PDKPATH) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A}
set ::env(PDK_ROOT) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk}
set ::env(PDN_CFG) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/openlane/scripts/openroad/common/pdn_cfg.tcl}
set ::env(PLACEMENT_CURRENT_DEF) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/tmp/floorplan/7-pdn.def}
set ::env(PLACE_SITE) {unithd}
set ::env(PLACE_SITE_HEIGHT) {2.720}
set ::env(PLACE_SITE_WIDTH) {0.460}
set ::env(PL_BASIC_PLACEMENT) {0}
set ::env(PL_ESTIMATE_PARASITICS) {1}
set ::env(PL_INIT_COEFF) {0.00002}
set ::env(PL_IO_ITER) {5}
set ::env(PL_LIB) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib}
set ::env(PL_MACRO_CHANNEL) {0 0}
set ::env(PL_MACRO_HALO) {90 90}
set ::env(PL_MAX_DISPLACEMENT_X) {500}
set ::env(PL_MAX_DISPLACEMENT_Y) {100}
set ::env(PL_OPTIMIZE_MIRRORING) {1}
set ::env(PL_RANDOM_GLB_PLACEMENT) {0}
set ::env(PL_RANDOM_INITIAL_PLACEMENT) {0}
set ::env(PL_RESIZER_ALLOW_SETUP_VIOS) {0}
set ::env(PL_RESIZER_BUFFER_INPUT_PORTS) {1}
set ::env(PL_RESIZER_BUFFER_OUTPUT_PORTS) {1}
set ::env(PL_RESIZER_DESIGN_OPTIMIZATIONS) {1}
set ::env(PL_RESIZER_HOLD_MAX_BUFFER_PERCENT) {50}
set ::env(PL_RESIZER_HOLD_SLACK_MARGIN) {0.1}
set ::env(PL_RESIZER_MAX_CAP_MARGIN) {20}
set ::env(PL_RESIZER_MAX_SLEW_MARGIN) {20}
set ::env(PL_RESIZER_MAX_WIRE_LENGTH) {0}
set ::env(PL_RESIZER_REPAIR_TIE_FANOUT) {1}
set ::env(PL_RESIZER_SETUP_MAX_BUFFER_PERCENT) {50}
set ::env(PL_RESIZER_SETUP_SLACK_MARGIN) {0.05}
set ::env(PL_RESIZER_TIE_SEPERATION) {0}
set ::env(PL_RESIZER_TIMING_OPTIMIZATIONS) {1}
set ::env(PL_ROUTABILITY_DRIVEN) {1}
set ::env(PL_SKIP_INITIAL_PLACEMENT) {0}
set ::env(PL_TARGET_DENSITY) {0.05}
set ::env(PL_TIME_DRIVEN) {1}
set ::env(PL_WIRELENGTH_COEF) {0.25}
set ::env(PRIMARY_SIGNOFF_TOOL) {magic}
set ::env(PRINTER) {ulstudent}
set ::env(PROCESS) {130}
set ::env(PROJECT_HOME) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend}
set ::env(PWD) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend}
set ::env(PYDEVD_USE_FRAME_EVAL) {NO}
set ::env(QT_IM_MODULE) {ibus}
set ::env(QUIT_ON_ASSIGN_STATEMENTS) {0}
set ::env(QUIT_ON_HOLD_VIOLATIONS) {1}
set ::env(QUIT_ON_ILLEGAL_OVERLAPS) {1}
set ::env(QUIT_ON_LONG_WIRE) {0}
set ::env(QUIT_ON_LVS_ERROR) {1}
set ::env(QUIT_ON_MAGIC_DRC) {0}
set ::env(QUIT_ON_SETUP_VIOLATIONS) {1}
set ::env(QUIT_ON_SYNTH_CHECKS) {0}
set ::env(QUIT_ON_TIMING_VIOLATIONS) {1}
set ::env(QUIT_ON_TR_DRC) {1}
set ::env(QUIT_ON_UNMAPPED_CELLS) {1}
set ::env(QUIT_ON_XOR_ERROR) {1}
set ::env(RCX_CC_MODEL) {10}
set ::env(RCX_CONTEXT_DEPTH) {5}
set ::env(RCX_CORNER_COUNT) {1}
set ::env(RCX_COUPLING_THRESHOLD) {0.1}
set ::env(RCX_MAX_RESISTANCE) {50}
set ::env(RCX_MERGE_VIA_WIRE_RES) {1}
set ::env(RCX_RULES) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.tech/openlane/rules.openrcx.sky130A.nom.calibre}
set ::env(RCX_RULES_MAX) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.tech/openlane/rules.openrcx.sky130A.max.calibre}
set ::env(RCX_RULES_MIN) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.tech/openlane/rules.openrcx.sky130A.min.calibre}
set ::env(REPORTS_DIR) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/reports}
set ::env(RESULTS_DIR) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/results}
set ::env(RE_BUFFER_CELL) {sky130_fd_sc_hd__buf_4}
set ::env(RIGHT_MARGIN_MULT) {12}
set ::env(RIPPLE_CARRY_ADDER_MAP) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.tech/openlane/sky130_fd_sc_hd/rca_map.v}
set ::env(ROOT_CLK_BUFFER) {sky130_fd_sc_hd__clkbuf_16}
set ::env(ROUTING_CORES) {48}
set ::env(ROUTING_CURRENT_DEF) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/tmp/cts/12-top_chip.resized.def}
set ::env(RSZ_DONT_TOUCH_RX) {\$^}
set ::env(RSZ_LIB) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/tmp/synthesis/resizer_sky130_fd_sc_hd__tt_025C_1v80.lib}
set ::env(RSZ_USE_OLD_REMOVER) {0}
set ::env(RT_MAX_LAYER) {met5}
set ::env(RT_MIN_LAYER) {met1}
set ::env(RUN_CVC) {0}
set ::env(RUN_DIR) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression}
set ::env(RUN_DRT) {1}
set ::env(RUN_FILL_INSERTION) {1}
set ::env(RUN_IRDROP_REPORT) {1}
set ::env(RUN_KLAYOUT) {0}
set ::env(RUN_KLAYOUT_DRC) {0}
set ::env(RUN_KLAYOUT_XOR) {0}
set ::env(RUN_LVS) {1}
set ::env(RUN_MAGIC) {1}
set ::env(RUN_MAGIC_DRC) {1}
set ::env(RUN_SPEF_EXTRACTION) {1}
set ::env(RUN_STANDALONE) {1}
set ::env(RUN_TAG) {230522-144242_accelerator_without_compression}
set ::env(RUN_TAP_DECAP_INSERTION) {1}
set ::env(SAVE_DEF) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/tmp/13-top_chip.def}
set ::env(SAVE_DIR) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/tmp/routing}
set ::env(SAVE_NETLIST) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/tmp/13-top_chip.nl.v}
set ::env(SAVE_ODB) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/tmp/13-top_chip.odb}
set ::env(SAVE_POWERED_NETLIST) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/tmp/13-top_chip.pnl.v}
set ::env(SAVE_SDC) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/tmp/13-top_chip.sdc}
set ::env(SCLPATH) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/sky130_fd_sc_hd}
set ::env(SCRIPTS_DIR) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/openlane/scripts}
set ::env(SELINUX_LEVEL_REQUESTED) {}
set ::env(SELINUX_ROLE_REQUESTED) {}
set ::env(SELINUX_USE_CURRENT_RANGE) {}
set ::env(SESSION_MANAGER) {local/unix:@/tmp/.ICE-unix/218846,unix/unix:/tmp/.ICE-unix/218846}
set ::env(SHELL) {/bin/bash}
set ::env(SHLVL) {5}
set ::env(SPEF_EXTRACTOR) {openrcx}
set ::env(SSH_AGENT_PID) {219201}
set ::env(SSH_AUTH_SOCK) {/tmp/ssh-7QCyf3VicR1l/agent.218846}
set ::env(SSH_CLIENT) {134.58.56.167 59604 22}
set ::env(SSH_CONNECTION) {134.58.56.167 59604 10.87.20.53 22}
set ::env(SSH_TTY) {/dev/pts/100}
set ::env(START_TIME) {2023.05.22_14.42.56}
set ::env(STA_PRE_CTS) {1}
set ::env(STA_REPORT_POWER) {1}
set ::env(STA_WRITE_LIB) {1}
set ::env(STD_CELL_GROUND_PINS) {VGND VNB}
set ::env(STD_CELL_LIBRARY) {sky130_fd_sc_hd}
set ::env(STD_CELL_LIBRARY_CDL) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/cdl/sky130_fd_sc_hd.cdl}
set ::env(STD_CELL_LIBRARY_OPT) {sky130_fd_sc_hd}
set ::env(STD_CELL_LIBRARY_OPT_CDL) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/cdl/sky130_fd_sc_hd.cdl}
set ::env(STD_CELL_POWER_PINS) {VPWR VPB}
set ::env(SYNTH_ADDER_TYPE) {YOSYS}
set ::env(SYNTH_BIN) {yosys}
set ::env(SYNTH_BUFFERING) {1}
set ::env(SYNTH_CAP_LOAD) {33.442}
set ::env(SYNTH_CLOCK_TRANSITION) {0.15}
set ::env(SYNTH_CLOCK_UNCERTAINTY) {0.25}
set ::env(SYNTH_DRIVING_CELL) {sky130_fd_sc_hd__inv_2}
set ::env(SYNTH_DRIVING_CELL_PIN) {Y}
set ::env(SYNTH_ELABORATE_ONLY) {0}
set ::env(SYNTH_EXTRA_MAPPING_FILE) {}
set ::env(SYNTH_FLAT_TOP) {0}
set ::env(SYNTH_LATCH_MAP) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.tech/openlane/sky130_fd_sc_hd/latch_map.v}
set ::env(SYNTH_MAX_FANOUT) {30}
set ::env(SYNTH_MAX_TRAN) {0.75}
set ::env(SYNTH_MIN_BUF_PORT) {sky130_fd_sc_hd__buf_2 A X}
set ::env(SYNTH_MUX4_MAP) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.tech/openlane/sky130_fd_sc_hd/mux4_map.v}
set ::env(SYNTH_MUX_MAP) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.tech/openlane/sky130_fd_sc_hd/mux2_map.v}
set ::env(SYNTH_NO_FLAT) {1}
set ::env(SYNTH_OPT) {0}
set ::env(SYNTH_READ_BLACKBOX_LIB) {0}
set ::env(SYNTH_SCRIPT) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/openlane/scripts/yosys/synth.tcl}
set ::env(SYNTH_SHARE_RESOURCES) {1}
set ::env(SYNTH_SIZING) {0}
set ::env(SYNTH_STRATEGY) {AREA 3}
set ::env(SYNTH_TIEHI_PORT) {sky130_fd_sc_hd__conb_1 HI}
set ::env(SYNTH_TIELO_PORT) {sky130_fd_sc_hd__conb_1 LO}
set ::env(SYNTH_TIMING_DERATE) {0.05}
set ::env(S_COLORS) {auto}
set ::env(TAG) {230522-144242_accelerator_without_compression}
set ::env(TAKE_LAYOUT_SCROT) {0}
set ::env(TCLLIBPATH) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/lib/tcllib1.21}
set ::env(TECH_LEF) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/techlef/sky130_fd_sc_hd__nom.tlef}
set ::env(TECH_LEF_MAX) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/techlef/sky130_fd_sc_hd__max.tlef}
set ::env(TECH_LEF_MIN) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/techlef/sky130_fd_sc_hd__min.tlef}
set ::env(TECH_LEF_OPT) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/techlef/sky130_fd_sc_hd__nom.tlef}
set ::env(TECH_METAL_LAYERS) {li1 met1 met2 met3 met4 met5}
set ::env(TERM) {xterm-color}
set ::env(TERMINAL_OUTPUT) {/dev/null}
set ::env(TMPDIR) {/tmp}
set ::env(TMP_DIR) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/tmp}
set ::env(TOP_MARGIN_MULT) {4}
set ::env(TRACKS_INFO_FILE) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.tech/openlane/sky130_fd_sc_hd/tracks.info}
set ::env(TRACKS_INFO_FILE_PROCESSED) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/tmp/routing/config.tracks}
set ::env(TRISTATE_BUFFER_MAP) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.tech/openlane/sky130_fd_sc_hd/tribuff_map.v}
set ::env(USER) {r0755727}
set ::env(USE_ARC_ANTENNA_CHECK) {1}
set ::env(USE_GPIO_PADS) {0}
set ::env(VDD_NET) {vccd1}
set ::env(VDD_NETS) {vccd1}
set ::env(VDD_PIN) {vccd1}
set ::env(VDD_PIN_VOLTAGE) {1.80}
set ::env(VERILOG_FILES) {../Verilog/RTL_accelerator_without_compression/*.v}
set ::env(VISUAL) {vi}
set ::env(VNCDESKTOP) {amazone.esat.kuleuven.be:5 (r0755727)}
set ::env(VTE_VERSION) {5204}
set ::env(WIRE_RC_LAYER) {met1}
set ::env(XDG_CURRENT_DESKTOP) {GNOME}
set ::env(XDG_DATA_DIRS) {/users/students/r0755727/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share:/usr/local/share:/usr/share}
set ::env(XDG_MENU_PREFIX) {gnome-}
set ::env(XDG_RUNTIME_DIR) {/run/user/219215}
set ::env(XDG_SESSION_ID) {36002}
set ::env(XMODIFIERS) {@im=ibus}
set ::env(YOSYS_REWRITE_VERILOG) {0}
set ::env(_) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/bin/flow.tcl}
set ::env(cts_logs) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/logs/cts}
set ::env(cts_reports) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/reports/cts}
set ::env(cts_results) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/results/cts}
set ::env(cts_tmpfiles) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/tmp/cts}
set ::env(eco_logs) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/logs/eco}
set ::env(eco_reports) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/reports/eco}
set ::env(eco_results) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/results/eco}
set ::env(eco_tmpfiles) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/tmp/eco}
set ::env(floorplan_logs) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/logs/floorplan}
set ::env(floorplan_reports) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/reports/floorplan}
set ::env(floorplan_results) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/results/floorplan}
set ::env(floorplan_tmpfiles) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/tmp/floorplan}
set ::env(fp_report_prefix) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/reports/floorplan/3-initial_fp}
set ::env(placement_logs) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/logs/placement}
set ::env(placement_reports) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/reports/placement}
set ::env(placement_results) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/results/placement}
set ::env(placement_tmpfiles) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/tmp/placement}
set ::env(routing_logs) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/logs/routing}
set ::env(routing_reports) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/reports/routing}
set ::env(routing_results) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/results/routing}
set ::env(routing_tmpfiles) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/tmp/routing}
set ::env(signoff_logs) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/logs/signoff}
set ::env(signoff_reports) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/reports/signoff}
set ::env(signoff_results) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/results/signoff}
set ::env(signoff_tmpfiles) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/tmp/signoff}
set ::env(synth_report_prefix) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/reports/synthesis/1-synthesis}
set ::env(synthesis_logs) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/logs/synthesis}
set ::env(synthesis_reports) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/reports/synthesis}
set ::env(synthesis_results) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/results/synthesis}
set ::env(synthesis_tmpfiles) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/tmp/synthesis}
set ::env(timer_start) {1684759376}
set ::env(which_declare) {declare -f}
set ::env(PDK_ROOT) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk}
set ::env(BASE_SDC_FILE) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/openlane/scripts/base.sdc}
set ::env(BASH_FUNC__module_raw%%) {() {  unset _mlshdbg;
 if [ \\"\\${MODULES_SILENT_SHELL_DEBUG:-0}\\" = '1' ]; then
 case \\"\\$-\\" in 
 *v*x*)
 set +vx;
 _mlshdbg='vx'
 ;;
 *v*)
 set +v;
 _mlshdbg='v'
 ;;
 *x*)
 set +x;
 _mlshdbg='x'
 ;;
 *)
 _mlshdbg=''
 ;;
 esac;
 fi;
 unset _mlre _mlIFS;
 if [ -n \\"\\${IFS+x}\\" ]; then
 _mlIFS=\\$IFS;
 fi;
 IFS=' ';
 for _mlv in \\${MODULES_RUN_QUARANTINE:-};
 do
 if [ \\"\\${_mlv}\\" = \\"\\${_mlv##*[!A-Za-z0-9_]}\\" -a \\"\\${_mlv}\\" = \\"\\${_mlv#[0-9]}\\" ]; then
 if [ -n \\"`eval 'echo \\${'\\$_mlv'+x}'`\\" ]; then
 _mlre=\\"\\${_mlre:-}\\${_mlv}_modquar='`eval 'echo \\${'\\$_mlv'}'`' \\";
 fi;
 _mlrv=\\"MODULES_RUNENV_\\${_mlv}\\";
 _mlre=\\"\\${_mlre:-}\\${_mlv}='`eval 'echo \\${'\\$_mlrv':-}'`' \\";
 fi;
 done;
 if [ -n \\"\\${_mlre:-}\\" ]; then
 eval `eval \\${_mlre} /usr/bin/tclsh /usr/share/Modules/libexec/modulecmd.tcl bash '\\"\\$@\\"'`;
 else
 eval `/usr/bin/tclsh /usr/share/Modules/libexec/modulecmd.tcl bash \\"\\$@\\"`;
 fi;
 _mlstatus=\\$?;
 if [ -n \\"\\${_mlIFS+x}\\" ]; then
 IFS=\\$_mlIFS;
 else
 unset IFS;
 fi;
 unset _mlre _mlv _mlrv _mlIFS;
 if [ -n \\"\\${_mlshdbg:-}\\" ]; then
 set -\\$_mlshdbg;
 fi;
 unset _mlshdbg;
 return \\$_mlstatus
}}
set ::env(BASH_FUNC_ml%%) {() {  module ml \\"\\$@\\"
}}
set ::env(BASH_FUNC_module%%) {() {  _module_raw \\"\\$@\\" 2>&1
}}
set ::env(BASH_FUNC_scl%%) {() {  if [ \\"\\$1\\" = \\"load\\" -o \\"\\$1\\" = \\"unload\\" ]; then
 eval \\"module \\$@\\";
 else
 /usr/bin/scl \\"\\$@\\";
 fi
}}
set ::env(BASH_FUNC_switchml%%) {() {  typeset swfound=1;
 if [ \\"\\${MODULES_USE_COMPAT_VERSION:-0}\\" = '1' ]; then
 typeset swname='main';
 if [ -e /usr/share/Modules/libexec/modulecmd.tcl ]; then
 typeset swfound=0;
 unset MODULES_USE_COMPAT_VERSION;
 fi;
 else
 typeset swname='compatibility';
 if [ -e /usr/share/Modules/libexec/modulecmd-compat ]; then
 typeset swfound=0;
 MODULES_USE_COMPAT_VERSION=1;
 export MODULES_USE_COMPAT_VERSION;
 fi;
 fi;
 if [ \\$swfound -eq 0 ]; then
 echo \\"Switching to Modules \\$swname version\\";
 source /usr/share/Modules/init/bash;
 else
 echo \\"Cannot switch to Modules \\$swname version, command not found\\";
 return 1;
 fi
}}
set ::env(BASH_FUNC_which%%) {() {  ( alias;
 eval \\${which_declare} ) | /usr/bin/which --tty-only --read-alias --read-functions --show-tilde --show-dot \\$@
}}
set ::env(BASIC_PREP_COMPLETE) {1}
set ::env(BOTTOM_MARGIN_MULT) {4}
set ::env(CARRY_SELECT_ADDER_MAP) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.tech/openlane/sky130_fd_sc_hd/csa_map.v}
set ::env(CELLS_LEF) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/lef/sky130_fd_sc_hd.lef /users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/lef/sky130_ef_sc_hd.lef}
set ::env(CELLS_LEF_OPT) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/lef/sky130_fd_sc_hd.lef /users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/lef/sky130_ef_sc_hd.lef}
set ::env(CELL_CLK_PORT) {CLK}
set ::env(CELL_PAD_EXCLUDE) {sky130_fd_sc_hd__tap* sky130_fd_sc_hd__decap* sky130_ef_sc_hd__decap* sky130_fd_sc_hd__fill*}
set ::env(CLICOLOR) {1}
set ::env(CLK_BUFFER) {sky130_fd_sc_hd__clkbuf_4}
set ::env(CLK_BUFFER_INPUT) {A}
set ::env(CLK_BUFFER_OUTPUT) {X}
set ::env(CLOCK_BUFFER_FANOUT) {16}
set ::env(CLOCK_NET) {clk}
set ::env(CLOCK_PERIOD) {100}
set ::env(CLOCK_PORT) {clk}
set ::env(CLOCK_TREE_SYNTH) {1}
set ::env(CLOCK_WIRE_RC_LAYER) {met5}
set ::env(COLORTERM) {truecolor}
set ::env(CONDA_PREFIX) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env}
set ::env(CONFIGS) {general.tcl checkers.tcl synthesis.tcl floorplan.tcl cts.tcl placement.tcl routing.tcl extraction.tcl disable-missing-tools.tcl}
set ::env(CORE_AREA) {5.52 10.88 11294.38 11288.0}
set ::env(CORE_HEIGHT) {11277.12}
set ::env(CORE_NUM) {48}
set ::env(CORE_WIDTH) {11288.86}
set ::env(CTS_CLK_BUFFER_LIST) {sky130_fd_sc_hd__clkbuf_8 sky130_fd_sc_hd__clkbuf_4 sky130_fd_sc_hd__clkbuf_2}
set ::env(CTS_CLK_MAX_WIRE_LENGTH) {0}
set ::env(CTS_CURRENT_DEF) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/results/placement/top_chip.def}
set ::env(CTS_DISABLE_POST_PROCESSING) {0}
set ::env(CTS_DISTANCE_BETWEEN_BUFFERS) {0}
set ::env(CTS_MAX_CAP) {1.53169}
set ::env(CTS_REPORT_TIMING) {1}
set ::env(CTS_ROOT_BUFFER) {sky130_fd_sc_hd__clkbuf_16}
set ::env(CTS_SINK_CLUSTERING_MAX_DIAMETER) {50}
set ::env(CTS_SINK_CLUSTERING_SIZE) {25}
set ::env(CTS_SQR_CAP) {0.258e-3}
set ::env(CTS_SQR_RES) {0.125}
set ::env(CTS_TARGET_SKEW) {200}
set ::env(CTS_TECH_DIR) {N/A}
set ::env(CTS_TOLERANCE) {100}
set ::env(CURRENT_DEF) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/tmp/cts/12-top_chip.resized.def}
set ::env(CURRENT_GUIDE) {0}
set ::env(CURRENT_INDEX) {13}
set ::env(CURRENT_LIB) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/results/synthesis/top_chip.lib}
set ::env(CURRENT_NETLIST) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/tmp/cts/12-top_chip.resized.nl.v}
set ::env(CURRENT_ODB) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/tmp/cts/12-top_chip.resized.odb}
set ::env(CURRENT_POWERED_NETLIST) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/tmp/cts/12-top_chip.resized.pnl.v}
set ::env(CURRENT_SDC) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/tmp/cts/12-top_chip.resized.sdc}
set ::env(CURRENT_SDF) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/results/synthesis/top_chip.sdf}
set ::env(CURRENT_STEP) {routing}
set ::env(CVC_SCRIPTS_DIR) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.tech/openlane/cvc}
set ::env(DATA_WIRE_RC_LAYER) {met2}
set ::env(DBUS_SESSION_BUS_ADDRESS) {unix:abstract=/tmp/dbus-uuS73zyVxJ,guid=34fe75f003ac08e27f0a6ca06467a6fc}
set ::env(DEBUGINFOD_URLS) {https://debuginfod.centos.org/ }
set ::env(DECAP_CELL) {sky130_ef_sc_hd__decap_12 sky130_fd_sc_hd__decap_8 sky130_fd_sc_hd__decap_6 sky130_fd_sc_hd__decap_4 sky130_fd_sc_hd__decap_3}
set ::env(DEFAULT_MAX_TRAN) {0.75}
set ::env(DEF_UNITS_PER_MICRON) {1000}
set ::env(DESIGN_CONFIG) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/config.tcl}
set ::env(DESIGN_DIR) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend}
set ::env(DESIGN_IS_CORE) {1}
set ::env(DESIGN_NAME) {top_chip}
set ::env(DETAILED_ROUTER) {tritonroute}
set ::env(DIE_AREA) {0.0 0.0 11300.0 11300.0}
set ::env(DIODE_CELL) {sky130_fd_sc_hd__diode_2}
set ::env(DIODE_CELL_PIN) {DIODE}
set ::env(DIODE_INSERTION_STRATEGY) {3}
set ::env(DIODE_PADDING) {2}
set ::env(DISPLAY) {:5}
set ::env(DONT_USE_CELLS) {sky130_fd_sc_hd__a2111oi_0 sky130_fd_sc_hd__a21boi_0 sky130_fd_sc_hd__and2_0 sky130_fd_sc_hd__buf_16 sky130_fd_sc_hd__clkdlybuf4s15_1 sky130_fd_sc_hd__clkdlybuf4s18_1 sky130_fd_sc_hd__fa_4 sky130_fd_sc_hd__lpflow_bleeder_1 sky130_fd_sc_hd__lpflow_clkbufkapwr_1 sky130_fd_sc_hd__lpflow_clkbufkapwr_16 sky130_fd_sc_hd__lpflow_clkbufkapwr_2 sky130_fd_sc_hd__lpflow_clkbufkapwr_4 sky130_fd_sc_hd__lpflow_clkbufkapwr_8 sky130_fd_sc_hd__lpflow_clkinvkapwr_1 sky130_fd_sc_hd__lpflow_clkinvkapwr_16 sky130_fd_sc_hd__lpflow_clkinvkapwr_2 sky130_fd_sc_hd__lpflow_clkinvkapwr_4 sky130_fd_sc_hd__lpflow_clkinvkapwr_8 sky130_fd_sc_hd__lpflow_decapkapwr_12 sky130_fd_sc_hd__lpflow_decapkapwr_3 sky130_fd_sc_hd__lpflow_decapkapwr_4 sky130_fd_sc_hd__lpflow_decapkapwr_6 sky130_fd_sc_hd__lpflow_decapkapwr_8 sky130_fd_sc_hd__lpflow_inputiso0n_1 sky130_fd_sc_hd__lpflow_inputiso0p_1 sky130_fd_sc_hd__lpflow_inputiso1n_1 sky130_fd_sc_hd__lpflow_inputiso1p_1 sky130_fd_sc_hd__lpflow_inputisolatch_1 sky130_fd_sc_hd__lpflow_isobufsrc_1 sky130_fd_sc_hd__lpflow_isobufsrc_16 sky130_fd_sc_hd__lpflow_isobufsrc_2 sky130_fd_sc_hd__lpflow_isobufsrc_4 sky130_fd_sc_hd__lpflow_isobufsrc_8 sky130_fd_sc_hd__lpflow_isobufsrckapwr_16 sky130_fd_sc_hd__lpflow_lsbuf_lh_hl_isowell_tap_1 sky130_fd_sc_hd__lpflow_lsbuf_lh_hl_isowell_tap_2 sky130_fd_sc_hd__lpflow_lsbuf_lh_hl_isowell_tap_4 sky130_fd_sc_hd__lpflow_lsbuf_lh_isowell_4 sky130_fd_sc_hd__lpflow_lsbuf_lh_isowell_tap_1 sky130_fd_sc_hd__lpflow_lsbuf_lh_isowell_tap_2 sky130_fd_sc_hd__lpflow_lsbuf_lh_isowell_tap_4 sky130_fd_sc_hd__mux4_4 sky130_fd_sc_hd__o21ai_0 sky130_fd_sc_hd__o311ai_0 sky130_fd_sc_hd__or2_0 sky130_fd_sc_hd__probe_p_8 sky130_fd_sc_hd__probec_p_8 sky130_fd_sc_hd__xor3_1 sky130_fd_sc_hd__xor3_2 sky130_fd_sc_hd__xor3_4 sky130_fd_sc_hd__xnor3_1 sky130_fd_sc_hd__xnor3_2 sky130_fd_sc_hd__xnor3_4  }
set ::env(DPL_CELL_PADDING) {0}
set ::env(DRC_EXCLUDE_CELL_LIST) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.tech/openlane/sky130_fd_sc_hd/drc_exclude.cells}
set ::env(DRC_EXCLUDE_CELL_LIST_OPT) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.tech/openlane/sky130_fd_sc_hd/drc_exclude.cells}
set ::env(DRT_OPT_ITERS) {64}
set ::env(ECO_ENABLE) {0}
set ::env(ECO_FINISH) {0}
set ::env(ECO_ITER) {0}
set ::env(ECO_SKIP_PIN) {1}
set ::env(EDITOR) {vi}
set ::env(ESAT_ARCH) {linux-x86_64}
set ::env(EXTRA_GDS_FILES) {OpenRAM_output/sky130_sram_1r1w_128x512_128.gds OpenRAM_output/sky130_sram_fifo_1r1w_8x1024_8.gds}
set ::env(EXTRA_LEFS) {OpenRAM_output/sky130_sram_1r1w_128x512_128.lef OpenRAM_output/sky130_sram_fifo_1r1w_8x1024_8.lef}
set ::env(EXTRA_LIBS) {OpenRAM_output/sky130_sram_1r1w_128x512_128_TT_1p8V_25C.lib OpenRAM_output/sky130_sram_fifo_1r1w_8x1024_8_TT_1p8V_25C.lib}
set ::env(FAKEDIODE_CELL) {sky130_ef_sc_hd__fakediode_2}
set ::env(FILL_CELL) {sky130_fd_sc_hd__fill*}
set ::env(FLOW_FAILED) {1}
set ::env(FP_ASPECT_RATIO) {1}
set ::env(FP_CORE_UTIL) {30}
set ::env(FP_ENDCAP_CELL) {sky130_fd_sc_hd__decap_3}
set ::env(FP_IO_HEXTEND) {0}
set ::env(FP_IO_HLAYER) {met3}
set ::env(FP_IO_HLENGTH) {4}
set ::env(FP_IO_HTHICKNESS_MULT) {2}
set ::env(FP_IO_MIN_DISTANCE) {3}
set ::env(FP_IO_MODE) {1}
set ::env(FP_IO_UNMATCHED_ERROR) {1}
set ::env(FP_IO_VEXTEND) {0}
set ::env(FP_IO_VLAYER) {met2}
set ::env(FP_IO_VLENGTH) {4}
set ::env(FP_IO_VTHICKNESS_MULT) {2}
set ::env(FP_PDN_AUTO_ADJUST) {1}
set ::env(FP_PDN_CHECK_NODES) {1}
set ::env(FP_PDN_CORE_RING) {0}
set ::env(FP_PDN_CORE_RING_HOFFSET) {6}
set ::env(FP_PDN_CORE_RING_HSPACING) {1.7}
set ::env(FP_PDN_CORE_RING_HWIDTH) {1.6}
set ::env(FP_PDN_CORE_RING_VOFFSET) {6}
set ::env(FP_PDN_CORE_RING_VSPACING) {1.7}
set ::env(FP_PDN_CORE_RING_VWIDTH) {1.6}
set ::env(FP_PDN_ENABLE_GLOBAL_CONNECTIONS) {1}
set ::env(FP_PDN_ENABLE_MACROS_GRID) {1}
set ::env(FP_PDN_ENABLE_RAILS) {1}
set ::env(FP_PDN_HOFFSET) {16.65}
set ::env(FP_PDN_HORIZONTAL_HALO) {10}
set ::env(FP_PDN_HPITCH) {153.18}
set ::env(FP_PDN_HSPACING) {1.7}
set ::env(FP_PDN_HWIDTH) {1.6}
set ::env(FP_PDN_IRDROP) {1}
set ::env(FP_PDN_LOWER_LAYER) {met4}
set ::env(FP_PDN_MACRO_HOOKS) { genblk1[0].sram_weights_banks      vccd1 vssd1 vccd1 vssd1, 
genblk1[1].sram_weights_banks      vccd1 vssd1 vccd1 vssd1, genblk1[2].sram_weights_banks      vccd1 vssd1 vccd1 vssd1, genblk1[3].sram_weights_banks      vccd1 vssd1 vccd1 vssd1, genblk1[4].sram_weights_banks      vccd1 vssd1 vccd1 vssd1, genblk1[5].sram_weights_banks      vccd1 vssd1 vccd1 vssd1, genblk1[6].sram_weights_banks      vccd1 vssd1 vccd1 vssd1, genblk1[7].sram_weights_banks      vccd1 vssd1 vccd1 vssd1, genblk2[0].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[1].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[2].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[3].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[4].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[5].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[6].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[7].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[8].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[9].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[10].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[11].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[12].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[13].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[14].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[15].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[16].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[17].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[18].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[19].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[20].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[21].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[22].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[23].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[24].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[25].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[26].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[27].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[28].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[29].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[30].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, genblk2[31].sram_activations_banks      vccd1 vssd1 vccd1 vssd1, fifo_0.fifo_mem_0      vccd1 vssd1 vccd1 vssd1}
set ::env(FP_PDN_RAILS_LAYER) {met1}
set ::env(FP_PDN_RAIL_OFFSET) {0}
set ::env(FP_PDN_RAIL_WIDTH) {0.48}
set ::env(FP_PDN_SKIPTRIM) {0}
set ::env(FP_PDN_UPPER_LAYER) {met5}
set ::env(FP_PDN_VERTICAL_HALO) {10}
set ::env(FP_PDN_VOFFSET) {16.32}
set ::env(FP_PDN_VPITCH) {153.6}
set ::env(FP_PDN_VSPACING) {1.7}
set ::env(FP_PDN_VWIDTH) {1.6}
set ::env(FP_SIZING) {absolute}
set ::env(FP_TAPCELL_DIST) {13}
set ::env(FP_TAP_HORIZONTAL_HALO) {10}
set ::env(FP_TAP_VERTICAL_HALO) {10}
set ::env(FP_WELLTAP_CELL) {sky130_fd_sc_hd__tapvpwrvgnd_1}
set ::env(FULL_ADDER_MAP) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.tech/openlane/sky130_fd_sc_hd/fa_map.v}
set ::env(GDS_FILES) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/gds/sky130_fd_sc_hd.gds}
set ::env(GDS_FILES_OPT) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/gds/sky130_fd_sc_hd.gds}
set ::env(GENERATE_FINAL_SUMMARY_REPORT) {1}
set ::env(GIT_PAGER) {cat}
set ::env(GJS_DEBUG_OUTPUT) {stderr}
set ::env(GJS_DEBUG_TOPICS) {JS ERROR;JS LOG}
set ::env(GLB_CFG_FILE) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/config.tcl}
set ::env(GLB_OPTIMIZE_MIRRORING) {1}
set ::env(GLB_RESIZER_ALLOW_SETUP_VIOS) {0}
set ::env(GLB_RESIZER_HOLD_MAX_BUFFER_PERCENT) {50}
set ::env(GLB_RESIZER_HOLD_SLACK_MARGIN) {0.05}
set ::env(GLB_RESIZER_MAX_CAP_MARGIN) {10}
set ::env(GLB_RESIZER_MAX_SLEW_MARGIN) {10}
set ::env(GLB_RESIZER_MAX_WIRE_LENGTH) {0}
set ::env(GLB_RESIZER_SETUP_MAX_BUFFER_PERCENT) {50}
set ::env(GLB_RESIZER_SETUP_SLACK_MARGIN) {0.025}
set ::env(GLB_RESIZER_TIMING_OPTIMIZATIONS) {1}
set ::env(GLOBAL_ROUTER) {fastroute}
set ::env(GND_NET) {vssd1}
set ::env(GND_NETS) {vssd1}
set ::env(GND_PIN) {vssd1}
set ::env(GND_PIN_VOLTAGE) {0.00}
set ::env(GNOME_DESKTOP_SESSION_ID) {this-is-deprecated}
set ::env(GNOME_TERMINAL_SCREEN) {/org/gnome/Terminal/screen/2fd7925c_9cd1_4e14_93a0_4a8623c89e25}
set ::env(GNOME_TERMINAL_SERVICE) {:1.75}
set ::env(GPIO_PADS_LEF) { /users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.ref/sky130_fd_io/lef/sky130_fd_io.lef /users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.ref/sky130_fd_io/lef/sky130_ef_io.lef }
set ::env(GPIO_PADS_LEF_CORE_SIDE) { /users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.tech/openlane/custom_cells/lef/sky130_fd_io_core.lef /users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.tech/openlane/custom_cells/lef/sky130_ef_io_core.lef }
set ::env(GPIO_PADS_PREFIX) {sky130_fd_io sky130_ef_io}
set ::env(GPIO_PADS_VERILOG) { /users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.ref/sky130_fd_io/verilog/sky130_ef_io.v
}
set ::env(GPL_CELL_PADDING) {0}
set ::env(GRT_ADJUSTMENT) {0.3}
set ::env(GRT_ALLOW_CONGESTION) {0}
set ::env(GRT_ANT_ITERS) {3}
set ::env(GRT_ESTIMATE_PARASITICS) {1}
set ::env(GRT_LAYER_ADJUSTMENTS) {0.99,0,0,0,0,0}
set ::env(GRT_MACRO_EXTENSION) {0}
set ::env(GRT_MAX_DIODE_INS_ITERS) {1}
set ::env(GRT_OVERFLOW_ITERS) {50}
set ::env(GS_OPTIONS) {-sPAPERSIZE=a4}
set ::env(HISTCONTROL) {ignoredups}
set ::env(HISTSIZE) {1000}
set ::env(HOME) {/users/students/r0755727}
set ::env(HOSTNAME) {amazone.esat.kuleuven.be}
set ::env(IO_PCT) {0.2}
set ::env(JPY_PARENT_PID) {248653}
set ::env(JPY_SESSION_NAME) {48722245-ddf0-4b5c-b49e-51fd404c5959}
set ::env(KDEDIRS) {/usr}
set ::env(KLAYOUT_DEF_LAYER_MAP) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.tech/klayout/tech/sky130A.map}
set ::env(KLAYOUT_DRC_KLAYOUT_GDS) {0}
set ::env(KLAYOUT_DRC_TECH_SCRIPT) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.tech/klayout/drc/sky130A_mr.drc}
set ::env(KLAYOUT_PROPERTIES) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.tech/klayout/tech/sky130A.lyp}
set ::env(KLAYOUT_TECH) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.tech/klayout/tech/sky130A.lyt}
set ::env(KLAYOUT_XOR_GDS) {1}
set ::env(KLAYOUT_XOR_IGNORE_LAYERS) {81/14}
set ::env(KLAYOUT_XOR_THREADS) {1}
set ::env(KLAYOUT_XOR_XML) {1}
set ::env(LANG) {en_US.UTF-8}
set ::env(LAST_TIMING_REPORT_TAG) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/reports/synthesis/2-syn_sta}
set ::env(LD_LIBRARY_PATH) {:/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/lib}
set ::env(LEC_ENABLE) {0}
set ::env(LEFT_MARGIN_MULT) {12}
set ::env(LESSOPEN) {||/usr/bin/lesspipe.sh %s}
set ::env(LIB_CTS) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/tmp/cts/cts.lib}
set ::env(LIB_FASTEST) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__ff_n40C_1v95.lib}
set ::env(LIB_SLOWEST) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__ss_100C_1v60.lib}
set ::env(LIB_SLOWEST_OPT) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__ss_100C_1v60.lib}
set ::env(LIB_SYNTH) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/tmp/synthesis/trimmed.lib}
set ::env(LIB_SYNTH_COMPLETE) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib}
set ::env(LIB_SYNTH_COMPLETE_NO_PG) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/tmp/synthesis/1-sky130_fd_sc_hd__tt_025C_1v80.no_pg.lib}
set ::env(LIB_SYNTH_MERGED) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/tmp/synthesis/merged.lib}
set ::env(LIB_SYNTH_NO_PG) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/tmp/synthesis/1-trimmed.no_pg.lib}
set ::env(LIB_TYPICAL) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib}
set ::env(LOADEDMODULES) {}
set ::env(LOGNAME) {r0755727}
set ::env(LOGS_DIR) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/logs}
set ::env(LPDEST) {ulstudent}
set ::env(LS_COLORS) {rs=0:di=38;5;33:ln=38;5;51:mh=00:pi=40;38;5;11:so=38;5;13:do=38;5;5:bd=48;5;232;38;5;11:cd=48;5;232;38;5;3:or=48;5;232;38;5;9:mi=01;05;37;41:su=48;5;196;38;5;15:sg=48;5;11;38;5;16:ca=48;5;196;38;5;226:tw=48;5;10;38;5;16:ow=48;5;10;38;5;21:st=48;5;21;38;5;15:ex=38;5;40:*.tar=38;5;9:*.tgz=38;5;9:*.arc=38;5;9:*.arj=38;5;9:*.taz=38;5;9:*.lha=38;5;9:*.lz4=38;5;9:*.lzh=38;5;9:*.lzma=38;5;9:*.tlz=38;5;9:*.txz=38;5;9:*.tzo=38;5;9:*.t7z=38;5;9:*.zip=38;5;9:*.z=38;5;9:*.dz=38;5;9:*.gz=38;5;9:*.lrz=38;5;9:*.lz=38;5;9:*.lzo=38;5;9:*.xz=38;5;9:*.zst=38;5;9:*.tzst=38;5;9:*.bz2=38;5;9:*.bz=38;5;9:*.tbz=38;5;9:*.tbz2=38;5;9:*.tz=38;5;9:*.deb=38;5;9:*.rpm=38;5;9:*.jar=38;5;9:*.war=38;5;9:*.ear=38;5;9:*.sar=38;5;9:*.rar=38;5;9:*.alz=38;5;9:*.ace=38;5;9:*.zoo=38;5;9:*.cpio=38;5;9:*.7z=38;5;9:*.rz=38;5;9:*.cab=38;5;9:*.wim=38;5;9:*.swm=38;5;9:*.dwm=38;5;9:*.esd=38;5;9:*.jpg=38;5;13:*.jpeg=38;5;13:*.mjpg=38;5;13:*.mjpeg=38;5;13:*.gif=38;5;13:*.bmp=38;5;13:*.pbm=38;5;13:*.pgm=38;5;13:*.ppm=38;5;13:*.tga=38;5;13:*.xbm=38;5;13:*.xpm=38;5;13:*.tif=38;5;13:*.tiff=38;5;13:*.png=38;5;13:*.svg=38;5;13:*.svgz=38;5;13:*.mng=38;5;13:*.pcx=38;5;13:*.mov=38;5;13:*.mpg=38;5;13:*.mpeg=38;5;13:*.m2v=38;5;13:*.mkv=38;5;13:*.webm=38;5;13:*.ogm=38;5;13:*.mp4=38;5;13:*.m4v=38;5;13:*.mp4v=38;5;13:*.vob=38;5;13:*.qt=38;5;13:*.nuv=38;5;13:*.wmv=38;5;13:*.asf=38;5;13:*.rm=38;5;13:*.rmvb=38;5;13:*.flc=38;5;13:*.avi=38;5;13:*.fli=38;5;13:*.flv=38;5;13:*.gl=38;5;13:*.dl=38;5;13:*.xcf=38;5;13:*.xwd=38;5;13:*.yuv=38;5;13:*.cgm=38;5;13:*.emf=38;5;13:*.ogv=38;5;13:*.ogx=38;5;13:*.aac=38;5;45:*.au=38;5;45:*.flac=38;5;45:*.m4a=38;5;45:*.mid=38;5;45:*.midi=38;5;45:*.mka=38;5;45:*.mp3=38;5;45:*.mpc=38;5;45:*.ogg=38;5;45:*.ra=38;5;45:*.wav=38;5;45:*.oga=38;5;45:*.opus=38;5;45:*.spx=38;5;45:*.xspf=38;5;45:}
set ::env(LVS_CONNECT_BY_LABEL) {0}
set ::env(LVS_INSERT_POWER_PINS) {1}
set ::env(MACRO_BLOCKAGES_LAYER) {li1 met1 met2 met3 met4}
set ::env(MACRO_PLACEMENT_CFG) {macro_placement.cfg}
set ::env(MAGIC_CONVERT_DRC_TO_RDB) {1}
set ::env(MAGIC_DEF_LABELS) {1}
set ::env(MAGIC_DEF_NO_BLOCKAGES) {1}
set ::env(MAGIC_DISABLE_HIER_GDS) {1}
set ::env(MAGIC_DRC_USE_GDS) {0}
set ::env(MAGIC_EXT_USE_GDS) {0}
set ::env(MAGIC_GDS_ALLOW_ABSTRACT) {0}
set ::env(MAGIC_GDS_POLYGON_SUBCELLS) {0}
set ::env(MAGIC_GENERATE_GDS) {1}
set ::env(MAGIC_GENERATE_LEF) {1}
set ::env(MAGIC_GENERATE_MAGLEF) {1}
set ::env(MAGIC_INCLUDE_GDS_POINTERS) {0}
set ::env(MAGIC_MAGICRC) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.tech/magic/sky130A.magicrc}
set ::env(MAGIC_PAD) {0}
set ::env(MAGIC_TECH_FILE) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.tech/magic/sky130A.tech}
set ::env(MAGIC_WRITE_FULL_LEF) {0}
set ::env(MAGIC_ZEROIZE_ORIGIN) {0}
set ::env(MAIL) {/var/spool/mail/r0755727}
set ::env(MAILCHECK) {0}
set ::env(MANPATH) {::/opt/puppetlabs/puppet/share/man:/freeware/man:/software/man}
set ::env(MAX_METAL_LAYER) {6}
set ::env(MERGED_LEF) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/tmp/merged.nom.lef}
set ::env(MERGED_LEF_MAX) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/tmp/merged.max.lef}
set ::env(MERGED_LEF_MIN) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/tmp/merged.min.lef}
set ::env(MICAS_LICENSE_FILE) {/users/micas/micas/license/license.dat}
set ::env(MODULEPATH) {/etc/scl/modulefiles:/usr/share/Modules/modulefiles:/etc/modulefiles:/usr/share/modulefiles}
set ::env(MODULEPATH_modshare) {/usr/share/Modules/modulefiles:2:/etc/modulefiles:2:/usr/share/modulefiles:2}
set ::env(MODULESHOME) {/usr/share/Modules}
set ::env(MODULES_CMD) {/usr/share/Modules/libexec/modulecmd.tcl}
set ::env(MODULES_RUN_QUARANTINE) {LD_LIBRARY_PATH LD_PRELOAD}
set ::env(MPLBACKEND) {module://matplotlib_inline.backend_inline}
set ::env(NETGEN_SETUP_FILE) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.tech/netgen/sky130A_setup.tcl}
set ::env(NO_SYNTH_CELL_LIST) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.tech/openlane/sky130_fd_sc_hd/no_synth.cells}
set ::env(OLDPWD) {/users/students/r0755727}
set ::env(OL_INSTALL_DIR) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/openlane/install}
set ::env(OPENLANE_LOCAL_INSTALL) {1}
set ::env(OPENLANE_ROOT) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/openlane}
set ::env(OPENLANE_VERBOSE) {0}
set ::env(OPENLANE_VERSION) {2023.03.01_0_ge10820ec-conda}
set ::env(OPENROAD_BIN) {openroad}
set ::env(PAGER) {cat}
set ::env(PATH) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/bin:/usr/share/Modules/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/opt/puppetlabs/bin:/freeware/bin/gnu-tools:/freeware/bin:/software/bin:/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/openlane:/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/openlane/scripts}
set ::env(PDK) {sky130A}
set ::env(PDKPATH) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A}
set ::env(PDK_ROOT) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk}
set ::env(PDN_CFG) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/openlane/scripts/openroad/common/pdn_cfg.tcl}
set ::env(PLACEMENT_CURRENT_DEF) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/tmp/floorplan/7-pdn.def}
set ::env(PLACE_SITE) {unithd}
set ::env(PLACE_SITE_HEIGHT) {2.720}
set ::env(PLACE_SITE_WIDTH) {0.460}
set ::env(PL_BASIC_PLACEMENT) {0}
set ::env(PL_ESTIMATE_PARASITICS) {1}
set ::env(PL_INIT_COEFF) {0.00002}
set ::env(PL_IO_ITER) {5}
set ::env(PL_LIB) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib}
set ::env(PL_MACRO_CHANNEL) {0 0}
set ::env(PL_MACRO_HALO) {90 90}
set ::env(PL_MAX_DISPLACEMENT_X) {500}
set ::env(PL_MAX_DISPLACEMENT_Y) {100}
set ::env(PL_OPTIMIZE_MIRRORING) {1}
set ::env(PL_RANDOM_GLB_PLACEMENT) {0}
set ::env(PL_RANDOM_INITIAL_PLACEMENT) {0}
set ::env(PL_RESIZER_ALLOW_SETUP_VIOS) {0}
set ::env(PL_RESIZER_BUFFER_INPUT_PORTS) {1}
set ::env(PL_RESIZER_BUFFER_OUTPUT_PORTS) {1}
set ::env(PL_RESIZER_DESIGN_OPTIMIZATIONS) {1}
set ::env(PL_RESIZER_HOLD_MAX_BUFFER_PERCENT) {50}
set ::env(PL_RESIZER_HOLD_SLACK_MARGIN) {0.1}
set ::env(PL_RESIZER_MAX_CAP_MARGIN) {20}
set ::env(PL_RESIZER_MAX_SLEW_MARGIN) {20}
set ::env(PL_RESIZER_MAX_WIRE_LENGTH) {0}
set ::env(PL_RESIZER_REPAIR_TIE_FANOUT) {1}
set ::env(PL_RESIZER_SETUP_MAX_BUFFER_PERCENT) {50}
set ::env(PL_RESIZER_SETUP_SLACK_MARGIN) {0.05}
set ::env(PL_RESIZER_TIE_SEPERATION) {0}
set ::env(PL_RESIZER_TIMING_OPTIMIZATIONS) {1}
set ::env(PL_ROUTABILITY_DRIVEN) {1}
set ::env(PL_SKIP_INITIAL_PLACEMENT) {0}
set ::env(PL_TARGET_DENSITY) {0.05}
set ::env(PL_TIME_DRIVEN) {1}
set ::env(PL_WIRELENGTH_COEF) {0.25}
set ::env(PRIMARY_SIGNOFF_TOOL) {magic}
set ::env(PRINTER) {ulstudent}
set ::env(PROCESS) {130}
set ::env(PROJECT_HOME) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend}
set ::env(PWD) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend}
set ::env(PYDEVD_USE_FRAME_EVAL) {NO}
set ::env(QT_IM_MODULE) {ibus}
set ::env(QUIT_ON_ASSIGN_STATEMENTS) {0}
set ::env(QUIT_ON_HOLD_VIOLATIONS) {1}
set ::env(QUIT_ON_ILLEGAL_OVERLAPS) {1}
set ::env(QUIT_ON_LONG_WIRE) {0}
set ::env(QUIT_ON_LVS_ERROR) {1}
set ::env(QUIT_ON_MAGIC_DRC) {0}
set ::env(QUIT_ON_SETUP_VIOLATIONS) {1}
set ::env(QUIT_ON_SYNTH_CHECKS) {0}
set ::env(QUIT_ON_TIMING_VIOLATIONS) {1}
set ::env(QUIT_ON_TR_DRC) {1}
set ::env(QUIT_ON_UNMAPPED_CELLS) {1}
set ::env(QUIT_ON_XOR_ERROR) {1}
set ::env(RCX_CC_MODEL) {10}
set ::env(RCX_CONTEXT_DEPTH) {5}
set ::env(RCX_CORNER_COUNT) {1}
set ::env(RCX_COUPLING_THRESHOLD) {0.1}
set ::env(RCX_MAX_RESISTANCE) {50}
set ::env(RCX_MERGE_VIA_WIRE_RES) {1}
set ::env(RCX_RULES) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.tech/openlane/rules.openrcx.sky130A.nom.calibre}
set ::env(RCX_RULES_MAX) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.tech/openlane/rules.openrcx.sky130A.max.calibre}
set ::env(RCX_RULES_MIN) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.tech/openlane/rules.openrcx.sky130A.min.calibre}
set ::env(REPORTS_DIR) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/reports}
set ::env(RESULTS_DIR) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/results}
set ::env(RE_BUFFER_CELL) {sky130_fd_sc_hd__buf_4}
set ::env(RIGHT_MARGIN_MULT) {12}
set ::env(RIPPLE_CARRY_ADDER_MAP) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.tech/openlane/sky130_fd_sc_hd/rca_map.v}
set ::env(ROOT_CLK_BUFFER) {sky130_fd_sc_hd__clkbuf_16}
set ::env(ROUTING_CORES) {48}
set ::env(ROUTING_CURRENT_DEF) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/tmp/cts/12-top_chip.resized.def}
set ::env(RSZ_DONT_TOUCH_RX) {\\$^}
set ::env(RSZ_LIB) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/tmp/synthesis/resizer_sky130_fd_sc_hd__tt_025C_1v80.lib}
set ::env(RSZ_USE_OLD_REMOVER) {0}
set ::env(RT_MAX_LAYER) {met5}
set ::env(RT_MIN_LAYER) {met1}
set ::env(RUN_CVC) {0}
set ::env(RUN_DIR) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression}
set ::env(RUN_DRT) {1}
set ::env(RUN_FILL_INSERTION) {1}
set ::env(RUN_IRDROP_REPORT) {1}
set ::env(RUN_KLAYOUT) {0}
set ::env(RUN_KLAYOUT_DRC) {0}
set ::env(RUN_KLAYOUT_XOR) {0}
set ::env(RUN_LVS) {1}
set ::env(RUN_MAGIC) {1}
set ::env(RUN_MAGIC_DRC) {1}
set ::env(RUN_SPEF_EXTRACTION) {1}
set ::env(RUN_STANDALONE) {1}
set ::env(RUN_TAG) {230522-144242_accelerator_without_compression}
set ::env(RUN_TAP_DECAP_INSERTION) {1}
set ::env(SAVE_DEF) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/tmp/13-top_chip.def}
set ::env(SAVE_DIR) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/tmp/routing}
set ::env(SAVE_NETLIST) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/tmp/13-top_chip.nl.v}
set ::env(SAVE_ODB) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/tmp/13-top_chip.odb}
set ::env(SAVE_POWERED_NETLIST) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/tmp/13-top_chip.pnl.v}
set ::env(SAVE_SDC) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/tmp/13-top_chip.sdc}
set ::env(SCLPATH) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/sky130_fd_sc_hd}
set ::env(SCRIPTS_DIR) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/openlane/scripts}
set ::env(SELINUX_LEVEL_REQUESTED) {}
set ::env(SELINUX_ROLE_REQUESTED) {}
set ::env(SELINUX_USE_CURRENT_RANGE) {}
set ::env(SESSION_MANAGER) {local/unix:@/tmp/.ICE-unix/218846,unix/unix:/tmp/.ICE-unix/218846}
set ::env(SHELL) {/bin/bash}
set ::env(SHLVL) {5}
set ::env(SPEF_EXTRACTOR) {openrcx}
set ::env(SSH_AGENT_PID) {219201}
set ::env(SSH_AUTH_SOCK) {/tmp/ssh-7QCyf3VicR1l/agent.218846}
set ::env(SSH_CLIENT) {134.58.56.167 59604 22}
set ::env(SSH_CONNECTION) {134.58.56.167 59604 10.87.20.53 22}
set ::env(SSH_TTY) {/dev/pts/100}
set ::env(START_TIME) {2023.05.22_14.42.56}
set ::env(STA_PRE_CTS) {1}
set ::env(STA_REPORT_POWER) {1}
set ::env(STA_WRITE_LIB) {1}
set ::env(STD_CELL_GROUND_PINS) {VGND VNB}
set ::env(STD_CELL_LIBRARY) {sky130_fd_sc_hd}
set ::env(STD_CELL_LIBRARY_CDL) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/cdl/sky130_fd_sc_hd.cdl}
set ::env(STD_CELL_LIBRARY_OPT) {sky130_fd_sc_hd}
set ::env(STD_CELL_LIBRARY_OPT_CDL) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/cdl/sky130_fd_sc_hd.cdl}
set ::env(STD_CELL_POWER_PINS) {VPWR VPB}
set ::env(SYNTH_ADDER_TYPE) {YOSYS}
set ::env(SYNTH_BIN) {yosys}
set ::env(SYNTH_BUFFERING) {1}
set ::env(SYNTH_CAP_LOAD) {33.442}
set ::env(SYNTH_CLOCK_TRANSITION) {0.15}
set ::env(SYNTH_CLOCK_UNCERTAINTY) {0.25}
set ::env(SYNTH_DRIVING_CELL) {sky130_fd_sc_hd__inv_2}
set ::env(SYNTH_DRIVING_CELL_PIN) {Y}
set ::env(SYNTH_ELABORATE_ONLY) {0}
set ::env(SYNTH_EXTRA_MAPPING_FILE) {}
set ::env(SYNTH_FLAT_TOP) {0}
set ::env(SYNTH_LATCH_MAP) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.tech/openlane/sky130_fd_sc_hd/latch_map.v}
set ::env(SYNTH_MAX_FANOUT) {30}
set ::env(SYNTH_MAX_TRAN) {0.75}
set ::env(SYNTH_MIN_BUF_PORT) {sky130_fd_sc_hd__buf_2 A X}
set ::env(SYNTH_MUX4_MAP) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.tech/openlane/sky130_fd_sc_hd/mux4_map.v}
set ::env(SYNTH_MUX_MAP) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.tech/openlane/sky130_fd_sc_hd/mux2_map.v}
set ::env(SYNTH_NO_FLAT) {1}
set ::env(SYNTH_OPT) {0}
set ::env(SYNTH_READ_BLACKBOX_LIB) {0}
set ::env(SYNTH_SCRIPT) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/openlane/scripts/yosys/synth.tcl}
set ::env(SYNTH_SHARE_RESOURCES) {1}
set ::env(SYNTH_SIZING) {0}
set ::env(SYNTH_STRATEGY) {AREA 3}
set ::env(SYNTH_TIEHI_PORT) {sky130_fd_sc_hd__conb_1 HI}
set ::env(SYNTH_TIELO_PORT) {sky130_fd_sc_hd__conb_1 LO}
set ::env(SYNTH_TIMING_DERATE) {0.05}
set ::env(S_COLORS) {auto}
set ::env(TAG) {230522-144242_accelerator_without_compression}
set ::env(TAKE_LAYOUT_SCROT) {0}
set ::env(TCLLIBPATH) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/lib/tcllib1.21}
set ::env(TECH_LEF) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/techlef/sky130_fd_sc_hd__nom.tlef}
set ::env(TECH_LEF_MAX) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/techlef/sky130_fd_sc_hd__max.tlef}
set ::env(TECH_LEF_MIN) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/techlef/sky130_fd_sc_hd__min.tlef}
set ::env(TECH_LEF_OPT) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/techlef/sky130_fd_sc_hd__nom.tlef}
set ::env(TECH_METAL_LAYERS) {li1 met1 met2 met3 met4 met5}
set ::env(TERM) {xterm-color}
set ::env(TERMINAL_OUTPUT) {/dev/null}
set ::env(TMPDIR) {/tmp}
set ::env(TMP_DIR) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/tmp}
set ::env(TOP_MARGIN_MULT) {4}
set ::env(TRACKS_INFO_FILE) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.tech/openlane/sky130_fd_sc_hd/tracks.info}
set ::env(TRACKS_INFO_FILE_PROCESSED) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/tmp/routing/config.tracks}
set ::env(TRISTATE_BUFFER_MAP) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/share/pdk/sky130A/libs.tech/openlane/sky130_fd_sc_hd/tribuff_map.v}
set ::env(USER) {r0755727}
set ::env(USE_ARC_ANTENNA_CHECK) {1}
set ::env(USE_GPIO_PADS) {0}
set ::env(VDD_NET) {vccd1}
set ::env(VDD_NETS) {vccd1}
set ::env(VDD_PIN) {vccd1}
set ::env(VDD_PIN_VOLTAGE) {1.80}
set ::env(VERILOG_FILES) {../Verilog/RTL_accelerator_without_compression/*.v}
set ::env(VISUAL) {vi}
set ::env(VNCDESKTOP) {amazone.esat.kuleuven.be:5 (r0755727)}
set ::env(VTE_VERSION) {5204}
set ::env(WIRE_RC_LAYER) {met1}
set ::env(XDG_CURRENT_DESKTOP) {GNOME}
set ::env(XDG_DATA_DIRS) {/users/students/r0755727/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share:/usr/local/share:/usr/share}
set ::env(XDG_MENU_PREFIX) {gnome-}
set ::env(XDG_RUNTIME_DIR) {/run/user/219215}
set ::env(XDG_SESSION_ID) {36002}
set ::env(XMODIFIERS) {@im=ibus}
set ::env(YOSYS_REWRITE_VERILOG) {0}
set ::env(_) {/users/students/r0755727/Documents/CA_Exercise/CA_Exercises/Backend/conda-env/bin/flow.tcl}
set ::env(cts_logs) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/logs/cts}
set ::env(cts_reports) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/reports/cts}
set ::env(cts_results) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/results/cts}
set ::env(cts_tmpfiles) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/tmp/cts}
set ::env(eco_logs) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/logs/eco}
set ::env(eco_reports) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/reports/eco}
set ::env(eco_results) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/results/eco}
set ::env(eco_tmpfiles) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/tmp/eco}
set ::env(floorplan_logs) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/logs/floorplan}
set ::env(floorplan_reports) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/reports/floorplan}
set ::env(floorplan_results) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/results/floorplan}
set ::env(floorplan_tmpfiles) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/tmp/floorplan}
set ::env(fp_report_prefix) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/reports/floorplan/3-initial_fp}
set ::env(placement_logs) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/logs/placement}
set ::env(placement_reports) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/reports/placement}
set ::env(placement_results) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/results/placement}
set ::env(placement_tmpfiles) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/tmp/placement}
set ::env(routing_logs) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/logs/routing}
set ::env(routing_reports) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/reports/routing}
set ::env(routing_results) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/results/routing}
set ::env(routing_tmpfiles) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/tmp/routing}
set ::env(signoff_logs) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/logs/signoff}
set ::env(signoff_reports) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/reports/signoff}
set ::env(signoff_results) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/results/signoff}
set ::env(signoff_tmpfiles) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/tmp/signoff}
set ::env(synth_report_prefix) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/reports/synthesis/1-synthesis}
set ::env(synthesis_logs) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/logs/synthesis}
set ::env(synthesis_reports) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/reports/synthesis}
set ::env(synthesis_results) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/results/synthesis}
set ::env(synthesis_tmpfiles) {/esat/micas_raid/users/r0755727/230522-144242_accelerator_without_compression/tmp/synthesis}
set ::env(timer_end) {1684763912}
set ::env(timer_start) {1684759376}
set ::env(which_declare) {declare -f}
