`include "uvm_macros.svh"

class my_seq_item extends uvm_sequence_item;
    // Data members
    rand logic [3:0] a;
    rand logic [3:0] b;
    logic [8:0] sum; // output

    constraint data {
        a > 5;
    }

    // object utilities macro
    `uvm_object_utils_begin(my_seq_item)
        `uvm_field_int(a, UVM_DEFAULT)
        `uvm_field_int(b, UVM_DEFAULT)
        `uvm_field_int(sum, UVM_DEFAULT)
    `uvm_object_utils_end

    // Constructor
    function new(string name = "my_seq_item");
        super.new(name);
    endfunction //new()

endclass : my_seq_item 
