interface adder_if(input i_clk, input i_rstn);
    logic i_enable;
    logic [9:0] i_a;
    logic [9:0] i_b;
    logic i_cin;
    logic o_valid;
    logic [10:0] o_result;
endinterface