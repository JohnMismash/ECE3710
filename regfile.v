`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineers: John Mismash, Andrew Porter, Vanessa Bentley, Zach Phelan
//
// Create Date: 12:54:08 08/30/2021
// Design Name: First Go -2021
// Module Name: RegFile with ALU
// Project Name: TEAM 1
// Additional Comments: Combines the ALU module with the regfile as inputs and outputs
//
//////////////////////////////////////////////////////////////////////////////////

module RegFile(Clocks, reset, out1, out2);
	wire [15:0] RegEnable; //This was an input, but changed to wire for FSM
	input Clocks, reset;
	
	//Internal Wires
	wire [15:0] Bus, alu_out, r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, outA, outB, BInput;
	wire reset;
	wire [4:0] flagswire;
	wire [7:0] opcode;
	output wire [6:0] out1, out2;
	
	//Finite State Machine
	myFSMBaby bby(Clocks, reset, RegEnable, opcode); //This is just for a testbench type control
	
	FlagReg flags (Clocks, flagswire, flagswire);
	alu_mux alumux(outB, 4'b0001, 8'b00000011, BInput);
	reg_mux regA (r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, 4'b0110,outA);
	reg_mux regB (r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, 4'b0111,outB);
	ALU alu(outA, BInput, Bus, opcode, flagswire);
	RegBank reg_bank(Bus,r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, RegEnable, Clocks, reset);
	
	//Output Display
	hexTo7Seg firstdigit (outB[3:0],out1);
	hexTo7Seg seconddigit (outB[7:4],out2);
	
endmodule

//Stuff needs to be altered.
module myFSMBaby(clock, Reset, regControl, AluOp);

	input clock, Reset;
	output reg [15:0] regControl;
	output reg [7:0] AluOp;

	parameter S0=4'd0, S1=4'd1, S2=4'd2, S3=4'd3, S4=4'd4, S5=4'd5, S6=4'd6, S7=4'd7, S8=4'd8, S9=4'd9;
					 
	reg [3:0] states, S;	//PS - present state, NS
	
	initial states = 0;
	//Determines next state
	 always @ (posedge clock or negedge Reset) begin
			  if (!Reset)
					S <= S0;
			  else
					S <= states;
	end


	//Present State becomes next state
	always@(S)begin
		case(S)
						S0: states=S1;
						S1: states=S2;
						S2: states=S3;
						S3: states=S4;
						S4: states=S5;
						S5: states=S6;
						S6: states=S7;
						S7: states=S8;
						S8: states=S9;
						S9: states=S9;
						default: states = 4'd15;
					endcase
	end

	//Output relies only on current state
	always@(states)begin
	case (states)
		S0 : begin regControl = 16'b0010; AluOp = 2'b00; end //Reset every register and buffer close
		S1 : begin regControl = 3'b001; AluOp = 2'b00; end //open buffer for data and load R1
		S2 : begin regControl = 3'b010; AluOp = 2'b00; end //open up R2 for loadimmediate
		S3 : begin regControl = 3'b100; AluOp = 2'b00; end //Add numbers and store in R3
		S4 : begin regControl = 3'b010; AluOp = 2'b00; end //Transfer data to R2
		S5 : begin  regControl = 3'b100; AluOp = 2'b01; end //Bitwise OR R1+R2
		S6 : begin regControl = 3'b101; AluOp = 2'b01; end //Move Output to R1
		S7 : begin regControl = 3'b100; AluOp = 2'b11; end //Bitwise Complement
		S8 : begin regControl = 3'b101; AluOp = 2'b11; end //Move R3 to R1
		S9 : begin  regControl = 3'b100; AluOp = 2'b10; end //XOR R1 and R2
		default : begin  regControl = 3'b010; AluOp = 2'b00; end //Shouldn't happen
		endcase
	end


endmodule

module FlagReg (Clock, flag_reg_in, flag_reg_out);
	input Clock;//, enable;
	input [4:0] flag_reg_in;
	output reg [4:0] flag_reg_out;
	
	always @(posedge Clock) begin
		//if (enable)
			flag_reg_out = flag_reg_in;
	end
	
endmodule

module alu_mux(reg_val, imm_val, op_control, out);
	input [15:0] reg_val;
	input [3:0] imm_val;
	input [7:0] op_control;
	output reg [15:0] out;
	
	always @(*)begin//If op_control is equal to any immediate instructions
	if (op_control == 8'b00000001 || op_control == 8'b00000011 || op_control == 8'b00000110 || op_control == 8'b00000111|| op_control == 8'b00001001 || op_control == 8'b00010010 || op_control ==  8'b00010100) begin
			out = $signed(imm_val); end
			
	else begin
		out = reg_val; end
	end
		
endmodule


module reg_mux(r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, s, out);
	input [15:0] r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15; 
	input [3:0] s;
	output reg [15:0] out;
	
	always @(s) begin
		case(s)
			  4'b0000:  out <= r0; 
			  4'b0001:  out <= r1;
			  4'b0010:  out <= r2;
			  4'b0011:  out <= r3;
			  4'b0100:  out <= r4;
			  4'b0101:  out <= r5;
			  4'b0110:  out <= r6;
			  4'b0111:  out <= r7;
			  4'b1000:  out <= r8;
			  4'b1001:  out <= r9;
			  4'b1010:  out <= r10;
			  4'b1011:  out <= r11;
			  4'b1100:  out <= r12;
			  4'b1101:  out <= r13;
			  4'b1110:  out <= r14;
			  4'b1111:  out <= r15;
			  endcase
	end
	
endmodule


module Register(D_in, wEnable, reset, clk, r);
	input [15:0] D_in;
	input clk, wEnable, reset;
	output reg [15:0] r;
	 
 always @( posedge clk )
	begin
		if (reset) r <= 16'b00000000_00000000;
	else
		begin			
			if (wEnable)
				begin
					r <= D_in;
				end
			else
				begin
					r <= r;
				end
		end
	end
endmodule


// Shown below is one way to implement the register file
// This is a bottom-up, structural instantiation
// Another module is described in another file...
// .... which shows two dimensional construct for regfile

// Structural Implementation of RegBank
/********/
module RegBank(ALUBus, r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, regEnable, clk, reset);
	input clk, reset;
	input [15:0] ALUBus;
	input [15:0] regEnable;
	output [15:0] r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15;

	
Register Inst0(
	.D_in(ALUBus),
	.wEnable(regEnable[0]),
	.reset(reset), 
	.clk(clk),
	.r(r0));
Register Inst1(ALUBus, regEnable[1], reset, clk, r1);
Register Inst2(ALUBus, regEnable[2], reset, clk, r2);
Register Inst3(ALUBus, regEnable[3], reset, clk, r3);
Register Inst4(ALUBus, regEnable[4], reset, clk, r4);
Register Inst5(ALUBus, regEnable[5], reset, clk, r5);
Register Inst6(ALUBus, regEnable[6], reset, clk, r6);
Register Inst7(ALUBus, regEnable[7], reset, clk, r7);
Register Inst8(ALUBus, regEnable[8], reset, clk, r8);
Register Inst9(ALUBus, regEnable[9], reset, clk, r9);
Register Inst10(ALUBus, regEnable[10], reset, clk, r10);
Register Inst11(ALUBus, regEnable[11], reset, clk, r11);
Register Inst12(ALUBus, regEnable[12], reset, clk, r12);
Register Inst13(ALUBus, regEnable[13], reset, clk, r13);
Register Inst14(ALUBus, regEnable[14], reset, clk, r14);
Register Inst15(ALUBus, regEnable[15], reset, clk, r15); 

endmodule
/**************/

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

module hexTo7Seg(input [3:0]x, output reg [6:0]z);
always @*
case(x)
	4'b0000 :			//Hexadecimal 0
	z = ~7'b0111111;
   4'b0001 :			//Hexadecimal 1
	z = ~7'b0000110;
   4'b0010 :			//Hexadecimal 2
	z = ~7'b1011011;
   4'b0011 : 			//Hexadecimal 3
	z = ~7'b1001111;
   4'b0100 : 			//Hexadecimal 4
	z = ~7'b1100110;
   4'b0101 : 			//Hexadecimal 5
	z = ~7'b1101101;
   4'b0110 : 			//Hexadecimal 6
	z = ~7'b1111101;
   4'b0111 :			//Hexadecimal 7
	z = ~7'b0000111;
   4'b1000 : 			//Hexadecimal 8
	z = ~7'b1111111;
   4'b1001 : 			//Hexadecimal 9
	z = ~7'b1100111;
	4'b1010 : 			//Hexadecimal A
	z = ~7'b1110111;
	4'b1011 : 			//Hexadecimal B
	z = ~7'b1111100;
	4'b1100 : 			//Hexadecimal C
	z = ~7'b1011000;
	4'b1101 : 			//Hexadecimal D
	z = ~7'b1011110;
	4'b1110 : 			//Hexadecimal E
	z = ~7'b1111001;
	4'b1111 : 			//Hexadecimal F	
	z = ~7'b1110001; 
   default :
	z = ~7'b0000000;
endcase
endmodule 
