module vga_display(Clk, Reset, Hsync, Vsync, video_on, pixel_tick, X, Y)

// Each pixel on the screen has a red, green, and blue component.

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


endmodule
