
class my_sequence extends uvm_sequence #(my_seq_item);
    // object utilities macro
    `uvm_object_utils(my_sequence)

    // Constructor
    function new(string name = "");
        super.new(name);
    endfunction //new()

    // Body task: main execution of the sequence
    task body;
        // req is a handle to the sequence item
        `uvm_do_with(req, {a == 4'b0111; b == 4'b0001;})
        `uvm_do_with(req, {a == 4'b1111; b == 4'b1111;})

        #10;
    endtask: body
endclass: my_sequence