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

    fulladd1 FA0(w_sum[0],w_c[0],i_a[0],i_b[0],i_cin );
    fulladd1 FA1(w_sum[1],w_c[1],i_a[1],i_b[1],w_c[0]);
    fulladd1 FA2(w_sum[2],w_c[2],i_a[2],i_b[2],w_c[1]);
    fulladd1 FA3(w_sum[3],w_c[3],i_a[3],i_b[3],w_c[2]);
    fulladd1 FA4(w_sum[4],w_c[4],i_a[4],i_b[4],w_c[3]);
    fulladd1 FA5(w_sum[5],w_c[5],i_a[5],i_b[5],w_c[4]);
    fulladd1 FA6(w_sum[6],w_c[6],i_a[6],i_b[6],w_c[5]);
    fulladd1 FA7(w_sum[7],w_c[7],i_a[7],i_b[7],w_c[6]);
    fulladd1 FA8(w_sum[8],w_c[8],i_a[8],i_b[8],w_c[7]);
    fulladd1 FA9(w_sum[9],w_cout,i_a[9],i_b[9],w_c[8]);

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