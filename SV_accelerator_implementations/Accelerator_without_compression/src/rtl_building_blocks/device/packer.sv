module packer #(
  parameter int IO_DATA_WIDTH = 8,
  parameter int MEM_BW = 128
  )
  (
  input logic [IO_DATA_WIDTH-1:0] outputs_in [0:15],
  output logic [128-1:0] outputs_out
  );

  logic [MEM_BW-1:0] outputs_out_internal;
  assign outputs_out_internal[MEM_BW - 1 - 8*0: MEM_BW - 8 - 8*0] = outputs_in[0];
  assign outputs_out_internal[MEM_BW - 1 - 8*1: MEM_BW - 8 - 8*1] = outputs_in[1];
  assign outputs_out_internal[MEM_BW - 1 - 8*2: MEM_BW - 8 - 8*2] = outputs_in[2];
  assign outputs_out_internal[MEM_BW - 1 - 8*3: MEM_BW - 8 - 8*3] = outputs_in[3];
  assign outputs_out_internal[MEM_BW - 1 - 8*4: MEM_BW - 8 - 8*4] = outputs_in[4];
  assign outputs_out_internal[MEM_BW - 1 - 8*5: MEM_BW - 8 - 8*5] = outputs_in[5];
  assign outputs_out_internal[MEM_BW - 1 - 8*6: MEM_BW - 8 - 8*6] = outputs_in[6];
  assign outputs_out_internal[MEM_BW - 1 - 8*7: MEM_BW - 8 - 8*7] = outputs_in[7];
  assign outputs_out_internal[MEM_BW - 1 - 8*8: MEM_BW - 8 - 8*8] = outputs_in[8];
  assign outputs_out_internal[MEM_BW - 1 - 8*9: MEM_BW - 8 - 8*9] = outputs_in[9];
  assign outputs_out_internal[MEM_BW - 1 - 8*10: MEM_BW - 8 - 8*10] = outputs_in[10];
  assign outputs_out_internal[MEM_BW - 1 - 8*11: MEM_BW - 8 - 8*11] = outputs_in[11];
  assign outputs_out_internal[MEM_BW - 1 - 8*12: MEM_BW - 8 - 8*12] = outputs_in[12];
  assign outputs_out_internal[MEM_BW - 1 - 8*13: MEM_BW - 8 - 8*13] = outputs_in[13];
  assign outputs_out_internal[MEM_BW - 1 - 8*14: MEM_BW - 8 - 8*14] = outputs_in[14];
  assign outputs_out_internal[MEM_BW - 1 - 8*15: MEM_BW - 8 - 8*15] = outputs_in[15];
  assign outputs_out = outputs_out_internal;
endmodule