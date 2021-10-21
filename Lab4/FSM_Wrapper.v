module FSM_Wrapper();


endmodule


module FSM (clock, Reset, dataA, dataB, addressA, addressB, enableA, enableB);

	input clock, Reset;
	output reg [15:0] dataA, dataB;
	output reg [9:0] addressA, addressB;
	output reg enableA, enableB;

	parameter S0=4'd0, S1=4'd1, S2=4'd2, S3=4'd3, S4=4'd4;
	//parameter S5=4'd5, S6=4'd6, S7=4'd7, S8=4'd8, S9=4'd9;
	//parameter S10=4'd10, S11=4'd11, S12=4'd12, S13=4'd13;

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
						S2: states=S2;
//						S3: states=S4;
//						S4: states=S5;
//						S5: states=S6;
//						S6: states=S7;
//						S7: states=S8;
//						S8: states=S9;
//						S9: states=S10;
//						S10: states=S11;
//						S11: states=S12;
//						S12: states=S13;
//						S13: states=S13;
//						S14: states=S14;
//						default: states = 4'd15;
					endcase
	end

	//Output relies only on current state
	always@(states)begin
	case (states) //Fibonnacci sequence
		S0 : begin dataA = 16'h44; dataB = 16'h0; addressA = 10'd1; addressB = 10'd1;
			enableA = 0; enableB = 0;end //read from address 1
		S1 : begin dataA = 16'h3; dataB = 16'h0; addressA = 10'd1; addressB = 10'd2;
			enableA = 1; enableB = 0;end //change the addres memory to 3
		S2 : begin dataA = 16'h4; dataB = 16'h0; addressA = 10'd1; addressB = 10'd512;
			enableA = 0; enableB = 0;end //verify value saved
//		S3 : begin data = 16'h0008; address = 8'd0; end // R1 + R2 = R3
//		S4 : begin data = 16'h0010; address = 8'd0; end //R3 + R2 = R4
//		S5 : begin data = 16'h0020; address = 8'd0; end //R3 + R4 = R5
//		S6 : begin data = 16'h0040; address = 8'd0; end //R4 + R5 = R6
//		S7 : begin data = 16'h0080; address = 8'd0; end //R5 + R6 = R7
//		S8 : begin data = 16'h0100; address = 8'd0; end //R6 + R7 = R8
//		S9 : begin data = 16'h0200; address = 8'd0; end //R7 + R8 = R9
//		S10: begin data = 16'h0400; address = 8'd0; end //R8 + R9 = R10
//		S11: begin data = 16'h0800; address = 8'd0; end //R9 + R10 = R11
//		S12: begin data = 16'h1000; address = 8'd0; end //R10 + R11 = R12
//		S13: begin data = 16'h2000; address = 8'd0; end //R11 + R12 = R13
//		S14: begin data = 16'h8000; address = 8'd0; end
//		//S14: begin data = 16'hF; address = 8'd0; end
	endcase
	end


endmodule
