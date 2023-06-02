module controller_fsm #(
  parameter int FEATURE_MAP_WIDTH = 56,
  parameter int FEATURE_MAP_HEIGHT = 56,
  parameter int INPUT_NB_CHANNELS = 64,
  parameter int OUTPUT_NB_CHANNELS = 64,
  parameter int KERNEL_SIZE = 3,
  parameter int MEM_BW = 128,
  parameter int ADDR_WIDTH_ACT = 14,
  parameter int ADDR_WIDTH_MASKS = 11,
  parameter int ADDR_WIDTH_WEIGHTS = 12
  )
  (input logic clk,
  input logic arst_n_in, //asynchronous reset, active low

  input logic start,
  output logic running,

  //datapad control interface & external handshaking communication of encoded data (activations), masks and weights
  input logic activations_valid,
  input logic weights_valid,
  input logic masks_valid,
  output logic weights_ready,
  output logic activations_ready,
  output logic masks_ready,
  output logic write_activations_registers_first,
  output logic write_activations_registers_second,
  output logic shift, 
  output logic write_weights_registers,
  output logic mac_valid,
  output logic mac_accumulate_internal,

  // Interfacing weights memory
  output logic write_weights_memory,
  output logic read_weights_memory,
  output logic [ADDR_WIDTH_WEIGHTS-1:0] address_weights,
  
  // Interfacing activations memory
  output logic write_activations_memory,
  output logic read_activations_memory,
  output logic [ADDR_WIDTH_ACT-1:0] address_activations_writing,
  output logic [ADDR_WIDTH_ACT-1:0] address_activations_reading,

  // Interfacing masks memory
  output logic write_masks_memory,
  output logic read_masks_memory,
  output logic [ADDR_WIDTH_MASKS-1:0] address_masks_writing,
  output logic [ADDR_WIDTH_MASKS-1:0] address_masks_reading,
  output logic CE_address_masks_writing,
  output logic [31:0] masks_transferred_to_memory,

  input logic [32-1:0] activation_rows_total,
  input logic delayed_CE_address_masks_writing,
  input logic [ADDR_WIDTH_MASKS-1:0] delayed_masks_transferred,

  // Indicating output valid
  output logic output_valid_encoded,
  output logic output_valid_masks,
  
  //Driver logic
  input logic ready_driver,
  output logic write_masks_registers [0:1][0:2][0:1],
  output logic start_driver,
  output logic reset_driver,
  output logic [1:0] fx,
  output logic [1:0] fy,
  output logic [31:0] start_address_encoded,

  //Decoder logic
  output logic CE_decoder,

  //Encoder + packer logic 
  output logic [31:0] x_reg_for_encoder,
  output logic CE_encoder,
  input logic ready_packer,
  output logic start_packer,
  output logic [3:0] encoder_to_packer_counter,

  input logic [ADDR_WIDTH_ACT-1:0] outputs_encoded_to_memory_counter,
  input logic [ADDR_WIDTH_MASKS-1:0] outputs_masks_to_memory_counter,

  // Extra word logic 
  output logic extra_word_write_valid,
  input logic extra_word_write_ready,
  input logic extra_word_read_valid,
  output logic extra_word_read_ready,
  output logic write_extra_word_in_register,
  output logic extra_word_from_FIFO,
  
  output logic zero_padding,
  output logic reset_fifo
  );

  //// INITIALIZATION

  typedef enum {IDLE, WRITE_WEIGHTS, WRITE_MASKS, WRITE_ACTIVATIONS, START_WRITE_ENC_MASK_REGISTERS, WRITE_ENC_MASK_REGISTERS, END_WRITE_ENC_MASK_REGISTERS, DUMMY_MAC_1, DUMMY_MAC_2, DUMMY_MAC_3, DRIVE_TO_DECODING_1, DO_DECODING_1, MAC_FX_0_AND_SHIFT_FX_1, DRIVE_TO_DECODING_2, DO_DECODING_2, MAC_FX_1_AND_FETCH_FX_2, MAC_FX_2, DO_ENCODING, ENCODING_TO_PACKING_1, WRITE_OUTPUTS_MASKS_TO_MONITOR, WRITE_OUTPUTS_ENCODED_TO_MONITOR, WRITE_MASKS_2, WRITE_ACTIVATIONS_2} fsm_state;
  fsm_state current_state;
  fsm_state next_state;

  localparam X_NEW = (FEATURE_MAP_WIDTH-1)/16+1;
  localparam INPUT_NB_CHANNELS_NEW = (INPUT_NB_CHANNELS - 1)/16+1;

  localparam Y_GRANULARITY_ACTIVATIONS = X_NEW*INPUT_NB_CHANNELS;
  localparam Y_GRANULARITY_MASKS = 2*X_NEW*INPUT_NB_CHANNELS_NEW;
  localparam ACTIVATIONS_START_ADDRESS = 4*Y_GRANULARITY_ACTIVATIONS;
  localparam MASKS_START_ADDRESS = 4*Y_GRANULARITY_MASKS;
  localparam MAXIMUM_Y_ACTIVATIONS_TRANSFER_MASKS = 32*Y_GRANULARITY_MASKS; //(1 << ADDR_WIDTH_ACT) - 4*Y_GRANULARITY;
  localparam OUTPUT_START_ADDRESS_ACTIVATIONS = 0;
  localparam OUTPUT_START_ADDRESS_MASKS = 0; 


  logic [31:0] activations_index_table [0:32*2*X_NEW*INPUT_NB_CHANNELS_NEW-1];
  logic [31:0] current_index_activations_index_table;
  logic [ADDR_WIDTH_ACT-1:0] start_write_address_activations;
  logic [ADDR_WIDTH_MASKS-1:0] start_write_address_masks;
  logic [31:0] prev_activation_rows;
  initial begin
    for (int i=0; i<32*2*X_NEW*INPUT_NB_CHANNELS_NEW; i++) begin 
      activations_index_table[i] = 0;
    end 
    current_index_activations_index_table = 0;
    start_write_address_activations = ACTIVATIONS_START_ADDRESS;
    start_write_address_masks = MASKS_START_ADDRESS;
    prev_activation_rows = 0;
    end

  //mac valid

  logic mac_valid_internal;
  logic dummy_mac;
  assign mac_valid = dummy_mac? 0 : mac_valid_internal;
  
  //loop counters (see register.sv for macro)
  
  `REG(32, k_v);
  `REG(32, k_h);
  `REG(32, x);
  `REG(32, y);
  `REG(32, ch_in);
  `REG(32, ch_out);

  logic reset_k_v, reset_k_h, reset_x, reset_y, reset_ch_in, reset_ch_out;
  assign k_v_next = reset_k_v ? 0 : k_v + 1;
  assign k_h_next = reset_k_h ? 0 : k_h + 1;
  assign x_next = reset_x ? 0 : x + 1;
  assign y_next = reset_y ? 0 : y + 1;
  assign ch_in_next = reset_ch_in ? 0 : ch_in + 1;
  assign ch_out_next = reset_ch_out ? 0 : ch_out + 1;

  logic last_k_v, last_k_h, last_x, last_y, last_ch_in, last_ch_out;
  assign last_k_v = k_v == KERNEL_SIZE - 1;
  assign last_k_h = k_h == KERNEL_SIZE - 1;
  assign last_x = x == (FEATURE_MAP_WIDTH-1)/16;
  assign last_y = y == FEATURE_MAP_HEIGHT-1;
  assign last_ch_in = ch_in == INPUT_NB_CHANNELS - 1;
  assign last_ch_out = ch_out == (OUTPUT_NB_CHANNELS-1)/16;

  assign reset_k_v = last_k_v;
  assign reset_k_h = last_k_h;
  assign reset_x = last_x;
  assign reset_y = last_y;
  assign reset_ch_in = last_ch_in;
  assign reset_ch_out = last_ch_out;


  /*
  chosen loop order:

  for y
    for x
      for ch_out     
        for ch_in
          for k_v
            for k_h
              body
  */
  // ==>
  assign k_h_we    = mac_valid_internal; //each time a mac is done, k_h_we increments (or resets to 0 if last)
  assign k_v_we    = mac_valid_internal && last_k_h; //only if last of k_h loop
  assign ch_in_we  = mac_valid_internal && last_k_h && last_k_v; //only if last of all enclosed loops
  assign ch_out_we = mac_valid_internal && last_k_h && last_k_v && last_ch_in; //only if last of all enclosed loops
  assign x_we      = mac_valid_internal && last_k_h && last_k_v && last_ch_in && last_ch_out; //only if last of all enclosed loops
  assign y_we      = mac_valid_internal && last_k_h && last_k_v && last_ch_in && last_ch_out && last_x; //only if last of all enclosed loops

  logic last_overall;
  assign last_overall   = last_k_h && last_k_v && last_ch_out && last_ch_in && last_y && last_x;

  logic first_overall;
  assign first_overall   = (k_h == 0) && (k_v == 0) && (ch_out == 0) && (ch_in == 0) && (y == 0) && (x == 0);

  assign mac_accumulate_internal = ! ((ch_in == 0 && k_v == 0 && k_h == 0) || (y == 0 && ch_in == 0 && k_v == 1 && k_h == 0)); // second because of padding

  `REG(32, x_reg_for_encoder_internal);
  assign x_reg_for_encoder_internal_next = x;
  assign x_reg_for_encoder = x_reg_for_encoder_internal;

  //driver registers counters
  
  `REG(2, x_offset_counter);
  `REG(2, y_offset_counter);
  `REG(2, line_offset_counter);

  logic reset_x_offset_counter, reset_y_offset_counter, reset_line_offset_counter;
  assign x_offset_counter_next = reset_x_offset_counter ? 0 : x_offset_counter + 1;
  assign y_offset_counter_next = reset_y_offset_counter ? 0 : y_offset_counter + 1;
  assign line_offset_counter_next = reset_line_offset_counter ? 0 : line_offset_counter + 1;

  logic last_x_offset_counter, last_y_offset_counter, last_line_offset_counter;
  assign last_x_offset_counter = x_offset_counter == 1;
  assign last_y_offset_counter = y_offset_counter == 2;
  assign last_line_offset_counter = line_offset_counter == 1;

  assign reset_x_offset_counter = last_x_offset_counter;
  assign reset_y_offset_counter = last_y_offset_counter;
  assign reset_line_offset_counter = last_line_offset_counter;

  /*
  chosen loop order:

  for x_offset_counter
    for y_offset_counter
      for line_offset_counter    
  */

  logic reg_count_enable;
  assign line_offset_counter_we    = reg_count_enable; //each time a reg_count_enable is set
  assign y_offset_counter_we    = reg_count_enable && last_line_offset_counter; //only if last of k_h loop
  assign x_offset_counter_we    = reg_count_enable && last_line_offset_counter && last_y_offset_counter; //only if last of all enclosed loops

  `REG(2, x_offset_counter_delay);
  `REG(2, y_offset_counter_delay);
  `REG(2, line_offset_counter_delay);

  assign x_offset_counter_delay_we = 1;
  assign y_offset_counter_delay_we = 1;
  assign line_offset_counter_delay_we = 1;

  assign x_offset_counter_delay_next = x_offset_counter;
  assign y_offset_counter_delay_next = y_offset_counter;
  assign line_offset_counter_delay_next = line_offset_counter;


  // Weights address counter

  localparam MAX_WEIGHT_ADDRESS = KERNEL_SIZE*KERNEL_SIZE*INPUT_NB_CHANNELS*OUTPUT_NB_CHANNELS/16-1;
  
  logic [ADDR_WIDTH_WEIGHTS-1:0] address_weights_internal;
  logic CE_address_weights_internal;
  logic reset_address_weights_internal;

  always @(posedge clk)
  begin: ADDRESS_WEIGHTS_COUNTER
      if(reset_address_weights_internal) address_weights_internal <= 0;
      else begin
        if (CE_address_weights_internal) begin
          if (address_weights_internal == MAX_WEIGHT_ADDRESS)
            address_weights_internal <= 0;
          else 
            address_weights_internal <= address_weights_internal + 1;
          end
        else
          address_weights_internal <= address_weights_internal;
      end
  end

  assign address_weights = address_weights_internal;

  // Mask writing address counter

  localparam MAX_MASKS_ADDRESS = (1 << ADDR_WIDTH_MASKS) - 1;
  logic [32-1:0] address_masks_writing_internal;
  logic CE_address_masks_writing_internal;
  logic reset_address_masks_writing_internal;

  always @(posedge clk)
  begin: ADDRESS_MASKS_WRITING_COUNTER
      if(reset_address_masks_writing_internal) address_masks_writing_internal <= MASKS_START_ADDRESS;
      else begin
        if (CE_address_masks_writing_internal)
          address_masks_writing_internal <= address_masks_writing_internal + 1;
        else
          address_masks_writing_internal <= address_masks_writing_internal;
      end
  end

  assign CE_address_masks_writing = CE_address_masks_writing_internal;
  
  // Activations writing address counter

  localparam MAX_ACT_ADDRESS = (1 << ADDR_WIDTH_ACT) - 1;
  logic [ADDR_WIDTH_ACT-1:0] address_activations_writing_internal;
  logic CE_address_activations_writing_internal;
  logic reset_address_activations_writing_internal;

  always @(posedge clk)
  begin: ADDRESS_ACTIVATIONS_WRITING_COUNTER
      if(reset_address_activations_writing_internal) address_activations_writing_internal <= ACTIVATIONS_START_ADDRESS;
      else begin
        if (CE_address_activations_writing_internal) begin
          if (address_activations_writing_internal == MAX_ACT_ADDRESS) begin
            address_activations_writing_internal <= 0;
          end else 
            address_activations_writing_internal <= address_activations_writing_internal + 1;
          end
        else
          address_activations_writing_internal <= address_activations_writing_internal;
      end
  end

  // Encoder_to_packer_counter

  logic reset_encoder_to_packer_counter_internal;
  `REG(4, encoder_to_packer_counter_internal);
  assign encoder_to_packer_counter_internal_next = reset_encoder_to_packer_counter_internal? 0 : encoder_to_packer_counter_internal + 1;
  assign encoder_to_packer_counter = encoder_to_packer_counter_internal;

