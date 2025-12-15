// ./sim_define.v

// RTL include path
+incdir+./rtl/

// TB include path
+incdir+./tb/

// Package files
./tb/uvm_global.sv
./tb/adder_pkg.sv

// UVM files
// ./tb/adder_if.sv
./tb/adder_transfer.sv
./tb/adder_seq_item.sv
./tb/adder_seq_lib.sv
./tb/adder_sequencer.sv
./tb/adder_driver.sv
./tb/adder_monitor.sv
./tb/adder_agent.sv
./tb/adder_sb.sv
./tb/adder_env.sv

// Test files
./tb/vseqr.sv
./tb/base_vseq_lib.sv
./tb/adder_vseq_lib.sv
./tb/tb.sv
// ./tb/intf_insts.sv
./tb/base_test.sv
./tb/adder_rand_test.sv
./tb/adder_user_test.sv

// TB files
// ./tb/testbench.sv

// RTL file
./rtl/fulladd10_en.v

// Top file
./tb/top.sv