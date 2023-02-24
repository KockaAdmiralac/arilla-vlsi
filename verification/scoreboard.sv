`include "uvm_macros.svh"

import uvm_pkg::*;

class scoreboard extends uvm_scoreboard;
    `uvm_component_utils(scoreboard)

    function new(string name = "scoreboard", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    uvm_analysis_imp #(ps2_item, scoreboard) mon_analysis_imp;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        mon_analysis_imp = new("mon_analysis_imp", this);
    endfunction

    bit [31:0] ps2_out = 32'h00000000;

    virtual function write(ps2_item item);
        if (ps2_out[7:0] == 8'hF0 || ps2_out[7:0] == 8'hE0) begin
            ps2_out = {16'h0000, ps2_out[7:0], item.data};
        end else begin
            ps2_out = {24'h000000, item.data};
        end
        if (ps2_out == item.out) begin
            `uvm_info("Scoreboard", $sformatf("PASS! Data: %h", ps2_out), UVM_LOW);
        end else begin
            `uvm_error("Scoreboard", $sformatf("FAIL! Expected: %h, got: %h", ps2_out, item.out));
        end
    endfunction
endclass
