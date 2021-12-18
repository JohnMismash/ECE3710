module program_counter_increaser(clock, add_select, displacement, out_increase);

	input clock, add_select;
	input [7:0] displacement;
	output reg [7:0] out_increase;
	
	always@(posedge clock)begin
		if(add_select)
			out_increase = 8'b0000_0001;
		else
			out_increase = displacement + 8'b0000_0001;	
	end
endmodule 
