module top_level_counter (
	input	clk, rst, left, right, center,
	output hsync, 
	output vsync,
	output reg vga_blank_n, vga_clk,
	output [23:0] RGB
);

reg [9:0] hcount, vcount;
wire[1:0] state;
wire [15:0] game_board;
wire [15:0] column_no, player;
wire [11:0] vga_lookup;

StateConversion State(left, right, center, state);
FSM_Final FSM(.Clock(clk), .Reset(rst), .controller_state(state), .vga_lookup(vga_lookup), .vga_out(game_board), .r1(column_no), .r2(player));


// parameters for a VGA 640 x 480 (60Hz) display
// dropping our 50MHz clock to a 25MHz pixel clock

parameter H_SYNC        = 10'd95;  // 3.8us  -- 25M * 3.8u  = 95
parameter H_BACK_PORCH  = 10'd48;  // 1.9us  -- 25M * 1.9u  = 47.5
parameter H_DISPLAY_INT = 10'd635; // 25.4us -- 25M * 25.4u = 635
parameter H_FRONT_PORCH = 10'd15;  // 0.6us  -- 25M * 0.6u  = 15
parameter H_TOTAL       = 10'd793; // total width -- 95 + 48 + 635 + 15 = 793

parameter V_SYNC        = 10'd2;   // 2 lines
parameter V_BACK_PORCH  = 10'd33;  // 33 lines
parameter V_DISPLAY_INT = 10'd480; // 480 lines
parameter V_FRONT_PORCH = 10'd10;  // 10 lines
parameter V_TOTAL       = 10'd525; // total width -- 2 + 33 + 480 + 10 = 525



assign hsync = ~((hcount >= H_BACK_PORCH) & (hcount < H_BACK_PORCH + H_SYNC));
assign vsync = ~((vcount >= V_DISPLAY_INT + V_FRONT_PORCH) & (vcount < V_DISPLAY_INT + V_FRONT_PORCH + V_SYNC));

bitgen bits(vga_blank_n, hcount, vcount, game_board, column_no, player, RGB, vga_lookup);


always @(posedge clk) begin
	
	if (rst) begin
		vcount  <= 10'd0;
		hcount  <= 10'd0;
		vga_clk <= 1'b0;
	end
	
	else if (vga_clk) begin
		hcount <= hcount + 1'b1;
		
		// clear if reaches end
		if (hcount == H_TOTAL) begin
			hcount <= 10'd0;
			vcount <= vcount + 1'b1;
			
			if (vcount == V_TOTAL)
				vcount <= 10'd0;
		end
	end
	
	vga_clk <= ~vga_clk; // generates 25MHz vga_clk
end

always @(hcount,vcount) begin
	
	// bright
	if ((hcount >= H_BACK_PORCH + H_SYNC + H_FRONT_PORCH) &&
		 (hcount < H_TOTAL - H_FRONT_PORCH) &&
		 (vcount < V_DISPLAY_INT))
		 vga_blank_n = 1'b1;
		 
	 
	 else 
		vga_blank_n = 1'b0;
		
end

endmodule

////////////////////////////////////////////////////////////////////////////////////////
//FSM CODE
///////////////////////////////////////////////////////////////////////////////////////

module StateConversion(
	input left, right, center,
	output reg [1:0] state
);

always@(*) begin
	if (left) begin
		state = 2'b10;	
	end
	else if (right) begin
		state = 2'b01;
	end
	
	else if (center) begin
		state = 2'b11;
	end
	
	else begin
		state = 2'b00;
	end
end

endmodule
