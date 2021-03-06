module register_mod(instruction, reset, Clocks, mem_data_in, outBus, outA, outB, ren, load_mux, flagwire);
	input [15:0] instruction, mem_data_in;
	input Clocks, reset, ren, load_mux;

	wire [15:0] reg_w;
	output wire [15:0] flagwire;
	wire [3:0] reg_enable_decoder;
	wire [15:0] alu_out, r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15,  B_muxed, alu_output;

	output [15:0] outBus, outA, outB;
	
	reg [3:0] A, B;
	reg [7:0] opcode;

	always@(*)begin //Sets the different sections of the flag
		opcode = instruction[15:8];
		A = instruction[7:4];
		B = instruction[3:0];
	end

	Decoder_mux decode(load_mux,opcode, A, B, reg_enable_decoder); 
	Fourto16decoder regEnable(ren, opcode, reg_enable_decoder, reg_w);
	
	//Component modules
	RegBank reg_bank(outBus,r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, reg_w, Clocks, reset);	
	//Register flags (flagwire, 1'b1, reset, Clocks, flagwire); 
	reg_mux regA (r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, A,outA);
	reg_mux regB (r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, B,outB);
	alu_mux alumux(outB, B, opcode, B_muxed);
	ALU alu(outA, B_muxed, alu_output, opcode, flagwire);
	load_mux load(load_mux, mem_data_in, alu_output, outBus);

endmodule 

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module Fourto16decoder(ren, Opcode, d_in, d_out);
	input ren;
	input [3:0] d_in;
	input [7:0] Opcode;
	output reg [15:0] d_out;
	parameter tmp = 16'b0000_0000_0000_0001;
	parameter NOP    = 8'b00010111;
	parameter STORE  = 8'b11011010;
	parameter LOAD   = 8'b10011001;
	parameter CMP    = 8'b00001010;
	parameter CMPI   = 8'b00001011;
	parameter CMPU   = 8'b00001100;

always@(*) begin

	if (ren) begin
		
		if (Opcode == CMP || Opcode == CMPI || Opcode == CMPU) begin //Do not enable any reg in case of CMP or NOP instruction
			d_out = 16'd0; end
		
		else begin
			case (d_in)
				4'b0000: begin d_out = tmp; end
				4'b0001: begin d_out = tmp<<1; end
				4'b0010: begin d_out = tmp<<2; end
				4'b0011: begin d_out = tmp<<3; end
				4'b0100: begin d_out = tmp<<4; end
				4'b0101: begin d_out = tmp<<5; end
				4'b0110: begin d_out = tmp<<6; end
				4'b0111: begin d_out = tmp<<7; end
				4'b1000: begin d_out = tmp<<8; end
				4'b1001: begin d_out = tmp<<9; end
				4'b1010: begin d_out = tmp<<10; end
				4'b1011: begin d_out = tmp<<11; end
				4'b1100: begin d_out = tmp<<12; end
				4'b1101: begin d_out = tmp<<13; end
				4'b1110: begin d_out = tmp<<14; end
				4'b1111: begin d_out = tmp<<15; end
				default: begin d_out = 16'bxxxx_xxxx_xxxx_xxxx; end
			endcase
		end
	end
			
			
	else
		d_out = 16'd0;
end

