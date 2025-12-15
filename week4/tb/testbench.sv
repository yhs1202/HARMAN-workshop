import uvm_pkg::*;
`include "uvm_macros.svh"   // `include: paste raw code from another file

`include "adder_pkg.sv"
import adder_pkg::*;

`include "adder_sb.sv"
`include "adder_env.sv"

`include "vseqr.sv"
`include "tb.sv"

`include "base_vseq_lib.sv"
`include "base_test.sv"

`include "adder_rand_test.sv"
`include "adder_user_test.sv"

`include "top.sv"
