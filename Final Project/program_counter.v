module program_counter (Clock, Enable, Reset, program_no); //This program counter is currently 

input wire Enable, Reset, Clock;
output reg [11:0] program_no;  //This is a 9bit number because we will be storing instructions in 512 words in memory. 2**9 = 512.

initial begin
program_no = 12'd0;
end

always@(posedge Clock) begin

if(Reset && Enable)
	program_no = program_no + 1;
else if (Reset && !Enable)
	program_no = program_no;
else
	program_no = 12'd0;
end


endmodule 
