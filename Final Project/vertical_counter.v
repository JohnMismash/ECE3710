`timescale 1ns/1ps

module vertical_counter(clk_25MHz, enable_V_counter, V_count) begin
	input clk_25MHz
	input reg enable_V_counter = 0;
	output reg [15:0] V_count = 0;

	always @(posedge clk_25MHz) begin
		if (V_count < 525 && enable_V_counter == 1'b1) begin
			V_count <= V_count + 1'b1;	
		end

		else begin 
			V_count <= 0;
		end
	end 
endmodule 
