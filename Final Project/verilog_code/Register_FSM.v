module Register_FSM(in, clk, en, out);
	input [15:0] in;
	input clk, en;
	output reg [15:0] out;
	
	always@(posedge clk) begin
	
		if(en)
			out = in;
		else
			out = out;
	
	end
	
endmodule 
