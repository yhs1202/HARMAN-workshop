class base_test_c extends uvm_test;
    // UVM Registration
    `uvm_component_utils(base_test_c)

    // Testbench handler instance
    tb_c tb;
    
    // Virtual interface handle
    // virtual adder_if vif;
    
    function new(string name = "base_test_c", uvm_component parent = null);
        super.new(name, parent);
    endfunction : new
    
    // Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        // Create the testbench instance
        tb = tb_c::type_id::create("tb", this);

        // Get the virtual interface from the testbench
        // if(!uvm_config_db#(virtual adder_if)::get(this, "", "vif", vif)) begin
            // `uvm_fatal("NOVIF", "Virtual interface not found")
        // end
    endfunction : build_phase
    
endclass : base_test_c