`timescale 1ns/1ps

module vertical_counter(Clk, Vert_Counter_Enable, V_Count);
	input Clk;
	input wire Vert_Counter_Enable;
	output reg [15:0] V_Count = 0;

	always @(posedge Clk) begin
    if (Vert_Counter_Enable == 1'b1) begin
        if (V_Count < 524) begin
            V_Count <= V_Count + 1;
          end
        else begin
            V_Count <= 0;
          end
      end
	end
endmodule
