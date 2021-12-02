`timescale 1ns/1ps

module top_level_counter(Clk, Reset, Hsync, Vsync, Red, Green, Blue, ClkOut, vga_blank);

	input wire Clk;
	input wire Reset;
	output Hsync;
	output Vsync;
	output reg [7:0] Red;
	output reg [7:0] Green;
	output reg [7:0] Blue;
	output reg ClkOut;
	output reg vga_blank;
	reg [9:0] H_Count, V_Count;


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

	reg Vert_Counter_Enable;


	assign Hsync = (H_Count < H_RETRACE) ? 1'b1:1'b0;
	assign Vsync = (V_Count < V_RETRACE) ? 1'b1:1'b0;

	always@(posedge Clk) begin

		if (Reset) begin
			H_Count <= 10'd0;
			V_Count <= 10'd0;
			ClkOut <= 1'b0;
		end
		
		if (ClkOut) begin
		
			if (H_Count < 799) begin
				H_Count <= H_Count + 1'b1;
				Vert_Counter_Enable <= 0;
			end

			else begin
				H_Count <= 0;
				Vert_Counter_Enable <= 1;
			end

			if (Vert_Counter_Enable == 1'b1) begin
				if (V_Count < 524) begin
					V_Count <= V_Count + 1'b1;
				end
				else begin
					V_Count <= 0;
				end
			end

			if ((H_Count % 92) >= 0 || (H_Count % 92) < 4 &&
				(V_Count % 70) >= 0 || (V_Count % 70) < 4 &&
				H_Count < (H_MAX - H_R_BORDER) &&
				H_Count > (H_L_BORDER + H_RETRACE - 1) &&
				V_Count < (V_MAX - V_B_BORDER) &&
				V_Count > (V_B_BORDER + V_RETRACE)) begin

				Red   = 8'b01100110;
				Green = 8'b0;
				Blue = 8'b0;
			end

			else begin

			// Check for position of each circle

				Red   = 8'b0;
				Green = 8'b0;
				Blue = 8'b0;
			end
		
		
		end


		ClkOut <= ~ClkOut;

	end
	
	
	always @(H_Count,V_Count) begin
	
	// bright
	if ((H_Count >= H_L_BORDER + H_RETRACE - 1 + H_R_BORDER - 1) &&
		 (H_Count < 793 - H_R_BORDER - 1) &&
		 (V_Count < V_DISPLAY))
		 vga_blank = 1'b1;
	 
	 else 
		vga_blank = 1'b0;
		
end


endmodule
