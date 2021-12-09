module Register_VGA(in, enable, out);
	input [15:0] in;
	input enable;
	output reg [15:0] out;
	
	initial begin out = 16'd0; end
	always@(*) begin
	
		if(enable)
			out = in;
		else
			out = out;
	
	end
	
endmodule 