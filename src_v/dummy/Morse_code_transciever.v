module Morse_code_transciever
(
    input RD,
    input WR,
    input [31:0] ADDR,
    inout [31:0] DATA,

    input clk,
    input rst_n,

    input IN,
    output OUT,
    output INV,
    output LOOP,
    output SOUND_EN,
    output SOUND_SAMP,
    output [7:0] REC_REG
);

endmodule