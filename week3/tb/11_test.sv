`include "env.sv"

// 2. Test class (layer 1)
class my_test extends uvm_test;
    // 2-1: Register the class with UVM factory
    `uvm_component_utils(my_test)

    // 2-2: Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent); // Call parent constructor
    endfunction //new()

    // 2-3: Declare environment and sequence (inside objects)
    my_environment env;  // Environment instance
    my_sequence seq;     // Sequence instance


    // 2-4: Build phase: override to create environment and sequence
    // Parameter: uvm_phase phase
    // Phases are predefined simulation stages in UVM, such as build, connect, run, etc.
    // virtual function void build_phase(uvm_phase phase);
    function void build_phase(uvm_phase phase); // "virtual" option is optional (defined in parent class)
        // Call super class build_phase
        super.build_phase(phase);           // Always call the parent class's build_phase

        // Create instances of environment and sequence using UVM factory
        env = my_environment::type_id::create("env", this);
        seq = my_sequence::type_id::create("seq", this);
    endfunction


    // 2-5: Start of simulation phase: to start the simulation (Optional)
    virtual function void start_of_simulation_phase(uvm_phase phase);
        super.start_of_simulation_phase(phase);
        // Print the UVM component hierarchy
        uvm_root::get().print_topology();
    endfunction


    // 2-6: Run phase: "main" execution phase of the test
    // virtual task run_phase(uvm_phase phase);
    task run_phase(uvm_phase phase);
        // Raise objection to keep the simulation running
        phase.raise_objection(this);

        // Start the sequence (sequence -> sequencer -> driver)
        // sequence (layer 1) -> env (layer 2) -> agent (layer 3) -> sequencer (layer 4)
        seq.start(env.agt.sqr);

        // Drop the objection
        phase.drop_objection(this);

        #20;

    endtask //run_phase
endclass //test extends uvm_test
