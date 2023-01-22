module GPU
(
    input [9:0] mX,
    input [9:0] mY,
    input clk,
    input rst_p,

    input RD,
    input WR,
    input [31:0] ADDR,
    inout [31:0] DATA,

    output [22:0] SDRAM_CTL,
    inout [15:0] SDRAM_DATA,
    output [3:0] R,
    output [3:0] G,
    output [3:0] B,
    output HSYNC,
    output VSYNC,
    output VDO_OUT
);

endmodule