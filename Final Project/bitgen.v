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

parameter BLOCK_SIZE_X = 50;
parameter BLOCK_SIZE_Y = 50;
parameter GAP_SIZE	= 40;
parameter INDENT_SIZE_X = 25;
parameter INDENT_SIZE_Y = 90;
parameter X_DISTANCE = BLOCK_SIZE_X + GAP_SIZE; // 90
parameter START_X = 115;
parameter END_X = START_X + BLOCK_SIZE_X; // 165
integer i;

always @(bright, x_pos, y_pos) begin
	
	// Reset RBG values.
	{b,g,r} = 0;
	
	r = 8'b01100110;
	b = 8'b0;
	g = 8'b0;
	
	// Display is allowed:
	if (bright) begin
		//i = i;
		if (x_pos >= 0 && x_pos < 640 && y_pos >= 84 && y_pos < 480) begin
		
			r = 8'b0;
			g = 8'b10000000;
			b = 8'b11111111;
			//(x_pos >= 25 && x_pos <= 75 && y_pos > 90 && y_pos <= 140)
			if (x_pos >= INDENT_SIZE_X && x_pos <= BLOCK_SIZE_X + INDENT_SIZE_X && y_pos > INDENT_SIZE_Y && y_pos <= BLOCK_SIZE_Y + INDENT_SIZE_Y) begin
				r = 8'b01100110;
				b = 8'b0;
				g = 8'b0;
				i = 4'd0;
			end
			
			else begin
				for (i = 0; i <= 5; i = i + 1) begin
					if (x_pos > START_X + X_DISTANCE * i && x_pos < END_X + X_DISTANCE * i && y_pos > INDENT_SIZE_Y && y_pos <= BLOCK_SIZE_Y + INDENT_SIZE_Y) begin
						r = 8'b01100110;
						b = 8'b0;
						g = 8'b0;
					end
				end
			end
			
		
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
		//i = i;
				
	end
	
	// cannot display
	// defaulted above to {r,g,b} = 0;
end

endmodule
