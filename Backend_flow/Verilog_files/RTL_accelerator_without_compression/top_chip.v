module top_chip (
	clk,
	arst_n_in,
	activations_input,
	activations_valid,
	activations_ready,
	weights_input,
	weights_valid,
	weights_ready,
	out,
	output_valid,
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
	parameter signed [31:0] ADDR_WIDTH_WEIGHTS = 12;
	input wire clk;
	input wire arst_n_in;
	input wire [MEM_BW - 1:0] activations_input;
	input wire activations_valid;
	output wire activations_ready;
	input wire [MEM_BW - 1:0] weights_input;
	input wire weights_valid;
	output wire weights_ready;
	output wire [MEM_BW - 1:0] out;
	output wire output_valid;
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
	wire write_weights_memory;
	wire read_weights_memory;
	wire [ADDR_WIDTH_WEIGHTS - 1:0] address_weights;
	wire mac_valid;
	wire mac_accumulate_internal;
	wire [3:0] mem_transfer_counter;
	wire extra_word_write_valid;
	wire extra_word_write_ready;
	wire extra_word_read_valid;
	wire extra_word_read_ready;
	wire write_extra_word_in_register;
	wire extra_word_from_FIFO;
	wire end_x_padding;
	wire reset_fifo;
	wire outputs_to_memory_flag;
	controller_fsm #(
		.FEATURE_MAP_WIDTH(FEATURE_MAP_WIDTH),
		.FEATURE_MAP_HEIGHT(FEATURE_MAP_HEIGHT),
		.INPUT_NB_CHANNELS(INPUT_NB_CHANNELS),
		.OUTPUT_NB_CHANNELS(OUTPUT_NB_CHANNELS),
		.KERNEL_SIZE(KERNEL_SIZE),
		.MEM_BW(MEM_BW),
		.ADDR_WIDTH_ACT(ADDR_WIDTH_ACT),
		.ADDR_WIDTH_WEIGHTS(ADDR_WIDTH_WEIGHTS)
	) controller(
		.clk(clk),
		.arst_n_in(arst_n_in),
		.start(start),
		.running(running),
		.activations_valid(activations_valid),
		.activations_ready(activations_ready),
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
		.output_valid(output_valid),
		.outputs_transferred_to_memory(mem_transfer_counter),
		.outputs_to_memory_flag(outputs_to_memory_flag),
		.extra_word_write_valid(extra_word_write_valid),
		.extra_word_write_ready(extra_word_write_ready),
		.extra_word_read_valid(extra_word_read_valid),
		.extra_word_read_ready(extra_word_read_ready),
		.write_extra_word_in_register(write_extra_word_in_register),
		.extra_word_from_FIFO(extra_word_from_FIFO),
		.end_x_padding(end_x_padding),
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
	wire [MEM_BW - 1:0] activations_memory_input;
	wire [MEM_BW - 1:0] activations_out_memory_internal [0:31];
	generate
		for (k = 0; k < 32; k = k + 1) begin : genblk2
			sky130_sram_1r1w_128x512_128 sram_activations_banks(
				.clk0(clk),
				.csb0(write_activations_memory || (k != address_activations_writing[ADDR_WIDTH_ACT - 1:ADDR_WIDTH_ACT - 5])),
				.addr0(address_activations_writing[ADDR_WIDTH_ACT - 6:0]),
				.din0(activations_memory_input),
				.clk1(clk),
				.csb1(read_activations_memory || (k != address_activations_reading[ADDR_WIDTH_ACT - 1:ADDR_WIDTH_ACT - 5])),
				.addr1(address_activations_reading[ADDR_WIDTH_ACT - 6:0]),
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
	assign address_activations_select_delay_next = address_activations_reading[ADDR_WIDTH_ACT - 1:ADDR_WIDTH_ACT - 5];
	assign address_activations_select_delay_we = 1;
	wire [MEM_BW - 1:0] activations_out_memory;
	assign activations_out_memory = activations_out_memory_internal[address_activations_select_delay];
	wire [((MEM_BW / IO_DATA_WIDTH) * IO_DATA_WIDTH) - 1:0] activations_out_driver;
	driver_activations #(
		.IO_DATA_WIDTH(IO_DATA_WIDTH),
		.MEM_BW(MEM_BW)
	) driver_activations_0(
		.activations_input(activations_out_memory),
		.activations_output(activations_out_driver)
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
		.din(activations_out_driver[((MEM_BW / IO_DATA_WIDTH) - 16) * IO_DATA_WIDTH+:IO_DATA_WIDTH]),
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
		for (j = 1; j >= 0; j = j - 1) begin : genblk3
			for (i = 15; i >= 0; i = i - 1) begin : genblk1
				if (j == 1) begin : genblk1
					if (i == 15) begin : genblk1
						register #(.WIDTH(IO_DATA_WIDTH)) shift_reg(
							.clk(clk),
							.arst_n_in(arst_n_in),
							.din((end_x_padding ? 8'h00 : (shift ? 8'h00 : activations_out_driver[(((MEM_BW / IO_DATA_WIDTH) - 1) - i) * IO_DATA_WIDTH+:IO_DATA_WIDTH]))),
							.qout(activation_registers[j][(15 - i) * IO_DATA_WIDTH+:IO_DATA_WIDTH]),
							.we(write_activations_registers_second)
						);
					end
					else if (i == 0) begin : genblk1
						register #(.WIDTH(IO_DATA_WIDTH)) shift_reg(
							.clk(clk),
							.arst_n_in(arst_n_in),
							.din((write_activations_registers_first ? (shift ? activation_registers[j][(15 - (i + 1)) * IO_DATA_WIDTH+:IO_DATA_WIDTH] : activations_out_driver[((MEM_BW / IO_DATA_WIDTH) - 16) * IO_DATA_WIDTH+:IO_DATA_WIDTH]) : (end_x_padding ? 8'h00 : activations_out_driver[(((MEM_BW / IO_DATA_WIDTH) - 1) - i) * IO_DATA_WIDTH+:IO_DATA_WIDTH]))),
							.qout(activation_registers[j][(15 - i) * IO_DATA_WIDTH+:IO_DATA_WIDTH]),
							.we(write_activations_registers_first || write_activations_registers_second)
						);
					end
					else begin : genblk1
						register #(.WIDTH(IO_DATA_WIDTH)) shift_reg(
							.clk(clk),
							.arst_n_in(arst_n_in),
							.din((end_x_padding ? 8'h00 : (shift ? activation_registers[j][(15 - (i + 1)) * IO_DATA_WIDTH+:IO_DATA_WIDTH] : activations_out_driver[(((MEM_BW / IO_DATA_WIDTH) - 1) - i) * IO_DATA_WIDTH+:IO_DATA_WIDTH]))),
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
							.din((shift ? activation_registers[j + 1][15 * IO_DATA_WIDTH+:IO_DATA_WIDTH] : activations_out_driver[(((MEM_BW / IO_DATA_WIDTH) - 1) - (i - 1)) * IO_DATA_WIDTH+:IO_DATA_WIDTH])),
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
							.din((shift ? activation_registers[j][(15 - (i + 1)) * IO_DATA_WIDTH+:IO_DATA_WIDTH] : activations_out_driver[(((MEM_BW / IO_DATA_WIDTH) - 1) - (i - 1)) * IO_DATA_WIDTH+:IO_DATA_WIDTH])),
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
		for (k = 0; k < 16; k = k + 1) begin : genblk4
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
	wire [(16 * IO_DATA_WIDTH) - 1:0] products_out_for_packer;
	assign products_out_for_packer[15 * IO_DATA_WIDTH+:IO_DATA_WIDTH] = (products_out[((240 + (15 - mem_transfer_counter)) * IO_DATA_WIDTH) + (IO_DATA_WIDTH - 1)] == 0 ? products_out[(240 + (15 - mem_transfer_counter)) * IO_DATA_WIDTH+:IO_DATA_WIDTH] : 0);
	assign products_out_for_packer[14 * IO_DATA_WIDTH+:IO_DATA_WIDTH] = (products_out[((224 + (15 - mem_transfer_counter)) * IO_DATA_WIDTH) + (IO_DATA_WIDTH - 1)] == 0 ? products_out[(224 + (15 - mem_transfer_counter)) * IO_DATA_WIDTH+:IO_DATA_WIDTH] : 0);
	assign products_out_for_packer[13 * IO_DATA_WIDTH+:IO_DATA_WIDTH] = (products_out[((208 + (15 - mem_transfer_counter)) * IO_DATA_WIDTH) + (IO_DATA_WIDTH - 1)] == 0 ? products_out[(208 + (15 - mem_transfer_counter)) * IO_DATA_WIDTH+:IO_DATA_WIDTH] : 0);
	assign products_out_for_packer[12 * IO_DATA_WIDTH+:IO_DATA_WIDTH] = (products_out[((192 + (15 - mem_transfer_counter)) * IO_DATA_WIDTH) + (IO_DATA_WIDTH - 1)] == 0 ? products_out[(192 + (15 - mem_transfer_counter)) * IO_DATA_WIDTH+:IO_DATA_WIDTH] : 0);
	assign products_out_for_packer[11 * IO_DATA_WIDTH+:IO_DATA_WIDTH] = (products_out[((176 + (15 - mem_transfer_counter)) * IO_DATA_WIDTH) + (IO_DATA_WIDTH - 1)] == 0 ? products_out[(176 + (15 - mem_transfer_counter)) * IO_DATA_WIDTH+:IO_DATA_WIDTH] : 0);
	assign products_out_for_packer[10 * IO_DATA_WIDTH+:IO_DATA_WIDTH] = (products_out[((160 + (15 - mem_transfer_counter)) * IO_DATA_WIDTH) + (IO_DATA_WIDTH - 1)] == 0 ? products_out[(160 + (15 - mem_transfer_counter)) * IO_DATA_WIDTH+:IO_DATA_WIDTH] : 0);
	assign products_out_for_packer[9 * IO_DATA_WIDTH+:IO_DATA_WIDTH] = (products_out[((144 + (15 - mem_transfer_counter)) * IO_DATA_WIDTH) + (IO_DATA_WIDTH - 1)] == 0 ? products_out[(144 + (15 - mem_transfer_counter)) * IO_DATA_WIDTH+:IO_DATA_WIDTH] : 0);
	assign products_out_for_packer[8 * IO_DATA_WIDTH+:IO_DATA_WIDTH] = (products_out[((128 + (15 - mem_transfer_counter)) * IO_DATA_WIDTH) + (IO_DATA_WIDTH - 1)] == 0 ? products_out[(128 + (15 - mem_transfer_counter)) * IO_DATA_WIDTH+:IO_DATA_WIDTH] : 0);
	assign products_out_for_packer[7 * IO_DATA_WIDTH+:IO_DATA_WIDTH] = (products_out[((112 + (15 - mem_transfer_counter)) * IO_DATA_WIDTH) + (IO_DATA_WIDTH - 1)] == 0 ? products_out[(112 + (15 - mem_transfer_counter)) * IO_DATA_WIDTH+:IO_DATA_WIDTH] : 0);
	assign products_out_for_packer[6 * IO_DATA_WIDTH+:IO_DATA_WIDTH] = (products_out[((96 + (15 - mem_transfer_counter)) * IO_DATA_WIDTH) + (IO_DATA_WIDTH - 1)] == 0 ? products_out[(96 + (15 - mem_transfer_counter)) * IO_DATA_WIDTH+:IO_DATA_WIDTH] : 0);
	assign products_out_for_packer[5 * IO_DATA_WIDTH+:IO_DATA_WIDTH] = (products_out[((80 + (15 - mem_transfer_counter)) * IO_DATA_WIDTH) + (IO_DATA_WIDTH - 1)] == 0 ? products_out[(80 + (15 - mem_transfer_counter)) * IO_DATA_WIDTH+:IO_DATA_WIDTH] : 0);
	assign products_out_for_packer[4 * IO_DATA_WIDTH+:IO_DATA_WIDTH] = (products_out[((64 + (15 - mem_transfer_counter)) * IO_DATA_WIDTH) + (IO_DATA_WIDTH - 1)] == 0 ? products_out[(64 + (15 - mem_transfer_counter)) * IO_DATA_WIDTH+:IO_DATA_WIDTH] : 0);
	assign products_out_for_packer[3 * IO_DATA_WIDTH+:IO_DATA_WIDTH] = (products_out[((48 + (15 - mem_transfer_counter)) * IO_DATA_WIDTH) + (IO_DATA_WIDTH - 1)] == 0 ? products_out[(48 + (15 - mem_transfer_counter)) * IO_DATA_WIDTH+:IO_DATA_WIDTH] : 0);
	assign products_out_for_packer[2 * IO_DATA_WIDTH+:IO_DATA_WIDTH] = (products_out[((32 + (15 - mem_transfer_counter)) * IO_DATA_WIDTH) + (IO_DATA_WIDTH - 1)] == 0 ? products_out[(32 + (15 - mem_transfer_counter)) * IO_DATA_WIDTH+:IO_DATA_WIDTH] : 0);
	assign products_out_for_packer[IO_DATA_WIDTH+:IO_DATA_WIDTH] = (products_out[((16 + (15 - mem_transfer_counter)) * IO_DATA_WIDTH) + (IO_DATA_WIDTH - 1)] == 0 ? products_out[(16 + (15 - mem_transfer_counter)) * IO_DATA_WIDTH+:IO_DATA_WIDTH] : 0);
	assign products_out_for_packer[0+:IO_DATA_WIDTH] = (products_out[((0 + (15 - mem_transfer_counter)) * IO_DATA_WIDTH) + (IO_DATA_WIDTH - 1)] == 0 ? products_out[(0 + (15 - mem_transfer_counter)) * IO_DATA_WIDTH+:IO_DATA_WIDTH] : 0);
	wire [MEM_BW - 1:0] packed_data;
	packer #(
		.IO_DATA_WIDTH(IO_DATA_WIDTH),
		.MEM_BW(MEM_BW)
	) packer_0(
		.outputs_in(products_out_for_packer),
		.outputs_out(packed_data)
	);
	assign activations_memory_input = (outputs_to_memory_flag ? packed_data : activations_input);
	assign out = activations_out_memory;
endmodule
