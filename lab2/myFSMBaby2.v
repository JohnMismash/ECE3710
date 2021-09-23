module myFSMBaby2(clock, Reset, regControl, regACont, regBCont, AluOp);

	input clock, Reset;
	output reg [15:0] regControl;
	output reg [7:0] AluOp;
	output reg [3:0] regACont, regBCont;

	parameter S0=4'd0, S1=4'd1, S2=4'd2, S3=4'd3, S4=4'd4;
	parameter S5=4'd5, S6=4'd6;
	
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
						S6: states=S6;
//						S7: states=S8;
//						S8: states=S9;
//						S9: states=S10;
//						S10: states=S11;
//						S11: states=S12;
//						S12: states=S13;
//						S13: states=S14;
//						S14: states=S14;
//						default: states = 4'd15;
					endcase
	end

	//Output relies only on current state
	always@(states)begin
	case (states) //Fibonnacci sequence
		S0 : begin regControl = 16'h0000; AluOp = 8'd1; regACont = 4'bx; regBCont = 4'bx;end //Intitialize registers to 0
		S1 : begin regControl = 16'h0003; AluOp = 8'd1; regACont = 4'b0001; regBCont = 4'b0000;end //Inserts 1 into R0 and R1
		S2 : begin regControl = 16'h0004; AluOp = 8'b00010001; regACont = 4'b0001; regBCont = 4'b0000;end //Stores R1 << 1 to C and saves in R2 i.e 1 ->10
		S3 : begin regControl = 16'h0008; AluOp = 8'b00010001; regACont = 4'b0010; regBCont = 4'b0010;end // R2 << R2 = R3  i.e. 10 -> 1000
		S4 : begin regControl = 16'h0010; AluOp = 8'd9; regACont = 4'b0011; regBCont = 4'b0010;end //R3 - 1 = R4
		S5 : begin regControl = 16'h0020; AluOp = 8'd8; regACont = 4'b0100; regBCont = 4'b0011;end // 7 - 8 = f or -1
		S6 : begin regControl = 16'h0040; AluOp = 8'd15; regACont = 4'b0100; regBCont = 4'b0010;end //7 ^ 2 = 5, 0111 ^ 0010 = 0101
		
		
//		S7 : begin regControl = 16'h0100; AluOp = 8'd0; regACont = 4'b0111; regBCont = 4'b0110;end //Move Output to R1
//		S8 : begin regControl = 16'h0200; AluOp = 8'd0; regACont = 4'b1000; regBCont = 4'b0111;end //Bitwise Complement
//		S9 : begin regControl = 16'h0400; AluOp = 8'd0; regACont = 4'b1001; regBCont = 4'b1000;end //Move R3 to R1
//		S10: begin regControl = 16'h0800; AluOp = 8'd0; regACont = 4'b1010; regBCont = 4'b1001;end //XOR R1 and R2
//		S11: begin regControl = 16'h1000; AluOp = 8'd0; regACont = 4'b1011; regBCont = 4'b1010;end
//		S12: begin regControl = 16'h2000; AluOp = 8'd0; regACont = 4'b1100; regBCont = 4'b1011;end
//		S13: begin regControl = 16'h4000; AluOp = 8'd0; regACont = 4'b1101; regBCont = 4'b1100;end
//		S14: begin regControl = 16'h8000; AluOp = 8'd0; regACont = 4'b1110; regBCont = 4'b1101;end
//		//S14: begin regControl = 16'hF; AluOp = 8'd0; regACont = 4'b1111; regBCont = 4'b1110;end
//				
//		default : begin  regControl = 3'b010; AluOp = 2'b00; end //Shouldn't happen
		endcase
	end


endmodule
