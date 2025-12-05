`timescale 1ns / 1ps
`define SIM

module line_buf_ctrl (
    // Global Signals
    input clk,
    input rst_n,

`ifdef SIM
    // Timing parameters
    input [5:0] VSW,
    input [5:0] VBP,
    input [5:0] VACT,
    input [5:0] VFP,
    input [5:0] HSW,
    input [5:0] HBP,
    input [5:0] HACT,
    input [5:0] HFP,
`endif

    // Input Video Signals
    input       i_vsync,
    input       i_hsync,
    input       i_de,       // Data Enable
    input [9:0] i_red,
    input [9:0] i_green,
    input [9:0] i_blue,

    // Output Video Signals
    output reg       o_vsync,
    output reg       o_hsync,
    output reg       o_de,  // Data Enable
    output reg [9:0] o_red,
    output reg [9:0] o_green,
    output reg [9:0] o_blue,

    // RAM Interface
    output reg        o_cs1,
    output reg        o_we1,
    output reg [ 5:0] o_addr1,
    output reg [29:0] o_din1,
    input      [29:0] i_dout1,

    output reg        o_cs2,
    output reg        o_we2,
    output reg [ 5:0] o_addr2,
    output reg [29:0] o_din2,
    input      [29:0] i_dout2

);

  // State Machine
  parameter ST_IDLE = 2'd0;
  parameter ST_FIRST_LINE = 2'd1;
  parameter ST_EVEN_LINE = 2'd2;
  parameter ST_ODD_LINE = 2'd3;

  reg [1:0] state, next_state;
  
  // Internal Registers

  reg [15:0] line_cnt;
  reg [5:0] addr_cnt;

  reg prev_line_valid;

  reg [29:0] mux_data;


`ifdef SIM
  wire [3:0] VTOT = VSW + VBP + VACT + VFP;  // total vertical lines, in this case, 1 + 1 + 4 + 1 = 7
  wire [3:0] HTOT = HSW + HBP + HACT + HFP;
`endif
  
  // Edge Detection
  reg i_de_d, i_vsync_d, i_hsync_d;
  reg o_hsync_d;

  wire vsync_rise = (~i_vsync_d & i_vsync); // frame start
  // wire vsync_fall   = (i_vsync_d & ~i_vsync);
  wire line_start  = (~i_de_d & i_de);    // start of active line (rising edge of de)
  wire o_line_start = (~o_hsync_d & o_hsync);
  wire line_end    = (i_de_d & ~i_de);    // end of active line (falling edge of de)
  wire h_start = (~i_hsync_d & i_hsync);  // hsync rising
  // wire h_end   = (i_hsync_d & ~i_hsync);  // hsync falling

  reg line_end_d;

  // Input signal pipeline
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      i_de_d    <= 0;
      i_vsync_d <= 0;
      i_hsync_d <= 0;
      o_hsync_d <= 0;
      line_end_d <= 0;
    end else begin
      i_de_d    <= i_de;
      i_vsync_d <= i_vsync;
      i_hsync_d <= i_hsync;
      o_hsync_d    <= o_hsync;
      line_end_d <= line_end;
    end
  end
  
  // HV Counters
  reg [15:0] h_cnt;
  reg [15:0] v_cnt;
  reg [15:0] v_cnt_out;
  reg [15:0] h_cnt_out;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      h_cnt <= 0;
      v_cnt <= 0;
    end else begin
      // Horizontal counter
      if (h_start) h_cnt <= 0;
      else h_cnt <= h_cnt + 1;

      // Vertical counter
      if (vsync_rise) begin 
        v_cnt <= 0;
        h_cnt <= 0;
      end else if (h_start) v_cnt <= v_cnt + 1;
    end
  end

`ifdef SIM
  always @(*) begin
    if (v_cnt == 0) v_cnt_out = VTOT - 1;
    else v_cnt_out = v_cnt - 1;
    if (h_cnt == 0) h_cnt_out = HTOT - 1;
    else h_cnt_out = h_cnt - 1;
  end
`else
  always @(*) begin
    // 1 line delay
    v_cnt_out = v_cnt - 1;
    // 1 pixel delay
    h_cnt_out = h_cnt - 1;
  end
