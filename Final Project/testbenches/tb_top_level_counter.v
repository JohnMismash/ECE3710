module tb_top_level_counter;

	reg clock, reset;
	wire [15:0] programm;

	// Instantiate the Unit Under Test (UUT)
	top_level_counter uut (
		.Clk(clock),
		.Reset(reset),
		.Hsync(hsync),
		.Vsync(vsync),
		.Red(red),
		.Green(green),
		.Blue(blue)
		);

	initial begin

		// Initialize Inputs

		reset = 0;
		clock = 0;

		#15;
		// reset = 1;
		// #10
		// reset=0;
		// #10
		// reset = 1;

		// Add stimulus here

	end

	always #10 clock = ~clock;
	//always #200 reset = ~reset;

endmodule
