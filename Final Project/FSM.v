module FSM_Final(Clock, Reset, controller_state, out0, out1, out2, out3);

	input wire Clock, Reset;
	input wire [1:0] controller_state;
	output wire [6:0] out0, out2, out3, out1;

	//These are the FSM outputs
	wire prgEnable, ls_ctrl, reg_enable, load_mux_ctrl, prgrm_incr_select;
	
  
  //Program Counter Hookup
	wire [11:0] program_no;
	wire [7:0]  FSM_increase, increaser;
  
  //Memory Hookup
	wire [15:0] outputB, addr_reg, store_val_reg, fsm_instruction, flagg;
	wire [11:0] store_addr;
	wire mem_enable;

	//This is the ALU/Reg Computation Hookups
	wire [15:0] instruction_out;
	wire [15:0] decoder_output;
	wire [15:0]  controller_out_fsm;
	
	hexTo7Seg blockdata1(program_no[3:0], out0);
	hexTo7Seg blockdata2(program_no[7:4], out1);
	hexTo7Seg blockdata3(program_no[11:8], out2);
	hexTo7Seg blockdata4(instruction_out[15:12], out3);
	
	program_counter_increaser jmpr_increase(.clock(Clock), .add_select(prgm_incr_select), .displacement(FSM_increase), .out_increase(increaser));
	program_counter PC(.Clock(Clock), .Enable(prgEnable), .Reset(Reset), .increase(increaser), .program_no(program_no));
	
	/*
	store_val_reg holds value that comes in to write to memory if store instruction used
	Data B will output mem values to Arduino
	store_addr takes grabs address for either load instruction or program counter to get data value
	addr_b will take requests from Arduino
	Write enable is for Store instruction
	instruction_out puts out the 16 bit opcode instruction or data value from memory
	output B is a placeholder for the future*/
	true_dual_port_ram_single_clock mem(.data_a(store_val_reg), .data_b(16'bx), .addr_a(store_addr), .addr_b(12'bx)
	, .we_a(mem_enable), .we_b(1'b0), .clk(Clock), .q_a(instruction_out), .q_b(outputB)); 
  
	register_mod ALU_decoder(.instruction(fsm_instruction), .reset(Reset), .Clocks(Clock), .mem_data_in(instruction_out), .controller_movement(controller_out_fsm),
	.outBus(decoder_output), .outA(addr_reg), .outB(store_val_reg), .ren(reg_enable), .load_mux(load_mux_ctrl), .flagwire(flagg));

	FSM myfsm(Clock, Reset, instruction_out, flagg, controller_state, prgEnable, fsm_instruction, mem_enable, ls_contrl, reg_enable, load_mux_ctrl, prgm_incr_select, FSM_increase, control_out_fsm);
  
	mem_mux store(ls_contrl, program_no, addr_reg[11:0], store_addr);
	
	
  
endmodule

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FSM (clock, Reset, instruction, Flags, control_in, programCountEnable, out_instruction, mem_enable, mem_addrA_ctrl, reg_enable, load_mux_ctrl, prgrm_count_increase, jmp_increase, control_out);

	input clock, Reset;
	input [15:0] instruction, Flags, control_in;
	output reg programCountEnable, mem_enable, mem_addrA_ctrl, reg_enable,  prgrm_count_increase;
	output reg [1:0] load_mux_ctrl, control_out;
	output reg [7:0] jmp_increase;
	output reg [15:0] out_instruction;

	parameter S0=4'd0, S1=4'd1, S2=4'd2, S3=4'd3, S4=4'd4;
	parameter S5=4'd5, S6=4'd6, S7=4'd7, S8=4'd8, S9=4'd9;
	parameter S10=4'd10, S11=4'd11, S12=4'd12, S13=4'd13;
	parameter S14=4'd14, S15=4'd15;
	
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
	parameter JUMP   = 8'b01000000; //Jump unconditional
	parameter JL     = 8'b01000001; //Jump <
	parameter JG     = 8'b01000010; //Jump >
	parameter JLE    = 8'b01000011; //Jump <=
	parameter JGE    = 8'b01000100; //Jump >=
	parameter JE     = 8'b01000101; //Jump Equal
	parameter CTLST  = 8'b10000000; //Loads instruction from controller and Loads in R0

	
	reg [3:0] states, S;	// PS - Present State, NS - Next State
	
	wire [15:0] save_instr, savedFlags, control_st;
	
	initial states = 0;

	//Registers to save previous instruction and flags
	Register_FSM savedInstr(.in(instruction), .clk(clock), .en(states == S1), .out(save_instr));
	Register_FSM FLAGS(.in(Flags), .clk(clock), .en(states == S2 || states == S3), .out(savedFlags));
	Register_FSM Controller(.in(control_in), .clk(clock), .en(states == S1 || states == S2), .out(control_st));
	
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
			else if(S == S1 && instruction[15:8] == NOP) states = S7; 
			else if(S == S1 && instruction[15:8] != LOAD && instruction[15:8] != STORE && instruction[15:14] != 2'b01) //RType
				states = S2;
			
			else if(S == S1 && instruction[15:8] == STORE)
				states = S3;
				
			else if(S == S1 && instruction[15:8] == LOAD)
				states = S4;
			else if(S == S4)
				states = S5;
				
			else if(S == S1 && instruction[15:8] == CTLST) //Loads controller state to R0
				states = S14;
				
			else if(S == S1 && instruction[15:8] == JUMP)
				states = S6;
				
			else if (S == S6 || S == S9 || S == S10 || S == S11 || S == S12 || S == S13)
				states = S8; //finish JUMP 
				
			else if (S == S1 && instruction[15:8] == JL) //Jump if A is less than B  e.g. JL 10 6  is same as JL B A and would trigger true
				states = S9;
			else if (S == S1 && instruction[15:8] == JG)
				states = S10;
			else if (S == S1 && instruction[15:8] == JGE)
				states = S11;
			else if (S == S1 && instruction[15:8] == JLE)
				states = S12;
			else if (S == S1 && instruction[15:8] == JE)
				states = S13;
			else if(S == S14)
				states = S15;
			else 
				states = S0; //Reach the end of any state path, reset
		
	end

	// Output relies only on current state
	always@(states)begin 
	
	  case (states)
			S0: begin //fetches instruction
				programCountEnable = 0; out_instruction = 16'bx; 
				mem_enable = 0; mem_addrA_ctrl = 1; reg_enable = 0; 
				load_mux_ctrl = 2'b0; prgrm_count_increase = 1; jmp_increase = 8'b0; control_out = 2'b00;
				end 
			S1: begin //Decode instruction
				programCountEnable = 0; out_instruction = 16'bx; prgrm_count_increase = 1;
				mem_enable = 0; mem_addrA_ctrl = 1; reg_enable = 0; load_mux_ctrl = 2'b0; jmp_increase = 8'b0; control_out = 2'b00;
			end 
			
			//R type instructions
			S2: begin programCountEnable = 1; out_instruction = save_instr; mem_enable = 0; mem_addrA_ctrl = 1; reg_enable = 1; load_mux_ctrl = 2'b00;
					prgrm_count_increase = 1; jmp_increase = 8'b0; control_out = 2'b00;
				 end
			
			//Store Instruction
			S3: begin programCountEnable = 1; out_instruction = save_instr; mem_enable = 1; mem_addrA_ctrl = 0; reg_enable = 0; load_mux_ctrl = 2'b00; //Execute Store instruction
				 prgrm_count_increase = 1; jmp_increase = 8'b0; control_out = 2'b00;
				 end
				
			//Load Instruction; S5 holds the value from memory to add
			S4: begin programCountEnable = 0; out_instruction = save_instr; mem_enable = 0; mem_addrA_ctrl = 0; control_out = 2'b00; reg_enable = 1; load_mux_ctrl = 2'b01; prgrm_count_increase = 1; jmp_increase = 8'b0;end 
			S5: begin programCountEnable = 1; out_instruction = save_instr /*data is instruction here*/; mem_enable = 0; mem_addrA_ctrl = 0; reg_enable = 1; 
				prgrm_count_increase = 1;load_mux_ctrl = 2'b01; jmp_increase = 8'b0; control_out = 2'b00;end
			
			//Unconditional Jump
			S6: begin programCountEnable = 0; out_instruction = save_instr; mem_enable = 0; mem_addrA_ctrl = 1; 
				reg_enable = 0; load_mux_ctrl = 2'b00; prgrm_count_increase = 0; jmp_increase = save_instr[7:0]; //Loads the displacement to programcounter
				end 
			S8: begin programCountEnable = 1; out_instruction = save_instr; mem_enable = 0; mem_addrA_ctrl = 1; 
				reg_enable = 0; load_mux_ctrl = 2'b00; prgrm_count_increase = 0; jmp_increase = save_instr[7:0];// Now able to execute displacement
				end 

			//NOP instruction
			S7: begin programCountEnable = 1; out_instruction = 16'bx; mem_enable = 0; mem_addrA_ctrl = 1; reg_enable = 0; 
				load_mux_ctrl = 2'b00; prgrm_count_increase = 1; jmp_increase = 8'b0;
				end 
			
			//JL instruction
			S9: begin programCountEnable = 0; out_instruction = save_instr; mem_enable = 0; mem_addrA_ctrl = 1; control_out = 2'b00;
				reg_enable = 0; load_mux_ctrl = 2'b00; prgrm_count_increase = 0; jmp_increase = (savedFlags[0] == 0  && savedFlags[4] == 0 ) ? save_instr[7:0] : 8'b0; //Loads the displacement to programcounter
				end 
			//JG	
			S10: begin programCountEnable = 0; out_instruction = save_instr; mem_enable = 0; mem_addrA_ctrl = 1; control_out = 2'b00;
				reg_enable = 0; load_mux_ctrl = 2'b00; prgrm_count_increase = 0; jmp_increase = (savedFlags[0] == 1) ? save_instr[7:0] : 8'b0; //Loads the displacement to programcounter
				end
			//JGE
			S11: begin programCountEnable = 0; out_instruction = save_instr; mem_enable = 0; mem_addrA_ctrl = 1; control_out = 2'b00;
				reg_enable = 0; load_mux_ctrl = 2'b00; prgrm_count_increase = 0; jmp_increase = (savedFlags[0] == 1  || savedFlags[4] == 1 ) ? save_instr[7:0] : 8'b0; //Loads the displacement to programcounter
				end
			//JLE
			S12: begin programCountEnable = 0; out_instruction = save_instr; mem_enable = 0; mem_addrA_ctrl = 1; control_out = 2'b00;
				reg_enable = 0; load_mux_ctrl = 2'b00; prgrm_count_increase = 0; jmp_increase = (savedFlags[0] == 0) ? save_instr[7:0] : 8'b0; //Loads the displacement to programcounter
				end
			//JE
			S13: begin programCountEnable = 0; out_instruction = save_instr; mem_enable = 0; mem_addrA_ctrl = 1; control_out = 2'b00;
				reg_enable = 0; load_mux_ctrl = 2'b00; prgrm_count_increase = 0; jmp_increase = (savedFlags[4] == 1) ? save_instr[7:0] : 8'b0; //Loads the displacement to programcounter
				end
			
			//CTLST
			S14: begin programCountEnable = 0; out_instruction = save_instr; mem_enable = 0; mem_addrA_ctrl = 0; reg_enable = 1; load_mux_ctrl = 2'b10; prgrm_count_increase = 1; jmp_increase = 8'b0; control_out = control_st;end 
			S15: begin programCountEnable = 1; out_instruction = save_instr; mem_enable = 0; mem_addrA_ctrl = 0; reg_enable = 1; load_mux_ctrl = 2'b10; prgrm_count_increase = 1; jmp_increase = 8'b0; control_out = control_st;end 

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
