`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:54:08 08/30/2011 
// Design Name: 
// Module Name:    alu 
// Project Name: 
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

parameter ADDU = 5'b00010;
parameter ADD = 5'b00000;
parameter SUB = 5'b01000;
parameter CMP = 5'b01010;
parameter ADDI =5'b00001 ;
parameter ADDUI = 5'b00011;
parameter ADDC = 5'b00100;
parameter ADDCU = 5'b00101;
parameter ADDCUI = 5'b00110;
parameter ADDCI = 5'b00111;
parameter SUBI = 5'b01001;
parameter CMPI = 5'b01011;
parameter AND =5'b01100;
parameter OR = 5'b01101;
parameter XOR = 5'b01110;
parameter NOT = 5'b01111;
parameter LSH = 5'b10000;
parameter LSHI = 5'b10001;
parameter RSH = 5'b10010;
parameter RSHI = 5'b10011
parameter ALSH = 5'b10100;
parameter ARSH = 5'b10101;
parameter NOP = 5'b10110;


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
