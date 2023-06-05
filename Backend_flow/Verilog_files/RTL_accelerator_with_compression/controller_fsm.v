module controller_fsm (
	clk,
	arst_n_in,
	start,
	running,
	activations_valid,
	weights_valid,
	masks_valid,
	weights_ready,
	activations_ready,
	masks_ready,
	write_activations_registers_first,
	write_activations_registers_second,
	shift,
	write_weights_registers,
	mac_valid,
	mac_accumulate_internal,
	write_weights_memory,
	read_weights_memory,
	address_weights,
	write_activations_memory,
	read_activations_memory,
	address_activations_writing,
	address_activations_reading,
	write_masks_memory,
	read_masks_memory,
	address_masks_writing,
	address_masks_reading,
	CE_address_masks_writing,
	masks_transferred_to_memory,
	activation_rows_total,
	delayed_CE_address_masks_writing,
	delayed_masks_transferred,
	output_valid_encoded,
	output_valid_masks,
	ready_driver,
	write_masks_registers,
	start_driver,
	reset_driver,
	fx,
	fy,
	start_address_encoded,
	CE_decoder,
	x_reg_for_encoder,
	CE_encoder,
	ready_packer,
	start_packer,
	encoder_to_packer_counter,
	outputs_encoded_to_memory_counter,
	outputs_masks_to_memory_counter,
	extra_word_write_valid,
	extra_word_write_ready,
	extra_word_read_valid,
	extra_word_read_ready,
	write_extra_word_in_register,
	extra_word_from_FIFO,
	zero_padding,
	reset_fifo
);
	parameter signed [31:0] FEATURE_MAP_WIDTH = 56;
	parameter signed [31:0] FEATURE_MAP_HEIGHT = 56;
	parameter signed [31:0] INPUT_NB_CHANNELS = 64;
	parameter signed [31:0] OUTPUT_NB_CHANNELS = 64;
	parameter signed [31:0] KERNEL_SIZE = 3;
	parameter signed [31:0] MEM_BW = 128;
	parameter signed [31:0] ADDR_WIDTH_ACT = 14;
	parameter signed [31:0] ADDR_WIDTH_MASKS = 11;
	parameter signed [31:0] ADDR_WIDTH_WEIGHTS = 12;
	input wire clk;
	input wire arst_n_in;
	input wire start;
	output reg running;
	input wire activations_valid;
	input wire weights_valid;
	input wire masks_valid;
	output reg weights_ready;
	output reg activations_ready;
	output reg masks_ready;
	output reg write_activations_registers_first;
	output reg write_activations_registers_second;
	output reg shift;
	output reg write_weights_registers;
	output wire mac_valid;
	output wire mac_accumulate_internal;
	output reg write_weights_memory;
	output reg read_weights_memory;
	output wire [ADDR_WIDTH_WEIGHTS - 1:0] address_weights;
	output reg write_activations_memory;
	output reg read_activations_memory;
	output wire [ADDR_WIDTH_ACT - 1:0] address_activations_writing;
	output wire [ADDR_WIDTH_ACT - 1:0] address_activations_reading;
	output reg write_masks_memory;
	output reg read_masks_memory;
	output wire [ADDR_WIDTH_MASKS - 1:0] address_masks_writing;
	output wire [ADDR_WIDTH_MASKS - 1:0] address_masks_reading;
	output wire CE_address_masks_writing;
	output wire [31:0] masks_transferred_to_memory;
	input wire [31:0] activation_rows_total;
	input wire delayed_CE_address_masks_writing;
	input wire [ADDR_WIDTH_MASKS - 1:0] delayed_masks_transferred;
	output wire output_valid_encoded;
	output wire output_valid_masks;
	input wire ready_driver;
	output reg [11:0] write_masks_registers;
	output reg start_driver;
	output reg reset_driver;
	output wire [1:0] fx;
	output wire [1:0] fy;
	output wire [31:0] start_address_encoded;
	output reg CE_decoder;
	output wire [31:0] x_reg_for_encoder;
	output reg CE_encoder;
	input wire ready_packer;
	output reg start_packer;
	output wire [3:0] encoder_to_packer_counter;
	input wire [ADDR_WIDTH_ACT - 1:0] outputs_encoded_to_memory_counter;
	input wire [ADDR_WIDTH_MASKS - 1:0] outputs_masks_to_memory_counter;
	output reg extra_word_write_valid;
	input wire extra_word_write_ready;
	input wire extra_word_read_valid;
	output reg extra_word_read_ready;
	output reg write_extra_word_in_register;
	output reg extra_word_from_FIFO;
	output reg zero_padding;
	output reg reset_fifo;
	reg [31:0] current_state;
	reg [31:0] next_state;
	localparam X_NEW = ((FEATURE_MAP_WIDTH - 1) / 16) + 1;
	localparam INPUT_NB_CHANNELS_NEW = ((INPUT_NB_CHANNELS - 1) / 16) + 1;
	localparam Y_GRANULARITY_ACTIVATIONS = X_NEW * INPUT_NB_CHANNELS;
	localparam Y_GRANULARITY_MASKS = (2 * X_NEW) * INPUT_NB_CHANNELS_NEW;
	localparam ACTIVATIONS_START_ADDRESS = 4 * Y_GRANULARITY_ACTIVATIONS;
	localparam MASKS_START_ADDRESS = 4 * Y_GRANULARITY_MASKS;
	localparam MAXIMUM_Y_ACTIVATIONS_TRANSFER_MASKS = 32 * Y_GRANULARITY_MASKS;
	localparam OUTPUT_START_ADDRESS_ACTIVATIONS = 0;
	localparam OUTPUT_START_ADDRESS_MASKS = 0;
	reg [31:0] activations_index_table [0:((64 * X_NEW) * INPUT_NB_CHANNELS_NEW) - 1];
	reg [31:0] current_index_activations_index_table;
	reg [ADDR_WIDTH_ACT - 1:0] start_write_address_activations;
	reg [ADDR_WIDTH_MASKS - 1:0] start_write_address_masks;
	reg [31:0] prev_activation_rows;
	initial begin
		begin : sv2v_autoblock_1
			reg signed [31:0] i;
			for (i = 0; i < ((64 * X_NEW) * INPUT_NB_CHANNELS_NEW); i = i + 1)
				activations_index_table[i] = 0;
		end
		current_index_activations_index_table = 0;
		start_write_address_activations = ACTIVATIONS_START_ADDRESS;
		start_write_address_masks = MASKS_START_ADDRESS;
		prev_activation_rows = 0;
	end
	reg mac_valid_internal;
	reg dummy_mac;
	assign mac_valid = (dummy_mac ? 0 : mac_valid_internal);
	wire [31:0] k_v_next;
	wire [31:0] k_v;
	wire k_v_we;
	register #(.WIDTH(32)) k_v_r(
		.clk(clk),
		.arst_n_in(arst_n_in),
		.din(k_v_next),
		.qout(k_v),
		.we(k_v_we)
	);
	wire [31:0] k_h_next;
	wire [31:0] k_h;
	wire k_h_we;
	register #(.WIDTH(32)) k_h_r(
		.clk(clk),
		.arst_n_in(arst_n_in),
		.din(k_h_next),
		.qout(k_h),
		.we(k_h_we)
	);
	wire [31:0] x_next;
	wire [31:0] x;
	wire x_we;
	register #(.WIDTH(32)) x_r(
		.clk(clk),
		.arst_n_in(arst_n_in),
		.din(x_next),
		.qout(x),
		.we(x_we)
	);
	wire [31:0] y_next;
	wire [31:0] y;
	wire y_we;
	register #(.WIDTH(32)) y_r(
		.clk(clk),
		.arst_n_in(arst_n_in),
		.din(y_next),
		.qout(y),
		.we(y_we)
	);
	wire [31:0] ch_in_next;
	wire [31:0] ch_in;
	wire ch_in_we;
	register #(.WIDTH(32)) ch_in_r(
		.clk(clk),
		.arst_n_in(arst_n_in),
		.din(ch_in_next),
		.qout(ch_in),
		.we(ch_in_we)
	);
	wire [31:0] ch_out_next;
	wire [31:0] ch_out;
	wire ch_out_we;
	register #(.WIDTH(32)) ch_out_r(
		.clk(clk),
		.arst_n_in(arst_n_in),
		.din(ch_out_next),
		.qout(ch_out),
		.we(ch_out_we)
	);
	wire reset_k_v;
	wire reset_k_h;
	wire reset_x;
	wire reset_y;
	wire reset_ch_in;
	wire reset_ch_out;
	assign k_v_next = (reset_k_v ? 0 : k_v + 1);
	assign k_h_next = (reset_k_h ? 0 : k_h + 1);
	assign x_next = (reset_x ? 0 : x + 1);
	assign y_next = (reset_y ? 0 : y + 1);
	assign ch_in_next = (reset_ch_in ? 0 : ch_in + 1);
	assign ch_out_next = (reset_ch_out ? 0 : ch_out + 1);
	wire last_k_v;
	wire last_k_h;
	wire last_x;
	wire last_y;
	wire last_ch_in;
	wire last_ch_out;
	assign last_k_v = k_v == (KERNEL_SIZE - 1);
	assign last_k_h = k_h == (KERNEL_SIZE - 1);
	assign last_x = x == ((FEATURE_MAP_WIDTH - 1) / 16);
	assign last_y = y == (FEATURE_MAP_HEIGHT - 1);
	assign last_ch_in = ch_in == (INPUT_NB_CHANNELS - 1);
	assign last_ch_out = ch_out == ((OUTPUT_NB_CHANNELS - 1) / 16);
	assign reset_k_v = last_k_v;
	assign reset_k_h = last_k_h;
	assign reset_x = last_x;
	assign reset_y = last_y;
	assign reset_ch_in = last_ch_in;
	assign reset_ch_out = last_ch_out;
	assign k_h_we = mac_valid_internal;
	assign k_v_we = mac_valid_internal && last_k_h;
	assign ch_in_we = (mac_valid_internal && last_k_h) && last_k_v;
	assign ch_out_we = ((mac_valid_internal && last_k_h) && last_k_v) && last_ch_in;
	assign x_we = (((mac_valid_internal && last_k_h) && last_k_v) && last_ch_in) && last_ch_out;
	assign y_we = ((((mac_valid_internal && last_k_h) && last_k_v) && last_ch_in) && last_ch_out) && last_x;
	wire last_overall;
	assign last_overall = ((((last_k_h && last_k_v) && last_ch_out) && last_ch_in) && last_y) && last_x;
	wire first_overall;
	assign first_overall = (((((k_h == 0) && (k_v == 0)) && (ch_out == 0)) && (ch_in == 0)) && (y == 0)) && (x == 0);
	assign mac_accumulate_internal = !((((ch_in == 0) && (k_v == 0)) && (k_h == 0)) || ((((y == 0) && (ch_in == 0)) && (k_v == 1)) && (k_h == 0)));
	wire [31:0] x_reg_for_encoder_internal_next;
	wire [31:0] x_reg_for_encoder_internal;
	reg x_reg_for_encoder_internal_we;
	register #(.WIDTH(32)) x_reg_for_encoder_internal_r(
		.clk(clk),
		.arst_n_in(arst_n_in),
		.din(x_reg_for_encoder_internal_next),
		.qout(x_reg_for_encoder_internal),
		.we(x_reg_for_encoder_internal_we)
	);
	assign x_reg_for_encoder_internal_next = x;
	assign x_reg_for_encoder = x_reg_for_encoder_internal;
	wire [1:0] x_offset_counter_next;
	wire [1:0] x_offset_counter;
	wire x_offset_counter_we;
	register #(.WIDTH(2)) x_offset_counter_r(
		.clk(clk),
		.arst_n_in(arst_n_in),
		.din(x_offset_counter_next),
		.qout(x_offset_counter),
		.we(x_offset_counter_we)
	);
	wire [1:0] y_offset_counter_next;
	wire [1:0] y_offset_counter;
	wire y_offset_counter_we;
	register #(.WIDTH(2)) y_offset_counter_r(
		.clk(clk),
		.arst_n_in(arst_n_in),
		.din(y_offset_counter_next),
		.qout(y_offset_counter),
		.we(y_offset_counter_we)
	);
	wire [1:0] line_offset_counter_next;
	wire [1:0] line_offset_counter;
	wire line_offset_counter_we;
	register #(.WIDTH(2)) line_offset_counter_r(
		.clk(clk),
		.arst_n_in(arst_n_in),
		.din(line_offset_counter_next),
		.qout(line_offset_counter),
		.we(line_offset_counter_we)
	);
	wire reset_x_offset_counter;
	wire reset_y_offset_counter;
	wire reset_line_offset_counter;
	assign x_offset_counter_next = (reset_x_offset_counter ? 0 : x_offset_counter + 1);
	assign y_offset_counter_next = (reset_y_offset_counter ? 0 : y_offset_counter + 1);
	assign line_offset_counter_next = (reset_line_offset_counter ? 0 : line_offset_counter + 1);
	wire last_x_offset_counter;
	wire last_y_offset_counter;
	wire last_line_offset_counter;
	assign last_x_offset_counter = x_offset_counter == 1;
	assign last_y_offset_counter = y_offset_counter == 2;
	assign last_line_offset_counter = line_offset_counter == 1;
	assign reset_x_offset_counter = last_x_offset_counter;
	assign reset_y_offset_counter = last_y_offset_counter;
	assign reset_line_offset_counter = last_line_offset_counter;
	reg reg_count_enable;
	assign line_offset_counter_we = reg_count_enable;
	assign y_offset_counter_we = reg_count_enable && last_line_offset_counter;
	assign x_offset_counter_we = (reg_count_enable && last_line_offset_counter) && last_y_offset_counter;
	wire [1:0] x_offset_counter_delay_next;
	wire [1:0] x_offset_counter_delay;
	wire x_offset_counter_delay_we;
	register #(.WIDTH(2)) x_offset_counter_delay_r(
		.clk(clk),
		.arst_n_in(arst_n_in),
		.din(x_offset_counter_delay_next),
		.qout(x_offset_counter_delay),
		.we(x_offset_counter_delay_we)
	);
	wire [1:0] y_offset_counter_delay_next;
	wire [1:0] y_offset_counter_delay;
	wire y_offset_counter_delay_we;
	register #(.WIDTH(2)) y_offset_counter_delay_r(
		.clk(clk),
		.arst_n_in(arst_n_in),
		.din(y_offset_counter_delay_next),
		.qout(y_offset_counter_delay),
		.we(y_offset_counter_delay_we)
	);
	wire [1:0] line_offset_counter_delay_next;
	wire [1:0] line_offset_counter_delay;
	wire line_offset_counter_delay_we;
	register #(.WIDTH(2)) line_offset_counter_delay_r(
		.clk(clk),
		.arst_n_in(arst_n_in),
		.din(line_offset_counter_delay_next),
		.qout(line_offset_counter_delay),
		.we(line_offset_counter_delay_we)
	);
	assign x_offset_counter_delay_we = 1;
	assign y_offset_counter_delay_we = 1;
	assign line_offset_counter_delay_we = 1;
	assign x_offset_counter_delay_next = x_offset_counter;
	assign y_offset_counter_delay_next = y_offset_counter;
	assign line_offset_counter_delay_next = line_offset_counter;
	localparam MAX_WEIGHT_ADDRESS = ((((KERNEL_SIZE * KERNEL_SIZE) * INPUT_NB_CHANNELS) * OUTPUT_NB_CHANNELS) / 16) - 1;
	reg [ADDR_WIDTH_WEIGHTS - 1:0] address_weights_internal;
	reg CE_address_weights_internal;
	reg reset_address_weights_internal;
	always @(posedge clk) begin : ADDRESS_WEIGHTS_COUNTER
		if (reset_address_weights_internal)
			address_weights_internal <= 0;
		else if (CE_address_weights_internal) begin
			if (address_weights_internal == MAX_WEIGHT_ADDRESS)
				address_weights_internal <= 0;
			else
				address_weights_internal <= address_weights_internal + 1;
		end
		else
			address_weights_internal <= address_weights_internal;
	end
	assign address_weights = address_weights_internal;
	localparam MAX_MASKS_ADDRESS = (1 << ADDR_WIDTH_MASKS) - 1;
	reg [31:0] address_masks_writing_internal;
	reg CE_address_masks_writing_internal;
	reg reset_address_masks_writing_internal;
	always @(posedge clk) begin : ADDRESS_MASKS_WRITING_COUNTER
		if (reset_address_masks_writing_internal)
			address_masks_writing_internal <= MASKS_START_ADDRESS;
		else if (CE_address_masks_writing_internal)
			address_masks_writing_internal <= address_masks_writing_internal + 1;
		else
			address_masks_writing_internal <= address_masks_writing_internal;
	end
	assign CE_address_masks_writing = CE_address_masks_writing_internal;
	localparam MAX_ACT_ADDRESS = (1 << ADDR_WIDTH_ACT) - 1;
	reg [ADDR_WIDTH_ACT - 1:0] address_activations_writing_internal;
	reg CE_address_activations_writing_internal;
	reg reset_address_activations_writing_internal;
	always @(posedge clk) begin : ADDRESS_ACTIVATIONS_WRITING_COUNTER
		if (reset_address_activations_writing_internal)
			address_activations_writing_internal <= ACTIVATIONS_START_ADDRESS;
		else if (CE_address_activations_writing_internal) begin
			if (address_activations_writing_internal == MAX_ACT_ADDRESS)
				address_activations_writing_internal <= 0;
			else
				address_activations_writing_internal <= address_activations_writing_internal + 1;
		end
		else
			address_activations_writing_internal <= address_activations_writing_internal;
	end
	reg reset_encoder_to_packer_counter_internal;
	wire [3:0] encoder_to_packer_counter_internal_next;
	wire [3:0] encoder_to_packer_counter_internal;
	reg encoder_to_packer_counter_internal_we;
	register #(.WIDTH(4)) encoder_to_packer_counter_internal_r(
		.clk(clk),
		.arst_n_in(arst_n_in),
		.din(encoder_to_packer_counter_internal_next),
		.qout(encoder_to_packer_counter_internal),
		.we(encoder_to_packer_counter_internal_we)
	);
	assign encoder_to_packer_counter_internal_next = (reset_encoder_to_packer_counter_internal ? 0 : encoder_to_packer_counter_internal + 1);
	assign encoder_to_packer_counter = encoder_to_packer_counter_internal;
	reg [ADDR_WIDTH_ACT - 1:0] outputs_masks_to_monitor_counter;
	reg CE_outputs_masks_to_monitor_counter;
	reg reset_outputs_masks_to_monitor_counter;
	always @(posedge clk) begin : OUTPUTS_MASKS_TO_MONITOR_COUNTER
		if (reset_outputs_masks_to_monitor_counter)
			outputs_masks_to_monitor_counter <= 0;
		else if (CE_outputs_masks_to_monitor_counter)
			outputs_masks_to_monitor_counter <= outputs_masks_to_monitor_counter + 1;
		else
			outputs_masks_to_monitor_counter <= outputs_masks_to_monitor_counter;
	end
	reg [ADDR_WIDTH_ACT - 1:0] outputs_encoded_to_monitor_counter;
	reg CE_outputs_encoded_to_monitor_counter;
	reg reset_outputs_encoded_to_monitor_counter;
	always @(posedge clk) begin : OUTPUTS_ENCODED_TO_MONITOR_COUNTER
		if (reset_outputs_encoded_to_monitor_counter)
			outputs_encoded_to_monitor_counter <= 0;
		else if (CE_outputs_encoded_to_monitor_counter)
			outputs_encoded_to_monitor_counter <= outputs_encoded_to_monitor_counter + 1;
		else
			outputs_encoded_to_monitor_counter <= outputs_encoded_to_monitor_counter;
	end
	wire [0:0] output_valid_masks_reg_next;
	wire [0:0] output_valid_masks_reg;
	wire output_valid_masks_reg_we;
	register #(.WIDTH(1)) output_valid_masks_reg_r(
		.clk(clk),
		.arst_n_in(arst_n_in),
		.din(output_valid_masks_reg_next),
		.qout(output_valid_masks_reg),
		.we(output_valid_masks_reg_we)
	);
	assign output_valid_masks_reg_next = CE_outputs_masks_to_monitor_counter;
	assign output_valid_masks_reg_we = 1;
	assign output_valid_masks = output_valid_masks_reg;
	wire [0:0] output_valid_encoded_reg_next;
	wire [0:0] output_valid_encoded_reg;
	wire output_valid_encoded_reg_we;
	register #(.WIDTH(1)) output_valid_encoded_reg_r(
		.clk(clk),
		.arst_n_in(arst_n_in),
		.din(output_valid_encoded_reg_next),
		.qout(output_valid_encoded_reg),
		.we(output_valid_encoded_reg_we)
	);
	assign output_valid_encoded_reg_next = CE_outputs_encoded_to_monitor_counter;
	assign output_valid_encoded_reg_we = 1;
	assign output_valid_encoded = output_valid_encoded_reg;
	localparam MAX_MASKS_FIRST = MAXIMUM_Y_ACTIVATIONS_TRANSFER_MASKS;
	localparam MAX_MASKS_AFTER = MAXIMUM_Y_ACTIVATIONS_TRANSFER_MASKS - (2 * Y_GRANULARITY_MASKS);
	reg record_start_write_address_activations;
	always @(posedge clk)
		if (record_start_write_address_activations)
			start_write_address_activations <= address_activations_writing;
		else
			start_write_address_activations <= start_write_address_activations;
	reg record_start_write_address_masks;
	always @(posedge clk)
		if (record_start_write_address_masks)
			start_write_address_masks <= address_masks_writing;
		else
			start_write_address_masks <= start_write_address_masks;
	always @(posedge clk)
		if (delayed_CE_address_masks_writing && ((delayed_masks_transferred % 2) == 1)) begin
			current_index_activations_index_table <= current_index_activations_index_table + 1;
			activations_index_table[current_index_activations_index_table] <= activation_rows_total;
			prev_activation_rows <= activation_rows_total;
		end
	wire [31:0] address_masks_reading_internal;
	assign address_masks_reading_internal = (((MASKS_START_ADDRESS + (((((y + y_offset_counter) - 1) * 2) * X_NEW) * INPUT_NB_CHANNELS_NEW)) + (((x + x_offset_counter) * 2) * INPUT_NB_CHANNELS_NEW)) + ((ch_in / 16) * 2)) + line_offset_counter;
	wire [31:0] address_activations_reading_internal;
	wire [31:0] standard_offset;
	assign standard_offset = (((((y + y_offset_counter) - 1) == 0) && ((x + x_offset_counter) == 0)) && ((ch_in / 16) == 0) ? ACTIVATIONS_START_ADDRESS : ACTIVATIONS_START_ADDRESS + activations_index_table[((((((y + y_offset_counter) - 1) * X_NEW) * INPUT_NB_CHANNELS_NEW) + ((x + x_offset_counter) * INPUT_NB_CHANNELS_NEW)) + (ch_in / 16)) - 1]);
	assign address_activations_reading_internal = standard_offset + line_offset_counter;
	wire need_new_activations_after;
	assign need_new_activations_after = ((((((activations_index_table[((y + 1) * X_NEW) * INPUT_NB_CHANNELS_NEW] < activations_index_table[((y - 1) * X_NEW) * INPUT_NB_CHANNELS_NEW]) && (k_v == 0)) && (ch_in == 0)) && (ch_out == 0)) && (x == 0)) && (y != 1)) && !last_y;
	assign address_masks_writing = address_masks_writing_internal[ADDR_WIDTH_MASKS - 1:0];
	assign address_masks_reading = (current_state == 32'd19 ? outputs_masks_to_monitor_counter : address_masks_reading_internal[ADDR_WIDTH_MASKS - 1:0]);
	assign address_activations_writing = address_activations_writing_internal;
	assign address_activations_reading = (current_state == 32'd20 ? outputs_encoded_to_monitor_counter : address_activations_reading_internal[ADDR_WIDTH_ACT - 1:0]);
	assign masks_transferred_to_memory = (address_masks_writing < start_write_address_masks ? ((address_masks_writing + MAX_MASKS_ADDRESS) + 1) - start_write_address_masks : address_masks_writing - start_write_address_masks);
	wire [31:0] outputs_masks_to_still_transfer_to_monitor;
	assign outputs_masks_to_still_transfer_to_monitor = (outputs_masks_to_memory_counter < outputs_masks_to_monitor_counter ? ((outputs_masks_to_memory_counter + MAX_ACT_ADDRESS) + 1) - outputs_masks_to_monitor_counter : outputs_masks_to_memory_counter - outputs_masks_to_monitor_counter);
	wire [31:0] outputs_encoded_to_still_transfer_to_monitor;
	assign outputs_encoded_to_still_transfer_to_monitor = (outputs_encoded_to_memory_counter < outputs_encoded_to_monitor_counter ? ((outputs_encoded_to_memory_counter + MAX_ACT_ADDRESS) + 1) - outputs_encoded_to_monitor_counter : outputs_encoded_to_memory_counter - outputs_encoded_to_monitor_counter);
	assign start_address_encoded = (((((y + k_v) - 1) == 0) && ((x + k_h) == 0)) && ((ch_in / 16) == 0) ? ACTIVATIONS_START_ADDRESS : ACTIVATIONS_START_ADDRESS + activations_index_table[((((((y + k_v) - 1) * X_NEW) * INPUT_NB_CHANNELS_NEW) + ((x + k_h) * INPUT_NB_CHANNELS_NEW)) + (ch_in / 16)) - 1]);
	assign fx = k_h;
	assign fy = k_v;
	wire go_dummy_mac_path;
	wire go_dummy_mac_path_after_mac;
	wire go_dummy_mac_path_driver;
	wire go_dummy_mac_path_driver_delay;
	assign go_dummy_mac_path = ((y == 0) && (k_v == 0)) || (last_y && (k_v == 2));
	assign go_dummy_mac_path_after_mac = ((y == 0) && (k_v_next == 0)) || ((y == (FEATURE_MAP_HEIGHT - 1)) && (k_v_next == 2));
	assign go_dummy_mac_path_driver = ((y == 0) && (y_offset_counter == 0)) || (last_y && (y_offset_counter == 2));
	assign go_dummy_mac_path_driver_delay = ((y == 0) && (y_offset_counter_delay == 0)) || (last_y && (y_offset_counter_delay == 2));
	always @(posedge clk or negedge arst_n_in)
		if (arst_n_in == 0)
			current_state <= 32'd0;
		else
			current_state <= next_state;
	always @(*) begin
		next_state = current_state;
		mac_valid_internal = 0;
		running = 1;
		weights_ready = 0;
		write_weights_memory = 1;
		read_weights_memory = 1;
		CE_address_weights_internal = 0;
		reset_address_weights_internal = 0;
		write_weights_registers = 0;
		masks_ready = 0;
		write_masks_memory = 1;
		read_masks_memory = 1;
		CE_address_masks_writing_internal = 0;
		reset_address_masks_writing_internal = 0;
		activations_ready = 0;
		write_activations_memory = 1;
		read_activations_memory = 1;
		CE_address_activations_writing_internal = 0;
		reset_address_activations_writing_internal = 0;
		record_start_write_address_activations = 0;
		record_start_write_address_masks = 0;
		write_activations_registers_first = 0;
		write_activations_registers_second = 0;
		reset_outputs_encoded_to_monitor_counter = 0;
		reset_outputs_masks_to_monitor_counter = 0;
		CE_outputs_encoded_to_monitor_counter = 0;
		CE_outputs_masks_to_monitor_counter = 0;
		shift = 0;
		reg_count_enable = 0;
		start_driver = 0;
		reset_driver = 0;
		start_packer = 0;
		begin : sv2v_autoblock_2
			reg signed [31:0] l;
			for (l = 0; l < 2; l = l + 1)
				begin : sv2v_autoblock_3
					reg signed [31:0] k;
					for (k = 0; k < 3; k = k + 1)
						begin : sv2v_autoblock_4
							reg signed [31:0] j;
							for (j = 0; j < 2; j = j + 1)
								write_masks_registers[((((1 - l) * 3) + (2 - k)) * 2) + (1 - j)] = 0;
						end
				end
		end
		CE_decoder = 0;
		x_reg_for_encoder_internal_we = 0;
		CE_encoder = 0;
		reset_encoder_to_packer_counter_internal = 0;
		encoder_to_packer_counter_internal_we = 0;
		write_extra_word_in_register = 0;
		extra_word_from_FIFO = 0;
		extra_word_read_ready = 0;
		extra_word_write_valid = 0;
		dummy_mac = 0;
		zero_padding = 0;
		reset_fifo = 1;
		case (current_state)
			32'd0: begin
				running = 0;
				reset_address_weights_internal = 1;
				reset_address_masks_writing_internal = 1;
				reset_address_activations_writing_internal = 1;
				reset_outputs_encoded_to_monitor_counter = 1;
				reset_outputs_masks_to_monitor_counter = 1;
				reset_encoder_to_packer_counter_internal = 1;
				encoder_to_packer_counter_internal_we = 1;
				next_state = (start ? 32'd1 : 32'd0);
			end
			32'd1: begin
				weights_ready = 1;
				CE_address_weights_internal = weights_valid;
				write_weights_memory = ~weights_valid;
				record_start_write_address_masks = 1;
				next_state = (weights_valid ? (address_weights_internal == MAX_WEIGHT_ADDRESS ? 32'd2 : 32'd1) : 32'd1);
			end
			32'd2: begin
				masks_ready = 1;
				CE_address_masks_writing_internal = masks_valid;
				write_masks_memory = ~masks_valid;
				record_start_write_address_activations = 1;
				next_state = (masks_valid ? ((masks_transferred_to_memory == (MAX_MASKS_FIRST - 1)) || ((address_masks_writing_internal - MASKS_START_ADDRESS) == ((((2 * FEATURE_MAP_HEIGHT) * X_NEW) * INPUT_NB_CHANNELS_NEW) - 1)) ? 32'd3 : 32'd2) : 32'd2);
			end
			32'd3: begin
				activations_ready = 1;
				CE_address_activations_writing_internal = activations_valid;
				write_activations_memory = ~activations_valid;
				next_state = (activations_valid ? ((address_activations_writing_internal - ACTIVATIONS_START_ADDRESS) == (prev_activation_rows - 1) ? 32'd4 : 32'd3) : 32'd3);
			end
			32'd4: begin
				reg_count_enable = 1;
				read_activations_memory = go_dummy_mac_path_driver;
				read_masks_memory = go_dummy_mac_path_driver;
				next_state = 32'd5;
			end
			32'd5: begin
				reg_count_enable = 1;
				read_activations_memory = ((x_offset_counter == 1) && last_x) || go_dummy_mac_path_driver;
				read_masks_memory = ((x_offset_counter == 1) && last_x) || go_dummy_mac_path_driver;
				write_masks_registers[((((1 - x_offset_counter_delay) * 3) + (2 - y_offset_counter_delay)) * 2) + (1 - line_offset_counter_delay)] = 1;
				zero_padding = ((x_offset_counter_delay == 1) && last_x) || go_dummy_mac_path_driver_delay;
				next_state = ((last_x_offset_counter && last_y_offset_counter) && last_line_offset_counter ? 32'd6 : 32'd5);
			end
			32'd6: begin
				zero_padding = ((x_offset_counter_delay == 1) && last_x) || go_dummy_mac_path_driver_delay;
				write_masks_registers[((((1 - x_offset_counter_delay) * 3) + (2 - y_offset_counter_delay)) * 2) + (1 - line_offset_counter_delay)] = 1;
				reset_driver = 1;
				next_state = (go_dummy_mac_path ? 32'd7 : 32'd10);
			end
			32'd7: begin
				mac_valid_internal = 1;
				CE_address_weights_internal = 1;
				dummy_mac = 1;
				next_state = 32'd8;
			end
			32'd8: begin
				mac_valid_internal = 1;
				CE_address_weights_internal = 1;
				dummy_mac = 1;
				next_state = 32'd9;
			end
			32'd9: begin
				mac_valid_internal = 1;
				CE_address_weights_internal = 1;
				dummy_mac = 1;
				next_state = (((ch_in_next % 16) == 0) && last_k_v ? (last_ch_in ? 32'd17 : 32'd4) : 32'd10);
			end
			32'd10: begin
				start_driver = 1;
				CE_decoder = ready_driver;
				read_weights_memory = !ready_driver;
				CE_address_weights_internal = ready_driver;
				extra_word_read_ready = (x != 0) && ready_driver;
				next_state = (ready_driver ? 32'd11 : 32'd10);
			end
			32'd11: begin
				write_activations_registers_first = 1;
				write_extra_word_in_register = 1;
				extra_word_from_FIFO = x != 0;
				extra_word_write_valid = !last_x;
				write_weights_registers = 1;
				next_state = 32'd12;
			end
			32'd12: begin
				mac_valid_internal = 1;
				write_activations_registers_first = 1;
				write_activations_registers_second = 1;
				shift = 1;
				next_state = 32'd13;
			end
			32'd13: begin
				start_driver = 1;
				CE_decoder = ready_driver;
				read_weights_memory = !ready_driver;
				CE_address_weights_internal = ready_driver;
				next_state = (ready_driver ? 32'd14 : 32'd13);
			end
			32'd14: begin
				write_activations_registers_second = 1;
				write_weights_registers = 1;
				read_weights_memory = 0;
				CE_address_weights_internal = 1;
				next_state = 32'd15;
			end
			32'd15: begin
				mac_valid_internal = 1;
				shift = 1;
				write_activations_registers_first = 1;
				write_activations_registers_second = 1;
				write_weights_registers = 1;
				next_state = 32'd16;
			end
			32'd16: begin
				mac_valid_internal = 1;
				x_reg_for_encoder_internal_we = 1;
				next_state = (((ch_in_next % 16) == 0) && last_k_v ? (last_ch_in ? 32'd17 : 32'd4) : (go_dummy_mac_path_after_mac ? 32'd7 : 32'd10));
			end
			32'd17: begin
				CE_encoder = 1;
				start_packer = 1;
				reset_fifo = !(((x == 0) && (ch_in == 0)) && (ch_out == 0));
				encoder_to_packer_counter_internal_we = 1;
				next_state = 32'd18;
			end
			32'd18: next_state = (ready_packer ? ((encoder_to_packer_counter_internal % 16) == 0 ? (first_overall || need_new_activations_after ? 32'd19 : 32'd4) : 32'd17) : 32'd18);
			32'd19: begin
				read_masks_memory = 0;
				CE_outputs_masks_to_monitor_counter = 1;
				next_state = (outputs_masks_to_still_transfer_to_monitor == 1 ? 32'd20 : 32'd19);
			end
			32'd20: begin
				read_activations_memory = 0;
				CE_outputs_encoded_to_monitor_counter = 1;
				record_start_write_address_masks = 1;
				next_state = (outputs_encoded_to_still_transfer_to_monitor == 1 ? (first_overall ? 32'd0 : 32'd21) : 32'd20);
			end
			32'd21: begin
				masks_ready = 1;
				CE_address_masks_writing_internal = masks_valid;
				write_masks_memory = ~masks_valid;
				record_start_write_address_activations = 1;
				next_state = (masks_valid ? ((masks_transferred_to_memory == (MAX_MASKS_AFTER - 1)) || ((address_masks_writing_internal - MASKS_START_ADDRESS) == ((((2 * FEATURE_MAP_HEIGHT) * X_NEW) * INPUT_NB_CHANNELS_NEW) - 1)) ? 32'd22 : 32'd21) : 32'd21);
			end
			32'd22: begin
				activations_ready = 1;
				CE_address_activations_writing_internal = activations_valid;
				write_activations_memory = ~activations_valid;
				next_state = (activations_valid ? ((address_activations_writing_internal - ACTIVATIONS_START_ADDRESS) == (prev_activation_rows - 1) ? 32'd4 : 32'd22) : 32'd22);
			end
		endcase
	end
endmodule
