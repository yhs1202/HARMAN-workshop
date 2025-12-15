class adder_driver_c extends uvm_driver #(adder_drv_pkt_c);
    
    `uvm_component_utils(adder_driver_c)

    // Virtual interface
    virtual interface adder_if adder_vif;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    // Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_full_name(), $sformatf("build_phase() starts.."), UVM_LOW)

        // Get the virtual interface from the uvm_config_db
        if (!uvm_config_db#(virtual adder_if)::get(this, "", "adder_vif", adder_vif)) begin
            `uvm_fatal(get_type_name(), {"Cannot get vif from uvm_config_db, Virtual interface must be set before the build_phase", get_full_name(), ".adder_vif"})
        end

        `uvm_info(get_full_name(), $sformatf("build_phase() ends.."), UVM_LOW)
    endfunction : build_phase


    // Main run phase
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);

        @(negedge adder_vif.i_rstn); // Wait for reset de-assertion
        reset_signals();
        forever begin
            @(posedge adder_vif.i_rstn);
            while (adder_vif.i_rstn) begin
                drive_signals();
            end
            reset_signals();
        end
    endtask : run_phase

    // Tasks to drive/reset signals
    virtual task reset_signals();
        `uvm_info(get_type_name(), $sformatf("reset_signals() starts.."), UVM_MEDIUM)
        adder_vif.i_enable = 0;
        adder_vif.i_a      = 0;
        adder_vif.i_b      = 0;
        adder_vif.i_cin    = 0;
        `uvm_info(get_type_name(), $sformatf("reset_signals() ends.."), UVM_MEDIUM)
    endtask : reset_signals

    virtual task drive_signals();
        `uvm_info(get_type_name(), $sformatf("drive_signals() starts.."), UVM_MEDIUM)
        seq_item_port.get_next_item(req);   // Get the next transaction item (req)

        @(posedge adder_vif.i_clk);
        adder_vif.i_enable = req.i_enable;
        adder_vif.i_a      = req.i_a;
        adder_vif.i_b      = req.i_b;
        adder_vif.i_cin    = req.i_cin;

        seq_item_port.item_done();  // Indicate that the item has been processed
        `uvm_info(get_type_name(), $sformatf("drive_signals() ends.."), UVM_MEDIUM)
    endtask : drive_signals
endclass : adder_driver_c