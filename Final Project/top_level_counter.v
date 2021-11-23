`timescale 1ns/1ps

module top_level_counter(

  input wire Clk;
  input wire Reset;
  output Hsync;
  output Vsync;
  output [3:0] Red;
  output [3:0] Green;
  output [3:0] Blue;
);

localparam H_DISPLAY   = 640; // Horizontal Display Area
localparam H_L_BORDER  =  48; // Horizontal Left Border
localparam H_R_BORDER  =  16; // Horizontal Right Border
localparam H_RETRACE   =  96; // Horizontal Retrace

localparam H_MAX           = H_DISPLAY + H_L_BORDER + H_R_BORDER +
                             H_RETRACE - 1;
localparam START_H_RETRACE = H_DISPLAY + H_R_BORDER;
localparam END_H_RETRACE   = H_DISPLAY + H_R_BORDER + H_RETRACE - 1;

localparam V_DISPLAY   = 480; // vertical display area
localparam V_T_BORDER  =  10; // vertical top border
localparam V_B_BORDER  =  33; // vertical bottom border
localparam V_RETRACE   =   2; // vertical retrace

localparam V_MAX           = V_DISPLAY + V_T_BORDER + V_B_BORDER +
                             V_RETRACE - 1;
localparam START_V_RETRACE = V_DISPLAY + V_B_BORDER;
localparam END_V_RETRACE   = V_DISPLAY + V_B_BORDER + V_RETRACE - 1;

wire Vert_Counter_Enable;
wire [15:0] H_Count, V_Count;

horizontal_counter H (Clk, Vert_Counter_Enable, H_Count);
vertical_counter V (Clk, Vert_Counter_Enable, V_Count);

assign Hsync = (H_Count < H_RETRACE) ? 1'b1:1'b0;
assign Vsync = (V_Count < V_RETRACE) ? 1'b1:1'b0;

always@(H_Count, V_Count) begin

  if ((H_Count % 92) >= 0 || (H_Count % 92) < 4 &&
      (V_Count % 70) >= 0 || (V_Count % 70) < 4 &&
       H_Count < (H_MAX - H_R_BORDER) &&
       H_Count > (H_L_BORDER + H_RETRACE - 1) &&
       V_Count < (V_MAX - V_B_BORDER) &&
       V_Count > (V_B_BORDER + V_RETRACE)) begin

    Red   = 4'h0;
    Green = 4'h0;
    Blue = 4'h0;
  end

  else begin
    Red   = 4'h0;
    Green = 4'h0;
    Blue = 4'b1;
  end

end

endmodule
