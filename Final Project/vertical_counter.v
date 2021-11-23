`timescale 1ns/1ps

module vertical_counter(Clk, enable_V_counter, V_count) begin
	input Clk
	input reg enable_V_counter = 0;
	output reg [15:0] V_Count = 0;

	always @(posedge Clk) begin
    if (enable_V_counter == 1'b1) begin
        if (V_Count < 524) begin
            V_Count <= V_Count + 1;
          end
        else begin
            V_Count <= 0;
          end
      end
	end
endmodule
