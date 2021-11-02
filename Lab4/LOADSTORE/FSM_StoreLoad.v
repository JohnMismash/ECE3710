module FSM_StoreLoad(Clock, Reset, instruction_out);//, out0, out1, out2, out3);

	input wire Clock, Reset;
	//output wire [6:0] out0, out2, out3, out1;

	//These are the FSM outputs
	wire prgEnable;
	
  
  //Program Counter Hookup
	wire [11:0] program_no;
  
  //Memory Hookup
	wire [15:0] outputB, addr_reg, store_val_reg;
	wire [11:0] store_addr;
	wire mem_enable;

	//This is the ALU/Reg Computation Hookups
	output wire [15:0] instruction_out;
	wire [15:0] decoder_output;
	
	/*hexTo7Seg blockdata1(decoder_output[3:0], out0);
	hexTo7Seg blockdata2(decoder_output[7:4], out1);
	hexTo7Seg blockdata3(decoder_output[11:8], out2);
	hexTo7Seg blockdata4(decoder_output[15:12], out3);*/
	
	
	program_counter PC(.Enable(prgEnable), .Reset(Reset), .program_no(program_no));
	
	/*No data on port A since we wont write anything
	Data B decoder_output is output from ALU C wire
	program_no is the program number address which instruction to output
	store_addr takes value store from a register file and writes to that address
	likewise for wr_enable A and B
	instruction_out puts out the 16 bit opcode instruction
	output B is a placeholder for the future*/
	true_dual_port_ram_single_clock mem(16'dx, store_val_reg, program_no, store_addr, 1'b0, mem_enable, prgEnable, instruction_out, outputB); 
  
	register_mod ALU_decoder(.instruction(instruction_out), .reset(Reset), .Clocks(prgEnable), .outBus(decoder_output), .outA(addr_reg), .outB(store_val_reg));

	FSM myfsm(Clock, Reset, prgEnable);
  
	mem_mux store(instruction_out[15:14], addr_reg[11:0], store_addr, mem_enable);
  
endmodule

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FSM (clock, Reset, programCountEnable);

	input clock, Reset;
	output reg programCountEnable;

	parameter S0=4'd0, S1=4'd1, S2=4'd2, S3=4'd3, S4=4'd4;
	parameter S5=4'd5, S6=4'd6, S7=4'd7, S8=4'd8, S9=4'd9;
	parameter S10=4'd10, S11=4'd11, S12=4'd12, S13=4'd13;

	reg [3:0] states, S;	// PS - Present State, NS - Next State

	initial states = 0;

	// Determines next state
	 always @ (posedge clock or negedge Reset) begin
			  if (!Reset)
					S <= S0;
			  else
					S <= states;

	end


	// Present State becomes Next State
	always@(S)begin
		case(S)
			S0: states=S1;
			S1: states=S0;
//			S2: states=S2;
//						S3: states=S4;
//						S4: states=S5;
//						S5: states=S6;
//						S6: states=S7;
//						S7: states=S8;
//						S8: states=S9;
//						S9: states=S10;
//						S10: states=S11;
//						S11: states=S12;
//						S12: states=S13;
//						S13: states=S13;
//						S14: states=S14;
//						default: states = 4'd15;
		endcase
	end

	// Output relies only on current state
	always@(states)begin
	  case (states)
			S0: begin programCountEnable <= 0; end
			S1: begin programCountEnable <= 1; end

	  endcase
	end

endmodule 

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 
// Mux for the memory module for accessing addresses
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module mem_mux(instr_code, addr, fetch_addr, enable);
input [1:0] instr_code;
input [11:0] addr;
output reg [11:0] fetch_addr;
output reg enable; //Enables write to the memory

always@(*)begin
	if(instr_code == 2'b11)begin //Let the 2 MSB be equal to 11 indicating a store instruction
		fetch_addr = addr;
		enable = 1; end
	else begin
		fetch_addr = 12'bx;
		enable = 0; end
end
endmodule 
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

module hexTo7Seg(input [3:0]x, output reg [6:0]z);
always @*
case(x)
	4'b0000 :			//Hexadecimal 0
	z = ~7'b0111111;
   4'b0001 :			//Hexadecimal 1
	z = ~7'b0000110;
   4'b0010 :			//Hexadecimal 2
	z = ~7'b1011011;
   4'b0011 : 			//Hexadecimal 3
	z = ~7'b1001111;
   4'b0100 : 			//Hexadecimal 4
	z = ~7'b1100110;
   4'b0101 : 			//Hexadecimal 5
	z = ~7'b1101101;
   4'b0110 : 			//Hexadecimal 6
	z = ~7'b1111101;
   4'b0111 :			//Hexadecimal 7
	z = ~7'b0000111;
   4'b1000 : 			//Hexadecimal 8
	z = ~7'b1111111;
   4'b1001 : 			//Hexadecimal 9
	z = ~7'b1100111;
	4'b1010 : 			//Hexadecimal A
	z = ~7'b1110111;
	4'b1011 : 			//Hexadecimal B
	z = ~7'b1111100;
	4'b1100 : 			//Hexadecimal C
	z = ~7'b1011000;
	4'b1101 : 			//Hexadecimal D
	z = ~7'b1011110;
	4'b1110 : 			//Hexadecimal E
	z = ~7'b1111001;
	4'b1111 : 			//Hexadecimal F	
	z = ~7'b1110001; 
   default :
	z = ~7'b0000000;
endcase
endmodule 
