`include "agent.sv"
`include "scoreboard.sv"

// 4. Environment class (layer 2)
class my_environment extends uvm_env;
    `uvm_component_utils(my_environment)

    // Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction //new()

    // Declare inside objects
    my_agent agt;
    my_scoreboard scb;


    // Build phase: create agent, and scoreboard
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        // Create instances of agent and scoreboard
        agt = my_agent::type_id::create("agt", this);
        scb = my_scoreboard::type_id::create("scb", this);
    endfunction //build_phase


    // Connect phase (Agent <> Scoreboard)
    // (Added 25.11.13) Connect phase: After build phase, used to connect TLM ports and exports
    // connect agent.monitor analysis export to scoreboard analysis port
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        // connect usage: agt.mon.send -> scb.recv
        agt.mon.item_collected_port.connect(scb.item_collected_export);     // Connect monitor to scoreboard, TLM Port-Export connection
    endfunction //connect_phase
endclass //my_environment extends uvm_env
