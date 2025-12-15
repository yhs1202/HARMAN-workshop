class adder_drv_pkt_c extends uvm_sequence_item;
    
    // Sequence item fields
    bit       i_enable;
    bit [9:0] i_a;
    bit [9:0] i_b;
    bit       i_cin;

    `uvm_object_utils_begin(adder_drv_pkt_c)
        `uvm_field_int(i_enable, UVM_DEFAULT)
        `uvm_field_int(i_a, UVM_DEFAULT)
        `uvm_field_int(i_b, UVM_DEFAULT)
        `uvm_field_int(i_cin, UVM_DEFAULT)
    `uvm_object_utils_end

    function new(string name = "adder_drv_pkt_c");
        super.new(name);
    endfunction : new
endclass : adder_drv_pkt_c


class adder_mon_pkt_c extends uvm_sequence_item;
    
    // Sequence item fields
    bit       i_enable;
    bit [9:0] i_a;
    bit [9:0] i_b;
    bit       i_cin;

    bit o_valid;
    bit [10:0] o_result;

    `uvm_object_utils_begin(adder_mon_pkt_c)
        `uvm_field_int(i_enable, UVM_DEFAULT)
        `uvm_field_int(i_a, UVM_DEFAULT)
        `uvm_field_int(i_b, UVM_DEFAULT)
        `uvm_field_int(i_cin, UVM_DEFAULT)
        `uvm_field_int(o_valid, UVM_DEFAULT)
        `uvm_field_int(o_result, UVM_DEFAULT)
    `uvm_object_utils_end

    function new(string name = "adder_mon_pkt_c");
        super.new(name);
    endfunction : new
endclass : adder_mon_pkt_c

