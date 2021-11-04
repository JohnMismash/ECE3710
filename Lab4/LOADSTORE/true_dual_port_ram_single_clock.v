////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Quartus Prime Verilog Template
// True Dual Port RAM with single clock
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module true_dual_port_ram_single_clock
#(parameter DATA_WIDTH=16, parameter ADDR_WIDTH=12,parameter file = "C:/Users/Owner/Documents/ECE3710/initialize.txt")
(
	input [(DATA_WIDTH-1):0] data_a, data_b,
	input [(ADDR_WIDTH-1):0] addr_a, addr_b,
	input we_a, we_b, clk,
	output reg [(DATA_WIDTH-1):0] q_a, q_b
);

	// Declare the RAM variable
	reg [DATA_WIDTH-1:0] ram[2**ADDR_WIDTH-1:0];

	initial //Initializes some memory
	begin
	
	$readmemb(file, ram);
	
	end

	// Port A 
	always @ (posedge clk)begin
	
		if(addr_a < 2**11) //We can store the instructions in the first 2**11 words of memory
			q_a <= ram[addr_a];
		
	end 

	// Port B 
	always @ (posedge clk)
	begin
		/*if(addr_b == 12'bz)begin
			q_b <= 16'bz; end*/
			
	   if (we_b) 
			//if(addr_b >= 2**11) //Store data values in memory after the 2**11 block
			begin
				ram[addr_b] <= data_b;
				q_b <= data_b;
			end
		
		else 
		begin
			q_b <= ram[addr_b];
		end 
	end

endmodule
