module encoder#(
  parameter int IO_DATA_WIDTH = 16,
  parameter int MEM_BW = 128
  )(
    input logic clk,
    input logic CE,
    input logic [7:0] to_encode [0:15], 
    output logic [15:0] mask,
    output logic [MEM_BW-1:0] encoded);

logic [7:0] counter;
logic [4:0] count_ones;
initial begin
    mask = 0;
    encoded = 0;
    counter = 8'd127;
    count_ones = 0;
end

integer i;
integer j;
integer k; 
always @(posedge clk) begin
    if (CE) begin 
        mask = 0;
        encoded = 0;
        counter = 8'd127;
        count_ones = 0;
        for (k = 0; k <= 1; k=k+1) begin 
            for (i = 7; i >= 0; i=i-1) begin //BIT ITERATION
                //for (j=0; j < 8; j=j+1) begin //WORD ITERATION
                    if (to_encode[0+k*8][i] || to_encode[1+k*8][i] || to_encode[2+k*8][i] || to_encode[3+k*8][i] || to_encode[4+k*8][i] || to_encode[5+k*8][i] || to_encode[6+k*8][i] || to_encode[7+k*8][i]) begin
                        mask[i+8*(1-k)] = 1; 
                        encoded[counter] = to_encode[0+k*8][i];
                        encoded[counter-1] = to_encode[1+k*8][i];
                        encoded[counter-2] = to_encode[2+k*8][i];
                        encoded[counter-3] = to_encode[3+k*8][i];
                        encoded[counter-4] = to_encode[4+k*8][i];
                        encoded[counter-5] = to_encode[5+k*8][i];
                        encoded[counter-6] = to_encode[6+k*8][i];
                        encoded[counter-7] = to_encode[7+k*8][i];
                        counter = counter - 8;
                    end
                //end
            end 
        end
    end    
end
endmodule