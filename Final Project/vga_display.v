module vga_display(Clk, Reset, Hsync, Vsync, video_on, pixel_tick, X, Y)

// Each pixel on the screen has a red, green, and blue component, and each
// color signal is analog.

// TODO: Figure out which color depth Implementation we will use:
// Could use Basys 2 or Basys 3 if available

input wire Clk;
input wire Reset;

output wire Hsync;
output wire Vsync;
output wire video_on;
output wire pixel_tick;
output wire X;
output wire Y;

localparam H_DISPLAY   = 640; // Horizontal Display Area
localparam H_L_BORDER  =  48; // Horizontal Left Border
localparam H_R_BORDER  =  16; // Horizontal Right Border
localparam H_RETRACE   =  96; // Horizontal Retrace

localparam H_MAX           = H_DISPLAY + H_L_BORDER + H_R_BORDER + H_RETRACE - 1;
localparam START_H_RETRACE = H_DISPLAY + H_R_BORDER;
localparam END_H_RETRACE   = H_DISPLAY + H_R_BORDER + H_RETRACE - 1;

localparam V_DISPLAY   = 480; // vertical display area
localparam V_T_BORDER  =  10; // vertical top border
localparam V_B_BORDER  =  33; // vertical bottom border
localparam V_RETRACE   =   2; // vertical retrace

localparam V_MAX           = V_DISPLAY + V_T_BORDER + V_B_BORDER + V_RETRACE - 1;
localparam START_V_RETRACE = V_DISPLAY + V_B_BORDER;
localparam END_V_RETRACE   = V_DISPLAY + V_B_BORDER + V_RETRACE - 1;


endmodule
