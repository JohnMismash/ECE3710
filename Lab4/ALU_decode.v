module instruction_decoder(instruction, Clocks, outBus);
	input [15:0] instruction;
	input Clocks;

	wire [3:0] reg_w;
	wire [4:0] flagwire;
	wire [15:0] Bus, alu_out, r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, outA, outB, B_muxed;

	output [15:0] outBus;
	
	reg [3:0] A, B;
	reg [7:0] opcode;

	always@(*)begin
		opcode = instruction[15:8];
		A = instruction[7:4];
		B = instruction[3:0];
	end

	Fourto16decoder(opcode, A, reg_w);
	
	//RegBank(Bus, reg_w, clk, reset);
	RegBank reg_bank(Bus,r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, reg_w, Clocks, reset);	
	Register flags (flagwire, 1'b1, reset, Clocks, flagwire); 
	reg_mux regA (r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, A,outA);
	reg_mux regB (r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, B,outB);
	alu_mux alumux(outB, instruction[3:0], opcode, B_muxed);
	ALU(outA, B_muxed, Bus, opcode, flagwire);

endmodule 

module Fourto16decoder(Opcode, d_in, d_out);
	input [3:0] d_in;
	input [7:0] Opcode;
	output reg [15:0] d_out;
	parameter tmp = 16'b0000_0000_0000_0001;

	always@(*) begin
	if (Opcode == 8'd10 || Opcode == 8'd11 || Opcode == 8'd12 || Opcode == 8'd23) //Do not enable any reg in case of CMP or NOP instruction
		d_out = 16'd0;
	
	else begin
		assign d_out = (d_in == 4'b0000) ? tmp   :
		       (d_in == 4'b0001) ? tmp<<1:
		       (d_in == 4'b0010) ? tmp<<2:
		       (d_in == 4'b0011) ? tmp<<3:
		       (d_in == 4'b0100) ? tmp<<4:
		       (d_in == 4'b0101) ? tmp<<5:
		       (d_in == 4'b0110) ? tmp<<6:
		       (d_in == 4'b0111) ? tmp<<7:
		       (d_in == 4'b1000) ? tmp<<8:
		       (d_in == 4'b1001) ? tmp<<9:
		       (d_in == 4'b1010) ? tmp<<10:
		       (d_in == 4'b1011) ? tmp<<11:
		       (d_in == 4'b1100) ? tmp<<12:
		       (d_in == 4'b1101) ? tmp<<13:
		       (d_in == 4'b1110) ? tmp<<14:
		       (d_in == 4'b1111) ? tmp<<15: 16'bxxxx_xxxx_xxxx_xxxx;
				 end
	end

endmodule 
