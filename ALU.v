`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineers: John Mismash, Andrew Porter, Vanessa Bentley, Zach Phelan
//
// Create Date:    12:54:08 08/30/2011
// Design Name: First Go -2021
// Module Name:    alu 
// Project Name: TEAM 1
// Target Devices:
// Tool versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
module alu( A, B, C, Opcode, Flags
    );
input [15:0] A, B;
input [4:0] Opcode;
output reg [15:0] C;
output reg [4:0] Flags;

parameter ADDU = 5'b0;
parameter ADD = 5'b00000;
parameter SUB = 5'b;
parameter CMP = 5'b11;
parameter ADDI =5'b ;
parameter ADDUI = 5'b;
parameter ADDC = 5'b;
parameter ADDCU = 5'b;
parameter ADDCUI = 5'b;
parameter ADDCI = 5'b;
parameter SUBI = 5'b;
parameter CMPI = 5'b;
parameter AND =5
parameter OR
parameter XOR
parameter NOT
parameter LSH
parameter LSHI
parameter RSH
parameter RSHI
parameter ALSH
parameter ARSH
parameter NOP


always @(A, B, Opcode)
begin
	case (Opcode)
	ADDU:
		begin
		{Flags[3], C} = A + B;
		// perhaps if ({Flags[3], C} == 5'b00000) ....
		if (C == 4'b0000) Flags[4] = 1'b1;
		else Flags[4] = 1'b0;
		Flags[2:0] = 3'b000;
		end
	ADD:
		begin
		C = A + B;
		if (C == 4'b0000) Flags[4] = 1'b1;
		else Flags[4] = 1'b0;
		if( (~A[3] & ~B[3] & C[3]) | (A[3] & B[3] & ~C[3]) ) Flags[2] = 1'b1;
		else Flags[2] = 1'b0;
		Flags[1:0] = 2'b00; Flags[3] = 1'b0;

		end
	SUB:
		begin
		C = A - B;
		if (C == 4'b0000) Flags[4] = 1'b1;
		else Flags[4] = 1'b0;
		if( (~A[3] & ~B[3] & C[3]) | (A[3] & B[3] & ~C[3]) ) Flags[2] = 1'b1;
		else Flags[2] = 1'b0;
		Flags[1:0] = 2'b00; Flags[3] = 1'b0;
		end
	CMP:
		begin
		if( $signed(A) < $signed(B) ) Flags[1:0] = 2'b11;
		else Flags[1:0] = 2'b00;
		C = 4'b0000;
		Flags[4:2] = 3'b000;
		// both positive or both negative
		/*if( A[3] == B[3] )
		begin
			if (A < B) Flags[1:0] = 2'b11;
			else Flags[1:0] = 2'b00;
		end
		else if (A[3] == 1'b0) Flags[1:0] = 2'b00;
		else Flags[1:0] = 2'b01;
		Flags[4:2] = 3'b000;

		// C = ?? if I don;t specify, then I'm in trouble.
		C = 4'b0000;
		*/
		end
	default:
		begin
			C = 4'b0000;
			Flags = 5'b00000;
		end
	endcase
end

endmodule
