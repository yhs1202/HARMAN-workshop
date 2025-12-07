`timescale 1ns / 1ps
`define SIM

module line_buf_ctrl #(
    parameter ADDR_WIDTH = 10,
    parameter DATA_WIDTH = 30,
    parameter SCALE_MODE = 2'b01  // 00: bypass, 01: 1/2, 10: 1/3, 11: nop
)(
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

  // Edge Detection
  reg i_vsync_d, i_hsync_d, i_de_d;
  wire i_vsync_rising =  i_vsync & ~i_vsync_d;
  wire i_hsync_rising =  i_hsync & ~i_hsync_d;
  wire i_de_rising    =  i_de    & ~i_de_d;
  wire i_de_falling   = ~i_de    &  i_de_d;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      i_vsync_d <= 1'b0;
      i_hsync_d <= 1'b0;
      i_de_d    <= 1'b0;
    end else begin
      i_vsync_d <= i_vsync;
      i_hsync_d <= i_hsync;
      i_de_d    <= i_de;
    end
  end


  // Horizontal and Vertical Counters
  reg [ADDR_WIDTH-1:0] h_cnt, v_cnt;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      h_cnt <= 0; v_cnt <= 0;
    end else begin
      if (i_hsync_rising) begin
        h_cnt <= 0;
        if (i_vsync_rising) begin
          v_cnt <= 0;
        end else begin
          v_cnt <= v_cnt + 1;
        end
      end else if (i_de) begin
        h_cnt <= h_cnt + 1;
      end
    end
  end


    // SRAM Control (Write Enable & Chip Select)
    
    // SRAM Address with Input Data
    always @(*) begin
        // Address and Data
        o_addr1 = h_cnt;
        o_addr2 = h_cnt;
        o_din1 = {i_red, i_green, i_blue};
        o_din2 = {i_red, i_green, i_blue};
        
        o_we1 = 0; o_we2 = 0;
        o_cs1 = 0; o_cs2 = 0;
        
        // SRAM Control Logic based on SCALE_MODE
        if (i_de) begin
            case (SCALE_MODE)
                2'b01: begin // 1/2 Downscale Mode (Vertical Ping-Pong)
                    o_cs1 = 1; o_cs2 = 1;
                    if (v_cnt[0] == 0) begin
                        o_we1 = 1;
                    end else begin
                    end
                end
                default: ; // Bypass or NOP
            endcase
        end
    end

    // Pixel Calculation and Output Timing
    
    // SRAM Read Data
    wire [9:0] d1_r, d1_g, d1_b; 
    wire [9:0] d2_r, d2_g, d2_b; // 1/3
    assign {d1_r, d1_g, d1_b} = i_dout1;
    assign {d2_r, d2_g, d2_b} = i_dout2;
    
    // Calculation Wires (1/2 Vertical Average)
    wire [10:0] avg_r_temp = {1'b0, d1_r} + {1'b0, i_red};
    wire [10:0] avg_g_temp = {1'b0, d1_g} + {1'b0, i_green};
    wire [10:0] avg_b_temp = {1'b0, d1_b} + {1'b0, i_blue};

    // Output DE Logic (Decimation)
    reg o_de_logic_comb;
    always @(*) begin
        o_de_logic_comb = 0;
        
        if (i_de) begin 
            case (SCALE_MODE)
                2'b00: begin // Bypass
                    o_de_logic_comb = 1;
                end
                2'b01: begin // 1/2 Downscale (Vertical Decimation)
                    if (v_cnt[0] == 1) o_de_logic_comb = 1;
                end
                // 2'b10:
                default: o_de_logic_comb = 0;
            endcase
        end
    end

    // Output Registers (Sync and Data)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            o_vsync <= 0; o_hsync <= 0; o_de    <= 0;
            o_red   <= 0; o_green <= 0; o_blue  <= 0;
        end else begin
            // 1. Sync Signal
            o_vsync <= i_vsync;
            o_hsync <= i_hsync;
            
            // 2. Output Data Enable
            o_de <= o_de_logic_comb;

            // 3. Output Data
            if (o_de_logic_comb) begin
                case (SCALE_MODE)
                    2'b00: begin // Bypass
                        o_red   <= i_red;
                        o_green <= i_green;
                        o_blue  <= i_blue;
                    end
                    2'b01: begin // 1/2 Vertical Average
                        o_red   <= avg_r_temp[10:1];
                        o_green <= avg_g_temp[10:1];
                        o_blue  <= avg_b_temp[10:1];
                    end
                    default: begin
                        o_red   <= 0;
                        o_green <= 0;
                        o_blue  <= 0;
                    end
                endcase
            end else begin
                o_red   <= 0; 
                o_green <= 0; 
                o_blue  <= 0;
            end
        end
    end

endmodule