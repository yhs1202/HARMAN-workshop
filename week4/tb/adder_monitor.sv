class adder_monitor_c extends uvm_monitor;
    
    `uvm_component_utils(adder_monitor_c)

    // Analysis port to send monitored packets
    uvm_analysis_port #(adder_mon_pkt_c) in_data_port;
    uvm_analysis_port #(adder_mon_pkt_c) out_data_port;

    // Virtual interface
    virtual interface adder_if adder_vif;
    adder_mon_pkt_c in_pkt;
    adder_mon_pkt_c out_pkt;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        in_data_port = new("in_data_port", this);
        out_data_port = new("out_data_port", this);
    endfunction : new

    // Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_type_name(), $sformatf("build_phase() starts.."), UVM_LOW)

        if (!uvm_config_db#(virtual adder_if)::get(this, "", "adder_vif", adder_vif)) begin
            `uvm_fatal(get_type_name(), {"Virtual interface must be set for: ", get_full_name(), ".adder_vif"})
        end

        `uvm_info(get_type_name(), $sformatf("build_phase() ends.."), UVM_LOW)
    endfunction : build_phase

    // Run phase
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);

        fork
            forever begin
                // Wait for clock edge when not in reset, iff: if and only if
                @(posedge adder_vif.i_clk iff adder_vif.i_rstn);   
                in_data();
            end
            forever begin
                @(posedge adder_vif.i_clk iff adder_vif.i_rstn);
                out_valid_data();
            end
        join_none
    endtask : run_phase

    // Task to monitor input data signals
    task in_data();
        `uvm_info(get_type_name(), $sformatf("in_data() starts.."), UVM_MEDIUM)
        in_pkt = adder_mon_pkt_c::type_id::create("in_pkt", this);
        in_pkt.i_enable = adder_vif.i_enable;
        in_pkt.i_a      = adder_vif.i_a;
        in_pkt.i_b      = adder_vif.i_b;
        in_pkt.i_cin    = adder_vif.i_cin;
        in_data_port.write(in_pkt);
        `uvm_info(get_type_name(), $sformatf("in_data() ends.."), UVM_MEDIUM)
    endtask : in_data

    // Task to monitor input data signals
    task out_valid_data();
        if(adder_vif.o_valid) begin
            `uvm_info(get_type_name(), $sformatf("out_valid_data() starts.."), UVM_MEDIUM)
            out_pkt = adder_mon_pkt_c::type_id::create("out_pkt", this);
            out_pkt.o_valid = adder_vif.o_valid;
            out_pkt.o_result = adder_vif.o_result;
            out_data_port.write(out_pkt);
            `uvm_info(get_type_name(), $sformatf("out_valid_data() ends.."), UVM_MEDIUM)
        end
    endtask : out_valid_data
endclass : adder_monitor_c
