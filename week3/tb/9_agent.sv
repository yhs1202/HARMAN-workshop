class my_agent extends uvm_agent;
    `uvm_component_utils(my_agent)

    // Constructor
    function new(string name = "agt", uvm_component parent);
        super.new(name, parent);
    endfunction //new()

    // Declare inside objects
    my_driver drv;
    uvm_sequencer #(my_seq_item) sqr;  // uvm_sequencer instance: sequencer for my_seq_item transactions
    my_monitor mon;


    // Build phase: create sequencer, driver, and monitor
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sqr = uvm_sequencer#(seq_item)::type_id::create("sqr", this);
        drv = my_driver::type_id::create("drv", this);
        mon = my_monitor::type_id::create("mon", this);
    endfunction //build_phase

    // Connect phase (driver <> sequencer)
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        // seq_item_port: where driver gets transactions from sequencer
        drv.seq_item_port.connect(sqr.seq_item_export); // Connect sequencer to driver.seq_item_port, TLM Port-Export connection
    endfunction //connect_phase
endclass //my_agent extends uvm_agent
