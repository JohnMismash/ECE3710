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

module fibonacci_test;

	// Inputs
	reg [15:0] RegEnable; //This was an input, but changed to wire for FSM
	reg [3:0] reg_s1, reg_s2;
	reg [3:0] imm_val;
	reg [7:0] opcode;
	reg Clocks, reset;
	
	// Outputs
	wire [15:0] r15;		
	wire [15:0] Bus;
	integer i;

	// Instantiate the Unit Under Test (UUT)
	regfile_tb_version uut (
		.Clocks(Clocks),
		.reset(reset),
		.RegEnable(RegEnable),
		.reg_s1(reg_s1),
		.reg_s2(reg_s2),
		.imm_val(imm_val),
		.opcode(opcode),
		.r15(r15),
		.Bus(Bus)
	);

	initial begin
//			$monitor("A: %0d, B: %0d, C: %0d, Flags[1:0]:
//%b, time:%0d", A, B, C, Flags[1:0], $time );
//Instead of the $display stmt in the loop, you could use just this
//monitor statement which is executed everytime there is an event on any
//signal in the argument list.

		// Initialize Inputs
		reset = 1;
		RegEnable = 0;
		reg_s1 = 5; // Avoid adding with R0 later. 
		reg_s2 = 0;
		imm_val = 0;
		opcode = 0;
		RegEnable = 0; // Select R0 to be written to
		
		// Instruction 1 - Load 1 into R15
		#20
		Clocks = 0;
		reset = 0;
		imm_val = 1;
		RegEnable[0] = 1; // Select R0 to be written to
		RegEnable[15] = 1;
		opcode[0] = 1; // Set op to ADDI
		//reg_select = 4'b0000; // Select R0 to be read from
		#20;
		Clocks = 1; // Load 1 into R0

		#20;
		$display("R0 = %0d", r15);
		Clocks = 0;
		RegEnable = 'd0; // Reset RegEnable
		RegEnable[1] = 1; // Select R1 to be written to
		RegEnable[15] = 1;
		imm_val = 1;
		opcode[0] = 1; // Set op to ADDI
				
		#20
		Clocks = 1; // Load 1 into R1
		
		#20
		$display("R1 = %0d", r15);
		Clocks = 0;

		opcode = 'd0; // Set to ADD op
		for (i = 2; i < 16; i = i + 1) begin
			Clocks = 0;
			RegEnable = 'd0; // Reset reg to write to
			RegEnable[i] = 1; // Enable reg i to write to
			RegEnable[15] = 1; // Write to R15 to check values.
			reg_s1 = i-2; // Select reg A
			reg_s2 = i-1; // Select reg B
			
			#20;
			
			Clocks = 1;
			
			#20;
			$display("R%0d = %0d", i, r15); // Should be 987 at R15
		end
		
		//$display("R15 = %0d", r15); // Should be 987
		Clocks = 0;
		#20;
	

	end

endmodule
