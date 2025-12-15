// TEST 1
class adder_rand_test_c extends base_test_c;
    
    `uvm_component_utils(adder_rand_test_c)


    function new(string name = "adder_rand_test_c", uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

    // Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        // Set the default sequence for the sequence runner
        // vseqr.run_phase -> default_sequence (mostly used)
        uvm_config_db#(uvm_object_wrapper)::set(this, "tb.vseqr.run_phase", "default_sequence", adder_rand::type_id::get());
    endfunction : build_phase

    // Run phase
    // task run_phase(uvm_phase phase);
        // super.run_phase(phase);
    // endtask : run_phase

    // After build phase, print the UVM component hierarchy in end_of_elaboration_phase
    virtual function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        uvm_top.print_topology();
    endfunction : end_of_elaboration_phase

endclass : adder_rand_test_c

// Virtual sequence Class
class adder_rand extends base_vseq_c;

    `uvm_object_utils(adder_rand)

    adder_vseq_c adder_vseq;

    function new(string name = "adder_rand");
        super.new(name);
    endfunction : new

    virtual task body();
        `uvm_info(get_type_name(), $sformatf("----------------------------------------------"), UVM_LOW)
        `uvm_info(get_type_name(), $sformatf("-------------Start adder_rand_test------------"), UVM_LOW)
        `uvm_info(get_type_name(), $sformatf("----------------------------------------------"), UVM_LOW)

        // Wait for reset de-assertion
        // uses p_sequencer interface to access DUT signals
        @(posedge p_sequencer.adder_vif.i_rstn);
        `uvm_info(get_type_name(), $sformatf("Reset ended"), UVM_LOW)

        `uvm_do_on_with(
            adder_vseq, p_sequencer.adder_seqr,
        {
            adder_user_mode == 0;
        })
        
        repeat(4) @(posedge p_sequencer.adder_vif.i_clk);

        `uvm_info(get_type_name(), $sformatf("----------------------------------------------"), UVM_LOW)
        `uvm_info(get_type_name(), $sformatf("-------------------TEST DONE------------------"), UVM_LOW)
        `uvm_info(get_type_name(), $sformatf("----------------------------------------------"), UVM_LOW)
    endtask : body
endclass : adder_rand