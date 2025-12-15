adder_if adder_intf(
    .i_clk(SystemClock),
    .i_rstn(nReset)
);

assign dut.i_clk = SystemClock;
assign dut.i_rstn = nReset;

// Input connections (DUT <= Interface)
assign dut.i_enable = adder_intf.i_enable;
assign dut.i_a = adder_intf.i_a;
assign dut.i_b = adder_intf.i_b;
assign dut.i_cin = adder_intf.i_cin;

// Output connections (Interface <= DUT)
assign adder_intf.o_valid = dut.o_valid;
assign adder_intf.o_result = dut.o_result;