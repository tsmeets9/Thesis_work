module controller_fsm #(
  parameter int FEATURE_MAP_WIDTH = 56,
  parameter int FEATURE_MAP_HEIGHT = 56,
  parameter int INPUT_NB_CHANNELS = 64,
  parameter int OUTPUT_NB_CHANNELS = 64,
  parameter int KERNEL_SIZE = 3,
  parameter int MEM_BW = 128,
  parameter int ADDR_WIDTH_ACT = 14,
  parameter int ADDR_WIDTH_WEIGHTS = 12
  )
  (input logic clk,
  input logic arst_n_in, //asynchronous reset, active low

  input logic start,
  output logic running,

  //datapad control interface & external handshaking communication of activations and weights
  input logic activations_valid,
  input logic weights_valid,
  output logic weights_ready,
  output logic activations_ready,
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

  // Pytorch mapping
  output logic CE_pytorch_mapping,
  output logic [31:0] output_channel_for_pytorch_mapping,

  // Indicating output valid
  output logic output_valid, 
  output logic [3:0] outputs_transferred_to_memory,
  output logic outputs_to_memory_flag,

  // Extra word logic 
  output logic extra_word_write_valid,
  input logic extra_word_write_ready,
  input logic extra_word_read_valid,
  output logic extra_word_read_ready,
  output logic write_extra_word_in_register,
  output logic extra_word_from_FIFO,

  output logic end_x_padding,
  output logic reset_fifo
  );

  //// INITIALIZATION
  typedef enum {IDLE, WRITE_WEIGHTS, WRITE_ACTIVATIONS, LOAD_FX_0, DUMMY_MAC_1, DUMMY_MAC_2, DUMMY_MAC_3, FETCH_FX_0, MAC_FX_0_AND_SHIFT_FX_1, FETCH_FX_1_AND_LOAD_FX_2, MAC_FX_1_AND_FETCH_FX_2, SHIFT_FX_2, MAC_FX_2, PYTORCH_MAPPING, WRITE_OUTPUTS_TO_MEMORY, WRITE_OUTPUTS_TO_MONITOR, WRITE_ACTIVATIONS_2} fsm_state;
  fsm_state current_state;
  fsm_state next_state;

  localparam X_NEW = (FEATURE_MAP_WIDTH-1)/16+1;

  localparam Y_GRANULARITY = X_NEW*INPUT_NB_CHANNELS;
  localparam ACTIVATIONS_START_ADDRESS = 4*Y_GRANULARITY;
  localparam MAXIMUM_Y_ACTIVATIONS_TRANSFER = 32*Y_GRANULARITY; //(1 << ADDR_WIDTH_ACT) - 4*Y_GRANULARITY;

  localparam OUTPUT_START_ADDRESS = 0;

  logic [31:0] y_address [0:1][0:31];
  logic [31:0] current_y_address_index_writing;
  logic [ADDR_WIDTH_ACT-1] start_write_address;
  logic [31:0] prev_y_address;
  initial begin
    for (int i=0; i<2; i++) begin 
      for (int j=0; j<32; j++) begin 
        y_address[i][j] = 0;
      end
    end 
    current_y_address_index_writing = 0;
    start_write_address = ACTIVATIONS_START_ADDRESS;
    prev_y_address = ACTIVATIONS_START_ADDRESS;
  end

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

  assign mac_accumulate_internal = ! ((ch_in ==0 && k_v == 0 && k_h == 0) || (y == 0 && ch_in == 0 && k_v == 1 && k_h == 0)); // second because of padding

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

  // Activations internal writing address counter

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


// Outputs to memory counter

  logic [ADDR_WIDTH_ACT-1:0] outputs_to_memory_counter;
  logic CE_outputs_to_memory_counter;
  logic reset_outputs_to_memory_counter;

  always @(posedge clk)
  begin: OUTPUTS_TO_MEMORY_COUNTER
      if(reset_outputs_to_memory_counter) outputs_to_memory_counter <= 0;
      else begin
        if (CE_outputs_to_memory_counter) begin
            outputs_to_memory_counter <= outputs_to_memory_counter + 1;
          end
        else
          outputs_to_memory_counter <= outputs_to_memory_counter;
      end
  end

