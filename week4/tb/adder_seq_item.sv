class adder_seq_item_c extends uvm_sequence_item;
    
    // Sequence item fields
    rand bit       i_enable;
    rand bit [9:0] i_a;
    rand bit [9:0] i_b;
    rand bit       i_cin;

    `uvm_object_utils_begin(adder_seq_item_c)
        `uvm_field_int(i_enable, UVM_DEFAULT)
        `uvm_field_int(i_a, UVM_DEFAULT)
        `uvm_field_int(i_b, UVM_DEFAULT)
        `uvm_field_int(i_cin, UVM_DEFAULT)
    `uvm_object_utils_end

    function new(string name = "adder_seq_item_c");
        super.new(name);
    endfunction : new
endclass : adder_seq_item_c
