module program_counter(Enable, Reset, program_no); // This program counter is currently 

input wire Enable, Reset;
	output reg [9:0] program_no;  //This is a 10 bit number because we will be storing instructions in the first 1024 words in memory. 2**10 = 1024.

initial begin
program_no = 10'd0;
end

always@(posedge Enable) begin

if(Reset)
	program_no = program_no + 1;
else
	program_no = 10'd0;
end

endmodule
