module FSM_Wrapper(Clock, Reset, out1, out3, out4);

	input Clock, Reset;
	output wire [6:0] out1, out3, out4;
	
	wire [15:0] newDataA, newDataB, outputA, outputB;
	wire [9:0] newAddrA, newAddrB;
	wire ea, eb;
		
	doublemem mymem(newDataA, newDataB, newAddrA, newAddrB, ea, eb, Clock, outputA, outputB);	
	
	FSM myfsm(Clock, Reset, newDataA, newDataB, newAddrA, newAddrB, ea, eb);
	
	hexTo7Seg blockdata1(outputA[3:0], out1);
	//hexTo7Seg blockdata2(outputA[7:4], out2);
	hexTo7Seg blockdata3(outputA[11:8], out3);
	hexTo7Seg blockdata4(outputA[15:12], out4);
	
endmodule 

module FSM (clock, Reset, dataA, dataB, addressA, addressB, enableA, enableB);

	input clock, Reset;
	output reg [15:0] dataA, dataB;
	output reg [9:0] addressA, addressB;
	output reg enableA, enableB;
	
	parameter S0=4'd0, S1=4'd1, S2=4'd2, S3=4'd3, S4=4'd4;
	//parameter S5=4'd5, S6=4'd6, S7=4'd7, S8=4'd8, S9=4'd9;
	//parameter S10=4'd10, S11=4'd11, S12=4'd12, S13=4'd13;
					 
	reg [3:0] states, S;	//PS - present state, NS
	
	initial states = 0;
	//Determines next state
	 always @ (posedge clock or negedge Reset) begin
			  if (!Reset)
					S <= S0;
			  else
					S <= states;
					
	end


	//Present State becomes next state
	always@(S)begin
		case(S)
						S0: states=S1;
						S1: states=S2;
						S2: states=S2;
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

	//Output relies only on current state
	always@(states)begin
	case (states) //Fibonnacci sequence
		S0 : begin dataA = 16'h44; dataB = 16'h0; addressA = 10'd1; addressB = 10'd1;
			enableA = 0; enableB = 0;end //read from address 1
		S1 : begin dataA = 16'h3; dataB = 16'h0; addressA = 10'd1; addressB = 10'd2;
			enableA = 1; enableB = 0;end //change the addres memory to 3
		S2 : begin dataA = 16'h4; dataB = 16'h0; addressA = 10'd1; addressB = 10'd512;
			enableA = 0; enableB = 0;end //verify value saved
//		S3 : begin data = 16'h0008; address = 8'd0; end // R1 + R2 = R3
//		S4 : begin data = 16'h0010; address = 8'd0; end //R3 + R2 = R4
//		S5 : begin data = 16'h0020; address = 8'd0; end //R3 + R4 = R5
//		S6 : begin data = 16'h0040; address = 8'd0; end //R4 + R5 = R6
//		S7 : begin data = 16'h0080; address = 8'd0; end //R5 + R6 = R7
//		S8 : begin data = 16'h0100; address = 8'd0; end //R6 + R7 = R8
//		S9 : begin data = 16'h0200; address = 8'd0; end //R7 + R8 = R9
//		S10: begin data = 16'h0400; address = 8'd0; end //R8 + R9 = R10
//		S11: begin data = 16'h0800; address = 8'd0; end //R9 + R10 = R11
//		S12: begin data = 16'h1000; address = 8'd0; end //R10 + R11 = R12
//		S13: begin data = 16'h2000; address = 8'd0; end //R11 + R12 = R13
//		S14: begin data = 16'h8000; address = 8'd0; end
//		//S14: begin data = 16'hF; address = 8'd0; end
	endcase
	end


endmodule 

module doublemem
#(parameter DATA_WIDTH=16, parameter ADDR_WIDTH=10)
(
	input [(DATA_WIDTH-1):0] data_a, data_b,
	input [(ADDR_WIDTH-1):0] addr_a, addr_b,
	input we_a, we_b, clk,
	output reg [(DATA_WIDTH-1):0] q_a, q_b
);

	reg [1:0] we_a1, we_b1;
	wire [31:0] outA, outB;
	

	
	true_dual_port_ram_single_clock firstmem(.data_a(data_a), .data_b(data_b), .addr_a(addr_a[8:0]), .addr_b(addr_b[8:0]), .we_a(we_a1[0]), .we_b(we_b1[0]), .clk(clk), .q_a(outA[15:0]), .q_b(outB[15:0]));
	true_dual_port_ram_single_clock #(.file("C:/Users/Owner/Documents/ECE3710/sinitialize.txt"))
		secondmem(.data_a(data_a), .data_b(data_b), .addr_a(addr_a[8:0]), .addr_b(addr_b[8:0]), .we_a(we_a1[1]), .we_b(we_b1[1]), .clk(clk), .q_a(outA[31:16]), .q_b(outB[31:16]));

	always@(data_a, addr_a, we_a, clk) begin //for one port
	
	if (we_a == 1) begin
		
		if (addr_a[9] == 1)  //just change the memory block in second memory and do not send any signal to firstmem
				we_a1 <= 2'b10;			
			
		else begin//enable first mem
				we_a1 <= 2'b01; end
	
	end
	
	else begin
		we_a1 <= 2'b00; end
	
	end
	
	always@(data_b, addr_b, we_b, clk) begin
	
		if(we_b == 1) begin
			if (addr_b[9] == 1)
				we_b1 <= 2'b10;
		
			else begin
				we_b1 <= 2'b01;end			
	end
	
		else begin
		we_b1 <= 2'b00; end
		
	end

	//This is for displaying proper output
	always@(clk, outA)begin
		if(addr_a[9] == 1)
			q_a <= outA[31:16];
		else 
			q_a <= outA[15:0];	
	end
	
	always@(clk, outB)begin
		if(addr_b[9] == 1)
			q_b <= outB[31:16];
		else 
			q_b <= outB[15:0];	
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

// Quartus Prime Verilog Template
// True Dual Port RAM with single clock

module true_dual_port_ram_single_clock
#(parameter DATA_WIDTH=16, parameter ADDR_WIDTH=9, parameter file = "C:/Users/Owner/Documents/ECE3710/initialize.txt")
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
	
	$readmemh(file, ram);
	
	end

	// Port A 
	always @ (posedge clk)
	begin
		if (we_a) 
		begin
			ram[addr_a] <= data_a;
			q_a <= data_a;
		end
		else 
		begin
			q_a <= ram[addr_a];
		end 
	end 

	// Port B 
	always @ (posedge clk)
	begin
		if (we_b) 
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
