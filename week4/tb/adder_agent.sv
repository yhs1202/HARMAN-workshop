class adder_agent_c extends uvm_agent;
    
    `uvm_component_utils_begin(adder_agent_c)
        `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_component_utils_end

    // Adder components
    adder_sequencer_c adder_sequencer;
    adder_driver_c    adder_driver;
    adder_monitor_c   adder_monitor;

//    // Virtual interface
    // vseqr_c vseqr;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    // Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_type_name(), $sformatf("build_phase() starts.."), UVM_LOW)

        if(!uvm_config_db#(uvm_active_passive_enum)::get(this, "", "is_active", is_active))
            `uvm_error(get_full_name(), "is_active not configured in uvm_config_db")

        if(is_active == UVM_ACTIVE) begin
            `uvm_info(get_type_name(), $sformatf("is_active = UVM_ACTIVE"), UVM_LOW)
            // Create sequencer
            adder_sequencer = adder_sequencer_c::type_id::create("adder_sequencer", this);
            // Create driver
            adder_driver = adder_driver_c::type_id::create("adder_driver", this);
        end
        // Create monitor (Default: always created)
        adder_monitor = adder_monitor_c::type_id::create("adder_monitor", this);

        `uvm_info(get_type_name(), $sformatf("build_phase() ends.."), UVM_LOW)

    endfunction : build_phase

    // Connect phase
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info(get_full_name(), $sformatf("connect_phase() starts.."), UVM_LOW)

        if(is_active == UVM_ACTIVE) begin
            // Connect driver to sequencer
            adder_driver.seq_item_port.connect(adder_sequencer.seq_item_export);
            `uvm_info(get_full_name(), $sformatf("Connecting ACTIVE agent components.."), UVM_LOW)
        end else begin
            `uvm_info(get_full_name(), $sformatf("Creating PASSIVE agent components.."), UVM_LOW)
        end
        `uvm_info(get_full_name(), $sformatf("connect_phase() ends.."), UVM_LOW)
    endfunction : connect_phase
endclass : adder_agent_c