`include "uvm_macros.svh"

import uvm_pkg::*;

class monitor extends uvm_monitor;
    `uvm_component_utils(monitor)

    function new(string name = "monitor", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual ps2_if vif;
    uvm_analysis_port #(ps2_item) mon_analysis_port;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual ps2_if)::get(this, "", "ps2_vif", vif)) begin
            `uvm_fatal("Monitor", "No interface found.")
        end
        mon_analysis_port = new("mon_analysis_port", this);
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        @(negedge vif.ps2clk);
        @(posedge vif.clk);
        forever begin
            ps2_item item = ps2_item::type_id::create("item");
            for (int i = 0; i < 11; i++) begin
                if (i >= 1 && i <= 8) begin
                    item.data[i-1] = vif.ps2dat;
                end
                @(negedge vif.ps2clk);
                @(posedge vif.clk);
            end
            item.out = vif.out;
            mon_analysis_port.write(item);
        end
    endtask
endclass
