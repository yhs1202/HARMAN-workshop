class base_vseq_c extends uvm_sequence;

    `uvm_object_utils(base_vseq_c)
    // virtual sequencer declaration to p_sequencer
    `uvm_declare_p_sequencer(vseqr_c)

    function new(string name = "base_vseq_c");
        super.new(name);
    endfunction : new

    // Pre-body and Post-body tasks to manage objections
    virtual task pre_body();
        super.pre_body();
        if (starting_phase != null) begin
            `uvm_info(get_type_name(), $sformatf("Raise objection"), UVM_LOW)   // Start of sequence
            starting_phase.raise_objection(this, get_type_name());
        end
    endtask : pre_body

    virtual task post_body();
        super.post_body();
        if (starting_phase != null) begin
            `uvm_info(get_type_name(), $sformatf("Drop objection"), UVM_LOW)    // End of sequence
            starting_phase.drop_objection(this, get_type_name());
        end
    endtask : post_body


endclass : base_vseq_c