`endif

  // Synchronize vsync for line counting
  reg vsync_line_cur;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      vsync_line_cur  <= 0;
    end else begin
      if (h_start) begin
        vsync_line_cur  <= i_vsync;
      end
    end
  end

  
  // FSM - SEQ
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      state           <= ST_IDLE;
      line_cnt        <= 0;
      addr_cnt        <= 0;
      prev_line_valid <= 0;
    end else begin
      if (vsync_rise) begin
        state           <= ST_IDLE;
        line_cnt        <= 0;
        addr_cnt        <= 0;
        prev_line_valid <= 0;
      end else begin
        state <= next_state;
        if (line_end) begin
          prev_line_valid <= 1;
          addr_cnt <= 0;
        end
        else if (line_start) begin
          line_cnt <= line_cnt + 1;
          addr_cnt <= 0;
        end
        else if (o_line_start) begin
          addr_cnt <= 0;
        end
        else if (i_de) begin
          addr_cnt <= addr_cnt + 1;
        end
        else if (o_de) begin
          addr_cnt <= addr_cnt + 1;
        end
      end
    end
  end

  
  // FSM - State Transition
  always @(*) begin
    next_state = state;
    case (state)
      ST_IDLE: begin
        if (line_start) begin
          if (line_cnt == 0) next_state = ST_FIRST_LINE;
          else if (line_cnt[0] == 1'b0) next_state = ST_ODD_LINE;
          else next_state = ST_EVEN_LINE;
        end
        // Last line handling
        if (v_cnt == (VSW + VBP + VACT)) begin
          next_state = (VACT == 1) ? ST_IDLE : (VACT % 2 == 1) ? ST_EVEN_LINE : ST_ODD_LINE;
        end
      end
      ST_FIRST_LINE, ST_ODD_LINE, ST_EVEN_LINE: if (line_end_d) next_state = ST_IDLE;
    endcase
  end


  //////////////////// SRAM R/W Control ////////////////////
  reg rd_en, rd_en_d;
  reg rd_s1, rd_s2;
  reg rd_s1_d;

  always @(*) begin
    // default
    o_cs1 = 0; o_we1 = 0;
    o_cs2 = 0; o_we2 = 0;

    rd_en = 0;
    rd_s1 = 0;
    rd_s2 = 0;

    case (state)
      ST_FIRST_LINE: begin
        // S1 W
        if (i_de || i_de_d) begin
          o_cs1 = 1;
          o_we1 = 1;
          o_addr1 = addr_cnt;
          o_addr2 = 0;
        end
        // S2 nop
      end

      ST_EVEN_LINE: begin
        // S2 W
        if (i_de || i_de_d) begin
          o_cs2 = 1; o_we2 = 1;
          o_addr2 = addr_cnt;
        end
        // S1 R
        if (prev_line_valid) begin
          o_cs1 = 1; o_we1 = 0;
          rd_en = 1; rd_s1 = 1;
          o_addr1 = addr_cnt;
        end
      end

      ST_ODD_LINE: begin
        // S1 W
        if (i_de || i_de_d) begin
          o_cs1 = 1; o_we1 = 1;
          o_addr1 = addr_cnt;
        end
        // S2 R
        if (prev_line_valid) begin
          o_cs2 = 1; o_we2 = 0;
          rd_en = 1; rd_s2 = 1;
          o_addr2 = addr_cnt;
        end
      end
    endcase
  end

  // Read pipeline, 1 cycle delay
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      rd_en_d <= 0;
      rd_s1_d <= 0;
      o_din1  <= 0;
      o_din2  <= 0;
    end else begin
      rd_en_d <= rd_en;
      rd_s1_d <= rd_s1;
      o_din1  <= {i_red, i_green, i_blue};
      o_din2  <= {i_red, i_green, i_blue};
    end
  end

  // Mux for read data (SRAM 1 or SRAM 2)
  always @(*) begin
    if (rd_s1_d) mux_data = i_dout1;
    else        mux_data = i_dout2;
    // DE (2, 6, 3, 13)
    o_de = (v_cnt_out >= (VSW + VBP)) &&
           (v_cnt_out <  (VSW + VBP + VACT)) &&
           (h_cnt >= (HSW + HBP + 1)) &&
           (h_cnt <  (HSW + HBP + HACT + 1));
    // RGB Data
    if (o_de) begin
      {o_red, o_green, o_blue} = mux_data;
    end else begin
      {o_red, o_green, o_blue} = 30'b0;
    end
  end
  
  // Output Video Signals
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      o_vsync <= 0;
      o_hsync <= 0;
      // o_de    <= 0;
      // o_red   <= 0;
      // o_green <= 0;
      // o_blue  <= 0;
    end else begin

`ifdef SIM
    // VSYNC (active-high)
    if (h_start) o_vsync <= vsync_line_cur;

    // HSYNC (active-high)
    if (h_cnt_out == HTOT - 1) o_hsync <= 1;
    else o_hsync <= 0;

`else
    o_vsync <= i_vsync;
    o_hsync <= i_hsync;
    o_de    <= rd_en_d;
`endif
    end
  end

endmodule
