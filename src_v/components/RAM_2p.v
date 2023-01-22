module RAM_2p
#(
    parameter BUS_WIDTH = 7,
    parameter DATA_WIDTH = 8
)
(
    input clk,
    input [BUS_WIDTH-1:0]ADDR_R,
    input [BUS_WIDTH-1:0]ADDR_W,
    input WR,
    input [DATA_WIDTH-1:0] DIN,
    output reg [DATA_WIDTH-1:0] DOUT
);

reg [DATA_WIDTH-1:0] mem [(2**BUS_WIDTH)-1:0] /* synthesis ramstyle = M9K */;

always @(posedge clk) begin
    if(WR == 1) 
    begin
        mem[ADDR_W] <= DIN;
    end
    DOUT <= mem[ADDR_R];
end

endmodule