endmodule 

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module reg_mux(r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, s, out);
	input [15:0] r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15; 
	input [3:0] s;
	output reg [15:0] out;
	
	always @(*) begin
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

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module alu_mux(reg_val, imm_val, op_control, out);
	input [15:0] reg_val;
	input [3:0] imm_val;
	input [7:0] op_control;
	output reg [15:0] out;

	
	always @(*)begin//If op_control is equal t store or immediate instructions, output those
	if (op_control == 8'b00000001 /*ADDI*/||  op_control == 8'b00000111 /*ADDCI*/ || op_control == 8'b00001011 /*CMPI*/)
		out = $signed(imm_val);
	else if (op_control == 8'b00000011 /*ADDUI*/ || op_control == 8'b00000110 /*ADDCUI*/|| op_control == 8'b00001001 /*SUBI*/||op_control == 8'b00010010 /*LSHI*/||op_control ==  8'b00010100 /*RSHI*/) begin
			out = $unsigned(imm_val); end
			
	else begin
		out = reg_val; end
	end
		
endmodule
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 
// Mux for the decoder to write to register
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Decoder_mux(loader, instr_code, enableA, enableB, ABEnable);
input [7:0] instr_code;
input [3:0] enableA, enableB;
input loader;
output reg [3:0] ABEnable;
parameter STORE  = 8'b11011010;
parameter LOAD   = 8'b10011001;

always@(*)begin
	if(instr_code == LOAD || loader) //Let the 2 MSB be equal to 10 indicating a load instruction. enable B register
		ABEnable = enableB;	
	else
		ABEnable = enableA;  //Otherwise enable A register as normal
	
end
endmodule 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 
// Mux for the Loading in immediate value or value from dataB from memory
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module load_mux(loader, mem_data, alu_output, c_output);
input loader;
input [15:0] mem_data;
input [15:0] alu_output;
output reg [15:0] c_output;

always@(*)begin
	if(loader) //Let the 2 MSB be equal to 10 indicating a load instruction. Load data from memory
		c_output = mem_data;
			
	else
		c_output = alu_output;  //If it is not an immediate or store instruction, outputs undefined
	
end
endmodule 
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module Register(D_in, wEnable, reset, clk, r);
	input [15:0] D_in;
	input clk, wEnable, reset;
	output reg [15:0] r;
	 
 always @( posedge clk )
	begin
		if (!reset) begin
			r <= 16'b0000000000000000; end
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

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module ALU( A, B, C, Opcode, Flags);
input [15:0] A, B;
input [7:0] Opcode;
output reg [15:0] C;
output reg [15:0] Flags; // Flags[4]-ZF Flags[3]-CF,  Flags[2]-FF, Flags[1]-LF, Flags[0]-NF -> truncate leading bits

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
parameter STORE  = 8'b11011010;
parameter LOAD   = 8'b10011001;

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
		Flags[15:5] = 9'b0;
		end

	ADD:
		begin
		C = A + B;
		if (C == 'h0) Flags[4] = 1'b1;
		else Flags[4] = 1'b0;
		if( (~A[15] & ~B[15] & C[15]) | (A[15] & B[15] & ~C[15]) ) Flags[2] = 1'b1; // Checks if overflow occurred. Another way of writing it: if (a > 0 & b > 0 & c < 0 | a < 0 & b < 0 & c > 0), set overflow bit.
		else Flags[2] = 1'b0;
		Flags[1:0] = 2'b00; Flags[3] = 1'b0;
		Flags[15:5] = 9'b0;
		end

    ADDI:
        begin
		C = A + B;
		if (C == 4'b0000) Flags[4] = 1'b1;
		else Flags[4] = 1'b0;
		if( (~A[15] & ~B[15] & C[15]) | (A[15] & B[15] & ~C[15]) ) Flags[2] = 1'b1;
		else Flags[2] = 1'b0;
		Flags[1:0] = 2'b00; Flags[3] = 1'b0;
		Flags[15:5] = 9'b0;
		end

    ADDUI:
		begin
		{Flags[3], C} = (A + B);
		// perhaps if ({Flags[3], C} == 5'b00000) ....
		if (C == 'h0) Flags[4] = 1'b1;
		else Flags[4] = 1'b0;
		Flags[2:0] = 3'b000;
		Flags[15:5] = 9'b0;
		end

    ADDC:
        begin
        C = A + B + Flags[3];
		if (C == 'h0) Flags[4] = 1'b1;
		else Flags[4] = 1'b0;
		if( (~A[15] & ~B[15] & C[15]) | (A[15] & B[15] & ~C[15]) ) Flags[2] = 1'b1;
		else Flags[2] = 1'b0;
		Flags[1:0] = 2'b00; Flags[3] = 1'b0;
		Flags[15:5] = 9'b0;
		end

    ADDCU:
		begin
		{Flags[3], C} = A + B + Flags[3];
		// perhaps if ({Flags[3], C} == 5'b00000) ....
		if (C == 'h0) Flags[4] = 1'b1;
		else Flags[4] = 1'b0;
		Flags[2:0] = 3'b000;
		Flags[15:5] = 9'b0;
		end

    ADDCUI:
		begin
		{Flags[3], C} = A + B + Flags[3];
		// perhaps if ({Flags[3], C} == 5'b00000) ....
		if (C == 'h0) Flags[4] = 1'b1;
		else Flags[4] = 1'b0;
		Flags[2:0] = 3'b000;
		Flags[15:5] = 9'b0;
		end

    ADDCI:
		begin
		{Flags[3], C} = A + Flags[3];
		// perhaps if ({Flags[3], C} == 5'b00000) ....
		if (C == 'h0) Flags[4] = 1'b1;
		else Flags[4] = 1'b0;
		Flags[2:0] = 3'b000;
		Flags[15:5] = 9'b0;
		end

	SUB:
		begin
		C = A - B;
		if (C == 16'd0) Flags[4] = 1'b1; //Sets the Z flag
		else Flags[4] = 1'b0;
		if( (~A[15] & ~B[15] & C[15]) | (A[15] & B[15] & ~C[15]) ) Flags[2] = 1'b1; //Sets the F flag
		else Flags[2] = 1'b0;

		Flags[1:0] = 2'b00; Flags[3] = 1'b0; //Ensure Other Flags to 0
		Flags[15:5] = 9'b0;
		end

	SUBI: //Same as SUB
		begin
		C = A - B;
		if (C == 16'd0) Flags[4] = 1'b1; //Sets the Z flag
		else Flags[4] = 1'b0;
		if( (~A[15] & ~B[15] & C[15]) | (A[15] & B[15] & ~C[15]) ) Flags[2] = 1'b1; //Sets the F flag
		else Flags[2] = 1'b0;
		Flags[1:0] = 2'b00; Flags[3] = 1'b0; //Ensure Other Flags to 0
		Flags[15:5] = 9'b0;
		end
		
	CMP: // Flags[4]-ZF Flags[3]-CF,  Flags[2]-FF, Flags[1]-LF, Flags[0]-NF
		begin
		if( $signed(A) < $signed(B) ) Flags[1:0] = 2'b00; //A is less than b so number is not negative or lower than 0
		else Flags[1:0] = 2'b11;
		C = 16'dx;
		if ($signed(A) == $signed(B)) Flags[4:2] = 3'b100;
		else Flags[4:2] = 3'b000;
		Flags[15:5] = 9'b0;
		end

	CMPU:
		begin
		if ( A < B ) Flags[1:0] = 2'b00; // A is Rdest, B is Rsrc
		else Flags[1:0] = 2'b10;
		C = 16'dx;
		if (A == B) Flags[4:2] = 3'b100;
		else Flags[4:2] = 3'b000;
		Flags[15:5] = 9'b0;
		end

	
	CMPI:
		begin
		if ( A < B ) Flags[1:0] = 2'b00; // A is Rdest, B is Immediate value
		else Flags[1:0] = 2'b10;
		C = 16'dx;
		if (A == B) Flags[4:2] = 3'b100;
		else Flags[4:2] = 3'b000;
		Flags[15:5] = 9'b0;
		end
		
	AND:
		begin
			C = A & B;
			Flags = 16'd0;
		end

	OR:
		begin
			C = A | B;
			Flags = 16'dx;
		end

	XOR:
		begin
		C = A ^ B;
		Flags = 16'dx;
		end

	NOT:
		begin
			C = ~A; // Output is opposite of A, either 1 or 0
		Flags = 16'dx;
		end

  LSH:
      begin
      if (B > 0)
        // Perform shift on A by B
        C  = A << B; // Fills with zeroes

      else
        // Perform shift by 1
        C = A << 1;
      Flags = 16'dx;
      end

  LSHI:
    begin
    if (B > 0)
      // Perform shift on A by B
      C = A << B; // Fills with zeroes

    else
      // Perform shift by 1
      C = A << 1;
    Flags = 16'dx;
    end

  ARSH:
    begin
    if (B > 0)
      // Perform shift on A by B
      C = A >>> B; // Sign extended

    else
      // Perform shift by 1
      C = A >>> 1; // Sign extended
    Flags = 16'dx;
    end

  ALSH:
    begin
    if (B > 0)
      // Perform shift on A by B
      C = A << B; // Sign extended

    else
      // Perform shift by 1
      C =A << 1; // Sign extended
	Flags = 16'dx;
    end

  RSH:
    begin
    if (B > 0)
      // Perform shift on A by B
      C = A >> B; // Sign extended

    else
      // Perform shift by 1
      C = A >> 1; // logical extended
	Flags = 16'dx;
    end
  
  RSHI:
    begin
    if (B > 0)
      // Perform shift on A by B
      C = A >>> B; // Sign extended

    else
      // Perform shift by 1
      C = A >>> 1; // Sign extended
	Flags = 16'dx;
    end

  NOP:
    begin
   	//do nothing
		C = 16'dx;
		Flags = 16'dx;

    end
	 
	STORE:
		begin
		 C = 16'dx;
		 Flags = 16'dx;		
		end
	
	LOAD:
		begin
		 C = B;
		 Flags = 16'dx;
		end
	
	default:
		begin
			C = 16'b0000;
			Flags = 16'b00000;
		end
		
	endcase
end

endmodule

