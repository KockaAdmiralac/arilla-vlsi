`include "uvm_macros.svh"

import uvm_pkg::*;

class test extends uvm_test;
    `uvm_component_utils(test)

    function new(string name = "test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual ps2_if vif;

    env e;
    generator g;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual ps2_if)::get(this, "", "ps2_vif", vif)) begin
            `uvm_fatal("Test", "No interface found.")
        end
        e = env::type_id::create("e", this);
        g = generator::type_id::create("g", this);
    endfunction

    virtual function void end_of_elaboration_phase(uvm_phase phase);
        uvm_top.print_topology();
    endfunction

    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);

        vif.rst_n <= 0;
        #20 vif.rst_n <= 1;

        g.start(e.a.seq);
        phase.drop_objection(this);
    endtask
endclass
