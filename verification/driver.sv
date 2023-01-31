`include "uvm_macros.svh"

import uvm_pkg::*;

class driver extends uvm_driver #(ps2_item);
    `uvm_component_utils(driver)

    function new(string name = "driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual ps2_if vif;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual ps2_if)::get(this, "", "ps2_vif", vif)) begin
            `uvm_fatal("Driver", "No interface found.")
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            ps2_item item;
            seq_item_port.get_next_item(item);
            for (int i = 0; i < 11; i++) begin
                if (i == 0) begin
                    // Start bit
                    vif.ps2dat <= 0;
                end else if (i == 9) begin
                    // TODO: parity bit
                    vif.ps2dat <= 0;
                end else if (i == 10) begin
                    // End bit
                    vif.ps2dat <= 1;
                end else begin
                    // Data bit
                    vif.ps2dat <= item.data[i-1];
                end
                @(negedge vif.ps2clk);
                @(posedge vif.clk);
            end
            seq_item_port.item_done();
        end
    endtask
endclass
