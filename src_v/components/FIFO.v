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

RAM_2p #(
    .BUS_WIDTH                (7),
    .DATA_WIDTH               (8)
) u_RAM_2p (
    .clk                      (clk),
    .ADDR_R                   (readCnt),
    .ADDR_W                   (writeCnt),
    .WR                       (WR),
    .DIN                      (DIN),
    .DOUT                     (DOUT)
);

always @(posedge clk, negedge rst_n) begin
    if(!rst_n)
    begin
        writeCnt <= {BUS_WIDTH{1'b0}};
        readCnt <= {BUS_WIDTH{1'b0}};
        count <= {BUS_WIDTH+1{1'b0}};
    end
    else 
    begin
        if(RD && WR)
        begin
            readCnt <= readCnt + 1;
            writeCnt <= writeCnt + 1;
        end
        else if(RD)
        begin
            readCnt <= readCnt + 1;
            count <= count - 1;
        end
        else if(WR)
        begin
            writeCnt <= writeCnt + 1;
            count <= count + 1;
        end
    end
end

endmodule