// Outputs masks to monitor counter

  logic [ADDR_WIDTH_ACT-1:0] outputs_masks_to_monitor_counter;
  logic CE_outputs_masks_to_monitor_counter;
  logic reset_outputs_masks_to_monitor_counter;

  always @(posedge clk)
  begin: OUTPUTS_MASKS_TO_MONITOR_COUNTER
      if(reset_outputs_masks_to_monitor_counter) outputs_masks_to_monitor_counter <= 0;
      else begin
        if (CE_outputs_masks_to_monitor_counter) begin
            outputs_masks_to_monitor_counter <= outputs_masks_to_monitor_counter + 1;
          end
        else
          outputs_masks_to_monitor_counter <= outputs_masks_to_monitor_counter;
      end
  end

  // Outputs encoded to monitor counter

  logic [ADDR_WIDTH_ACT-1:0] outputs_encoded_to_monitor_counter;
  logic CE_outputs_encoded_to_monitor_counter;
  logic reset_outputs_encoded_to_monitor_counter;

  always @(posedge clk)
  begin: OUTPUTS_ENCODED_TO_MONITOR_COUNTER
      if(reset_outputs_encoded_to_monitor_counter) outputs_encoded_to_monitor_counter <= 0;
      else begin
        if (CE_outputs_encoded_to_monitor_counter) begin
            outputs_encoded_to_monitor_counter <= outputs_encoded_to_monitor_counter + 1;
          end
        else
          outputs_encoded_to_monitor_counter <= outputs_encoded_to_monitor_counter;
      end
  end

  //mark outputs masks

  `REG(1, output_valid_masks_reg);
  assign output_valid_masks_reg_next = CE_outputs_masks_to_monitor_counter;
  assign output_valid_masks_reg_we   = 1;
  
  assign output_valid_masks = output_valid_masks_reg;

  //mark outputs encoded

  `REG(1, output_valid_encoded_reg);
  assign output_valid_encoded_reg_next = CE_outputs_encoded_to_monitor_counter;
  assign output_valid_encoded_reg_we   = 1;
  
  assign output_valid_encoded = output_valid_encoded_reg;

  localparam MAX_MASKS_FIRST = MAXIMUM_Y_ACTIVATIONS_TRANSFER_MASKS;
  localparam MAX_MASKS_AFTER = MAXIMUM_Y_ACTIVATIONS_TRANSFER_MASKS-2*Y_GRANULARITY_MASKS;

  // When writing, keep track of the first write address of that complete transfer of the activations
  
  logic record_start_write_address_activations; 
  always @(posedge clk)
  begin 
    if (record_start_write_address_activations) begin 
      start_write_address_activations <= address_activations_writing;
    end else begin 
      start_write_address_activations <= start_write_address_activations;
    end 
  end 

  // When writing, keep track of the first write address of that complete transfer of the masks
  
  logic record_start_write_address_masks; 
  always @(posedge clk)
  begin 
    if (record_start_write_address_masks) begin 
      start_write_address_masks <= address_masks_writing;
    end else begin 
      start_write_address_masks <= start_write_address_masks;
    end 
  end 

  // Store a mask table 
  
  always @(posedge clk) 
  begin 
    if (delayed_CE_address_masks_writing && (delayed_masks_transferred % 2 == 1)) begin
      current_index_activations_index_table <= current_index_activations_index_table + 1;
      activations_index_table[current_index_activations_index_table] <= activation_rows_total;
      prev_activation_rows <= activation_rows_total;
    end 
  end 

  // Masks reading address
  
  logic [31:0] address_masks_reading_internal;
  assign address_masks_reading_internal = MASKS_START_ADDRESS + (y+y_offset_counter-1)*2*X_NEW*INPUT_NB_CHANNELS_NEW + (x+x_offset_counter)*2*INPUT_NB_CHANNELS_NEW + (ch_in/16)*2 + line_offset_counter; // -1 for padding

  // Activations reading address
  
  logic [31:0] address_activations_reading_internal;
  logic [31:0] standard_offset;
  assign standard_offset = (((y+y_offset_counter-1) == 0) && ((x+x_offset_counter) == 0) && ((ch_in/16) == 0))? ACTIVATIONS_START_ADDRESS : ACTIVATIONS_START_ADDRESS + activations_index_table[(y+y_offset_counter-1)*X_NEW*INPUT_NB_CHANNELS_NEW + (x+x_offset_counter)*INPUT_NB_CHANNELS_NEW + (ch_in/16)-1]; //-1 for padding
  assign address_activations_reading_internal = standard_offset + line_offset_counter; 
    
  // flag to indicate that we need new activations into on-chip memory
  
  logic need_new_activations_after;
  assign need_new_activations_after = (activations_index_table[(y+2-1)*X_NEW*INPUT_NB_CHANNELS_NEW] < activations_index_table[(y-1)*X_NEW*INPUT_NB_CHANNELS_NEW] && k_v == 0 && ch_in == 0 && ch_out == 0 && x == 0 && y!=1 && !last_y); // -1 for padding
  
  // Masks addresses 
  
  assign address_masks_writing = address_masks_writing_internal[ADDR_WIDTH_MASKS-1:0];
  assign address_masks_reading = (current_state == WRITE_OUTPUTS_MASKS_TO_MONITOR)? outputs_masks_to_monitor_counter : address_masks_reading_internal[ADDR_WIDTH_MASKS-1:0];

  // Activations addresses 
  
  assign address_activations_writing = address_activations_writing_internal;
  assign address_activations_reading = (current_state == WRITE_OUTPUTS_ENCODED_TO_MONITOR)? outputs_encoded_to_monitor_counter : address_activations_reading_internal[ADDR_WIDTH_ACT-1:0];

  assign masks_transferred_to_memory = (address_masks_writing < start_write_address_masks)? address_masks_writing+MAX_MASKS_ADDRESS+1-start_write_address_masks : address_masks_writing-start_write_address_masks;

  // Determine the total amount of outputs masks still to be transferred to memory in one consecutive transfer
  
  logic [31:0] outputs_masks_to_still_transfer_to_monitor;
  assign outputs_masks_to_still_transfer_to_monitor = (outputs_masks_to_memory_counter < outputs_masks_to_monitor_counter)? outputs_masks_to_memory_counter+MAX_ACT_ADDRESS+1-outputs_masks_to_monitor_counter : outputs_masks_to_memory_counter-outputs_masks_to_monitor_counter;

  // Determine the total amount of output encoded data still to be transferred to memory in one consecutive transfer
  
  logic [31:0] outputs_encoded_to_still_transfer_to_monitor;
  assign outputs_encoded_to_still_transfer_to_monitor = (outputs_encoded_to_memory_counter < outputs_encoded_to_monitor_counter)? outputs_encoded_to_memory_counter+MAX_ACT_ADDRESS+1-outputs_encoded_to_monitor_counter : outputs_encoded_to_memory_counter-outputs_encoded_to_monitor_counter;
  
  //For driver

  assign start_address_encoded = (((y+k_v-1) == 0) && ((x+k_h) == 0) && ((ch_in/16) == 0))? ACTIVATIONS_START_ADDRESS : ACTIVATIONS_START_ADDRESS + activations_index_table[(y+k_v-1)*X_NEW*INPUT_NB_CHANNELS_NEW + (x+k_h)*INPUT_NB_CHANNELS_NEW + (ch_in/16)-1]; // -1 for padding
  assign fx = k_h;
  assign fy = k_v;

  // Dummy path in case of padding

  logic go_dummy_mac_path;
  logic go_dummy_mac_path_after_mac;

  logic go_dummy_mac_path_driver;
  logic go_dummy_mac_path_driver_delay;
  assign go_dummy_mac_path = (y == 0 && k_v == 0) || (last_y && k_v == 2); // because padding
  assign go_dummy_mac_path_after_mac = (y == 0 && k_v_next == 0) || (y == (FEATURE_MAP_HEIGHT-1) && k_v_next == 2);
  assign go_dummy_mac_path_driver = (y == 0 && y_offset_counter == 0) || (last_y && y_offset_counter == 2);
  assign go_dummy_mac_path_driver_delay = (y == 0 && y_offset_counter_delay == 0) || (last_y && y_offset_counter_delay == 2);

  // FINITE STATE MACHINE

  always @ (posedge clk or negedge arst_n_in) begin
    if(arst_n_in==0) begin
      current_state <= IDLE;
    end else begin
      current_state <= next_state;
    end
  end

  always_comb begin
    //defaults: applicable if not overwritten below
    next_state = current_state;
    mac_valid_internal = 0;
    running = 1;
    
    //weights
      //memory
    weights_ready = 0;
    write_weights_memory = 1;
    read_weights_memory = 1;

    CE_address_weights_internal = 0;
    reset_address_weights_internal = 0;
      //registers
    write_weights_registers = 0;

    //masks
    masks_ready = 0;
    write_masks_memory = 1;
    read_masks_memory = 1;

    CE_address_masks_writing_internal = 0;
    reset_address_masks_writing_internal = 0;
    //activations
      //memory
    activations_ready = 0;
    write_activations_memory = 1;
    read_activations_memory = 1;
    
    CE_address_activations_writing_internal = 0;
    reset_address_activations_writing_internal = 0;
    
    record_start_write_address_activations = 0;
    record_start_write_address_masks = 0;
      //registers
    write_activations_registers_first = 0;
    write_activations_registers_second = 0;

    // outputs 
  
    reset_outputs_encoded_to_monitor_counter = 0;
    reset_outputs_masks_to_monitor_counter = 0;
    CE_outputs_encoded_to_monitor_counter = 0;
    CE_outputs_masks_to_monitor_counter = 0;
    
    shift = 0;

    // driver 

    reg_count_enable = 0;

    start_driver = 0;
    reset_driver = 0;
    start_packer = 0;
    for (int l=0; l<2; l++) begin 
      for (int k=0; k<3; k++) begin 
        for (int j=0; j<2; j++) begin 
          write_masks_registers[l][k][j] = 0;
        end
      end
    end

    //decoder
    CE_decoder = 0;

    //encoder
    x_reg_for_encoder_internal_we = 0;
    CE_encoder = 0;
    reset_encoder_to_packer_counter_internal = 0;
    encoder_to_packer_counter_internal_we = 0;

    //Extra word logic 
    write_extra_word_in_register = 0;
    extra_word_from_FIFO = 0;

    extra_word_read_ready = 0;
    extra_word_write_valid = 0;
    
    // Padding logic
    dummy_mac = 0;
    zero_padding = 0;
    reset_fifo = 1;


    case (current_state)
      IDLE: begin
        running = 0;
        //weights
        reset_address_weights_internal = 1;
        //masks
        reset_address_masks_writing_internal = 1;
        //activations
        reset_address_activations_writing_internal = 1;
        //outputs
        reset_outputs_encoded_to_monitor_counter = 1;
        reset_outputs_masks_to_monitor_counter = 1;

        reset_encoder_to_packer_counter_internal = 1;
        encoder_to_packer_counter_internal_we = 1;
        next_state = start ? WRITE_WEIGHTS : IDLE;
      end
      WRITE_WEIGHTS: begin
        //weights
        weights_ready = 1;
        CE_address_weights_internal = weights_valid;
        write_weights_memory = ~weights_valid; 

        //activations
        record_start_write_address_masks = 1;
        next_state = weights_valid? (address_weights_internal == MAX_WEIGHT_ADDRESS ? WRITE_MASKS : WRITE_WEIGHTS) : WRITE_WEIGHTS;
      end

      WRITE_MASKS: begin 
        //masks
        masks_ready = 1;
        CE_address_masks_writing_internal = masks_valid;
        write_masks_memory = ~masks_valid;
        record_start_write_address_activations = 1;
        next_state = masks_valid? (((masks_transferred_to_memory == (MAX_MASKS_FIRST-1)) || ((address_masks_writing_internal - MASKS_START_ADDRESS) == (2*FEATURE_MAP_HEIGHT*X_NEW*INPUT_NB_CHANNELS_NEW-1)))? WRITE_ACTIVATIONS : WRITE_MASKS) : WRITE_MASKS;
      end
      
      WRITE_ACTIVATIONS: begin 
        //activations
        activations_ready = 1;
        CE_address_activations_writing_internal = activations_valid;
        write_activations_memory = ~activations_valid;
        next_state = activations_valid? (((address_activations_writing_internal-ACTIVATIONS_START_ADDRESS) == prev_activation_rows-1)? START_WRITE_ENC_MASK_REGISTERS: WRITE_ACTIVATIONS) : WRITE_ACTIVATIONS;
      end 
      START_WRITE_ENC_MASK_REGISTERS: begin  
        reg_count_enable = 1;
        //encoded
        read_activations_memory = go_dummy_mac_path_driver;
        //masks
        read_masks_memory = go_dummy_mac_path_driver;
        next_state = WRITE_ENC_MASK_REGISTERS;
      end
      WRITE_ENC_MASK_REGISTERS: begin
        reg_count_enable = 1;
        //encoded
        read_activations_memory = (x_offset_counter == 1 && last_x) || go_dummy_mac_path_driver;
        //masks
        read_masks_memory = (x_offset_counter == 1 && last_x) || go_dummy_mac_path_driver;
        write_masks_registers[x_offset_counter_delay][y_offset_counter_delay][line_offset_counter_delay] = 1;
        zero_padding = (x_offset_counter_delay == 1 && last_x) || go_dummy_mac_path_driver_delay;
        next_state = (last_x_offset_counter && last_y_offset_counter && last_line_offset_counter)? END_WRITE_ENC_MASK_REGISTERS : WRITE_ENC_MASK_REGISTERS;
      end
      END_WRITE_ENC_MASK_REGISTERS: begin 
        zero_padding = (x_offset_counter_delay == 1 && last_x) || go_dummy_mac_path_driver_delay; 
        write_masks_registers[x_offset_counter_delay][y_offset_counter_delay][line_offset_counter_delay] = 1;
        reset_driver = 1;
        next_state = go_dummy_mac_path? DUMMY_MAC_1 : DRIVE_TO_DECODING_1;
      end 

      DUMMY_MAC_1: begin 
        mac_valid_internal = 1;
        CE_address_weights_internal = 1;
        dummy_mac = 1;
        next_state = DUMMY_MAC_2;
      end
      DUMMY_MAC_2: begin 
        mac_valid_internal = 1;
        CE_address_weights_internal = 1;
        dummy_mac = 1;
        next_state = DUMMY_MAC_3;
      end
      
      DUMMY_MAC_3: begin 
        mac_valid_internal = 1;
        CE_address_weights_internal = 1;
        dummy_mac = 1;
        next_state = ((ch_in_next%16 == 0) && last_k_v)? (last_ch_in? DO_ENCODING : START_WRITE_ENC_MASK_REGISTERS) : DRIVE_TO_DECODING_1;
      end

      DRIVE_TO_DECODING_1: begin 
        start_driver = 1;
        CE_decoder = ready_driver;
        read_weights_memory = !ready_driver;
        CE_address_weights_internal = ready_driver;
        extra_word_read_ready = !(x == 0) && ready_driver;
        next_state = ready_driver? DO_DECODING_1 : DRIVE_TO_DECODING_1;
      end 
      DO_DECODING_1: begin
        //activations
        write_activations_registers_first = 1;
        write_extra_word_in_register = 1;
        extra_word_from_FIFO = !(x == 0);
        extra_word_write_valid = !(last_x);
        //weights
        write_weights_registers = 1; 
        next_state = MAC_FX_0_AND_SHIFT_FX_1;
      end
      MAC_FX_0_AND_SHIFT_FX_1: begin
        mac_valid_internal = 1;
        //activations
        write_activations_registers_first = 1;
        write_activations_registers_second = 1;
        shift = 1;
        next_state = DRIVE_TO_DECODING_2;
      end
      DRIVE_TO_DECODING_2: begin 
        start_driver = 1;
        CE_decoder = ready_driver;
        //weights
        read_weights_memory = !ready_driver;
        CE_address_weights_internal = ready_driver;
        next_state = ready_driver? DO_DECODING_2 : DRIVE_TO_DECODING_2;
      end 
      DO_DECODING_2: begin 
        //activations
        write_activations_registers_second = 1;
        //weights
        write_weights_registers = 1; 
        read_weights_memory = 0;
        CE_address_weights_internal = 1;
        next_state = MAC_FX_1_AND_FETCH_FX_2;   
      end 
      MAC_FX_1_AND_FETCH_FX_2: begin
        mac_valid_internal = 1;
        //activations
        shift = 1;
        write_activations_registers_first = 1;
        write_activations_registers_second = 1;
        //weights
        write_weights_registers = 1; 
        next_state = MAC_FX_2;
      end
      MAC_FX_2: begin
        mac_valid_internal = 1;
        x_reg_for_encoder_internal_we = 1;
        next_state = ((ch_in_next%16 == 0) && last_k_v)? (last_ch_in? DO_ENCODING : START_WRITE_ENC_MASK_REGISTERS) : (go_dummy_mac_path_after_mac? DUMMY_MAC_1 :  DRIVE_TO_DECODING_1);
      end
      DO_ENCODING: begin 
        CE_encoder = 1;
        start_packer = 1;
        reset_fifo = !(x == 0 && ch_in == 0 && ch_out == 0);
        encoder_to_packer_counter_internal_we = 1;
        next_state = ENCODING_TO_PACKING_1;
      end 
      ENCODING_TO_PACKING_1: begin
        next_state = ready_packer? ((encoder_to_packer_counter_internal%16 ==0)? ((first_overall || need_new_activations_after)? WRITE_OUTPUTS_MASKS_TO_MONITOR : START_WRITE_ENC_MASK_REGISTERS) : DO_ENCODING) : ENCODING_TO_PACKING_1;
      end 
      WRITE_OUTPUTS_MASKS_TO_MONITOR: begin 
        read_masks_memory = 0;
        CE_outputs_masks_to_monitor_counter = 1;
        next_state = (outputs_masks_to_still_transfer_to_monitor == 1)? WRITE_OUTPUTS_ENCODED_TO_MONITOR : WRITE_OUTPUTS_MASKS_TO_MONITOR;
      end 
      WRITE_OUTPUTS_ENCODED_TO_MONITOR: begin 
        read_activations_memory = 0;
        CE_outputs_encoded_to_monitor_counter = 1;
        record_start_write_address_masks = 1;
        next_state = (outputs_encoded_to_still_transfer_to_monitor == 1)? (first_overall? IDLE : WRITE_MASKS_2) : WRITE_OUTPUTS_ENCODED_TO_MONITOR;
      end 
      WRITE_MASKS_2: begin 
        //masks
        masks_ready = 1;
        CE_address_masks_writing_internal = masks_valid;
        write_masks_memory = ~masks_valid;
        record_start_write_address_activations = 1;
        next_state = masks_valid? (((masks_transferred_to_memory == (MAX_MASKS_AFTER-1)) || ((address_masks_writing_internal - MASKS_START_ADDRESS) == (2*FEATURE_MAP_HEIGHT*X_NEW*INPUT_NB_CHANNELS_NEW-1)))? WRITE_ACTIVATIONS_2 : WRITE_MASKS_2) : WRITE_MASKS_2;
      end
      WRITE_ACTIVATIONS_2: begin 
        //activations
        activations_ready = 1;
        CE_address_activations_writing_internal = activations_valid;
        write_activations_memory = ~activations_valid;
        next_state = activations_valid? (((address_activations_writing_internal-ACTIVATIONS_START_ADDRESS) == prev_activation_rows-1)? START_WRITE_ENC_MASK_REGISTERS : WRITE_ACTIVATIONS_2) : WRITE_ACTIVATIONS_2;
      end 
    endcase
  end
endmodule
