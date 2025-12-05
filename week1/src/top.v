
module line_buf_ctrl_top #(
    // Timing parameters
    parameter [5:0] VSW = 1,
    parameter [5:0] VBP = 1,
    parameter [5:0] VACT = 4,
    parameter [5:0] VFP = 1,
    parameter [5:0] HSW = 1,
    parameter [5:0] HBP = 2,
    parameter [5:0] HACT = 10,
    parameter [5:0] HFP = 2
) (
    // Global Signals
    input clk,
    input rstn,

    // Input Video Signals
    input       i_vsync,
    input       i_hsync,
    input       i_de,      // Data Enable
    input [9:0] i_r_data,
    input [9:0] i_g_data,
    input [9:0] i_b_data,

    // Output Video Signals
    output o_vsync,
    output o_hsync,
    output o_de,      // Data Enable
    output [9:0] o_r_data,
    output [9:0] o_g_data,
    output [9:0] o_b_data
);

  wire o_cs1, o_we1;
  wire [ 5:0] o_addr1;
  wire [29:0] o_din1;
  wire o_cs2, o_we2;
  wire [5:0] o_addr2;
  wire [29:0] o_din2;

  wire [29:0] sram1_dout;
  wire [29:0] sram2_dout;


  line_buf_ctrl u_line_buf_ctrl (
      .clk    (clk),
      .rst_n  (rstn),
  `ifdef SIM
        .VSW (VSW),
        .VBP (VBP),
        .VACT(VACT),
        .VFP (VFP),
        .HSW (HSW),
        .HBP (HBP),
        .HACT(HACT),
        .HFP (HFP),
  `endif
      .i_vsync(i_vsync),
      .i_hsync(i_hsync),
      .i_de   (i_de),
      .i_red  (i_r_data),
      .i_green(i_g_data),
      .i_blue (i_b_data),
      .o_vsync(o_vsync),
      .o_hsync(o_hsync),
      .o_de   (o_de),
      .o_red  (o_r_data),
      .o_green(o_g_data),
      .o_blue (o_b_data),
      .o_cs1  (o_cs1),
      .o_we1  (o_we1),
      .o_addr1(o_addr1),
      .o_din1 (o_din1),
      .i_dout1(sram1_dout),
      .o_cs2  (o_cs2),
      .o_we2  (o_we2),
      .o_addr2(o_addr2),
      .o_din2 (o_din2),
      .i_dout2(sram2_dout)
  );


  single_port_ram u_ram1 (
      .clk(clk),
      .i_cs(o_cs1),
      .i_we(o_we1),
      .i_addr(o_addr1),
      .i_din(o_din1),
      .o_dout(sram1_dout)
  );

  single_port_ram u_ram2 (
      .clk(clk),
      .i_cs(o_cs2),
      .i_we(o_we2),
      .i_addr(o_addr2),
      .i_din(o_din2),
      .o_dout(sram2_dout)
  );

  // assign o_vsync  = i_vsync  ;
  // assign o_hsync  = i_hsync  ;
  // assign o_de    = i_de  ;
  // assign o_r_data = i_r_data ;
  // assign o_g_data = i_g_data ;
  // assign o_b_data = i_b_data ;

endmodule



