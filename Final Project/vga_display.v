module vga_display(Clk, Reset, Hsync, Vsync, video_on, pixel_tick, X, Y)

// Each pixel on the screen has a red, green, and blue component, and each
// color signal is analog.

// TODO: Figure out which color depth Implementation we will use:
// Could use Basys 2 or Basys 3 if available

input wire Clk;
input wire Reset;

// Controls the time needed to scan through a row of pixels.
output wire Hsync;

// Controls the time needed to scan through a entire screen of pixel rows.
output wire Vsync;

output wire video_on;
output wire pixel_tick;
output wire X;
output wire Y;

// Display is a resolution of 640 x 480. Origin of display is 0 x 0 (located
// in the top left corner), and will extend.

// The pixel rate (ie. 25 MHz) determines the pixel scan rate per second.
// In order to simplify the math, we can represent our display as a 800 x
// 800 grid.


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

// mod-2 counter to generate 25 MHz pixel tick
reg pixel_reg;
wire pixel_next, pixel_tick;

always @(posedge clk)
  pixel_reg <= pixel_next;

assign pixel_next = ~pixel_reg; // next state is complement of current

assign pixel_tick = (pixel_reg == 0); // assert tick half of the time

// registers to keep track of current pixel location
reg [9:0] h_count_reg, h_count_next, v_count_reg, v_count_next;

// register to keep track of vsync and hsync signal states
reg vsync_reg, hsync_reg;
wire vsync_next, hsync_next;

// infer registers
always @(posedge clk, posedge reset)
  if(reset)
      begin
                  v_count_reg <= 0;
                  h_count_reg <= 0;
                  vsync_reg   <= 0;
                  hsync_reg   <= 0;
            end
  else
      begin
                  v_count_reg <= v_count_next;
                  h_count_reg <= h_count_next;
                  vsync_reg   <= vsync_next;
                  hsync_reg   <= hsync_next;
            end

// next-state logic of horizontal vertical sync counters
always @*
  begin
  h_count_next = pixel_tick ?
                 h_count_reg == H_MAX ? 0 : h_count_reg + 1
           : h_count_reg;

  v_count_next = pixel_tick && h_count_reg == H_MAX ?
                 (v_count_reg == V_MAX ? 0 : v_count_reg + 1)
           : v_count_reg;
  end

      // hsync and vsync are active low signals
      // hsync signal asserted during horizontal retrace
      assign hsync_next = h_count_reg >= START_H_RETRACE
                          && h_count_reg <= END_H_RETRACE;

      // vsync signal asserted during vertical retrace
      assign vsync_next = v_count_reg >= START_V_RETRACE
                          && v_count_reg <= END_V_RETRACE;

      // video only on when pixels are in both horizontal and vertical display region
      assign video_on = (h_count_reg < H_DISPLAY)
                         && (v_count_reg < V_DISPLAY);

      // output signals
      assign hsync  = hsync_reg;
      assign vsync  = vsync_reg;
      assign x      = h_count_reg;
      assign y      = v_count_reg;
      assign p_tick = pixel_tick;


endmodule
