module Seven_segment_interface
(
    input [23:0] PC,
    input [23:0] K_CD,
    input pc_n,
    output [47:0] HEX
);

wire [23:0] val;

assign val = pc_n ? K_CD : PC;

Single_hex_interface hex0(val[3 : 0],HEX[ 7: 0]);
Single_hex_interface hex1(val[7 : 4],HEX[15: 8]);
Single_hex_interface hex2(val[11: 8],HEX[23:16]);
Single_hex_interface hex3(val[15:12],HEX[31:24]);
Single_hex_interface hex4(val[19:16],HEX[39:32]);
Single_hex_interface hex5(val[23:20],HEX[47:40]);

endmodule