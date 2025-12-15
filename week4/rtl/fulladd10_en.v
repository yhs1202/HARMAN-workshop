module fulladd10_en (
    input i_clk,
    input i_rstn,
    input i_enable,
    input [9:0] i_a,
    input [9:0] i_b,
    input i_cin,
    output reg o_valid,
    output reg [10:0] o_result
);
    wire [9:0] w_sum;
    wire w_cout;
    wire [8:0] w_c; // Carry bits between full adders

    fulladd1 FA0(w_sum[0], w_c[0], i_a[0], i_b[0], i_cin);
    genvar i;
    generate
        for (i = 1; i < 9; i = i + 1) begin
            fulladd1 FA(w_sum[i], w_c[i], i_a[i], i_b[i], w_c[i-1]);
        end
    endgenerate

    always @(posedge i_clk, negedge i_rstn) begin
        if (!i_rstn) begin
            o_valid <= 1'b0;
            o_result <= 11'd0;
        end else if (i_enable) begin
            o_valid <= 1'b1;
            o_result <= {w_cout, w_sum[9:0]};
        end else begin
            o_valid <= 1'b0;
        end
    end
endmodule

module fulladd1 (
    output sum,
    output cout,
    input a,
    input b,
    input cin
);
    // assign sum = a ^ b ^ cin;
    // assign cout = (a & b) | (b & cin) | (a & cin);

    wire y0, y1, y2;
    xor (y0, a, b);
    xor (sum, y0, cin);

    and (y2, a, b);
    and (y1, y0, cin);

    or (cout, y1, y2);
endmodule