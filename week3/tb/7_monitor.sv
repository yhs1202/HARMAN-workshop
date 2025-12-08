
class my_monitor extends uvm_monitor;
    `uvm_component_utils(my_monitor)

    // Virtual interface handle
    virtual dut_if dut_vif;

    // Analysis export to send transactions to scoreboard
    // <> uvm_analysis_imp
    uvm_analysis_port #(my_seq_item) item_collected_port;   // send port

    // Transaction item
    my_seq_item trans_collected;

    // Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
        // 반드시 Create를 통해 만들어질 필요 없다.
        item_collected_port = new("item_collected_port", this); // Initialize analysis port
        trans_collected = new(); // Initialize transaction item
    endfunction //new()

    // Build phase: get virtual interface from config DB
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // trans_collected = my_seq_item::type_id::create("trans_collected"); // Create item
        if (!uvm_config_db#(virtual dut_if)::get(this, "", "dut_vif", dut_vif)) begin
            `uvm_fatal("no VIF", {"Virtual interface must be set for:", get_full_name(), ".dut_vif"});
        end
    endfunction //build_phase


    // Main run phase: monitor DUT outputs and send transactions to scoreboard
    task run_phase(uvm_phase phase);
        forever begin
            // Wait for a clock cycle
            @(posedge dut_vif.clock);
            // Capture DUT inputs and output
            trans_collected.a = dut_vif.a;
            trans_collected.b = dut_vif.b;
            trans_collected.sum = dut_vif.sum;

            // `uvm_info("MON", $sformatf("Monitoring: a=%0d, b=%0d, y=%0d", trans_collected.a, trans_collected.b, trans_collected.sum), UVM_LOW)
            // trans_collected.print(uvm_default_line_printer); // Print captured transaction

            // Send captured item to scoreboard
            item_collected_port.write(trans_collected);
        end
    endtask //run_phase
endclass //my_monitor extends uvm_monitor
