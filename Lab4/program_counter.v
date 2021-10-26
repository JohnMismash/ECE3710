module program_counter(Enable, Reset, program_no); //This program counter is currently 

input wire Enable, Reset;
output reg [9:0] program_no;  //This is a 9bit number because we will be storing instructions in 512 words in memory. 2**9 = 512.

initial begin
program_no = 10'd0;
end

always@(posedge Enable) begin

if(!Reset)
	program_no = program_no + 1;
else
	program_no = 10'd0;
end


endmodule 
