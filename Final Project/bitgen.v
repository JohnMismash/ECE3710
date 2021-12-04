module bitgen (
	input bright, 
	input [9:0] hcount, vcount,
	input [15:0] game_board, column_no, player,
	output [23:0] rgb,
	output reg [11:0] vga_lookup
);

assign rgb = {b,g,r};
reg [7:0] r, g, b;

// x_start = H_BACK_PORCH + H_SYNC + H_FRONT_PORCH = 48 + 95 + 15 = 158
// x_end   = H_TOTAL - H_BACK_PORCH = 793 - 48 = 745
// y_start = 0
// y_end   = V_DISPLAY_INT = 480

wire [9:0] x_pos, y_pos;
assign x_pos = hcount - 10'd158;
assign y_pos = vcount; 

always @(bright, x_pos, y_pos) begin
	
	// Reset RBG values.
	{b,g,r} = 0;
	
	r = 8'b01100110;
	b = 8'b0;
	g = 8'b0;
	
	// Display is allowed:
	if (bright) begin
		if (x_pos >= 100 && x_pos < 545 && y_pos >= 100 && y_pos < 380) begin
			r = 8'b0;
			g = 8'b10000000;
			b = 8'b11111111;
		
		// Condition for inner squares
			// Check memory for if this square is filled and by which color
				// two if statements, one for each color
		
		
		// Condition for whos turn it is
		
		// Condition 
	
		end
		
		// Maroon Background
		else begin
			r = 8'b01100110;
			b = 8'b0;
			g = 8'b0;
		end
				
	end
	
	else begin
		if (x_pos >= 100 && x_pos < 545 && y_pos >= 100 && y_pos < 380) begin
			r = 8'b0;
			g = 8'b10000000;
			b = 8'b11111111;
			
			end
	
	end
	
	// cannot display
	// defaulted above to {r,g,b} = 0;

end

endmodule
