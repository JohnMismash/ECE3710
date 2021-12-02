module bitgen (
	input bright, 
	input [9:0] hcount, vcount, 
	output [23:0] rgb
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
	
	// Display is allowed:
	if (bright) begin
		if (x_pos >= 100 && x_pos < 545 && y_pos >= 100 && y_pos < 380) begin
			r = 8'b0;
			g = 8'b10000000;
			b = 8'b11111111;
		
		end
	
	
	
//		// draw a square
//		if (x_pos >= 200 && x_pos < 400 &&
//			 y_pos >= 200 && y_pos < 300)
//				r = 8'd255;
//				
//		else if (x_pos >= 250 && x_pos < 450 &&
//					y_pos >= 350 && y_pos < 450)
//				g = 8'd255;
		
		// background color
		else begin
			r = 8'b01100110;
			b = 8'b0;
			g = 8'b0;
		end
				
	end
	
	// cannot display
	// defaulted above to {r,g,b} = 0;

end

endmodule
