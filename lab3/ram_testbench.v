`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:25:01 08/30/2011
// Design Name:   alu
// Module Name:   C:/Documents and Settings/Administrator/ALU/alutest.v
// Project Name:  ALU
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: alu
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_SDRAM;

	reg clocksig, reset;
	wire [6:0] first, secd, thrd, forth;
	
	// Instantiate the Unit Under Test (UUT)
	FSM_Wrapper uut (
		.Clock(clocksig), 
		.Reset(reset), 
		.out1(first), 
		//.out2(secd), 
		.out3(thrd),
		.out4(forth)
	);

	initial begin
		
		
//			$monitor("A: %0d, B: %0d, C: %0d, Flags[1:0]:
//%b, time:%0d", A, B, C, Flags[1:0], $time );
//Instead of the $display stmt in the loop, you could use just this
//monitor statement which is executed everytime there is an event on any

		
		// Initialize Inputs
		
		reset = 0;
		clocksig = 0;
		
		#15
		reset = 1;
		//#10
		//reset=0;
		//#10
		//reset = 1;

		//Random simulation
		$display("Starting tests:");
		#100
		$display("%b | %b, %b %b", clocksig, forth, thrd, first);
		//$display();
		
		// Add stimulus here

	end
	
	always #10 clocksig = ~clocksig;
	
      endmodule 
