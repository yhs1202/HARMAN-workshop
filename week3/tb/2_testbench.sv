`timescale 1ns/1ps

`include "uvm_macros.svh"
`include "hm_pkg.sv"

// include vs import

module top;
    import uvm_pkg::*;
    import hm_pkg::*;

    dut_if dut_if1();
    dut dut1(.dif(dut_if1));

    initial begin
        dut_if1.clock = 0;
        forever #5 dut_if1.clock = ~dut_if1.clock;
    end

    initial begin 
        run_test("my_test");
        // run_test("hm_pkg::my_test"); // specify package name when import statement is not used
    end

    initial begin
        uvm_config_db#(virtual dut_if)::set(null, "*", "dut_vif", dut_if1);
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, top);
    end

endmodule