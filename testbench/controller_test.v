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

module controller_test;

	// Inputs
	reg [15:0] RegEnable; //This was an input, but changed to wire for FSM
	reg [3:0] reg_s1, reg_s2;
	reg [3:0] imm_val;
	reg [7:0] opcode;
	reg Clocks, reset;
	
	// Outputs
	wire [15:0] r15;		
	wire [15:0] Bus;
	wire [6:0] out1, out2;
	integer i;

	// Instantiate the Unit Under Test (UUT)
	Controller uut (
		.Clocks(Clocks),
		.reset(reset),
		.out1(out1),
		.out2(out2),
		.Bus(Bus)
	);

	initial begin
	
//		reset = 1;
		RegEnable = 0;
		reg_s1 = 5; // Avoid adding with R0 later. 
		reg_s2 = 0;
		imm_val = 0;
		opcode = 0;
		RegEnable = 0; // Select R0 to be written to
		Clocks = 0;
		reset = 0;
		
		#20; 
		
		for (i = 0; i < 40; i = i + 1) begin
			Clocks = ~Clocks;
			#10;
		end
	

	end

endmodule 
