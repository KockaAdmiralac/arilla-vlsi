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

class generator extends uvm_sequence;
    `uvm_object_utils(generator)

    function new(string name = "generator");
        super.new(name);
    endfunction

    int totalItems = 2000;

    virtual task body();
        for (int i = 0; i < totalItems; i++) begin
            ps2_item item = ps2_item::type_id::create("item");
            start_item(item);
            item.randomize();
            `uvm_info("Generator", $sformatf("Item %0d/%0d created with data %h", i + 1, totalItems, item.data), UVM_LOW);
            finish_item(item);
        end
    endtask
endclass

interface ps2_if(
	input bit clk,
	input bit ps2clk
);
	logic rst_n;
	logic ps2dat;
	logic [31:0] out;
endinterface

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

module testbench;
    reg clk;
    reg ps2_clk;
    ps2_if dut_if(clk, ps2_clk);
    ps2kbd dut(clk, dut_if.rst_n, ps2_clk, dut_if.ps2dat, dut_if.out);

    initial begin
        clk = 0;
        forever begin
            #10 clk = ~clk;
        end
    end
    initial begin
        ps2_clk = 0;
        forever begin
            #537 ps2_clk = ~ps2_clk;
        end
    end
    initial begin
        uvm_config_db#(virtual ps2_if)::set(null, "*", "ps2_vif", dut_if);
        run_test("test");
    end
endmodule
