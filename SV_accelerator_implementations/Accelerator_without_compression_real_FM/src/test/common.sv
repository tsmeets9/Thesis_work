
typedef struct {
  int DATA_WIDTH         = 8;
  int ACCUMULATION_WIDTH = 16;
  int FEATURE_MAP_WIDTH  = 112;
  int FEATURE_MAP_HEIGHT = 112;
  int INPUT_NB_CHANNELS  = 32;
  int OUTPUT_NB_CHANNELS = 32;
  int KERNEL_SIZE        = 3;
  int MEM_BW             = 128;
  int ADDR_WIDTH_ACT     = 14;
  int ADDR_WIDTH_WEIGHTS = 9;
} config_t;
