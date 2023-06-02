module count_ones #(
    parameter int MEM_BW = 128
  )(
  input logic [MEM_BW-1:0] input_word,
  output logic [$clog2(MEM_BW):0] output_count
);

int count;

  always @(*) begin
    count = 0;
    for (int i = 0; i < MEM_BW; i = i + 1) begin
      count = count + input_word[i];
    end
    output_count = count;
  end
endmodule