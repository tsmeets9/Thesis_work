class Transaction_Feature #(config_t cfg);
  logic [cfg.MEM_BW - 1 : 0] inputs [0 : ((cfg.FEATURE_MAP_WIDTH-1)/16+1)*cfg.FEATURE_MAP_HEIGHT*cfg.INPUT_NB_CHANNELS - 1];

endclass

// !!NOTE!! Relook this for when the INPUT NB OF CHANNELS IS NOT A 
class Transaction_Masks #(config_t cfg);
  logic [cfg.MEM_BW - 1 : 0] masks [0 : ((cfg.FEATURE_MAP_WIDTH-1)/16+1)*cfg.FEATURE_MAP_HEIGHT*cfg.INPUT_NB_CHANNELS/8 - 1];

endclass

class Transaction_Kernel #(config_t cfg);
  logic signed [cfg.DATA_WIDTH - 1 : 0] kernel [0:cfg.KERNEL_SIZE - 1][0:cfg.KERNEL_SIZE - 1][0 : cfg.INPUT_NB_CHANNELS - 1][0 : cfg.OUTPUT_NB_CHANNELS - 1];
endclass

class Transaction_Output_Encoded #(config_t cfg);
  logic [cfg.MEM_BW-1:0] output_data_encoded;
  logic [$clog2(((cfg.FEATURE_MAP_WIDTH-1)/16+1)*cfg.FEATURE_MAP_HEIGHT*cfg.OUTPUT_NB_CHANNELS)-1:0] index;
endclass

class Transaction_Output_Masks #(config_t cfg);
  logic [cfg.MEM_BW-1:0] output_data_masks;
  logic [$clog2(((cfg.FEATURE_MAP_WIDTH-1)/16+1)*cfg.FEATURE_MAP_HEIGHT*cfg.OUTPUT_NB_CHANNELS/8)-1:0] index;
endclass