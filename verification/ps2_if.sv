`include "uvm_macros.svh"

import uvm_pkg::*;

interface ps2_if(
	input bit clk,
	input bit ps2clk
);
	logic rst_n;
	logic ps2dat;
	logic [31:0] out;
endinterface
