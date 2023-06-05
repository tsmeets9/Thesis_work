module top_chip (
	clk,
	arst_n_in,
	activations_input,
	activations_valid,
	activations_ready,
	masks_input,
	masks_valid,
	masks_ready,
	weights_input,
	weights_valid,
	weights_ready,
	out_encoded,
	out_masks,
	output_valid_encoded,
	output_valid_masks,
	start,
	running
);
	parameter signed [31:0] IO_DATA_WIDTH = 8;
	parameter signed [31:0] ACCUMULATION_WIDTH = 32;
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
	input wire [MEM_BW - 1:0] activations_input;
	input wire activations_valid;
	output wire activations_ready;
	input wire [MEM_BW - 1:0] masks_input;
	input wire masks_valid;
	output wire masks_ready;
	input wire [MEM_BW - 1:0] weights_input;
	input wire weights_valid;
	output wire weights_ready;
	output wire [MEM_BW - 1:0] out_encoded;
	output wire [MEM_BW - 1:0] out_masks;
	output wire output_valid_encoded;
	output wire output_valid_masks;
	input wire start;
	output wire running;
	wire write_activations_registers_first;
	wire write_activations_registers_second;
	wire write_weights_registers;
	wire shift;
	wire write_activations_memory;
	wire read_activations_memory;
	wire [ADDR_WIDTH_ACT - 1:0] address_activations_writing;
	wire [ADDR_WIDTH_ACT - 1:0] address_activations_reading;
	wire write_masks_memory;
	wire read_masks_memory;
	wire [ADDR_WIDTH_MASKS - 1:0] address_masks_writing;
	wire [ADDR_WIDTH_MASKS - 1:0] address_masks_reading;
	wire CE_address_masks_writing;
	wire [31:0] masks_transferred_to_memory;
	wire [31:0] activation_rows_total;
	wire delayed_CE_address_masks_writing;
	wire [ADDR_WIDTH_MASKS - 1:0] delayed_masks_transferred;
	wire write_weights_memory;
	wire read_weights_memory;
	wire [ADDR_WIDTH_WEIGHTS - 1:0] address_weights;
	wire mac_valid;
	wire mac_accumulate_internal;
	wire [11:0] write_masks_registers;
	wire start_driver;
	wire reset_driver;
	wire [1:0] fx;
	wire [1:0] fy;
	wire [31:0] start_address_encoded;
	wire ready_driver;
	wire driver_read_control;
	wire read_activations_memory_extra;
	wire [ADDR_WIDTH_ACT - 1:0] address_activations_reading_extra;
	wire [MEM_BW - 1:0] encoded_activations_driver;
	wire [15:0] masks_activations_driver;
	wire CE_decoder;
	wire CE_encoder;
	wire [31:0] x_reg_for_encoder;
	wire start_packer;
	wire ready_packer;
	wire [3:0] encoder_to_packer_counter;
	wire packer_write_control;
	wire write_activations_memory_extra;
	wire write_masks_memory_extra;
	wire [MEM_BW - 1:0] output_encoded;
	wire [MEM_BW - 1:0] output_masks;
	wire [ADDR_WIDTH_ACT - 1:0] outputs_encoded_to_memory_counter;
	wire [ADDR_WIDTH_MASKS - 1:0] outputs_masks_to_memory_counter;
	wire extra_word_write_valid;
	wire extra_word_write_ready;
	wire extra_word_read_valid;
	wire extra_word_read_ready;
	wire write_extra_word_in_register;
	wire extra_word_from_FIFO;
	wire zero_padding;
	wire reset_fifo;
	controller_fsm #(
		.FEATURE_MAP_WIDTH(FEATURE_MAP_WIDTH),
		.FEATURE_MAP_HEIGHT(FEATURE_MAP_HEIGHT),
		.INPUT_NB_CHANNELS(INPUT_NB_CHANNELS),
		.OUTPUT_NB_CHANNELS(OUTPUT_NB_CHANNELS),
		.KERNEL_SIZE(KERNEL_SIZE),
		.MEM_BW(MEM_BW),
		.ADDR_WIDTH_ACT(ADDR_WIDTH_ACT),
		.ADDR_WIDTH_MASKS(ADDR_WIDTH_MASKS),
		.ADDR_WIDTH_WEIGHTS(ADDR_WIDTH_WEIGHTS)
	) controller(
		.clk(clk),
		.arst_n_in(arst_n_in),
		.start(start),
		.running(running),
		.activations_valid(activations_valid),
		.activations_ready(activations_ready),
		.masks_valid(masks_valid),
		.masks_ready(masks_ready),
		.weights_valid(weights_valid),
		.weights_ready(weights_ready),
		.write_activations_registers_first(write_activations_registers_first),
		.write_activations_registers_second(write_activations_registers_second),
		.shift(shift),
		.write_weights_registers(write_weights_registers),
		.mac_valid(mac_valid),
		.mac_accumulate_internal(mac_accumulate_internal),
		.write_weights_memory(write_weights_memory),
		.read_weights_memory(read_weights_memory),
		.address_weights(address_weights),
		.write_activations_memory(write_activations_memory),
		.read_activations_memory(read_activations_memory),
		.address_activations_writing(address_activations_writing),
		.address_activations_reading(address_activations_reading),
		.write_masks_memory(write_masks_memory),
		.read_masks_memory(read_masks_memory),
		.address_masks_writing(address_masks_writing),
		.address_masks_reading(address_masks_reading),
		.CE_address_masks_writing(CE_address_masks_writing),
		.masks_transferred_to_memory(masks_transferred_to_memory),
		.activation_rows_total(activation_rows_total),
		.delayed_CE_address_masks_writing(delayed_CE_address_masks_writing),
		.delayed_masks_transferred(delayed_masks_transferred),
		.output_valid_encoded(output_valid_encoded),
		.output_valid_masks(output_valid_masks),
		.ready_driver(ready_driver),
		.write_masks_registers(write_masks_registers),
		.start_driver(start_driver),
		.reset_driver(reset_driver),
		.fx(fx),
		.fy(fy),
		.start_address_encoded(start_address_encoded),
		.CE_decoder(CE_decoder),
		.CE_encoder(CE_encoder),
		.x_reg_for_encoder(x_reg_for_encoder),
		.ready_packer(ready_packer),
		.start_packer(start_packer),
		.encoder_to_packer_counter(encoder_to_packer_counter),
		.outputs_encoded_to_memory_counter(outputs_encoded_to_memory_counter),
		.outputs_masks_to_memory_counter(outputs_masks_to_memory_counter),
		.extra_word_write_valid(extra_word_write_valid),
		.extra_word_write_ready(extra_word_write_ready),
		.extra_word_read_valid(extra_word_read_valid),
		.extra_word_read_ready(extra_word_read_ready),
		.write_extra_word_in_register(write_extra_word_in_register),
		.extra_word_from_FIFO(extra_word_from_FIFO),
		.zero_padding(zero_padding),
		.reset_fifo(reset_fifo)
	);
	wire [MEM_BW - 1:0] weights_out_memory_internal [0:7];
	genvar k;
	generate
		for (k = 0; k < 8; k = k + 1) begin : genblk1
			sky130_sram_1r1w_128x512_128 sram_weights_banks(
				.clk0(clk),
				.csb0(write_weights_memory || (k != address_weights[ADDR_WIDTH_WEIGHTS - 1:ADDR_WIDTH_WEIGHTS - 3])),
				.addr0(address_weights[ADDR_WIDTH_WEIGHTS - 4:0]),
				.din0(weights_input),
				.clk1(clk),
				.csb1(read_weights_memory || (k != address_weights[ADDR_WIDTH_WEIGHTS - 1:ADDR_WIDTH_WEIGHTS - 3])),
				.addr1(address_weights[ADDR_WIDTH_WEIGHTS - 4:0]),
				.dout1(weights_out_memory_internal[k])
			);
		end
	endgenerate
	wire [2:0] address_weights_select_delay_next;
	wire [2:0] address_weights_select_delay;
	wire address_weights_select_delay_we;
	register #(.WIDTH(3)) address_weights_select_delay_r(
		.clk(clk),
		.arst_n_in(arst_n_in),
		.din(address_weights_select_delay_next),
		.qout(address_weights_select_delay),
		.we(address_weights_select_delay_we)
	);
	assign address_weights_select_delay_next = address_weights[ADDR_WIDTH_WEIGHTS - 1:ADDR_WIDTH_WEIGHTS - 3];
	assign address_weights_select_delay_we = 1;
	wire [MEM_BW - 1:0] weights_out_memory;
	assign weights_out_memory = weights_out_memory_internal[address_weights_select_delay];
	wire [((MEM_BW / IO_DATA_WIDTH) * IO_DATA_WIDTH) - 1:0] weights_out_driver;
	driver_weights #(
		.IO_DATA_WIDTH(IO_DATA_WIDTH),
		.MEM_BW(MEM_BW)
	) driver_weights_0(
		.weights_input(weights_out_memory),
		.weights_output(weights_out_driver)
	);
	wire [MEM_BW - 1:0] masks_out_memory_internal [0:3];
	generate
		for (k = 0; k < 4; k = k + 1) begin : genblk2
			sky130_sram_1r1w_128x512_128 sram_masks_banks(
				.clk0(clk),
				.csb0((packer_write_control ? write_masks_memory_extra || (k != outputs_masks_to_memory_counter[ADDR_WIDTH_MASKS - 1:ADDR_WIDTH_MASKS - 2]) : write_masks_memory || (k != address_masks_writing[ADDR_WIDTH_MASKS - 1:ADDR_WIDTH_MASKS - 2]))),
				.addr0((packer_write_control ? outputs_masks_to_memory_counter[ADDR_WIDTH_MASKS - 3:0] : address_masks_writing[ADDR_WIDTH_MASKS - 3:0])),
				.din0((packer_write_control ? output_masks : masks_input)),
				.clk1(clk),
				.csb1(read_masks_memory || (k != address_masks_reading[ADDR_WIDTH_MASKS - 1:ADDR_WIDTH_MASKS - 2])),
				.addr1(address_masks_reading[ADDR_WIDTH_MASKS - 3:0]),
				.dout1(masks_out_memory_internal[k])
			);
		end
	endgenerate
	wire [1:0] address_masks_select_delay_next;
	wire [1:0] address_masks_select_delay;
	wire address_masks_select_delay_we;
	register #(.WIDTH(2)) address_masks_select_delay_r(
		.clk(clk),
		.arst_n_in(arst_n_in),
		.din(address_masks_select_delay_next),
		.qout(address_masks_select_delay),
		.we(address_masks_select_delay_we)
	);
	assign address_masks_select_delay_next = address_masks_reading[ADDR_WIDTH_MASKS - 1:ADDR_WIDTH_MASKS - 2];
	assign address_masks_select_delay_we = 1;
	wire [MEM_BW - 1:0] masks_out_memory;
	assign masks_out_memory = masks_out_memory_internal[address_masks_select_delay];
	index_table_logic #(
		.MEM_BW(MEM_BW),
		.ADDR_WIDTH_ACT(ADDR_WIDTH_ACT),
		.ADDR_WIDTH_MASKS(ADDR_WIDTH_MASKS)
	) index_table_logic_0(
		.clk(clk),
		.arst_n_in(arst_n_in),
		.masks(masks_input),
		.CE_signal(CE_address_masks_writing),
		.masks_transferred(masks_transferred_to_memory),
		.activation_rows_total(activation_rows_total),
		.delayed_CE(delayed_CE_address_masks_writing),
		.delayed_masks_transferred(delayed_masks_transferred)
	);
	wire [MEM_BW - 1:0] activations_out_memory_internal [0:31];
	generate
		for (k = 0; k < 32; k = k + 1) begin : genblk3
			sky130_sram_1r1w_128x512_128 sram_encoded_data_banks(
				.clk0(clk),
				.csb0((packer_write_control ? write_activations_memory_extra || (k != outputs_encoded_to_memory_counter[ADDR_WIDTH_ACT - 1:ADDR_WIDTH_ACT - 5]) : write_activations_memory || (k != address_activations_writing[ADDR_WIDTH_ACT - 1:ADDR_WIDTH_ACT - 5]))),
				.addr0((packer_write_control ? outputs_encoded_to_memory_counter[ADDR_WIDTH_ACT - 6:0] : address_activations_writing[ADDR_WIDTH_ACT - 6:0])),
				.din0((packer_write_control ? output_encoded : activations_input)),
				.clk1(clk),
				.csb1((driver_read_control ? read_activations_memory_extra || (k != address_activations_reading_extra[ADDR_WIDTH_ACT - 1:ADDR_WIDTH_ACT - 5]) : read_activations_memory || (k != address_activations_reading[ADDR_WIDTH_ACT - 1:ADDR_WIDTH_ACT - 5]))),
				.addr1((driver_read_control ? address_activations_reading_extra[ADDR_WIDTH_ACT - 6:0] : address_activations_reading[ADDR_WIDTH_ACT - 6:0])),
				.dout1(activations_out_memory_internal[k])
			);
		end
	endgenerate
	wire [4:0] address_activations_select_delay_next;
	wire [4:0] address_activations_select_delay;
	wire address_activations_select_delay_we;
	register #(.WIDTH(5)) address_activations_select_delay_r(
		.clk(clk),
		.arst_n_in(arst_n_in),
		.din(address_activations_select_delay_next),
		.qout(address_activations_select_delay),
		.we(address_activations_select_delay_we)
	);
	assign address_activations_select_delay_next = (driver_read_control ? address_activations_reading_extra[ADDR_WIDTH_ACT - 1:ADDR_WIDTH_ACT - 5] : address_activations_reading[ADDR_WIDTH_ACT - 1:ADDR_WIDTH_ACT - 5]);
	assign address_activations_select_delay_we = 1;
	wire [MEM_BW - 1:0] activations_out_memory;
	assign activations_out_memory = activations_out_memory_internal[address_activations_select_delay];
	driver_encoded_and_masks #(
		.IO_DATA_WIDTH(IO_DATA_WIDTH),
		.MEM_BW(MEM_BW),
		.ADDR_WIDTH_ACT(ADDR_WIDTH_ACT)
	) driver_encoded_and_masks_0(
		.clk(clk),
		.arst_n_in(arst_n_in),
		.encoded_input(activations_out_memory),
		.masks_input(masks_out_memory),
		.write_masks_registers(write_masks_registers),
		.start_driver(start_driver),
		.reset_driver(reset_driver),
		.fx(fx),
		.fy(fy),
		.start_address_encoded(start_address_encoded),
		.ready_driver(ready_driver),
		.driver_read_control(driver_read_control),
		.read_activations_memory_extra(read_activations_memory_extra),
		.address_activations_reading_extra(address_activations_reading_extra),
		.encoded_output(encoded_activations_driver),
		.masks_output(masks_activations_driver),
		.zero_padding(zero_padding)
	);
	wire [((MEM_BW / IO_DATA_WIDTH) * IO_DATA_WIDTH) - 1:0] activations_out_decoder;
	decoder #(
		.IO_DATA_WIDTH(IO_DATA_WIDTH),
		.MEM_BW(MEM_BW)
	) decoder_0(
		.clk(clk),
		.CE(CE_decoder),
		.mask(masks_activations_driver),
		.to_decode(encoded_activations_driver),
		.decoded(activations_out_decoder)
	);
	wire signed [IO_DATA_WIDTH - 1:0] output_FIFO;
	wire total_reset_fifo;
	assign total_reset_fifo = arst_n_in && reset_fifo;
	fifo #(
		.WIDTH(IO_DATA_WIDTH),
		.LOG2_OF_DEPTH(10),
		.USE_AS_EXTERNAL_FIFO(0)
	) fifo_0(
		.clk(clk),
		.arst_n_in(total_reset_fifo),
		.din(activations_out_decoder[((MEM_BW / IO_DATA_WIDTH) - 16) * IO_DATA_WIDTH+:IO_DATA_WIDTH]),
		.input_valid(extra_word_write_valid),
		.input_ready(extra_word_write_ready),
		.qout(output_FIFO),
		.output_valid(extra_word_read_valid),
		.output_ready(extra_word_read_ready)
	);
	wire signed [IO_DATA_WIDTH - 1:0] extra_word;
	assign extra_word = (extra_word_from_FIFO ? output_FIFO : 0);
	wire signed [(16 * IO_DATA_WIDTH) - 1:0] activation_registers [0:1];
	genvar j;
	genvar i;
	generate
		for (j = 1; j >= 0; j = j - 1) begin : genblk4
			for (i = 15; i >= 0; i = i - 1) begin : genblk1
				if (j == 1) begin : genblk1
					if (i == 15) begin : genblk1
						register #(.WIDTH(IO_DATA_WIDTH)) shift_reg(
							.clk(clk),
							.arst_n_in(arst_n_in),
							.din((shift ? 8'h00 : activations_out_decoder[(((MEM_BW / IO_DATA_WIDTH) - 1) - i) * IO_DATA_WIDTH+:IO_DATA_WIDTH])),
							.qout(activation_registers[j][(15 - i) * IO_DATA_WIDTH+:IO_DATA_WIDTH]),
							.we(write_activations_registers_second)
						);
					end
					else if (i == 0) begin : genblk1
						register #(.WIDTH(IO_DATA_WIDTH)) shift_reg(
							.clk(clk),
							.arst_n_in(arst_n_in),
							.din((write_activations_registers_first ? (shift ? activation_registers[j][(15 - (i + 1)) * IO_DATA_WIDTH+:IO_DATA_WIDTH] : activations_out_decoder[((MEM_BW / IO_DATA_WIDTH) - 16) * IO_DATA_WIDTH+:IO_DATA_WIDTH]) : activations_out_decoder[(((MEM_BW / IO_DATA_WIDTH) - 1) - i) * IO_DATA_WIDTH+:IO_DATA_WIDTH])),
							.qout(activation_registers[j][(15 - i) * IO_DATA_WIDTH+:IO_DATA_WIDTH]),
							.we(write_activations_registers_first || write_activations_registers_second)
						);
					end
					else begin : genblk1
						register #(.WIDTH(IO_DATA_WIDTH)) shift_reg(
							.clk(clk),
							.arst_n_in(arst_n_in),
							.din((shift ? activation_registers[j][(15 - (i + 1)) * IO_DATA_WIDTH+:IO_DATA_WIDTH] : activations_out_decoder[(((MEM_BW / IO_DATA_WIDTH) - 1) - i) * IO_DATA_WIDTH+:IO_DATA_WIDTH])),
							.qout(activation_registers[j][(15 - i) * IO_DATA_WIDTH+:IO_DATA_WIDTH]),
							.we(write_activations_registers_second)
						);
					end
				end
				else begin : genblk1
					if (i == 15) begin : genblk1
						register #(.WIDTH(IO_DATA_WIDTH)) shift_reg(
							.clk(clk),
							.arst_n_in(arst_n_in),
							.din((shift ? activation_registers[j + 1][15 * IO_DATA_WIDTH+:IO_DATA_WIDTH] : activations_out_decoder[(((MEM_BW / IO_DATA_WIDTH) - 1) - (i - 1)) * IO_DATA_WIDTH+:IO_DATA_WIDTH])),
							.qout(activation_registers[j][(15 - i) * IO_DATA_WIDTH+:IO_DATA_WIDTH]),
							.we(write_activations_registers_first)
						);
					end
					else if (i == 0) begin : genblk1
						register #(.WIDTH(IO_DATA_WIDTH)) shift_reg(
							.clk(clk),
							.arst_n_in(arst_n_in),
							.din((shift ? activation_registers[j][(15 - (i + 1)) * IO_DATA_WIDTH+:IO_DATA_WIDTH] : extra_word)),
							.qout(activation_registers[j][(15 - i) * IO_DATA_WIDTH+:IO_DATA_WIDTH]),
							.we(write_activations_registers_first || write_extra_word_in_register)
						);
					end
					else begin : genblk1
						register #(.WIDTH(IO_DATA_WIDTH)) shift_reg(
							.clk(clk),
							.arst_n_in(arst_n_in),
							.din((shift ? activation_registers[j][(15 - (i + 1)) * IO_DATA_WIDTH+:IO_DATA_WIDTH] : activations_out_decoder[(((MEM_BW / IO_DATA_WIDTH) - 1) - (i - 1)) * IO_DATA_WIDTH+:IO_DATA_WIDTH])),
							.qout(activation_registers[j][(15 - i) * IO_DATA_WIDTH+:IO_DATA_WIDTH]),
							.we(write_activations_registers_first)
						);
					end
				end
			end
		end
	endgenerate
	wire signed [(16 * IO_DATA_WIDTH) - 1:0] weights_registers;
	generate
		for (k = 0; k < 16; k = k + 1) begin : genblk5
			register #(.WIDTH(IO_DATA_WIDTH)) reg_weights(
				.clk(clk),
				.arst_n_in(arst_n_in),
				.din(weights_out_driver[(((MEM_BW / IO_DATA_WIDTH) - 1) - k) * IO_DATA_WIDTH+:IO_DATA_WIDTH]),
				.qout(weights_registers[(15 - k) * IO_DATA_WIDTH+:IO_DATA_WIDTH]),
				.we(write_weights_registers)
			);
		end
	endgenerate
	wire signed [(256 * IO_DATA_WIDTH) - 1:0] products_out;
	PE_array #(
		.A_WIDTH(IO_DATA_WIDTH),
		.B_WIDTH(IO_DATA_WIDTH),
		.ACCUMULATOR_WIDTH(ACCUMULATION_WIDTH),
		.OUTPUT_WIDTH(IO_DATA_WIDTH),
		.OUTPUT_SCALE(0)
	) PE_array(
		.clk(clk),
		.arst_n_in(arst_n_in),
		.input_valid(mac_valid),
		.accumulate_internal(mac_accumulate_internal),
		.activations(activation_registers[0][0+:IO_DATA_WIDTH * 16]),
		.weights(weights_registers),
		.outs(products_out)
	);
	wire [(16 * IO_DATA_WIDTH) - 1:0] products_out_for_encoder;
	assign products_out_for_encoder[15 * IO_DATA_WIDTH+:IO_DATA_WIDTH] = ((products_out[((240 + (15 - encoder_to_packer_counter)) * IO_DATA_WIDTH) + (IO_DATA_WIDTH - 1)] == 0) && (((x_reg_for_encoder * 16) + 0) <= (FEATURE_MAP_WIDTH - 1)) ? products_out[(240 + (15 - encoder_to_packer_counter)) * IO_DATA_WIDTH+:IO_DATA_WIDTH] : 0);
	assign products_out_for_encoder[14 * IO_DATA_WIDTH+:IO_DATA_WIDTH] = ((products_out[((224 + (15 - encoder_to_packer_counter)) * IO_DATA_WIDTH) + (IO_DATA_WIDTH - 1)] == 0) && (((x_reg_for_encoder * 16) + 1) <= (FEATURE_MAP_WIDTH - 1)) ? products_out[(224 + (15 - encoder_to_packer_counter)) * IO_DATA_WIDTH+:IO_DATA_WIDTH] : 0);
	assign products_out_for_encoder[13 * IO_DATA_WIDTH+:IO_DATA_WIDTH] = ((products_out[((208 + (15 - encoder_to_packer_counter)) * IO_DATA_WIDTH) + (IO_DATA_WIDTH - 1)] == 0) && (((x_reg_for_encoder * 16) + 2) <= (FEATURE_MAP_WIDTH - 1)) ? products_out[(208 + (15 - encoder_to_packer_counter)) * IO_DATA_WIDTH+:IO_DATA_WIDTH] : 0);
	assign products_out_for_encoder[12 * IO_DATA_WIDTH+:IO_DATA_WIDTH] = ((products_out[((192 + (15 - encoder_to_packer_counter)) * IO_DATA_WIDTH) + (IO_DATA_WIDTH - 1)] == 0) && (((x_reg_for_encoder * 16) + 3) <= (FEATURE_MAP_WIDTH - 1)) ? products_out[(192 + (15 - encoder_to_packer_counter)) * IO_DATA_WIDTH+:IO_DATA_WIDTH] : 0);
	assign products_out_for_encoder[11 * IO_DATA_WIDTH+:IO_DATA_WIDTH] = ((products_out[((176 + (15 - encoder_to_packer_counter)) * IO_DATA_WIDTH) + (IO_DATA_WIDTH - 1)] == 0) && (((x_reg_for_encoder * 16) + 4) <= (FEATURE_MAP_WIDTH - 1)) ? products_out[(176 + (15 - encoder_to_packer_counter)) * IO_DATA_WIDTH+:IO_DATA_WIDTH] : 0);
	assign products_out_for_encoder[10 * IO_DATA_WIDTH+:IO_DATA_WIDTH] = ((products_out[((160 + (15 - encoder_to_packer_counter)) * IO_DATA_WIDTH) + (IO_DATA_WIDTH - 1)] == 0) && (((x_reg_for_encoder * 16) + 5) <= (FEATURE_MAP_WIDTH - 1)) ? products_out[(160 + (15 - encoder_to_packer_counter)) * IO_DATA_WIDTH+:IO_DATA_WIDTH] : 0);
	assign products_out_for_encoder[9 * IO_DATA_WIDTH+:IO_DATA_WIDTH] = ((products_out[((144 + (15 - encoder_to_packer_counter)) * IO_DATA_WIDTH) + (IO_DATA_WIDTH - 1)] == 0) && (((x_reg_for_encoder * 16) + 6) <= (FEATURE_MAP_WIDTH - 1)) ? products_out[(144 + (15 - encoder_to_packer_counter)) * IO_DATA_WIDTH+:IO_DATA_WIDTH] : 0);
	assign products_out_for_encoder[8 * IO_DATA_WIDTH+:IO_DATA_WIDTH] = ((products_out[((128 + (15 - encoder_to_packer_counter)) * IO_DATA_WIDTH) + (IO_DATA_WIDTH - 1)] == 0) && (((x_reg_for_encoder * 16) + 7) <= (FEATURE_MAP_WIDTH - 1)) ? products_out[(128 + (15 - encoder_to_packer_counter)) * IO_DATA_WIDTH+:IO_DATA_WIDTH] : 0);
	assign products_out_for_encoder[7 * IO_DATA_WIDTH+:IO_DATA_WIDTH] = ((products_out[((112 + (15 - encoder_to_packer_counter)) * IO_DATA_WIDTH) + (IO_DATA_WIDTH - 1)] == 0) && (((x_reg_for_encoder * 16) + 8) <= (FEATURE_MAP_WIDTH - 1)) ? products_out[(112 + (15 - encoder_to_packer_counter)) * IO_DATA_WIDTH+:IO_DATA_WIDTH] : 0);
	assign products_out_for_encoder[6 * IO_DATA_WIDTH+:IO_DATA_WIDTH] = ((products_out[((96 + (15 - encoder_to_packer_counter)) * IO_DATA_WIDTH) + (IO_DATA_WIDTH - 1)] == 0) && (((x_reg_for_encoder * 16) + 9) <= (FEATURE_MAP_WIDTH - 1)) ? products_out[(96 + (15 - encoder_to_packer_counter)) * IO_DATA_WIDTH+:IO_DATA_WIDTH] : 0);
	assign products_out_for_encoder[5 * IO_DATA_WIDTH+:IO_DATA_WIDTH] = ((products_out[((80 + (15 - encoder_to_packer_counter)) * IO_DATA_WIDTH) + (IO_DATA_WIDTH - 1)] == 0) && (((x_reg_for_encoder * 16) + 10) <= (FEATURE_MAP_WIDTH - 1)) ? products_out[(80 + (15 - encoder_to_packer_counter)) * IO_DATA_WIDTH+:IO_DATA_WIDTH] : 0);
	assign products_out_for_encoder[4 * IO_DATA_WIDTH+:IO_DATA_WIDTH] = ((products_out[((64 + (15 - encoder_to_packer_counter)) * IO_DATA_WIDTH) + (IO_DATA_WIDTH - 1)] == 0) && (((x_reg_for_encoder * 16) + 11) <= (FEATURE_MAP_WIDTH - 1)) ? products_out[(64 + (15 - encoder_to_packer_counter)) * IO_DATA_WIDTH+:IO_DATA_WIDTH] : 0);
	assign products_out_for_encoder[3 * IO_DATA_WIDTH+:IO_DATA_WIDTH] = ((products_out[((48 + (15 - encoder_to_packer_counter)) * IO_DATA_WIDTH) + (IO_DATA_WIDTH - 1)] == 0) && (((x_reg_for_encoder * 16) + 12) <= (FEATURE_MAP_WIDTH - 1)) ? products_out[(48 + (15 - encoder_to_packer_counter)) * IO_DATA_WIDTH+:IO_DATA_WIDTH] : 0);
	assign products_out_for_encoder[2 * IO_DATA_WIDTH+:IO_DATA_WIDTH] = ((products_out[((32 + (15 - encoder_to_packer_counter)) * IO_DATA_WIDTH) + (IO_DATA_WIDTH - 1)] == 0) && (((x_reg_for_encoder * 16) + 13) <= (FEATURE_MAP_WIDTH - 1)) ? products_out[(32 + (15 - encoder_to_packer_counter)) * IO_DATA_WIDTH+:IO_DATA_WIDTH] : 0);
	assign products_out_for_encoder[IO_DATA_WIDTH+:IO_DATA_WIDTH] = ((products_out[((16 + (15 - encoder_to_packer_counter)) * IO_DATA_WIDTH) + (IO_DATA_WIDTH - 1)] == 0) && (((x_reg_for_encoder * 16) + 14) <= (FEATURE_MAP_WIDTH - 1)) ? products_out[(16 + (15 - encoder_to_packer_counter)) * IO_DATA_WIDTH+:IO_DATA_WIDTH] : 0);
	assign products_out_for_encoder[0+:IO_DATA_WIDTH] = ((products_out[((0 + (15 - encoder_to_packer_counter)) * IO_DATA_WIDTH) + (IO_DATA_WIDTH - 1)] == 0) && (((x_reg_for_encoder * 16) + 15) <= (FEATURE_MAP_WIDTH - 1)) ? products_out[(0 + (15 - encoder_to_packer_counter)) * IO_DATA_WIDTH+:IO_DATA_WIDTH] : 0);
	wire [MEM_BW - 1:0] encoded_output_encoder;
	wire [15:0] masks_output_encoder;
	encoder #(
		.IO_DATA_WIDTH(IO_DATA_WIDTH),
		.MEM_BW(MEM_BW)
	) encoder_0(
		.clk(clk),
		.CE(CE_encoder),
		.to_encode(products_out_for_encoder),
		.mask(masks_output_encoder),
		.encoded(encoded_output_encoder)
	);
	packer #(
		.IO_DATA_WIDTH(IO_DATA_WIDTH),
		.MEM_BW(MEM_BW),
		.ADDR_WIDTH_ACT(ADDR_WIDTH_ACT),
		.ADDR_WIDTH_MASKS(ADDR_WIDTH_MASKS)
	) packer_0(
		.clk(clk),
		.arst_n_in(arst_n_in),
		.masks_in(masks_output_encoder),
		.encoded_in(encoded_output_encoder),
		.encoder_to_packer_counter(encoder_to_packer_counter),
		.start_packer(start_packer),
		.ready_packer(ready_packer),
		.packer_write_control(packer_write_control),
		.write_activations_memory_extra(write_activations_memory_extra),
		.write_masks_memory_extra(write_masks_memory_extra),
		.output_encoded(output_encoded),
		.output_masks(output_masks),
		.outputs_encoded_to_memory_counter(outputs_encoded_to_memory_counter),
		.outputs_masks_to_memory_counter(outputs_masks_to_memory_counter)
	);
	assign out_encoded = activations_out_memory;
	assign out_masks = masks_out_memory;
endmodule
