
class my_driver extends uvm_driver #(my_seq_item);
    `uvm_component_utils(my_driver)

    // Virtual interface handle
    virtual dut_if dut_vif;

    // Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction //new()


    // Build phase: get virtual interface from config DB
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual dut_if)::get(this, "", "intf", dut_vif)) begin
            `uvm_fatal("DRV", "Virtual interface not found in uvm_config_db")
        end
    endfunction //build_phase

    // Main run phase: get transactions from sequencer and drive DUT inputs
    task run_phase(uvm_phase phase);
        dut_vif.en = 0;
        #6;
        dut_vif.en = 1;
        forever begin
            // Wait for a clock cycle
            @(posedge dut_vif.clock);

            // Get transaction from sequencer
            // seq_item_port: where driver gets transactions from sequencer
            // get_next_item: driver calls this to get the next transaction
            seq_item_port.get_next_item(req);


            // Drive DUT inputs
            // Use non-blocking assignments to drive inputs
            dut_vif.a <= req.a;
            dut_vif.b <= req.b;
            dut_vif.sum <= req.sum;
            // Indicate that the item is done
            seq_item_port.item_done();

            // // Print driven values
            // `uvm_info("DRIVER", $sformatf("Driving: a=%0d, b=%0d", req.a, req.b), UVM_LOW)
            // // Wait for a clock cycle (assuming clock is handled elsewhere)
            // @(posedge dut_vif.clock); // Wait for output to be valid
        end
        endtask //run_phase


endclass //my_driver extends uvm_driver #(seq_item)
