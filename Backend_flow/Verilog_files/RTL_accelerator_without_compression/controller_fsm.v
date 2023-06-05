module controller_fsm (
	clk,
	arst_n_in,
	start,
	running,
	activations_valid,
	weights_valid,
	weights_ready,
	activations_ready,
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
	output_valid,
	outputs_transferred_to_memory,
	outputs_to_memory_flag,
	extra_word_write_valid,
	extra_word_write_ready,
	extra_word_read_valid,
	extra_word_read_ready,
	write_extra_word_in_register,
	extra_word_from_FIFO,
	end_x_padding,
	reset_fifo
);
	parameter signed [31:0] FEATURE_MAP_WIDTH = 56;
	parameter signed [31:0] FEATURE_MAP_HEIGHT = 56;
	parameter signed [31:0] INPUT_NB_CHANNELS = 64;
	parameter signed [31:0] OUTPUT_NB_CHANNELS = 64;
	parameter signed [31:0] KERNEL_SIZE = 3;
	parameter signed [31:0] MEM_BW = 128;
	parameter signed [31:0] ADDR_WIDTH_ACT = 14;
	parameter signed [31:0] ADDR_WIDTH_WEIGHTS = 12;
	input wire clk;
	input wire arst_n_in;
	input wire start;
	output reg running;
	input wire activations_valid;
	input wire weights_valid;
	output reg weights_ready;
	output reg activations_ready;
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
	output wire output_valid;
	output wire [3:0] outputs_transferred_to_memory;
	output wire outputs_to_memory_flag;
	output reg extra_word_write_valid;
	input wire extra_word_write_ready;
	input wire extra_word_read_valid;
	output reg extra_word_read_ready;
	output reg write_extra_word_in_register;
	output reg extra_word_from_FIFO;
	output reg end_x_padding;
	output reg reset_fifo;
	reg [31:0] current_state;
	reg [31:0] next_state;
	localparam X_NEW = ((FEATURE_MAP_WIDTH - 1) / 16) + 1;
	localparam Y_GRANULARITY = X_NEW * INPUT_NB_CHANNELS;
	localparam ACTIVATIONS_START_ADDRESS = 4 * Y_GRANULARITY;
	localparam MAXIMUM_Y_ACTIVATIONS_TRANSFER = 32 * Y_GRANULARITY;
	localparam OUTPUT_START_ADDRESS = 0;
	reg [31:0] y_address [0:1][0:31];
	reg [31:0] current_y_address_index_writing;
	reg [0:ADDR_WIDTH_ACT - 2] start_write_address;
	reg [31:0] prev_y_address;
	initial begin
		begin : sv2v_autoblock_1
			reg signed [31:0] i;
			for (i = 0; i < 2; i = i + 1)
				begin : sv2v_autoblock_2
					reg signed [31:0] j;
					for (j = 0; j < 32; j = j + 1)
						y_address[i][j] = 0;
				end
		end
		current_y_address_index_writing = 0;
		start_write_address = ACTIVATIONS_START_ADDRESS;
		prev_y_address = ACTIVATIONS_START_ADDRESS;
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
	reg [ADDR_WIDTH_ACT - 1:0] outputs_to_memory_counter;
	reg CE_outputs_to_memory_counter;
	reg reset_outputs_to_memory_counter;
	always @(posedge clk) begin : OUTPUTS_TO_MEMORY_COUNTER
		if (reset_outputs_to_memory_counter)
			outputs_to_memory_counter <= 0;
		else if (CE_outputs_to_memory_counter)
			outputs_to_memory_counter <= outputs_to_memory_counter + 1;
		else
			outputs_to_memory_counter <= outputs_to_memory_counter;
	end
	reg [ADDR_WIDTH_ACT - 1:0] outputs_to_monitor_counter;
	reg CE_outputs_to_monitor_counter;
	reg reset_outputs_to_monitor_counter;
	always @(posedge clk) begin : OUTPUTS_TO_MONITOR_COUNTER
		if (reset_outputs_to_monitor_counter)
			outputs_to_monitor_counter <= 0;
		else if (CE_outputs_to_monitor_counter)
			outputs_to_monitor_counter <= outputs_to_monitor_counter + 1;
		else
			outputs_to_monitor_counter <= outputs_to_monitor_counter;
	end
	wire [0:0] output_valid_reg_1_next;
	wire [0:0] output_valid_reg_1;
	wire output_valid_reg_1_we;
	register #(.WIDTH(1)) output_valid_reg_1_r(
		.clk(clk),
		.arst_n_in(arst_n_in),
		.din(output_valid_reg_1_next),
		.qout(output_valid_reg_1),
		.we(output_valid_reg_1_we)
	);
	assign output_valid_reg_1_next = CE_outputs_to_monitor_counter;
	assign output_valid_reg_1_we = 1;
	assign output_valid = output_valid_reg_1;
	localparam MAX_ACTIVATIONS_FIRST = MAXIMUM_Y_ACTIVATIONS_TRANSFER;
	localparam MAX_ACTIVATIONS_AFTER = MAXIMUM_Y_ACTIVATIONS_TRANSFER - (2 * Y_GRANULARITY);
	reg record_start_write_address;
	always @(posedge clk)
		if (record_start_write_address)
			start_write_address <= (current_state == 32'd1 ? address_activations_writing : outputs_to_memory_counter);
		else
			start_write_address <= start_write_address;
	wire [31:0] y_offset;
	assign y_offset = (address_activations_writing < prev_y_address ? ((address_activations_writing + MAX_ACT_ADDRESS) + 1) - prev_y_address : address_activations_writing - prev_y_address);
	always @(posedge clk)
		if (CE_address_activations_writing_internal && ((y_offset == 0) || (y_offset == Y_GRANULARITY))) begin
			current_y_address_index_writing <= current_y_address_index_writing + 1;
			y_address[0][current_y_address_index_writing % 32] <= current_y_address_index_writing;
			y_address[1][current_y_address_index_writing % 32] <= address_activations_writing_internal;
			prev_y_address <= address_activations_writing_internal;
		end
	wire [31:0] address_activations_reading_internal;
	wire [31:0] y_address_offset;
	assign y_address_offset = y_address[1][((y + k_v) - 1) % 32];
	assign address_activations_reading_internal = (y_address_offset + (INPUT_NB_CHANNELS * (x + k_h))) + ch_in;
	wire need_new_activations_after;
	assign need_new_activations_after = ((((((y_address[0][(y + 1) % 32] != (y_address[0][(y - 1) % 32] + 2)) && (k_v == 0)) && (ch_in == 0)) && (ch_out == 0)) && (x == 0)) && (y != 1)) && !last_y;
	assign address_activations_writing = (current_state == 32'd13 ? outputs_to_memory_counter : address_activations_writing_internal);
	assign address_activations_reading = (current_state == 32'd14 ? outputs_to_monitor_counter : address_activations_reading_internal[ADDR_WIDTH_ACT - 1:0]);
	wire [31:0] activations_transferred_to_memory;
	assign activations_transferred_to_memory = (address_activations_writing < start_write_address ? ((address_activations_writing + MAX_ACT_ADDRESS) + 1) - start_write_address : address_activations_writing - start_write_address);
	wire [31:0] outputs_transferred_to_memory_internal;
	assign outputs_transferred_to_memory_internal = (outputs_to_memory_counter < start_write_address ? ((outputs_to_memory_counter + MAX_ACT_ADDRESS) + 1) - start_write_address : outputs_to_memory_counter - start_write_address);
	assign outputs_transferred_to_memory = outputs_transferred_to_memory_internal;
	wire [31:0] outputs_to_still_transfer_to_monitor;
	assign outputs_to_still_transfer_to_monitor = (outputs_to_memory_counter < outputs_to_monitor_counter ? ((outputs_to_memory_counter + MAX_ACT_ADDRESS) + 1) - outputs_to_monitor_counter : outputs_to_memory_counter - outputs_to_monitor_counter);
	assign outputs_to_memory_flag = CE_outputs_to_memory_counter;
	wire go_dummy_mac_path;
	wire go_dummy_mac_path_after_mac;
	assign go_dummy_mac_path = ((y == 0) && (k_v == 0)) || (last_y && (k_v == 2));
	assign go_dummy_mac_path_after_mac = ((y == 0) && (k_v_next == 0)) || ((y == (FEATURE_MAP_HEIGHT - 1)) && (k_v_next == 2));
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
		activations_ready = 0;
		write_activations_memory = 1;
		read_activations_memory = 1;
		CE_address_activations_writing_internal = 0;
		reset_address_activations_writing_internal = 0;
		record_start_write_address = 0;
		write_activations_registers_first = 0;
		write_activations_registers_second = 0;
		reset_outputs_to_memory_counter = 0;
		CE_outputs_to_memory_counter = 0;
		reset_outputs_to_monitor_counter = 0;
		CE_outputs_to_monitor_counter = 0;
		shift = 0;
		write_extra_word_in_register = 0;
		extra_word_from_FIFO = 0;
		extra_word_read_ready = 0;
		extra_word_write_valid = 0;
		dummy_mac = 0;
		end_x_padding = 0;
		reset_fifo = 1;
		case (current_state)
			32'd0: begin
				running = 0;
				reset_address_weights_internal = 1;
				reset_address_activations_writing_internal = 1;
				reset_outputs_to_memory_counter = 1;
				reset_outputs_to_monitor_counter = 1;
				next_state = (start ? 32'd1 : 32'd0);
			end
			32'd1: begin
				weights_ready = 1;
				CE_address_weights_internal = weights_valid;
				write_weights_memory = ~weights_valid;
				record_start_write_address = 1;
				next_state = (weights_valid ? (address_weights_internal == MAX_WEIGHT_ADDRESS ? 32'd2 : 32'd1) : 32'd1);
			end
			32'd2: begin
				activations_ready = 1;
				CE_address_activations_writing_internal = activations_valid;
				write_activations_memory = ~activations_valid;
				next_state = (activations_valid ? ((activations_transferred_to_memory == (MAX_ACTIVATIONS_FIRST - 1)) || ((current_y_address_index_writing == FEATURE_MAP_HEIGHT) && (y_offset == (Y_GRANULARITY - 1))) ? (go_dummy_mac_path ? 32'd4 : 32'd3) : 32'd2) : 32'd2);
			end
			32'd3: begin
				read_weights_memory = 0;
				CE_address_weights_internal = 1;
				read_activations_memory = 0;
				extra_word_read_ready = x != 0;
				next_state = 32'd7;
			end
			32'd4: begin
				mac_valid_internal = 1;
				CE_address_weights_internal = 1;
				dummy_mac = 1;
				next_state = 32'd5;
			end
			32'd5: begin
				mac_valid_internal = 1;
				CE_address_weights_internal = 1;
				dummy_mac = 1;
				next_state = 32'd6;
			end
			32'd6: begin
				mac_valid_internal = 1;
				CE_address_weights_internal = 1;
				dummy_mac = 1;
				next_state = (last_ch_in && last_k_v ? 32'd13 : 32'd3);
			end
			32'd7: begin
				write_activations_registers_first = 1;
				write_extra_word_in_register = 1;
				extra_word_from_FIFO = x != 0;
				extra_word_write_valid = !last_x;
				write_weights_registers = 1;
				next_state = 32'd8;
			end
			32'd8: begin
				write_activations_registers_first = 1;
				write_activations_registers_second = 1;
				shift = 1;
				read_weights_memory = 0;
				CE_address_weights_internal = 1;
				mac_valid_internal = 1;
				next_state = 32'd9;
			end
			32'd9: begin
				read_weights_memory = 0;
				CE_address_weights_internal = 1;
				write_weights_registers = 1;
				read_activations_memory = last_x;
				next_state = 32'd10;
			end
			32'd10: begin
				mac_valid_internal = 1;
				end_x_padding = last_x;
				write_activations_registers_second = 1;
				write_weights_registers = 1;
				next_state = 32'd11;
			end
			32'd11: begin
				shift = 1;
				write_activations_registers_first = 1;
				write_activations_registers_second = 1;
				next_state = 32'd12;
			end
			32'd12: begin
				mac_valid_internal = 1;
				record_start_write_address = 1;
				next_state = (last_ch_in && last_k_v ? 32'd13 : (go_dummy_mac_path_after_mac ? 32'd4 : 32'd3));
			end
			32'd13: begin
				CE_outputs_to_memory_counter = 1;
				write_activations_memory = 0;
				reset_fifo = !(((x == 0) && (ch_in == 0)) && (ch_out == 0));
				next_state = (outputs_transferred_to_memory == 15 ? (first_overall || need_new_activations_after ? 32'd14 : (go_dummy_mac_path ? 32'd4 : 32'd3)) : 32'd13);
			end
			32'd14: begin
				read_activations_memory = 0;
				CE_outputs_to_monitor_counter = 1;
				record_start_write_address = 1;
				next_state = (outputs_to_still_transfer_to_monitor == 1 ? (first_overall ? 32'd0 : 32'd15) : 32'd14);
			end
			32'd15: begin
				activations_ready = 1;
				CE_address_activations_writing_internal = activations_valid;
				write_activations_memory = ~activations_valid;
				next_state = (activations_valid ? ((activations_transferred_to_memory == (MAX_ACTIVATIONS_AFTER - 1)) || ((current_y_address_index_writing == FEATURE_MAP_HEIGHT) && (y_offset == (Y_GRANULARITY - 1))) ? (go_dummy_mac_path ? 32'd4 : 32'd3) : 32'd15) : 32'd15);
			end
		endcase
	end
endmodule
