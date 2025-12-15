class adder_vseq_c extends uvm_sequence;

    `uvm_object_utils(adder_vseq_c)

    adder_rand_seq_c adder_rand_seq;
    adder_user_seq_c adder_user_seq;

    rand bit adder_user_mode;
    rand bit [9:0] adder_user_a;
    rand bit [9:0] adder_user_b;
    rand bit adder_user_cin;

    // Default constraint
    // soft constraints have lower priority than hard constraints
    constraint adder_mode_set_default {
        soft adder_user_mode == 0;
        soft adder_user_a == 0;
        soft adder_user_b == 0;
        soft adder_user_cin == 0;
    }

    function new(string name = "adder_vseq_c");
        super.new(name);
        adder_rand_seq = adder_rand_seq_c::type_id::create("adder_rand_seq");
        adder_user_seq = adder_user_seq_c::type_id::create("adder_user_seq");
    endfunction : new


    virtual task body();
        `uvm_info(get_type_name(), $sformatf("adder_vseq_c starts.."), UVM_LOW)

        if (adder_user_mode) begin
            adder_user_seq.user_a = adder_user_a;
            adder_user_seq.user_b = adder_user_b;
            adder_user_seq.user_cin = adder_user_cin;
            `uvm_send(adder_user_seq)   // Send the user sequence, which was configured with specific values (not random)
        end
        else begin
            // `uvm_info(get_type_name(), "Starting adder_rand_seq", UVM_LOW)
            `uvm_send(adder_rand_seq);
        end
    endtask : body
endclass : adder_vseq_c