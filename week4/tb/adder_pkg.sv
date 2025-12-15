package adder_pkg;
    
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  `include "adder_transfer.sv"
  `include "adder_sequencer.sv"
  `include "adder_driver.sv"
  `include "adder_monitor.sv"
  `include "adder_agent.sv"

  // Include sequence item classes
  `include "adder_seq_item.sv"
  `include "adder_seq_lib.sv"
  `include "adder_vseq_lib.sv"
endpackage

`include "adder_if.sv"