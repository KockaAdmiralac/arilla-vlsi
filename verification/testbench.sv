`include "uvm_macros.svh"

import uvm_pkg::*;

`include "ps2_item.sv"
`include "generator.sv"
`include "ps2_if.sv"
`include "driver.sv"
`include "monitor.sv"
`include "agent.sv"
`include "scoreboard.sv"
`include "env.sv"
`include "test.sv"

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
