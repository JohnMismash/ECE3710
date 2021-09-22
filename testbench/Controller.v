module Controller(Clocks, reset, Bus, out1, out2);
	input Clocks, reset;
	
	wire [7:0] imm_val; 
	wire [15:0] RegEnable;
	wire [3:0] reg_s1, reg_s2;
	wire [7:0] opcode;
	wire [15:0] r15;
	
	output [15:0] Bus;
	output [6:0] out1, out2;
	
	FSM fsm(
	.Clocks(Clocks), 
	.reset(reset), 
	.RegEnable(RegEnable), 
	.reg_s1(reg_s1), 
	.reg_s2(reg_s2),
	.imm_val(imm_val),
	.opcode(opcode)
	);
	
	regfile_tb_version regfile(
		.Clocks(Clocks),
		.reset(reset),
		.RegEnable(RegEnable),
		.reg_s1(reg_s1),
		.reg_s2(reg_s2),
		.imm_val(imm_val),
		.opcode(opcode),
		.r15(r15),
		.Bus(Bus)
	);
	//Output Display
	hexTo7Seg firstdigit (Bus[3:0],out1);
	hexTo7Seg seconddigit (Bus[7:4],out2);
	
endmodule 
