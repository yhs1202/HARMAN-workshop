class my_sequencer extends uvm_sequencer #(my_seq_item);
    // object utilities macro
    `uvm_component_utils(my_sequencer)

    // Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction //new()
endclass: my_sequencer