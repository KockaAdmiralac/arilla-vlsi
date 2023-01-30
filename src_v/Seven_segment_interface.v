module seven_segment_interface
(
	input  [23:0] pc,
	input  [23:0] key_code,
	input  seven_segment_select,
	output [41:0] hex
);

wire [23:0] val;

//option 0 core program counter
//option 1 keyboard key code
assign val = seven_segment_select ? key_code : pc;

single_hex_interface hex0(val[3 : 0],hex[ 6: 0]);
single_hex_interface hex1(val[7 : 4],hex[13: 7]);
single_hex_interface hex2(val[11: 8],hex[20:14]);
single_hex_interface hex3(val[15:12],hex[27:21]);
single_hex_interface hex4(val[19:16],hex[34:28]);
single_hex_interface hex5(val[23:20],hex[41:35]);

endmodule