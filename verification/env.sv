`include "uvm_macros.svh"

import uvm_pkg::*;

class env extends uvm_env;
    `uvm_component_utils(env)

    function new(string name = "env", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    agent a;
    scoreboard sb;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        a = agent::type_id::create("a", this);
        sb = scoreboard::type_id::create("sb", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        a.mon.mon_analysis_port.connect(sb.mon_analysis_imp);
    endfunction
endclass
