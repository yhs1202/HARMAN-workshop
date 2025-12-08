
// 6. Scoreboard class (layer 3)
class my_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(my_scoreboard)

    // No internal objects needed

    // Analysis export to receive transactions from monitor
    // uvm_analysis_imp: analysis implementation class to implement analysis export
    // uvm_analysis_port: analysis port class to send transactions
    // #(seq_item, my_scoreboard): seq_item is the type of transaction, my_scoreboard is the class implementing the export
    uvm_analysis_imp #(my_seq_item, my_scoreboard) item_collected_export;    // receive port

    my_seq_item item_from_mon; // Received transactions from DUT->monitor


    // Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
        item_collected_export = new("item_collected_export", this); // Initialize analysis export
    endfunction //new()

    // build_phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        item_from_mon = seq_item::type_id::create("item_from_mon", this); // Create item_from_mon
    endfunction //build_phase


    // write: called when a transaction is received from monitor
    function void write(my_seq_item item);
        item_from_mon = item; // Store received transaction
        `uvm_info("SCOREBOARD", $sformatf("Scoreboard received: a=%0d, b=%0d, y=%0d", item.a, item.b, item.sum), UVM_LOW)
        item.print(uvm_default_printer); // Print received transaction
        // Check if the sum is correct
        if (item_from_mon.sum !== (item_from_mon.a + item_from_mon.b)) begin
            `uvm_error("SCOREBOARD", $sformatf("Mismatch: a=%0d, b=%0d, y=%0d, expected=%0d", item_from_mon.a, item_from_mon.b, item_from_mon.sum, item_from_mon.a + item_from_mon.b))
        end else begin
            `uvm_info("SCOREBOARD", "Match: Correct sum", UVM_NONE)
        end
    endfunction //write()
endclass //my_scoreboard extends uvm_scoreboard
