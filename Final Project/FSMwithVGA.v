module FSMwithVGA(
	input	clk, rst, left, right, center,
	output hsync, vsync,
	output vga_blank, vga_clk,
	output [23:0] RGB
);

wire [1:0] state;
wire [11:0] vga_lookup;
wire [15:0] game_board;

StateConversion State(left, right, center, state);
FSM_Final FSM(.Clock(clk), .Reset(rst), .controller_state(state), .vga_lookup(vga_lookup), .vga_out(game_board));
top_level_counter counter(clk, rst, state, hysnc, vsync, vga_blank, vga_clk, game_board, RGB, vga_lookup);

endmodule

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
