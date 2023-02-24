`include "uvm_macros.svh"

import uvm_pkg::*;

class agent extends uvm_agent;
    `uvm_component_utils(agent)

    function new(string name = "agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    driver drv;
    monitor mon;
    uvm_sequencer#(ps2_item) seq;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        drv = driver::type_id::create("drv", this);
        mon = monitor::type_id::create("mon", this);
        seq = uvm_sequencer#(ps2_item)::type_id::create("seq", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        drv.seq_item_port.connect(seq.seq_item_export);
    endfunction
endclass
