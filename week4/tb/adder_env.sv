class adder_env_c extends uvm_env;
    
    `uvm_component_utils(adder_env_c)

    // Adder agent
    adder_agent_c adder_agent;
    adder_sb_c adder_sb;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    // Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_type_name(), $sformatf("build_phase() starts.."), UVM_LOW)

        // Create adder agent
        adder_agent = adder_agent_c::type_id::create("adder_agent", this);
        uvm_config_db#(uvm_active_passive_enum)::set(this, "adder_agent", "is_active", UVM_ACTIVE);
        adder_sb = adder_sb_c::type_id::create("adder_sb", this);

        `uvm_info(get_type_name(), $sformatf("build_phase() ends.."), UVM_LOW)
    endfunction : build_phase

    // Connect phase
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info(get_type_name(), $sformatf("connect_phase() starts.."), UVM_LOW)
        // Connect the scoreboard analysis export to the agent analysis port
        adder_agent.adder_monitor.in_data_port.connect(adder_sb.in_adder_imp_port);
        adder_agent.adder_monitor.out_data_port.connect(adder_sb.out_adder_imp_port);

        `uvm_info(get_type_name(), $sformatf("connect_phase() ends.."), UVM_LOW)
    endfunction : connect_phase
    
endclass : adder_env_c