module FIFO
#(
    parameter BUS_WIDTH = 7,
    parameter DATA_WIDTH = 8
)
(
    input clk,
    input rst_n,
    input RD,
    input WR,
    input [DATA_WIDTH-1:0] DIN,
    output [DATA_WIDTH-1:0] DOUT,
    output full,
    output notEmpty
);



reg [BUS_WIDTH-1:0] writeCnt;
reg [BUS_WIDTH-1:0] readCnt;
reg [BUS_WIDTH:0] count;

assign full = count == (2**BUS_WIDTH);
assign notEmpty = count != 0;

endmodule