`include "dut_if.sv"

module dut (
    dut_if dif
);
always @(posedge dif.clock) begin
    if(dif.en) begin
        assign dif.sum = dif.a + dif.b;
    end
    else begin
        dif.a = 0;
        dif.b = 0;
        dif.sum = 0;
    end
end
endmodule
