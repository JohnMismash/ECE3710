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
	reg Clocks, reset;
	reg [15:0] RegEnable;

	// Outputs
	reg [15:0] Bus, alu_out, r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, outA, outB, BInput;
	wire [4:0] flagswire;

	integer i;
	// Instantiate the Unit Under Test (UUT)
	ALU uut (
		.Clocks(Clocks),
		.RegEnable(RegEnable),
		.reset(reset),
		.Bus(Bus),
		.alu_out(alu_out)
		.r0(r0),
		.r1(r1),
		.r2(r2),
		.r3(r3),
		.r4(r4),
		.r5(r5),
		.r6(r6),
		.r7(r7),
		.r8(r8),
		.r9(r9),
		.r10(r10),
		.r11(r11),
		.r12(r12),
		.r13(r13),
		.r14(r14),
		.r15(r15),
		.outA(outA),
		.outB(outB),
		.BInput(BInput),
		.flagswire(flagswire)
	);

	initial begin
//			$monitor("A: %0d, B: %0d, C: %0d, Flags[1:0]:
//%b, time:%0d", A, B, C, Flags[1:0], $time );
//Instead of the $display stmt in the loop, you could use just this
//monitor statement which is executed everytime there is an event on any
//signal in the argument list.

		// Initialize Inputs
		A = 5;
		B = -7;
		Opcode = 8'b00000000;

		// Wait 100 ns for global reset to finish
/*****
		// One vector-by-vector case simulation
		#10;
	        Opcode = 2'b11;
		A = 4'b0010; B = 4'b0011;
		#10
		A = 4'b1111; B = 4'b 1110;
		//$display("A: %b, B: %b, C:%b, Flags[1:0]: %b, time:%d", A, B, C, Flags[1:0], $time);
****/
		//Random simulation
		for( i = 0; i< 32; i = i+ 1)
		begin
			#10
			Opcode = 0;
			A = i;
			B = 3*i;

			if (C != A + B)
				$display("Error: %0d + %0d != %0d", A, B, C);
			//B = 2 + i;
			//$display("A: %0d, B: %0d, C: %0d, Flags[1:0]: %b, time:%0d", A, B, C, Flags[1:0], $time );
		end


	end

endmodule
