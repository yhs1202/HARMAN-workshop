class vseqr_c extends uvm_sequencer;
    
    `uvm_component_utils(vseqr_c)

    // Virtual interface
    virtual interface adder_if adder_vif;
    adder_sequencer_c adder_seqr;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info(get_type_name(), $sformatf("connect_phase() starts.."), UVM_LOW)

        // Get the virtual interface from the uvm_config_db
        if (!uvm_config_db#(virtual adder_if)::get(this, "", "adder_vif", adder_vif)) begin
            `uvm_fatal(get_type_name(), {"Cannot get vif from uvm_config_db, Virtual interface must be set before the connect_phase", get_full_name(), ".adder_vif"})
        end

        `uvm_info(get_type_name(), $sformatf("connect_phase() ends.."), UVM_LOW)
    endfunction : connect_phase

endclass : vseqr_c
