module bitgen (
	input bright, 
	input [9:0] hcount, vcount,
	input [15:0] game_board, column_no, player,
	input vsync,
	output [23:0] rgb,
	output reg [11:0] vga_lookup
);

assign rgb = {b,g,r};
reg [7:0] r, g, b;

// Current X, Y position on the screen.
wire [9:0] x_pos, y_pos;
assign x_pos = hcount - 10'd158;
assign y_pos = vcount; 

// Each empty or color filled block size.
parameter BLOCK_SIZE_X = 50;
parameter BLOCK_SIZE_Y = 50;

// Gap inbetween each block, for each gap on the x-axis and y-axis.
parameter GAP_SIZE_X	= 36;
parameter GAP_SIZE_Y = 10;

// Indents at the top underneath the border and on each side of the screen.
parameter INDENT_SIZE_X = 36;
parameter INDENT_SIZE_Y = 110;

// Accounts for the difference between each starting drawing point.
parameter X_DISTANCE = BLOCK_SIZE_X + GAP_SIZE_X; // 86
parameter Y_DISTANCE = BLOCK_SIZE_Y + GAP_SIZE_Y; // 90

// Accounts for the starting block point.
parameter START_X = 40;
parameter START_Y = 90;
parameter END_X = START_X + BLOCK_SIZE_X; // 165

// Variables to track which block we are currently drawing.
integer i;
integer j;
integer k;

//how to update registers
//need to look at registers for draw color
reg [15:0] in_data [41:0];
wire [15:0] game_data [41:0];
reg [41:0] enable_bits;
genvar v;
generate 
	for (v = 0; v < 42; v = v+1) begin:Tony
		Register_VGA r(.in(in_data[v]), .enable(enable_bits[v]), .out(game_data[v]));
	end

endgenerate


// TODO: Make FSM to control this!
always @(vsync) begin
	if (!vsync) begin
		for(k=0; k < 42; k = k+1)begin
			enable_bits[k] = 1;
			vga_lookup = 2048 + k;
			in_data[k] = game_board;
			enable_bits[k] = 0;			
		end	
	end
end

always @(bright, x_pos, y_pos) begin
	
	// Reset RBG values.
	{b,g,r} = 0;
	
	r = 8'd255;
	b = 8'd255;
	g = 8'd255;
	
	// Display is allowed:
	if (bright) begin
	
		// Light blue
		r = 8'd153;
		g = 8'd204;
		b = 8'd255;
	
		// For each position within the game board, draw the respective square, with its respective color based on
		// if a piece is being placed or not and by which player.
		for (j = 0; j <= 5; j = j + 1) begin
			if (x_pos >= 0 && x_pos < 640 && y_pos >= 84 && y_pos < 480) begin
			
				for (i = 0; i <= 6; i = i + 1) begin
					if (i == 0) begin
						if (x_pos >= INDENT_SIZE_X && x_pos <= BLOCK_SIZE_X + INDENT_SIZE_X && y_pos > INDENT_SIZE_Y + Y_DISTANCE * j && y_pos <= BLOCK_SIZE_Y + INDENT_SIZE_Y + Y_DISTANCE * j) begin
							
							// Check memory if piece must be placed.
							
							if (game_board[1:0] == 2'b01) begin
								// Player 1
								r = 8'b11111111;
								b = 8'b0;
								g = 8'b0;							
							end
							
							else if (game_board[1:0] == 2'b10) begin
								// Player 2
								r = 8'b11111111;
								b = 8'b0;
								g = 8'b11111111;
							
							end
							
							else begin
								// No piece is being placed here, so we must draw it as a blank position.
								r = 8'd255;
								b = 8'd255;
								g = 8'd255;
							end

						end
					
					end
					
					if (x_pos > START_X + X_DISTANCE * i && x_pos < END_X + X_DISTANCE * i && y_pos > INDENT_SIZE_Y + Y_DISTANCE * j && y_pos <= BLOCK_SIZE_Y + INDENT_SIZE_Y + Y_DISTANCE * j && i > 0) begin
						
						// Check memory if piece must be placed
						
						if (game_board[1:0] == 2'b01) begin
							// Player 1
							r = 8'b11111111;
							b = 8'b0;
							g = 8'b0;
							
							
						end
						
						else if (game_board[1:0] == 2'b10) begin
							// Player 2
							r = 8'b11111111;
							b = 8'b0;
							g = 8'b11111111;
						
						end
						
						else begin
							// No piece is being placed here, so we must draw it as a blank position.
							r = 8'd255;
							b = 8'd255;
							g = 8'd255;
						end
					end
				end
				
			end
		
			// Top section (grey background and red marker)
			else begin
				if (x_pos >= START_X + X_DISTANCE * column_no && x_pos < END_X + X_DISTANCE * column_no && y_pos >= 16 && y_pos <= 66) begin // Draw dropdown square
					r = 8'd255;
					g = 8'd0;
					b = 8'd0;
					if (player[1:0] == 2'b01) begin
						// Player 1
						r = 8'b11111111;
						b = 8'b0;
						g = 8'b0;							
					end
							
					else if (player[1:0] == 2'b10) begin
						// Player 2
						r = 8'b11111111;
						b = 8'b0;
						g = 8'b11111111;
					end
					
					else begin
						r = 8'b0;
						b = 8'd0;
						g = 8'd0;
					end
				end
				
				else begin
					r = 8'd96;
					b = 8'd96;
					g = 8'd96;
				end
			end		
		end
				
	end
	
	// Cannot display, so it will default above to {r,g,b} = 0;
	 
end

endmodule
