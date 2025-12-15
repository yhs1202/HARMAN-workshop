import "DPI-C" context function int unsigned addFunc(int unsigned a, int unsigned b, int unsigned c);

`uvm_analysis_imp_decl(_in_adder)
`uvm_analysis_imp_decl(_out_adder)

class adder_sb_c extends uvm_scoreboard;
    
    `uvm_component_utils(adder_sb_c)

    // Analysis exports to connect to monitor
    uvm_analysis_imp_in_adder #(adder_mon_pkt_c, adder_sb_c) in_adder_imp_port;
    uvm_analysis_imp_out_adder #(adder_mon_pkt_c, adder_sb_c) out_adder_imp_port;

    bit [10:0] c_result_q[$]; // Queue to store expected results
    bit [10:0] rtl_result_q[$]; // Queue to store DUT results
    int match_cnt;
    int mismatch_cnt;


    // Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
        in_adder_imp_port = new("in_adder_imp_port", this);
        out_adder_imp_port = new("out_adder_imp_port", this);
    endfunction : new

    // Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction : build_phase

    // Run phase
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);

        compare_data();
    endtask : run_phase

    // Task to compare expected and DUT results
    virtual task compare_data();
        bit [10:0] c_result;
        bit [10:0] rtl_result;
        forever begin
            wait(c_result_q.size() > 0 && rtl_result_q.size() > 0);

            c_result = c_result_q.pop_front();
            rtl_result = rtl_result_q.pop_front();
            if (c_result === rtl_result) begin
                match_cnt++;
                `uvm_info(get_type_name(), $sformatf("MATCH: Expected: %0d, DUT: %0d", c_result, rtl_result), UVM_LOW)
            end else begin
                mismatch_cnt++;
                `uvm_error(get_type_name(), $sformatf("MISMATCH: Expected: %0d, DUT: %0d", c_result, rtl_result))
            end
        end
    endtask : compare_data

    // Report phase
    virtual function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        
        if (c_result_q.size() != 0 || rtl_result_q.size() != 0) begin
            `uvm_error(get_type_name(), $sformatf("Result queues are not empty! c_result_q size: %0d, rtl_result_q size: %0d", c_result_q.size(), rtl_result_q.size()))
        end

        `uvm_info(get_type_name(), $sformatf("MATCH COUNT: %0d", match_cnt), UVM_LOW)
        `uvm_info(get_type_name(), $sformatf("MISMATCH COUNT: %0d", mismatch_cnt), UVM_LOW)
    endfunction : report_phase


    // Write method for input analysis port
    function void write_in_adder(adder_mon_pkt_c pkt);
        `uvm_info(get_full_name(), $sformatf("Scoreboard received input packet: %s", pkt.convert2string()), UVM_LOW)
        // You can add checking logic here if needed
        if (pkt.i_enable) begin
            int unsigned sum = addFunc(pkt.i_a, pkt.i_b, pkt.i_cin);
            c_result_q.push_back(sum[10:0]);
        end
    endfunction : write_in_adder

    // Write method for output analysis port
    function void write_out_adder(adder_mon_pkt_c pkt);
        `uvm_info(get_full_name(), $sformatf("Scoreboard received output packet: %s", pkt.convert2string()), UVM_LOW)
        // You can add checking logic here if needed
        rtl_result_q.push_back(pkt.o_result);
    endfunction : write_out_adder
endclass : adder_sb_c