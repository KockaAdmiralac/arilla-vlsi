module VGA_adapter
(
    input [3:0] R,
    input [3:0] G,
    input [3:0] B,
    input HSYNC,
    input VSYNC,
    input VDO_OUT,
    input clk,
    output [7:0] VGA_R,
    output [7:0] VGA_G,
    output [7:0] VGA_B,
    output VGA_HSYNC,
    output VGA_VSYNC,
    output VGA_CLK,
    output VGA_BLANK_N,
    output VGA_SYNC_N
);

assign VGA_R = {R,R};
assign VGA_G = {G,G};
assign VGA_B = {B,B};

assign VGA_HSYNC = HSYNC;
assign VGA_VSYNC = VSYNC;
assign VGA_CLK = clk;
assign VGA_BLANK_N = VDO_OUT;
assign VGA_SYNC_N = 0;

endmodule