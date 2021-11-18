`timescale 1ns/1ps

module vertical_counter(clk_25MHz, enable_V_counter, V_count) begin
	input clk_25MHz
	input reg enable_V_counter = 0;
	output reg [15:0] V_Count = 0;

	always @(posedge clk_25MHz) begin
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
