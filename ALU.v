
	`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineers: John Mismash, Andrew Porter, Vanessa Bentley, Zach Phelan
//
// Create Date: 12:54:08 08/30/2021
// Design Name: First Go -2021
// Module Name: alu
// Project Name: TEAM 1
// Additional Comments: Testing
//
//////////////////////////////////////////////////////////////////////////////////

module ALU( A, B, C, Opcode, Flags);
input [15:0] A, B;
input [7:0] Opcode;
output reg [15:0] C;
output reg [4:0] Flags; // Flags[4]-ZF Flags[3]-CF,  Flags[2]-FF, Flags[1]-LF, Flags[0]-NF

parameter ADD    = 8'b00000000;
parameter ADDI   = 8'b00000001;
parameter ADDU   = 8'b00000010;
parameter ADDUI  = 8'b00000011;
parameter ADDC   = 8'b00000100;
parameter ADDCU  = 8'b00000101;
parameter ADDCUI = 8'b00000110;
parameter ADDCI  = 8'b00000111;
parameter SUB    = 8'b00001000;
parameter SUBI   = 8'b00001001;
parameter CMP    = 8'b00001010;
parameter CMPI   = 8'b00001011;
parameter CMPU   = 8'b00001100;
parameter AND    = 8'b00001101;
parameter OR     = 8'b00001110;
parameter XOR    = 8'b00001111;
parameter NOT    = 8'b00010000;
parameter LSH    = 8'b00010001;
parameter LSHI   = 8'b00010010;
parameter RSH    = 8'b00010011;
parameter RSHI   = 8'b00010100;
parameter ALSH   = 8'b00010101;
parameter ARSH   = 8'b00010110;
parameter NOP    = 8'b00010111;


always @(A, B, Opcode)
begin
	case (Opcode)
	ADDU:
		begin
		{Flags[3], C} = A + B;

		if (C == 'h0)
			Flags[4] = 1'b1; // Set Z flag if all zeros
		else
			Flags[4] = 1'b0;
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
		if ( A < B ) Flags[1:0] = 2'b10; // A is Rdest, B is Rsrc
		else Flags[1:0] = 2'b00;
		C = 16'd0;
		if (A == B) Flags[4:2] = 3'b100;
		else Flags[4:2] = 3'b000;
		end


	AND:
		begin
			C = A & B;
			Flags = 5'd0;
		end

	OR:
		begin
			C = A | B;
			Flags = 5'd0;
		end

	XOR:
		begin
		C = A ^ B;
		Flags = 5'd0;
		end

	NOT:
		begin
			C = ~A; // Output is opposite of A, either 1 or 0
		Flags = 5'd0;
		end

  LSH:
      begin
      if (B > 0)
        // Perform shift on A by B
        C  = A << B; // Fills with zeroes

      else
        // Perform shift by 1
        C = A << 1;
      Flags = Flags;
      end

  LSHI:
    begin
    if (B > 0)
      // Perform shift on A by B
      C = A << B; // Fills with zeroes

    else
      // Perform shift by 1
      C = A << 1;
    Flags = Flags;
    end

  ARSH:
    begin
    if (B > 0)
      // Perform shift on A by B
      C = A >>> B; // Sign extended

    else
      // Perform shift by 1
      C = A >>> 1; // Sign extended
    Flags = Flags;
    end

  ALSH:
    begin
    if (B > 0)
      // Perform shift on A by B
      C = A << B; // Sign extended

    else
      // Perform shift by 1
      C =A << 1; // Sign extended
	Flags = Flags;
    end

  RSH:
    begin
    if (B > 0)
      // Perform shift on A by B
      C = A >> B; // Sign extended

    else
      // Perform shift by 1
      C = A >> 1; // logical extended
Flags = Flags;
    end
  RSHI:
    begin
    if (B > 0)
      // Perform shift on A by B
      C = A >>> B; // Sign extended

    else
      // Perform shift by 1
      C = A >>> 1; // Sign extended
		Flags = Flags;
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
