module FSM_StoreLoad(Clock, Reset, instruction_out);//, out0, out1, out2, out3);

	input wire Clock, Reset;
	//output wire [6:0] out0, out2, out3, out1;

	//These are the FSM outputs
	wire prgEnable, ls_ctrl;
	
  
  //Program Counter Hookup
	wire [11:0] program_no;
  
  //Memory Hookup
	wire [15:0] outputB, addr_reg, store_val_reg, fsm_instruction;
	wire [11:0] store_addr;
	wire mem_enable;

	//This is the ALU/Reg Computation Hookups
	output wire [15:0] instruction_out;
	wire [15:0] decoder_output;
	
	/*hexTo7Seg blockdata1(decoder_output[3:0], out0);
	hexTo7Seg blockdata2(decoder_output[7:4], out1);
	hexTo7Seg blockdata3(decoder_output[11:8], out2);
	hexTo7Seg blockdata4(decoder_output[15:12], out3);*/
	
	
	program_counter PC(.Clock(Clock), .Enable(prgEnable), .Reset(Reset), .program_no(program_no));
	
	/*No data on port A since we wont write anything
	Data B decoder_output is output from ALU C wire
	program_no is the program number address which instruction to output
	store_addr takes value store from a register file and writes to that address
	likewise for wr_enable A and B
	instruction_out puts out the 16 bit opcode instruction
	output B is a placeholder for the future*/
	true_dual_port_ram_single_clock mem(.data_a(store_val_reg), .data_b(16'bx), .addr_a(store_addr), .addr_b(12'bx)
	, .we_a(mem_enable), .we_b(1'b0), .clk(Clock), .q_a(instruction_out), .q_b(outputB)); 
  
	register_mod ALU_decoder(.instruction(fsm_instruction), .reset(Reset), .Clocks(Clock), .mem_data_in(outputB), .outBus(decoder_output), .outA(addr_reg), .outB(store_val_reg));

	FSM myfsm(Clock, Reset, instruction_out, prgEnable, fsm_instruction, mem_enable, ls_contrl);
  
	mem_mux store(ls_contrl, program_no, addr_reg[11:0], store_addr);
  
endmodule

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FSM (clock, Reset, instruction, programCountEnable, out_instruction, mem_enable, mem_addrA_ctrl);

	input clock, Reset;
	input [15:0] instruction;
	output reg programCountEnable, mem_enable, mem_addrA_ctrl;
	output reg [15:0] out_instruction;

	parameter S0=4'd0, S1=4'd1, S2=4'd2, S3=4'd3, S4=4'd4;
	parameter S5=4'd5, S6=4'd6, S7=4'd7, S8=4'd8, S9=4'd9;
	parameter S10=4'd10, S11=4'd11, S12=4'd12, S13=4'd13;
	
	parameter ADD    = 8'b00000000;
	parameter ADDI   = 8'b00000001;
	parameter ADDU   = 8'b00000010;
	parameter ADDUI  = 8'b00000011;
	parameter ADDC   = 8'b00000100;
	parameter ADDCU  = 8'b00000101;
	parameter ADDCUI = 8'b00000110;
	parameter ADDCI  = 8'b00000111;
	parameter SUB    = 8'b00001000;
	parameter SUBI   = 8'b00001001;
	parameter CMP    = 8'b00001010;
	parameter CMPI   = 8'b00001011;
	parameter CMPU   = 8'b00001100;
	parameter AND    = 8'b00001101;
	parameter OR     = 8'b00001110;
	parameter XOR    = 8'b00001111;
	parameter NOT    = 8'b00010000;
	parameter LSH    = 8'b00010001;
	parameter LSHI   = 8'b00010010;
	parameter RSH    = 8'b00010011;
	parameter RSHI   = 8'b00010100;
	parameter ALSH   = 8'b00010101;
	parameter ARSH   = 8'b00010110;
	parameter NOP    = 8'b00010111;
	parameter STORE  = 8'b11011010;
	parameter LOAD   = 8'b10011001;
	
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
			if(S == S0) states=S1; //Takes instruction
			else if(instruction[15:8] == NOP) states = S7; 
			else if(S == S1 && instruction[15:8] != LOAD && instruction[15:8] != STORE) //&& instruction != JUMP
				states = S2;
			else if(S == S1 && instruction[15:8] == STORE)
				states = S3;
			else if(S == S1 && instruction[15:8] == LOAD)
				states = S4;
			else if(S == S4)
				states = S5;
			else if(S == S2 || S == S3)
				states = S0;
			else if(S == S7)
				states = S0;
			else 
				states = states; //This should never occur
				
			
//						default: states = 4'd15;
		
	end

	// Output relies only on current state
	always@(states)begin
	  case (states)
			S0: begin programCountEnable <= 0; out_instruction <= 16'bx; mem_enable <= 0; mem_addrA_ctrl <= 1; end //fetches instruction
			S1: begin programCountEnable <= 0; out_instruction <= 16'bx; mem_enable <= 0; mem_addrA_ctrl <= 1;end //Decode instruction
			S2: begin programCountEnable <= 1; out_instruction <= instruction; mem_enable <= 0; mem_addrA_ctrl <=1; end //Execute R instruction
			S3: begin programCountEnable <= 1; out_instruction <= instruction; mem_enable <= 1; mem_addrA_ctrl <= 0; end //Execute Store instruction
			S4: begin programCountEnable <= 0; out_instruction <= instruction; mem_enable <= 0; mem_addrA_ctrl <= 1; end //Load address label to memory
			S5: begin programCountEnable <= 1; out_instruction <= instruction; mem_enable <= 0; mem_addrA_ctrl <= 1; end //Load data to register
			S7: begin programCountEnable <= 1; out_instruction <= 16'bx; mem_enable <= 0; mem_addrA_ctrl <= 1;end //NOP instruction
	  endcase
	end

endmodule 

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 
// Mux for the memory module for accessing addresses
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module mem_mux(ls_ctrl, instr_code, addr, fetch_addr);
input ls_ctrl;
input [11:0] instr_code;
input [11:0] addr;
output reg [11:0] fetch_addr;

always@(*)begin
	if(ls_ctrl)begin //Let the 2 MSB be equal to 11 indicating a store instruction
		fetch_addr = instr_code;
		end
	else begin
		fetch_addr = addr;
		end
end
endmodule 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 
// 

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
