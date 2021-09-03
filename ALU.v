<<<<<<< current
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
// Additional Comments: Testing
//
//////////////////////////////////////////////////////////////////////////////////
module alu( A, B, C, Opcode, Flags
    );
input [15:0] A, B;
input [7:0] Opcode;
output reg [15:0] C;
output reg [4:0] Flags; // Flags[4]-ZF Flags[3]-LF,  Flags[2]-FF, Flags[1]-NF, Flags[0]-CF

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

		// C = ?? if I don't specify, then I'm in trouble.
		C = 4'b0000;
		*/
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

  RSH:
    begin



    end


  RSHI:
      begin



      end
	default:
		begin
			C = 4'b0000;
			Flags = 5'b00000;
		end
	endcase
end

endmodule
=======
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
// Additional Comments: Testing
//
//////////////////////////////////////////////////////////////////////////////////
module alu( A, B, C, Opcode, Flags
    );
input [15:0] A, B;
input [7:0] Opcode;
output reg [15:0] C;
output reg [4:0] Flags;

parameter ADD = 8'b00000000;
parameter ADDI = 8'00001000;
parameter ADDU = 8'b00010000;
parameter ADDUI = 8'b00011000;
parameter ADDC = 8'b00100000;
parameter ADDCU = 8'b00101000;
parameter ADDCUI = 8'b00110000;
parameter ADDCI = 8'b00111000;
parameter SUB = 8'b01000;
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

		// C = ?? if I don't specify, then I'm in trouble.
		C = 4'b0000;
		*/
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

  RSH:
    begin
    if (B > 0)
      // Perform shift on A by B
      A >> B; // Fills with zeroes

    else
      // Perform shift by 1
      A >> 1;
    end

  RSHI:
    begin
    if (B > 0)
      // Perform shift on A by B
      A >> B;

    else
      // Perform shift by 1
      A >> 1

    end

	default:
		begin
			C = 4'b0000;
			Flags = 5'b00000;
		end
	endcase
end

endmodule
>>>>>>> before discard
