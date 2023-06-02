module decoder #(
  parameter int IO_DATA_WIDTH = 8,
  parameter int MEM_BW = 128
  )(
    input logic clk,
    input logic CE,
    input logic [2*IO_DATA_WIDTH-1:0] mask,
    input logic [MEM_BW-1:0] to_decode, 
    output logic [7:0] decoded [0:15]);

logic [7:0] counter;
initial begin
    decoded = '{16{8'b0}};
    counter = 8'd127;
end
integer i;
integer j;
always @(posedge clk) begin
    if (CE) begin 
        decoded = '{16{8'b0}};
        counter = 8'd127;
        for (j = 0; j <= 1; j=j+1) begin
            for (i = 7; i >= 0; i=i-1) begin //BIT ITERATION
                if (mask[i+8*(1-j)] != 0) begin
                    decoded[0+j*8][i] = to_decode[counter];
                    decoded[1+j*8][i] = to_decode[counter-1];
                    decoded[2+j*8][i] = to_decode[counter-2];
                    decoded[3+j*8][i] = to_decode[counter-3];
                    decoded[4+j*8][i] = to_decode[counter-4];
                    decoded[5+j*8][i] = to_decode[counter-5];
                    decoded[6+j*8][i] = to_decode[counter-6];
                    decoded[7+j*8][i] = to_decode[counter-7];
                    counter = counter - 8;
                end
            end
        end 
    end    
end  
endmodule
