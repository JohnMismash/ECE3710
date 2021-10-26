module FSM_Wrapper(Clock, Reset, instruction_out);

	input wire Clock, Reset;

	//These are the FSM outputs
	wire prgEnable;
  
  //Program Counter Hookup
	wire [9:0] program_no;
  
  //Memory Hookup
	wire [15:0] outputB;

	//This is the ALU/Reg Computation Hookups
	output wire [15:0] instruction_out;
	wire [15:0] decoder_output;
	
	
	
	program_counter PC(.Enable(prgEnable), .Reset(Reset), .program_no(program_no));
	
	/*No data on port A since we wont write anything
	Data B decoder_output is output from ALU C wire
	program_no is the program number address which instruction to output
	0 for addr_b since we do not care at the moment of load and store
	likewise for wr_enable A and B
	instruction_out puts out the 16 bit opcode instruction
	output B is a placeholder for the future*/
	true_dual_port_ram_single_clock mem(16'dx, decoder_output, program_no, 10'd0, 1'b0, 1'b0, prgEnable, instruction_out, outputB); 
  
	instruction_decoder ALU_decoder(.instruction(instruction_out), .reset(Reset), .Clocks(prgEnable), .outBus(decoder_output));

	FSM myfsm(Clock, Reset, prgEnable);
  
  
  
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
// Quartus Prime Verilog Template
// True Dual Port RAM with single clock
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module true_dual_port_ram_single_clock
#(parameter DATA_WIDTH=16, parameter ADDR_WIDTH=10, parameter file = "C:/Users/Owner/Documents/ECE3710/initialize.txt")
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
	
		q_a <= ram[addr_a];
		
	end 

	// Port B 
	always @ (posedge clk)
	begin
		if (we_b) 
			if(addr_b >= 2**10)
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
