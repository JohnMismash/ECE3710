module FSM(Clocks, reset, imm_val, RegEnable, reg_s1, reg_s2, opcode);
	input Clocks, reset;
	
	output reg [15:0] RegEnable;
	output reg [3:0] reg_s1, reg_s2;
	output reg [7:0] opcode;
	output reg [7:0] imm_val;
	
	parameter S0 = 4'd0, S1 = 4'd1, S2 = 4'd2, S3 = 4'd3;
	
	reg [3:0] states, S;
	initial states = 0;
	
	always @(negedge Clocks) begin
		if (reset)
			S <= S0;
		
		else
			S <= states;
	end
	
	always @(S) begin
		case(S)
			S0: states = S1;
			S1: states = S2;
			S2: states = S3;
			S3: states = S0;
		endcase
	end
	
	always @(states) begin 
		case (states)
			S0: begin  RegEnable[0] = 1; reg_s1 = 0; reg_s2 = 0; opcode = 1; imm_val = 1;  end // Select ADDI, 1 should always be imm val
			S1: begin  RegEnable = 0; RegEnable[1] = 1; reg_s1 = 4; reg_s2 = 4; opcode = 1; imm_val = 1;   end // Load 1 into R1
			S2: begin  RegEnable = 0; RegEnable[2] = 1; reg_s1 = 0; reg_s2 = 1; opcode = 0; imm_val = 0;  end // R0 + R1 -> R2 -- 1 + 1 -> 2
		endcase
	end
	
	
endmodule 
