`include "uvm_macros.svh"

import uvm_pkg::*;

class ps2_item extends uvm_sequence_item;
    rand bit [7:0] data;
    bit [31:0] out;

    `uvm_object_utils_begin(ps2_item)
        `uvm_field_int(data, UVM_DEFAULT | UVM_HEX)
        `uvm_field_int(out, UVM_NOPRINT)
    `uvm_object_utils_end

    function new(string name = "ps2_item");
        super.new(name);
    endfunction
endclass
