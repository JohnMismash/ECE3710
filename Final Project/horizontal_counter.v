`timescale 1ns/1ps

module horizontal_counter(

    input wire Clk;
    output reg Vert_Counter_Enable = 0;
    output reg [15:0] Horizontal_Count = 0;
);


always@(posedge Clk)
  begin
    if (Horizontal_Count < 800)
      begin
        Horizontal_Count <= Horizontal_Count + 1;
        Vert_Counter_Enable <= 0
      end

    else
      begin
        Horizontal_Count <= 0;
        Vert_Counter_Enable <= 1;
      end
  end
endmodule
