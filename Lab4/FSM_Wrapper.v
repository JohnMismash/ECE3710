module FSM_Wrapper();


endmodule


module FSM (clock, Reset, dataA, dataB, addressA, addressB, enableA, enableB);

	input clock, Reset;
	output reg [15:0] dataA, dataB;
	output reg [9:0] addressA, addressB;
	output reg enableA, enableB;

	parameter S0=4'd0, S1=4'd1, S2=4'd2, S3=4'd3, S4=4'd4;
	parameter S5=4'd5, S6=4'd6, S7=4'd7, S8=4'd8, S9=4'd9;
	parameter S10=4'd10, S11=4'd11, S12=4'd12, S13=4'd13;

	reg [3:0] states, S;	// PS - Present State, NS - Next State

	initial states = 0;

	// Determines next state
	 always @ (posedge clock or negedge Reset) begin
			  if (!Reset)
					S <= S0;
			  else
					S <= states;

	end


	// Present State becomes Next State
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

	// Output relies only on current state
	always@(states)begin
	  case (states)

	  endcase
	end


endmodule
