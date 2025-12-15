class tb_c extends uvm_env;
    
    `uvm_component_utils(tb_c)

    // Virtual interface
    vseqr_c vseqr;
    adder_env_c adder_env;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    // Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_full_name(), $sformatf("build_phase() starts.."), UVM_LOW)

        // Create sequencer
        vseqr = vseqr_c::type_id::create("vseqr", this);
        adder_env = adder_env_c::type_id::create("adder_env", this);

        `uvm_info(get_full_name(), $sformatf("build_phase() ends.."), UVM_LOW)
    endfunction : build_phase


    // Connect phase
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info(get_type_name(), $sformatf("connect_phase() starts.."), UVM_LOW)

        vseqr.adder_seqr = adder_env.adder_agent.adder_sequencer;

        `uvm_info(get_type_name(), $sformatf("connect_phase() ends.."), UVM_LOW)
    endfunction : connect_phase
endclass : tb_c