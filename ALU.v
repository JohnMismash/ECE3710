`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineers: John Mismash, Andrew Porter, Vanessa Bentley, Zach Phelan
//
// Create Date:    12:54:08 08/30/2021
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
// Additional Comments: Testing
//
//////////////////////////////////////////////////////////////////////////////////
module alu( A, B, C, Opcode, Flags);
input [15:0] A, B;
input [7:0] Opcode;
output reg [15:0] C;
output reg [4:0] Flags; // Flags[4]-ZF Flags[3]-CF,  Flags[2]-FF, Flags[1]-LF, Flags[0]-NF

parameter ADD = 8'b00000000;
parameter ADDI = 8'00001000;
parameter ADDU = 8'b00010000;
parameter ADDUI = 8'b00011000;
parameter ADDC = 8'b00100000;
parameter ADDCU = 8'b00101000;
parameter ADDCUI = 8'b00110000;
parameter ADDCI = 8'b00111000;
parameter SUB = 8'b01000000;
parameter SUBI = 8'b01001000;
parameter CMP = 8'b01010000;
parameter CMPI = 8'b01011000;
parameter AND = 8'b01100000;
parameter OR = 8'b01101000;
parameter XOR = 8'b01110000;
parameter NOT = 8'b01111000;
parameter LSH = 8'b10000000;
parameter LSHI = 8'b10001000;
parameter RSH = 8'b10010000;
parameter RSHI = 8'b10011000;
parameter ALSH = 8'b10100000;
parameter ARSH = 8'b10101000;
parameter NOP = 8'b10110000;
parameter CMPU = 8'b11100000;

always @(A, B, Opcode)
begin
	case (Opcode)
	ADDU:
		begin
		{Flags[3], C} = A + B;
		// perhaps if ({Flags[3], C} == 5'b00000) ....
		if (C == 'h0) Flags[4] = 1'b1; // Set Z flag if all zeros
		else Flags[4] = 1'b0;
		Flags[2:0] = 3'b000;
		end

	ADD:
		begin
		C = A + B;
		if (C == 'h0) Flags[4] = 1'b1;
		else Flags[4] = 1'b0;
		if( (~A[15] & ~B[15] & C[15]) | (A[15] & B[15] & ~C[15]) ) Flags[2] = 1'b1; // Checks if overflow occurred. Another way of writing it: if (a > 0 & b > 0 & c < 0 | a < 0 & b < 0 & c > 0), set overflow bit.
		else Flags[2] = 1'b0;
		Flags[1:0] = 2'b00; Flags[3] = 1'b0;
		end

    ADDI:
        begin
		C = A + B;
		if (C == 4'b0000) Flags[4] = 1'b1;
		else Flags[4] = 1'b0;
		if( (~A[15] & ~B[15] & C[15]) | (A[15] & B[15] & ~C[15]) ) Flags[2] = 1'b1;
		else Flags[2] = 1'b0;
		Flags[1:0] = 2'b00; Flags[3] = 1'b0;
		end

    ADDUI:
		begin
		{Flags[3], C} = A + B;
		// perhaps if ({Flags[3], C} == 5'b00000) ....
		if (C == 'h0) Flags[4] = 1'b1;
		else Flags[4] = 1'b0;
		Flags[2:0] = 3'b000;
		end

    ADDC:
        begin
        C = A + B + Flags[3];
		if (C == 'h0) Flags[4] = 1'b1;
		else Flags[4] = 1'b0;
		if( (~A[15] & ~B[15] & C[15]) | (A[15] & B[15] & ~C[15]) ) Flags[2] = 1'b1;
		else Flags[2] = 1'b0;
		Flags[1:0] = 2'b00; Flags[3] = 1'b0;
		end

    ADDCU:
		begin
		{Flags[3], C} = A + B + Flags[3];
		// perhaps if ({Flags[3], C} == 5'b00000) ....
		if (C == 'h0) Flags[4] = 1'b1;
		else Flags[4] = 1'b0;
		Flags[2:0] = 3'b000;
		end

    ADDCUI:
		begin
		{Flags[3], C} = A + B + Flags[3];
		// perhaps if ({Flags[3], C} == 5'b00000) ....
		if (C == 'h0) Flags[4] = 1'b1;
		else Flags[4] = 1'b0;
		Flags[2:0] = 3'b000;
		end

    ADDCI:
		begin
		{Flags[3], C} = A + Flags[3];
		// perhaps if ({Flags[3], C} == 5'b00000) ....
		if (C == 'h0) Flags[4] = 1'b1;
		else Flags[4] = 1'b0;
		Flags[2:0] = 3'b000;
		end

	SUB:
		begin
		C = A - B;
		if (C == 16'd0) Flags[4] = 1'b1; //Sets the Z flag
		else Flags[4] = 1'b0;
		if( (~A[15] & ~B[15] & C[15]) | (A[15] & B[15] & ~C[15]) ) Flags[2] = 1'b1; //Sets the F flag
		else Flags[2] = 1'b0;

		Flags[1:0] = 2'b00; Flags[3] = 1'b0; //Ensure Other Flags to 0
		end

	SUBI: //Same as SUB
		begin

		C = A - B;
		if (C == 16'd0) Flags[4] = 1'b1; //Sets the Z flag
		else Flags[4] = 1'b0;
		if( (~A[15] & ~B[15] & C[15]) | (A[15] & B[15] & ~C[15]) ) Flags[2] = 1'b1; //Sets the F flag
		else Flags[2] = 1'b0;

		Flags[1:0] = 2'b00; Flags[3] = 1'b0; //Ensure Other Flags to 0

		end
	CMP:
		begin
		if( $signed(A) < $signed(B) ) Flags[1:0] = 2'b11;
		else Flags[1:0] = 2'b00;
		C = 16'd0;
		if ($signed(A) == $signed(B)) Flags[4:2] = 3'b100;
		else Flags[4:2] = 3'b000;

		end

	CMPU:
		begin
		if ( A < B ) Flag[1:0] = 2'b10;
		else Flags[1:0] = 2'b00;
		C = 16'd0;
		if (A == B) Flags[4:2] = 3'b100;
		else Flags[4:2] = 3'b000;
		end

	AND:
		begin
		if (A == 1'b1 & B == 1'b1) // If both inputs are true, output is true
			C = 1'b1;
		else
			C = 1'b0; // Else output is false
		end

	OR:
		begin
		if (A == 1 | B == 1) // If A or B is true, Output is true
			C = 1'b1;
		else
			C = 1'b0; // Else output is false
		end

	XOR:
		begin
		if (A == 1'b0 & B == 1'b1 | A == 1'b1 & B == 1'b0) //If both inputs are true, output is true
			C = 1'b1;
		else
			C = 1'b0;
		end

	NOT:
		begin
			C = ~A; // Output is opposite of A, either 1 or 0

		end

  LSH:
      begin
      if (B > 0)
        // Perform shift on A by B
        A << B; // Fills with zeroes

      else
        // Perform shift by 1
        A << 1;
      end

  LSHI:
    begin
    if (B > 0)
      // Perform shift on A by B
      A << B; // Fills with zeroes

    else
      // Perform shift by 1
      A << 1;
    end

  ARSH:
    begin
    if (B > 0)
      // Perform shift on A by B
      A >>> B; // Sign extended

    else
      // Perform shift by 1
      A >>> 1; // Sign extended
    end

  ALSH:
    begin
    if (B > 0)
      // Perform shift on A by B
      A <<< B; // Sign extended

    else
      // Perform shift by 1
      A <<< 1; // Sign extended

    end
  RSHI:
    begin
    if (B > 0)
      // Perform shift on A by B
      A >>> B; // Sign extended

    else
      // Perform shift by 1
      A >>> 1; // Sign extended

    end


  NOP:
    begin
   	//do nothing

    end

	default:
		begin
			C = 4'b0000;
			Flags = 5'b00000;
		end
	endcase
end

endmodule
