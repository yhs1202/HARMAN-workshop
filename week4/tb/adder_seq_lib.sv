class adder_base_seq_c extends uvm_sequence #(adder_drv_pkt_c); // drv_pkt will be sent to req

    `uvm_object_utils(adder_base_seq_c)

    adder_seq_item_c rnd_item;

    function new(string name = "adder_base_seq_c");
        super.new(name);
        rnd_item = new();
    endfunction : new

    task send_signal();
        `uvm_info(get_type_name(), $sformatf("Sending signal to sequencer.."), UVM_MEDIUM)

        `uvm_create(req);
        req.i_enable = rnd_item.i_enable;
        req.i_a = rnd_item.i_a;
        req.i_b = rnd_item.i_b;
        req.i_cin = rnd_item.i_cin;
        `uvm_send(req);
        
        `uvm_info(get_type_name(), $sformatf("Signal sent: enable=%0b, a=%0d, b=%0d, cin=%0b", req.i_enable, req.i_a, req.i_b, req.i_cin), UVM_MEDIUM)
    endtask : send_signal

    task send_init(input int size=1);
        for (int i = 1; i<=size; i++) begin
            rnd_item.i_enable = 0;
            rnd_item.i_a = 0;
            rnd_item.i_b = 0;
            rnd_item.i_cin = 0;
            send_signal();
        end
    endtask : send_init
endclass : adder_base_seq_c

// Random sequence Class based on adder_base_seq_c
// which sends random signals to the DUT via the driver
class adder_rand_seq_c extends adder_base_seq_c;

    `uvm_object_utils(adder_rand_seq_c)

    function new(string name = "adder_rand_seq_c");
        super.new(name);
    endfunction : new

    virtual task body();
        `uvm_info(get_type_name(), $sformatf("adder_rand_seq_c starts.."), UVM_LOW)

        // Send random signals
        send_init(5);
        send_randomize_data(3);
        send_init(2);
        send_randomize_all(6);
        send_init(2);

        `uvm_info(get_type_name(), $sformatf("adder_rand_seq_c ends.."), UVM_LOW)
    endtask : body
    
    task send_randomize_all(input int size=1);
        for (int i = 1; i<=size; i++) begin
            void'(rnd_item.randomize());
            // assert(rnd_item.randomize());
            send_signal();
        end
    endtask : send_randomize_all

    task send_randomize_data(input int size=1);
        for (int i = 1; i<=size; i++) begin
            // void'(rnd_item.randomize() with {
                // i_enable == 1;
                // i_cin == 0;
            // });
            void'(rnd_item.randomize());
            rnd_item.i_enable = 1;
            rnd_item.i_cin = 0;
            send_signal();
        end
    endtask : send_randomize_data
endclass : adder_rand_seq_c



class adder_user_seq_c extends adder_base_seq_c;

    `uvm_object_utils(adder_user_seq_c)

    bit [9:0] user_a;
    bit [9:0] user_b;
    bit       user_cin;

    function new(string name = "adder_user_seq_c");
        super.new(name);
    endfunction : new

    virtual task body();
        `uvm_info(get_type_name(), $sformatf("adder_user_seq_c starts.."), UVM_LOW)

        // Send user signals
        send_init(5);
        // send_randomize_data(3);
        send_user(3);
        send_init(2);
        // send_randomize_all(6);
        send_init(6);
        send_init(2);

        `uvm_info(get_type_name(), $sformatf("adder_user_seq_c ends.."), UVM_LOW)
        endtask : body

    
    task send_user(input int size=1);
        for (int i = 1; i<=size; i++) begin
            rnd_item.i_enable = 1;
            rnd_item.i_a = user_a;
            rnd_item.i_b = user_b;
            rnd_item.i_cin = user_cin;
            send_signal();
        end
    endtask : send_user

endclass : adder_user_seq_c