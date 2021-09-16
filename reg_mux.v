module reg_mux(r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, s, out);
	input [15:0] r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15; 
	input [3:0] s;
	output [15:0] out;
	
	case s:
        4'b0000: assign out = r0;
        4'b0001: assign out = r1;
        4'b0010: assign out = r2;
        4'b0011: assign out = r3;
        4'b0100: assign out = r4;
        4'b0101: assign out = r5;
        4'b0110: assign out = r6;
        4'b0111: assign out = r7;
        4'b1000: assign out = r8;
        4'b1001: assign out = r9;
        4'b1010: assign out = r10;
        4'b1011: assign out = r11;
        4'b1100: assign out = r12;
        4'b1101: assign out = r13;
        4'b1110: assign out = r14;
        4'b1111: assign out = r15;
	
endmodule