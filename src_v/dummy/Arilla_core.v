module Arilla_core
(
    input [9:0] D_SW,
    input [2:0] D_BTN,
    input clk,

    output RD,
    output WR,
    output [31:0] ADDR,
    inout [31:0] DATA,

    output [3:0] ByteEna,
    output [31:0] PC,
    output [9:0] DEBUG_OUT
);
    
endmodule