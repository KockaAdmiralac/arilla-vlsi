// megafunction wizard: %LPM_MUX%
// GENERATION: STANDARD
// VERSION: WM1.0
// MODULE: LPM_MUX 

// ============================================================
// File Name: MUX4_32.v
// Megafunction Name(s):
// 			LPM_MUX
//
// Simulation Library Files(s):
// 			lpm
// ============================================================
// ************************************************************
// THIS IS A WIZARD-GENERATED FILE. DO NOT EDIT THIS FILE!
//
// 13.1.0 Build 162 10/23/2013 SJ Web Edition
// ************************************************************


//Copyright (C) 1991-2013 Altera Corporation
//Your use of Altera Corporation's design tools, logic functions 
//and other software and tools, and its AMPP partner logic 
//functions, and any output files from any of the foregoing 
//(including device programming or simulation files), and any 
//associated documentation or information are expressly subject 
//to the terms and conditions of the Altera Program License 
//Subscription Agreement, Altera MegaCore Function License 
//Agreement, or other applicable license agreement, including, 
//without limitation, that your use is for the sole purpose of 
//programming logic devices manufactured by Altera and sold by 
//Altera or its authorized distributors.  Please refer to the 
//applicable agreement for further details.


//lpm_mux DEVICE_FAMILY="Cyclone III" LPM_SIZE=4 LPM_WIDTH=32 LPM_WIDTHS=2 data result sel
//VERSION_BEGIN 13.1 cbx_lpm_mux 2013:10:23:18:05:48:SJ cbx_mgl 2013:10:23:18:06:54:SJ  VERSION_END
// synthesis VERILOG_INPUT_VERSION VERILOG_2001
// altera message_off 10463


//synthesis_resources = lut 64 
//synopsys translate_off
`timescale 1 ps / 1 ps
//synopsys translate_on
module  MUX4_32_mux
	( 
	data,
	result,
	sel) /* synthesis synthesis_clearbox=1 */;
	input   [127:0]  data;
	output   [31:0]  result;
	input   [1:0]  sel;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_off
`endif
	tri0   [127:0]  data;
	tri0   [1:0]  sel;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_on
