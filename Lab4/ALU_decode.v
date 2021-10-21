module instruction_decoder(instruction, imm, Clock, Bus);
	input [15:0] instruction;
	input [3:0] imm;
	input Clock;

	wire [15:0] Bus;
	wire [3:0] reg_w;
	wire [4:0] flags
	wire [15:0] Bus, alu_out, r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, outA, outB, B_muxed;

	output [15:0] Bus;

	always@(instruction) {
		opcode = instruction[15:8];
		A = instruction[7:4];
		B = instruction[3:0];


		4to16decoder(A, reg_w);

		//RegBank(Bus, reg_w, clk, reset);
		RegBank reg_bank(Bus,r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, reg_w, Clock, reset);

		Register flags (flags, 1'b1, reset, Clock, flags);
		reg_mux regA (r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, A,outA);
		reg_mux regB (r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, B,outB);
		alu_mux alumux(outB, imm, opcode, B_muxed);
		ALU(outA, B_muxed, Bus, opcode, flags);
		}
endmodule

module 4to16decoder(data, out);
	input [3:0] d_in;
	output [15:0] dout;
	parameter tmp = 16'0000_0000_0000_0001;

	always@(data) {
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
	}

endmodule