// Outputs to monitor counter

  logic [ADDR_WIDTH_ACT-1:0] outputs_to_monitor_counter;
  logic CE_outputs_to_monitor_counter;
  logic reset_outputs_to_monitor_counter;

  always @(posedge clk)
  begin: OUTPUTS_TO_MONITOR_COUNTER
      if(reset_outputs_to_monitor_counter) outputs_to_monitor_counter <= 0;
      else begin
        if (CE_outputs_to_monitor_counter) begin
            outputs_to_monitor_counter <= outputs_to_monitor_counter + 1;
          end
        else
          outputs_to_monitor_counter <= outputs_to_monitor_counter;
      end
  end

  //mark outputs

  `REG(1, output_valid_reg_1);
  assign output_valid_reg_1_next = CE_outputs_to_monitor_counter;
  assign output_valid_reg_1_we   = 1;
  
  assign output_valid = output_valid_reg_1;

  localparam MAX_ACTIVATIONS_FIRST = MAXIMUM_Y_ACTIVATIONS_TRANSFER;
  localparam MAX_ACTIVATIONS_AFTER = MAXIMUM_Y_ACTIVATIONS_TRANSFER-2*Y_GRANULARITY;

  // When writing, keep track of the first write address of that complete transfer

  logic record_start_write_address; 
  always @(posedge clk)
  begin 
    if (record_start_write_address) begin 
      start_write_address <= (current_state == WRITE_WEIGHTS)? address_activations_writing : outputs_to_memory_counter;
    end else begin 
      start_write_address <= start_write_address;
    end 
  end 


  //// Bookkeeping for y
  // y offset gives the write offset within a transfer corresponding to the first transfer corresponding to that y

  logic [31:0] y_offset; 
  assign y_offset = (address_activations_writing < prev_y_address) ? (address_activations_writing+MAX_ACT_ADDRESS+1-prev_y_address) : (address_activations_writing-prev_y_address);

  // Store a y address index table

  always @(posedge clk) 
  begin 
    if (CE_address_activations_writing_internal && ((y_offset == 0) || (y_offset == Y_GRANULARITY))) begin
      current_y_address_index_writing <= current_y_address_index_writing + 1;
      y_address[0][current_y_address_index_writing%32] <= current_y_address_index_writing;
      y_address[1][current_y_address_index_writing%32] <= address_activations_writing_internal;
      prev_y_address <= address_activations_writing_internal;
    end 
  end 

  // Activations internal reading address

  logic [31:0] address_activations_reading_internal;
  logic [31:0] y_address_offset;
  assign y_address_offset = y_address[1][(y+k_v-1)%32]; // -1 because padding
  assign address_activations_reading_internal = y_address_offset + INPUT_NB_CHANNELS*(x+k_h) + ch_in; 

  // flag to indicate that we need new activations into on-chip memory

  logic need_new_activations_after;
  assign need_new_activations_after = (y_address[0][(y+2 -1)%32] != (y_address[0][(y-1)%32]+2) && k_v == 0 && ch_in == 0 && ch_out == 0 && x == 0 && y!=1 && !last_y); // -1 for padding
  
  // Activations addresses
  assign address_activations_writing = (current_state == WRITE_OUTPUTS_TO_MEMORY)? outputs_to_memory_counter: address_activations_writing_internal;
  assign address_activations_reading = (current_state == WRITE_OUTPUTS_TO_MONITOR)? outputs_to_monitor_counter : address_activations_reading_internal[ADDR_WIDTH_ACT-1:0];

  // Determine the total amount of activations transferred to memory in one consecutive transfer
  logic [31:0] activations_transferred_to_memory;
  assign activations_transferred_to_memory = (address_activations_writing < start_write_address)? address_activations_writing+MAX_ACT_ADDRESS+1-start_write_address : address_activations_writing-start_write_address;
  
  // Determine the total amount of outputs transferred to memory in one consecutive transfer
  logic [31:0] outputs_transferred_to_memory_internal;
  assign outputs_transferred_to_memory_internal = (outputs_to_memory_counter < start_write_address)? outputs_to_memory_counter+MAX_ACT_ADDRESS+1-start_write_address : outputs_to_memory_counter-start_write_address;
  assign outputs_transferred_to_memory = outputs_transferred_to_memory_internal;

  // Determine the total amount of outputs still to be transferred to memory in one consecutive transfer
  logic [31:0] outputs_to_still_transfer_to_monitor;
  assign outputs_to_still_transfer_to_monitor = (outputs_to_memory_counter < outputs_to_monitor_counter)? outputs_to_memory_counter+MAX_ACT_ADDRESS+1-outputs_to_monitor_counter : outputs_to_memory_counter-outputs_to_monitor_counter;
  
  // Flag to indicate that outputs are transferred to memory 
  assign outputs_to_memory_flag = CE_outputs_to_memory_counter;

  // Dummy path in case of padding
  logic go_dummy_mac_path;
  logic go_dummy_mac_path_after_mac;
  assign go_dummy_mac_path = (y == 0 && k_v == 0) || (last_y && k_v == 2); // because padding
  assign go_dummy_mac_path_after_mac = (y == 0 && k_v_next == 0) || (y == (FEATURE_MAP_HEIGHT-1) && k_v_next == 2);

  // Determine output channel for the pytorch mapping
  logic track_ch_out;
  `REG(32, ch_out_delay_for_pytorch_mapping);
  assign ch_out_delay_for_pytorch_mapping_next = ch_out;
  assign ch_out_delay_for_pytorch_mapping_we   = track_ch_out;
  assign output_channel_for_pytorch_mapping = 16*ch_out_delay_for_pytorch_mapping + outputs_transferred_to_memory;
  // FINITE STATE MACHINE

  always @ (posedge clk or negedge arst_n_in) begin
    if(arst_n_in==0) begin
      current_state <= IDLE;
    end else begin
      current_state <= next_state;
    end
  end

  always_comb begin

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

    //activations
      //memory
    activations_ready = 0;
    write_activations_memory = 1;
    read_activations_memory = 1;
    
    CE_address_activations_writing_internal = 0;
    reset_address_activations_writing_internal = 0;
    
    record_start_write_address = 0;
      //registers
    write_activations_registers_first = 0;
    write_activations_registers_second = 0;

    CE_pytorch_mapping = 0;
    track_ch_out = 0;
    // outputs 

    reset_outputs_to_memory_counter = 0;
    CE_outputs_to_memory_counter = 0; 
  
    reset_outputs_to_monitor_counter = 0;
    CE_outputs_to_monitor_counter = 0;
    
    shift = 0;

    // Extra word logic 

    write_extra_word_in_register = 0;
    extra_word_from_FIFO = 0;

    extra_word_read_ready = 0;
    extra_word_write_valid = 0;

    // Padding logic
    dummy_mac = 0;
    end_x_padding = 0;
    reset_fifo = 1;

    case (current_state)
      IDLE: begin
        running = 0;
        //weights
        reset_address_weights_internal = 1;
        //activations
        reset_address_activations_writing_internal = 1;
        //outputs
        reset_outputs_to_memory_counter = 1;
        reset_outputs_to_monitor_counter = 1;

        next_state = start ? WRITE_WEIGHTS : IDLE;
      end
      WRITE_WEIGHTS: begin
        //weights
        weights_ready = 1;
        CE_address_weights_internal = weights_valid;
        write_weights_memory = ~weights_valid; 

        //activations
        record_start_write_address = 1;

        next_state = weights_valid? (address_weights_internal == MAX_WEIGHT_ADDRESS ? WRITE_ACTIVATIONS : WRITE_WEIGHTS) : WRITE_WEIGHTS;
      end

      WRITE_ACTIVATIONS: begin 
        //activations
        activations_ready = 1;
        CE_address_activations_writing_internal = activations_valid;
        write_activations_memory = ~activations_valid;

        next_state = activations_valid? (((activations_transferred_to_memory == (MAX_ACTIVATIONS_FIRST-1)) || ((current_y_address_index_writing == FEATURE_MAP_HEIGHT) && (y_offset == (Y_GRANULARITY-1))))? (go_dummy_mac_path? DUMMY_MAC_1 : LOAD_FX_0) : WRITE_ACTIVATIONS) : WRITE_ACTIVATIONS;
      end 
      LOAD_FX_0: begin  
        //weights
        read_weights_memory = 0;
        CE_address_weights_internal = 1;
        //activations
        read_activations_memory = 0;
        extra_word_read_ready = !(x == 0);
        next_state = FETCH_FX_0;
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
        track_ch_out = 1;
        next_state = (last_ch_in && last_k_v)? PYTORCH_MAPPING : LOAD_FX_0;
      end
      FETCH_FX_0: begin
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
        //activations
        write_activations_registers_first = 1;
        write_activations_registers_second = 1;
        shift = 1;
        //weights
        read_weights_memory = 0;
        CE_address_weights_internal = 1;    
        
        mac_valid_internal = 1;

        next_state = FETCH_FX_1_AND_LOAD_FX_2;
      end
      FETCH_FX_1_AND_LOAD_FX_2: begin
        //weights
        read_weights_memory = 0;
        CE_address_weights_internal = 1;
        write_weights_registers = 1; 
        //activations
        read_activations_memory = last_x;
        
        next_state = MAC_FX_1_AND_FETCH_FX_2;

      end
      MAC_FX_1_AND_FETCH_FX_2: begin
        mac_valid_internal = 1;
        //activations
        end_x_padding = last_x;
        write_activations_registers_second = 1;
        //weights
        write_weights_registers = 1; 
        
        next_state = SHIFT_FX_2;
      end
      SHIFT_FX_2: begin 
        shift = 1;
        //activations
        write_activations_registers_first = 1;
        write_activations_registers_second = 1;
        
        next_state = MAC_FX_2;
      end
      MAC_FX_2: begin
        mac_valid_internal = 1;
        record_start_write_address = 1;
        track_ch_out = 1;
        next_state = (last_ch_in && last_k_v)? PYTORCH_MAPPING : (go_dummy_mac_path_after_mac? DUMMY_MAC_1 : LOAD_FX_0);
      end
      PYTORCH_MAPPING: begin
        CE_pytorch_mapping = 1;
        next_state = WRITE_OUTPUTS_TO_MEMORY;
      end
      WRITE_OUTPUTS_TO_MEMORY: begin 
        CE_outputs_to_memory_counter = 1;
        write_activations_memory = 0;
        reset_fifo = !(x == 0 && ch_in == 0 && ch_out == 0);
        next_state = (outputs_transferred_to_memory == 15) ? ((first_overall || need_new_activations_after)? WRITE_OUTPUTS_TO_MONITOR : (go_dummy_mac_path? DUMMY_MAC_1 : LOAD_FX_0)): PYTORCH_MAPPING;
      end 

      WRITE_OUTPUTS_TO_MONITOR: begin 
        read_activations_memory = 0;
        CE_outputs_to_monitor_counter = 1;
        record_start_write_address = 1;
        next_state = (outputs_to_still_transfer_to_monitor == 1)? (first_overall? IDLE : WRITE_ACTIVATIONS_2) : WRITE_OUTPUTS_TO_MONITOR;
      end 
      WRITE_ACTIVATIONS_2: begin 
        //activations
        activations_ready = 1;
        CE_address_activations_writing_internal = activations_valid;
        write_activations_memory = ~activations_valid;
        
        next_state = activations_valid? (((activations_transferred_to_memory == (MAX_ACTIVATIONS_AFTER-1)) || ((current_y_address_index_writing == FEATURE_MAP_HEIGHT) && (y_offset == (Y_GRANULARITY-1))))? (go_dummy_mac_path? DUMMY_MAC_1 : LOAD_FX_0) : WRITE_ACTIVATIONS_2) : WRITE_ACTIVATIONS_2;
      end 
    endcase
  end

  
  //ENERGY ESTIMATION:
  // WRITING
  always @ (posedge clk) begin
    if(!(current_state == WRITE_OUTPUTS_TO_MEMORY) && !write_activations_memory) begin
      tbench_top.energy_activations_data_input_on_chip_writing += 1;
    end
  end

  always @ (posedge clk) begin
    if(!write_weights_memory) begin
      tbench_top.energy_weights_on_chip_writing += 1;
    end
  end

  always @ (posedge clk) begin
    if((current_state == WRITE_OUTPUTS_TO_MEMORY) && !write_activations_memory) begin 
      tbench_top.energy_activations_data_output_on_chip_writing += 1;
    end
  end

  always @ (posedge clk) begin
    if(extra_word_write_valid && extra_word_write_ready) begin 
      tbench_top.energy_fifo_writing += 1;
    end
  end

  // READING
  always @ (posedge clk) begin
    if(!(current_state == WRITE_OUTPUTS_TO_MONITOR) && !read_activations_memory) begin
      tbench_top.energy_activations_data_input_on_chip_reading += 1;
    end
  end

  always @ (posedge clk) begin
    if(!read_weights_memory) begin
      tbench_top.energy_weights_on_chip_reading += 1;
    end
  end

  always @ (posedge clk) begin
    if((current_state == WRITE_OUTPUTS_TO_MONITOR) && !read_activations_memory) begin 
      tbench_top.energy_activations_data_output_on_chip_reading += 1;
    end
  end

  always @ (posedge clk) begin
    if(extra_word_read_valid && extra_word_read_ready) begin 
      tbench_top.energy_fifo_reading += 1;
    end
  end

endmodule