`endif

	wire  [31:0]  result_node;
	wire  [1:0]  sel_node;
	wire  [3:0]  w_data109w;
	wire  [3:0]  w_data134w;
	wire  [3:0]  w_data159w;
	wire  [3:0]  w_data184w;
	wire  [3:0]  w_data209w;
	wire  [3:0]  w_data234w;
	wire  [3:0]  w_data259w;
	wire  [3:0]  w_data284w;
	wire  [3:0]  w_data309w;
	wire  [3:0]  w_data334w;
	wire  [3:0]  w_data34w;
	wire  [3:0]  w_data359w;
	wire  [3:0]  w_data384w;
	wire  [3:0]  w_data409w;
	wire  [3:0]  w_data434w;
	wire  [3:0]  w_data459w;
	wire  [3:0]  w_data484w;
	wire  [3:0]  w_data4w;
	wire  [3:0]  w_data509w;
	wire  [3:0]  w_data534w;
	wire  [3:0]  w_data559w;
	wire  [3:0]  w_data584w;
	wire  [3:0]  w_data59w;
	wire  [3:0]  w_data609w;
	wire  [3:0]  w_data634w;
	wire  [3:0]  w_data659w;
	wire  [3:0]  w_data684w;
	wire  [3:0]  w_data709w;
	wire  [3:0]  w_data734w;
	wire  [3:0]  w_data759w;
	wire  [3:0]  w_data784w;
	wire  [3:0]  w_data84w;

	assign
		result = result_node,
		result_node = {(((w_data784w[1] & sel_node[0]) & (~ (((w_data784w[0] & (~ sel_node[1])) & (~ sel_node[0])) | (sel_node[1] & (sel_node[0] | w_data784w[2]))))) | ((((w_data784w[0] & (~ sel_node[1])) & (~ sel_node[0])) | (sel_node[1] & (sel_node[0] | w_data784w[2]))) & (w_data784w[3] | (~ sel_node[0])))), (((w_data759w[1] & sel_node[0]) & (~ (((w_data759w[0] & (~ sel_node[1])) & (~ sel_node[0])) | (sel_node[1] & (sel_node[0] | w_data759w[2]))))) | ((((w_data759w[0] & (~ sel_node[1])) & (~ sel_node[0])) | (sel_node[1] & (sel_node[0] | w_data759w[2]))) & (w_data759w[3] | (~ sel_node[0])))), (((w_data734w[1] & sel_node[0]) & (~ (((w_data734w[0] & (~ sel_node[1])) & (~ sel_node[0])) | (sel_node[1] & (sel_node[0] | w_data734w[2]))))) | ((((w_data734w[0] & (~ sel_node[1])) & (~ sel_node[0])) | (sel_node[1] & (sel_node[0] | w_data734w[2]))) & (w_data734w[3] | (~ sel_node[0])))), (((w_data709w[1] & sel_node[0]) & (~ (((w_data709w[0] & (~ sel_node[1])) & (~ sel_node[0])) | (sel_node[1] & (sel_node[0] | w_data709w[2]))))) | ((((w_data709w[0] & (~ sel_node[1])) & (~ sel_node[0])) | (sel_node[1] & (sel_node[0] | w_data709w[2]))) & (w_data709w[3] | (~ sel_node[0])))), (((w_data684w[1] & sel_node[0]) & (~ (((w_data684w[0] & (~ sel_node[1])) & (~ sel_node[0])) | (sel_node[1] & (sel_node[0] | w_data684w[2]))))) | ((((w_data684w[0] & (~ sel_node[1])) & (~ sel_node[0])) | (sel_node[1] & (sel_node[0] | w_data684w[2]))) & (w_data684w[3] | (~ sel_node[0])))), (((w_data659w[1] & sel_node[0]) & (~ (((w_data659w[0] & (~ sel_node[1])) & (~ sel_node[0])) | (sel_node[1] & (sel_node[0] | w_data659w[2]))))) | ((((w_data659w[0] & (~ sel_node[1])) & (~ sel_node[0])) | (sel_node[1] & (sel_node[0] | w_data659w[2]))) & (w_data659w[3] | (~ sel_node[0])))), (((w_data634w[1] & sel_node[0]) & (~ (((w_data634w[0] & (~ sel_node[1])) & (~ sel_node[0])) | (sel_node[1] & (sel_node[0] | w_data634w[2]))))) | ((((w_data634w[0] & (~ sel_node[1])) & (~ sel_node[0])) | (sel_node[1] & (sel_node[0] | w_data634w[2]))) & (w_data634w[3] | (~ sel_node[0])))), (((w_data609w[1]
 & sel_node[0]) & (~ (((w_data609w[0] & (~ sel_node[1])) & (~ sel_node[0])) | (sel_node[1] & (sel_node[0] | w_data609w[2]))))) | ((((w_data609w[0] & (~ sel_node[1])) & (~ sel_node[0])) | (sel_node[1] & (sel_node[0] | w_data609w[2]))) & (w_data609w[3] | (~ sel_node[0])))), (((w_data584w[1] & sel_node[0]) & (~ (((w_data584w[0] & (~ sel_node[1])) & (~ sel_node[0])) | (sel_node[1] & (sel_node[0] | w_data584w[2]))))) | ((((w_data584w[0] & (~ sel_node[1])) & (~ sel_node[0])) | (sel_node[1] & (sel_node[0] | w_data584w[2]))) & (w_data584w[3] | (~ sel_node[0])))), (((w_data559w[1] & sel_node[0]) & (~ (((w_data559w[0] & (~ sel_node[1])) & (~ sel_node[0])) | (sel_node[1] & (sel_node[0] | w_data559w[2]))))) | ((((w_data559w[0] & (~ sel_node[1])) & (~ sel_node[0])) | (sel_node[1] & (sel_node[0] | w_data559w[2]))) & (w_data559w[3] | (~ sel_node[0])))), (((w_data534w[1] & sel_node[0]) & (~ (((w_data534w[0] & (~ sel_node[1])) & (~ sel_node[0])) | (sel_node[1] & (sel_node[0] | w_data534w[2]))))) | ((((w_data534w[0] & (~ sel_node[1])) & (~ sel_node[0])) | (sel_node[1] & (sel_node[0] | w_data534w[2]))) & (w_data534w[3] | (~ sel_node[0])))), (((w_data509w[1] & sel_node[0]) & (~ (((w_data509w[0] & (~ sel_node[1])) & (~ sel_node[0])) | (sel_node[1] & (sel_node[0] | w_data509w[2]))))) | ((((w_data509w[0] & (~ sel_node[1])) & (~ sel_node[0])) | (sel_node[1] & (sel_node[0] | w_data509w[2]))) & (w_data509w[3] | (~ sel_node[0])))), (((w_data484w[1] & sel_node[0]) & (~ (((w_data484w[0] & (~ sel_node[1])) & (~ sel_node[0])) | (sel_node[1] & (sel_node[0] | w_data484w[2]))))) | ((((w_data484w[0] & (~ sel_node[1])) & (~ sel_node[0])) | (sel_node[1] & (sel_node[0] | w_data484w[2]))) & (w_data484w[3] | (~ sel_node[0])))), (((w_data459w[1] & sel_node[0]) & (~ (((w_data459w[0] & (~ sel_node[1])) & (~ sel_node[0])) | (sel_node[1] & (sel_node[0] | w_data459w[2]))))) | ((((w_data459w[0] & (~ sel_node[1])) & (~ sel_node[0])) | (sel_node[1] & (sel_node[0] | w_data459w[2]))) & (w_data459w[3] | (~ sel_node[0])))), (((w_data434w[1] & sel_node[0]) & (~ (((w_data434w[0]
 & (~ sel_node[1])) & (~ sel_node[0])) | (sel_node[1] & (sel_node[0] | w_data434w[2]))))) | ((((w_data434w[0] & (~ sel_node[1])) & (~ sel_node[0])) | (sel_node[1] & (sel_node[0] | w_data434w[2]))) & (w_data434w[3] | (~ sel_node[0])))), (((w_data409w[1] & sel_node[0]) & (~ (((w_data409w[0] & (~ sel_node[1])) & (~ sel_node[0])) | (sel_node[1] & (sel_node[0] | w_data409w[2]))))) | ((((w_data409w[0] & (~ sel_node[1])) & (~ sel_node[0])) | (sel_node[1] & (sel_node[0] | w_data409w[2]))) & (w_data409w[3] | (~ sel_node[0])))), (((w_data384w[1] & sel_node[0]) & (~ (((w_data384w[0] & (~ sel_node[1])) & (~ sel_node[0])) | (sel_node[1] & (sel_node[0] | w_data384w[2]))))) | ((((w_data384w[0] & (~ sel_node[1])) & (~ sel_node[0])) | (sel_node[1] & (sel_node[0] | w_data384w[2]))) & (w_data384w[3] | (~ sel_node[0])))), (((w_data359w[1] & sel_node[0]) & (~ (((w_data359w[0] & (~ sel_node[1])) & (~ sel_node[0])) | (sel_node[1] & (sel_node[0] | w_data359w[2]))))) | ((((w_data359w[0] & (~ sel_node[1])) & (~ sel_node[0])) | (sel_node[1] & (sel_node[0] | w_data359w[2]))) & (w_data359w[3] | (~ sel_node[0])))), (((w_data334w[1] & sel_node[0]) & (~ (((w_data334w[0] & (~ sel_node[1])) & (~ sel_node[0])) | (sel_node[1] & (sel_node[0] | w_data334w[2]))))) | ((((w_data334w[0] & (~ sel_node[1])) & (~ sel_node[0])) | (sel_node[1] & (sel_node[0] | w_data334w[2]))) & (w_data334w[3] | (~ sel_node[0])))), (((w_data309w[1] & sel_node[0]) & (~ (((w_data309w[0] & (~ sel_node[1])) & (~ sel_node[0])) | (sel_node[1] & (sel_node[0] | w_data309w[2]))))) | ((((w_data309w[0] & (~ sel_node[1])) & (~ sel_node[0])) | (sel_node[1] & (sel_node[0] | w_data309w[2]))) & (w_data309w[3] | (~ sel_node[0])))), (((w_data284w[1] & sel_node[0]) & (~ (((w_data284w[0] & (~ sel_node[1])) & (~ sel_node[0])) | (sel_node[1] & (sel_node[0] | w_data284w[2]))))) | ((((w_data284w[0] & (~ sel_node[1])) & (~ sel_node[0])) | (sel_node[1] & (sel_node[0] | w_data284w[2]))) & (w_data284w[3] | (~ sel_node[0])))), (((w_data259w[1] & sel_node[0]) & (~ (((w_data259w[0] & (~ sel_node[1])) & (~ sel_node[0]
)) | (sel_node[1] & (sel_node[0] | w_data259w[2]))))) | ((((w_data259w[0] & (~ sel_node[1])) & (~ sel_node[0])) | (sel_node[1] & (sel_node[0] | w_data259w[2]))) & (w_data259w[3] | (~ sel_node[0])))), (((w_data234w[1] & sel_node[0]) & (~ (((w_data234w[0] & (~ sel_node[1])) & (~ sel_node[0])) | (sel_node[1] & (sel_node[0] | w_data234w[2]))))) | ((((w_data234w[0] & (~ sel_node[1])) & (~ sel_node[0])) | (sel_node[1] & (sel_node[0] | w_data234w[2]))) & (w_data234w[3] | (~ sel_node[0])))), (((w_data209w[1] & sel_node[0]) & (~ (((w_data209w[0] & (~ sel_node[1])) & (~ sel_node[0])) | (sel_node[1] & (sel_node[0] | w_data209w[2]))))) | ((((w_data209w[0] & (~ sel_node[1])) & (~ sel_node[0])) | (sel_node[1] & (sel_node[0] | w_data209w[2]))) & (w_data209w[3] | (~ sel_node[0])))), (((w_data184w[1] & sel_node[0]) & (~ (((w_data184w[0] & (~ sel_node[1])) & (~ sel_node[0])) | (sel_node[1] & (sel_node[0] | w_data184w[2]))))) | ((((w_data184w[0] & (~ sel_node[1])) & (~ sel_node[0])) | (sel_node[1] & (sel_node[0] | w_data184w[2]))) & (w_data184w[3] | (~ sel_node[0])))), (((w_data159w[1] & sel_node[0]) & (~ (((w_data159w[0] & (~ sel_node[1])) & (~ sel_node[0])) | (sel_node[1] & (sel_node[0] | w_data159w[2]))))) | ((((w_data159w[0] & (~ sel_node[1])) & (~ sel_node[0])) | (sel_node[1] & (sel_node[0] | w_data159w[2]))) & (w_data159w[3] | (~ sel_node[0])))), (((w_data134w[1] & sel_node[0]) & (~ (((w_data134w[0] & (~ sel_node[1])) & (~ sel_node[0])) | (sel_node[1] & (sel_node[0] | w_data134w[2]))))) | ((((w_data134w[0] & (~ sel_node[1])) & (~ sel_node[0])) | (sel_node[1] & (sel_node[0] | w_data134w[2]))) & (w_data134w[3] | (~ sel_node[0])))), (((w_data109w[1] & sel_node[0]) & (~ (((w_data109w[0] & (~ sel_node[1])) & (~ sel_node[0])) | (sel_node[1] & (sel_node[0] | w_data109w[2]))))) | ((((w_data109w[0] & (~ sel_node[1])) & (~ sel_node[0])) | (sel_node[1] & (sel_node[0] | w_data109w[2]))) & (w_data109w[3] | (~ sel_node[0])))), (((w_data84w[1] & sel_node[0]) & (~ (((w_data84w[0] & (~ sel_node[1])) & (~ sel_node[0])) | (sel_node[1] & (sel_node[0]
 | w_data84w[2]))))) | ((((w_data84w[0] & (~ sel_node[1])) & (~ sel_node[0])) | (sel_node[1] & (sel_node[0] | w_data84w[2]))) & (w_data84w[3] | (~ sel_node[0])))), (((w_data59w[1] & sel_node[0]) & (~ (((w_data59w[0] & (~ sel_node[1])) & (~ sel_node[0])) | (sel_node[1] & (sel_node[0] | w_data59w[2]))))) | ((((w_data59w[0] & (~ sel_node[1])) & (~ sel_node[0])) | (sel_node[1] & (sel_node[0] | w_data59w[2]))) & (w_data59w[3] | (~ sel_node[0])))), (((w_data34w[1] & sel_node[0]) & (~ (((w_data34w[0] & (~ sel_node[1])) & (~ sel_node[0])) | (sel_node[1] & (sel_node[0] | w_data34w[2]))))) | ((((w_data34w[0] & (~ sel_node[1])) & (~ sel_node[0])) | (sel_node[1] & (sel_node[0] | w_data34w[2]))) & (w_data34w[3] | (~ sel_node[0])))), (((w_data4w[1] & sel_node[0]) & (~ (((w_data4w[0] & (~ sel_node[1])) & (~ sel_node[0])) | (sel_node[1] & (sel_node[0] | w_data4w[2]))))) | ((((w_data4w[0] & (~ sel_node[1])) & (~ sel_node[0])) | (sel_node[1] & (sel_node[0] | w_data4w[2]))) & (w_data4w[3] | (~ sel_node[0]))))},
		sel_node = {sel[1:0]},
		w_data109w = {data[100], data[68], data[36], data[4]},
		w_data134w = {data[101], data[69], data[37], data[5]},
		w_data159w = {data[102], data[70], data[38], data[6]},
		w_data184w = {data[103], data[71], data[39], data[7]},
		w_data209w = {data[104], data[72], data[40], data[8]},
		w_data234w = {data[105], data[73], data[41], data[9]},
		w_data259w = {data[106], data[74], data[42], data[10]},
		w_data284w = {data[107], data[75], data[43], data[11]},
		w_data309w = {data[108], data[76], data[44], data[12]},
		w_data334w = {data[109], data[77], data[45], data[13]},
		w_data34w = {data[97], data[65], data[33], data[1]},
		w_data359w = {data[110], data[78], data[46], data[14]},
		w_data384w = {data[111], data[79], data[47], data[15]},
		w_data409w = {data[112], data[80], data[48], data[16]},
		w_data434w = {data[113], data[81], data[49], data[17]},
		w_data459w = {data[114], data[82], data[50], data[18]},
		w_data484w = {data[115], data[83], data[51], data[19]},
		w_data4w = {data[96], data[64], data[32], data[0]},
		w_data509w = {data[116], data[84], data[52], data[20]},
		w_data534w = {data[117], data[85], data[53], data[21]},
		w_data559w = {data[118], data[86], data[54], data[22]},
		w_data584w = {data[119], data[87], data[55], data[23]},
		w_data59w = {data[98], data[66], data[34], data[2]},
		w_data609w = {data[120], data[88], data[56], data[24]},
		w_data634w = {data[121], data[89], data[57], data[25]},
		w_data659w = {data[122], data[90], data[58], data[26]},
		w_data684w = {data[123], data[91], data[59], data[27]},
		w_data709w = {data[124], data[92], data[60], data[28]},
		w_data734w = {data[125], data[93], data[61], data[29]},
		w_data759w = {data[126], data[94], data[62], data[30]},
		w_data784w = {data[127], data[95], data[63], data[31]},
		w_data84w = {data[99], data[67], data[35], data[3]};
endmodule //MUX4_32_mux
//VALID FILE


// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on
module MUX4_32 (
	data0x,
	data1x,
	data2x,
	data3x,
	sel,
	result)/* synthesis synthesis_clearbox = 1 */;

	input	[31:0]  data0x;
	input	[31:0]  data1x;
	input	[31:0]  data2x;
	input	[31:0]  data3x;
	input	[1:0]  sel;
	output	[31:0]  result;

	wire [31:0] sub_wire0;
	wire [31:0] sub_wire5 = data0x[31:0];
	wire [31:0] sub_wire4 = data1x[31:0];
	wire [31:0] sub_wire3 = data2x[31:0];
	wire [31:0] result = sub_wire0[31:0];
	wire [31:0] sub_wire1 = data3x[31:0];
	wire [127:0] sub_wire2 = {sub_wire5, sub_wire4, sub_wire3, sub_wire1};

	MUX4_32_mux	MUX4_32_mux_component (
				.data (sub_wire2),
				.sel (sel),
				.result (sub_wire0));

endmodule

// ============================================================
// CNX file retrieval info
// ============================================================
// Retrieval info: PRIVATE: INTENDED_DEVICE_FAMILY STRING "Cyclone III"
// Retrieval info: PRIVATE: SYNTH_WRAPPER_GEN_POSTFIX STRING "1"
// Retrieval info: PRIVATE: new_diagram STRING "1"
// Retrieval info: LIBRARY: lpm lpm.lpm_components.all
// Retrieval info: CONSTANT: LPM_SIZE NUMERIC "4"
// Retrieval info: CONSTANT: LPM_TYPE STRING "LPM_MUX"
// Retrieval info: CONSTANT: LPM_WIDTH NUMERIC "32"
// Retrieval info: CONSTANT: LPM_WIDTHS NUMERIC "2"
// Retrieval info: USED_PORT: data0x 0 0 32 0 INPUT NODEFVAL "data0x[31..0]"
// Retrieval info: USED_PORT: data1x 0 0 32 0 INPUT NODEFVAL "data1x[31..0]"
// Retrieval info: USED_PORT: data2x 0 0 32 0 INPUT NODEFVAL "data2x[31..0]"
// Retrieval info: USED_PORT: data3x 0 0 32 0 INPUT NODEFVAL "data3x[31..0]"
// Retrieval info: USED_PORT: result 0 0 32 0 OUTPUT NODEFVAL "result[31..0]"
// Retrieval info: USED_PORT: sel 0 0 2 0 INPUT NODEFVAL "sel[1..0]"
// Retrieval info: CONNECT: @data 1 0 32 0 data0x 0 0 32 0
// Retrieval info: CONNECT: @data 1 1 32 0 data1x 0 0 32 0
// Retrieval info: CONNECT: @data 1 2 32 0 data2x 0 0 32 0
// Retrieval info: CONNECT: @data 1 3 32 0 data3x 0 0 32 0
// Retrieval info: CONNECT: @sel 0 0 2 0 sel 0 0 2 0
// Retrieval info: CONNECT: result 0 0 32 0 @result 0 0 32 0
// Retrieval info: GEN_FILE: TYPE_NORMAL MUX4_32.tdf TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL MUX4_32.inc TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL MUX4_32.cmp FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL MUX4_32.bsf TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL MUX4_32_inst.tdf FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL MUX4_32_syn.v TRUE
// Retrieval info: LIB_FILE: lpm
