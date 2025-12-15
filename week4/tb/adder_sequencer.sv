class adder_sequencer_c extends uvm_sequencer #(adder_drv_pkt_c);
    
    `uvm_component_utils(adder_sequencer_c)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new
endclass : adder_sequencer_c