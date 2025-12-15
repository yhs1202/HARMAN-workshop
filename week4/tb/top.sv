// top.sv: Top-level module for UVM testbench (include last)
module top;

    // UVM package import
    import uvm_pkg::*;
    import adder_pkg::*;

    // Clock and Reset generation
    reg nReset;
    reg SystemClock = 0;    // register type : synthesis not needed

    always #10 SystemClock = ~SystemClock;

    initial begin
        #10 nReset = 0;
        #30 nReset = 1;
    end

    // Interface instantiation
    fulladd10_en dut(); // port connection will be done via intf_insts.sv

    `include "intf_insts.sv"

    initial begin
        // UVM Configuration settings
        // Virtual interface binding
        // handle type: virtual adder adder_if
        uvm_config_db#(virtual adder_if)::set(null, "uvm_test_top.tb.adder_env.adder_agent*", "adder_vif", adder_intf);
        uvm_config_db#(virtual adder_if)::set(null, "uvm_test_top.tb.vseqr*", "adder_vif", adder_intf);

        // Run Test
        run_test("adder_rand_test_c");
        // run_test("adder_user_test_c");
    end

    initial begin
        $fsdbDumpfile("wave.fsdb");
        $fsdbDumpvars(0);
        // $dumpfile("dump.vcd");
        // $dumpvars(0, top);
    end
endmodule