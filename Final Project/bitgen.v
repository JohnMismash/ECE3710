module bitgen (
	input bright, 
	input [9:0] hcount, vcount,
	input [15:0] game_board, column_no, player,
	output [23:0] rgb,
	output reg [11:0] vga_lookup
);

assign rgb = {b,g,r};
reg [7:0] r, g, b;

wire [9:0] x_pos, y_pos;
assign x_pos = hcount - 10'd158;
assign y_pos = vcount; 

parameter BLOCK_SIZE_X = 50;
parameter BLOCK_SIZE_Y = 50;
parameter GAP_SIZE_X	= 30;
parameter GAP_SIZE_Y = 10;
parameter INDENT_SIZE_X = 40;
parameter INDENT_SIZE_Y = 110;
parameter X_DISTANCE = BLOCK_SIZE_X + GAP_SIZE_X; // 90
parameter Y_DISTANCE = BLOCK_SIZE_Y + GAP_SIZE_Y; // 90
parameter START_X = 50;
parameter START_Y = 90;
parameter END_X = START_X + BLOCK_SIZE_X; // 165
integer i;
integer j;

always @(bright, x_pos, y_pos) begin
	
	// Reset RBG values.
	{b,g,r} = 0;
	
	r = 8'b01100110;
	b = 8'b0;
	g = 8'b0;
	
	// Display is allowed:
	if (bright) begin
	
		r = 8'b0;
		g = 8'b10000000;
		b = 8'b11111111;
	
		for (j = 0; j <=5; j = j + 1) begin
			if (x_pos >= 0 && x_pos < 640 && y_pos >= 84 && y_pos < 480) begin
			
				for (i = 0; i <= 6; i = i + 1) begin
					if (i == 0) begin
						if (x_pos >= INDENT_SIZE_X && x_pos <= BLOCK_SIZE_X + INDENT_SIZE_X && y_pos > INDENT_SIZE_Y + Y_DISTANCE * j && y_pos <= BLOCK_SIZE_Y + INDENT_SIZE_Y + Y_DISTANCE * j) begin
							r = 8'b01100110;
							b = 8'b0;
							g = 8'b0;
						end
					
					end
					
					if (x_pos > START_X + X_DISTANCE * i && x_pos < END_X + X_DISTANCE * i && y_pos > INDENT_SIZE_Y + Y_DISTANCE * j && y_pos <= BLOCK_SIZE_Y + INDENT_SIZE_Y + Y_DISTANCE * j && i > 0) begin
						r = 8'b01100110;
						b = 8'b0;
						g = 8'b0;
					end
				end
			end
		
			// Maroon Background
			else begin
				r = 8'b01100110;
				b = 8'b0;
				g = 8'b0;
			end		
		end
				
	end
	
	// cannot display
	// defaulted above to {r,g,b} = 0;
end

endmodule
