// ALU Control Test Bench

`timescale 1ns / 1ps

module tb_alu_control();

reg [1:0] ALUop;
reg [4:0] Opcode;
reg [4:0] AlterOp;
reg CLK;
parameter HALF_Period = 50;

wire [3:0] ALUOutOp;

// ALU Control 
alu_control alu_control_inst
(
	.Opcode(Opcode) ,	// input [4:0] Opcode_sig
	.ALUOp(ALUop) ,	// input [1:0] ALUOp_sig
	.AlterOp(AlterOp) ,	// input [4:0] AlterOp_sig
	.out(ALUOutOp) 	// output [3:0] out_sig
);


initial begin
		 CLK = 0;
		 forever begin
			  #(HALF_Period);
			  CLK = ~CLK;
		 end
	end


initial begin
    
	// Test ALUop = 2'b10; Opcode = 5'b00000
	ALUop = 2'b10;
	Opcode = 5'b00000;
	#HALF_Period;
	if(ALUOutOp != 4'b0000)begin
		$display("Output for ALUop 10, Opcode 00000 does not equal 0000");
	 end
	 
	 #HALF_Period;
		
	//Test ALUop = 2'b10; Opcode = 5'b00001
	ALUop = 2'b10;
	 Opcode = 5'b00001;
	 #HALF_Period;
	 if(ALUOutOp != 4'b0001)begin
		$display("Output for ALUop 10, Opcode 00001 does not equal 0001");
	 end
		 #HALF_Period;
	
	// Test ALUop = 2'b10; Opcode = 5'b00010
	ALUop = 2'b10;
	Opcode = 5'b00010;
	#HALF_Period;
	if(ALUOutOp != 4'b0111)begin
		$display("%b", ALUOutOp);
		$display("Output for ALUop 10, Opcode 00010 does not equal 0111");
	end
	#HALF_Period;

	// Test ALUop = 2'b10; Opcode = 5'b00011
	ALUop = 2'b10;
	Opcode = 5'b00011;
	#HALF_Period;
	if(ALUOutOp != 4'b0101)begin
		$display("%b", ALUOutOp);
		$display("Output for ALUop 10, Opcode 00011 does not equal 0101");
	end
	#HALF_Period;
		
	//Test ALUop = 2'b10; Opcode = 5'b00100
	ALUop = 2'b10;
	Opcode = 5'b00100;
	#HALF_Period;
	if(ALUOutOp != 4'b0110)begin
		$display("Output for ALUop 10, Opcode 00100 does not equal 0110");
	end
	 
	#HALF_Period;
			 
	// Test ALUop = 2'b10; Opcode = 5'b00101
	ALUop = 2'b10;
	 Opcode = 5'b00101;
	 #HALF_Period;
	 if(ALUOutOp != 4'b0010)begin
		$display("Output for ALUop 10, Opcode 00101 does not equal 0010");
	 end
	 
	#HALF_Period;

	// Test ALUop = 2'b10; Opcode = 5'b01000
	ALUop = 2'b10;
	Opcode = 5'b01000;
	#HALF_Period;
	if(ALUOutOp != 4'b0101)begin
		$display("Output for ALUop 10, Opcode 01000 does not equal 0101");
	end
	 
	#HALF_Period;
		 
		
	//Test ALUop = 2'b10; Opcode = 5'b01001
	ALUop = 2'b10;
	Opcode = 5'b01001;
	#HALF_Period;
	if(ALUOutOp != 4'b0111)begin
		$display("Output for ALUop 10, Opcode 01001 does not equal 0111");
	end
	 
	#HALF_Period;
		 
	// Test ALUop = 2'b10; Opcode = 5'b01010
	ALUop = 2'b10;
	Opcode = 5'b01010;
	#HALF_Period;
	if(ALUOutOp != 4'b0110)begin
		$display("Output for ALUop 10, Opcode 01010 does not equal 0110");
	end
	 
	#HALF_Period;
	
	//Test ALUop = 2'b10; Opcode = 5'b01011
	ALUop = 2'b10;
	Opcode = 5'b01011;
	#HALF_Period;
	if(ALUOutOp != 4'b0000)begin
		$display("Output for ALUop 10, Opcode 01011 does not equal 0000");
	end
	 
	#HALF_Period;
	 
	// Test ALUop = 2'b10; Opcode = 5'b01100
	ALUop = 2'b10;
	Opcode = 5'b01100;
	#HALF_Period;
	if(ALUOutOp != 4'b0010)begin
		$display("Output for ALUop 10, Opcode 01100 does not equal 0010");
	end
	#HALF_Period;
	 
	
	//Test ALUop = 2'b10; Opcode = 5'b01101
	ALUop = 2'b10;
	Opcode = 5'b01101;
	#HALF_Period;
	if(ALUOutOp != 4'b0011)begin
		$display("Output for ALUop 10, Opcode 01101 does not equal 0011");
	end
	 
	#HALF_Period;
	 
	// Test ALUop = 2'b10; Opcode = 5'b01110
	ALUop = 2'b10;
	Opcode = 5'b01110;
	#HALF_Period;
	if(ALUOutOp != 4'b0100)begin
		$display("Output for ALUop 10, Opcode 01110 does not equal 0100");
	end
	 
	#HALF_Period;
	
	//Test ALUop = 2'b10; Opcode = 5'b01111
	ALUop = 2'b10;
	Opcode = 5'b01111;
	#HALF_Period;
	if(ALUOutOp != 4'b1011)begin
		$display("Output for ALUop 10, Opcode 01111 does not equal 1011");
	end
	 
	#HALF_Period;
		 
	// Test ALUop = 2'b10; Opcode = 5'b10000
	ALUop = 2'b10;
	Opcode = 5'b10000;
	#HALF_Period;
	if(ALUOutOp != 4'b1000)begin
		$display("Output for ALUop 10, Opcode 10000 does not equal 1000");
	end
	 
	#HALF_Period;
	 
	// Test ALUop = 2'b10; Opcode = 5'b10001
	ALUop = 2'b10;
	Opcode = 5'b10001;
	#HALF_Period;
	if(ALUOutOp != 4'b1010)begin
		$display("Output for ALUop 10, Opcode 10001 does not equal 1010");
	end
	 
	#HALF_Period;
	
	//Test ALUop = 2'b10; Opcode = 5'b10010
	ALUop = 2'b10;
	Opcode = 5'b10010;
	#HALF_Period;
	if(ALUOutOp != 4'b1011)begin
		$display("Output for ALUop 10, Opcode 10010 does not equal 1011");
	end
	 
	#HALF_Period;
		
	// Test ALUop = 2'b10; Opcode = 5'b10011
	ALUop = 2'b10;
	Opcode = 5'b10011;
	#HALF_Period;
	if(ALUOutOp != 4'b1011)begin
		$display("Output for ALUop 10, Opcode 10011 does not equal 1011");
	end
	 
	#HALF_Period;
		
	//Test ALUop = 2'b10; Opcode = 5'b10111
	ALUop = 2'b10;
	Opcode = 5'b10111;
	#HALF_Period;
	if(ALUOutOp != 4'b0000)begin
		$display("Output for ALUop 10, Opcode 10111 does not equal 0000");
	end
	 
	#HALF_Period;
	 
	//Test ALUop = 2'b10; Opcode = 5'b11000
	ALUop = 2'b10;
	Opcode = 5'b11000;
	#HALF_Period;
	if(ALUOutOp != 4'b1111)begin
		$display("Output for ALUop 10, Opcode 11000 does not equal 1111");
	end
		
	#HALF_Period;
		 
	// Test ALUop = 2'b10; Opcode = 5'b11001
	ALUop = 2'b10;
	Opcode = 5'b11001;
	#HALF_Period;
	if(ALUOutOp != 4'b0000)begin
		$display("Output for ALUop 10, Opcode 11001 does not equal 0000");
	end
	 
	#HALF_Period;
		 
	//Test ALUop = 2'b10; Opcode = 5'b11101
	ALUop = 2'b10;
	Opcode = 5'b11101;
	#HALF_Period;
	if(ALUOutOp != 4'b1110)begin
		$display("Output for ALUop 10, Opcode 11101 does not equal 1110");
	end
	 
	#HALF_Period;
		 
	// Test ALUop = 2'b00
	ALUop = 2'b00;
	#HALF_Period;
	if(ALUOutOp != 4'b0000)begin
		$display("Output for ALUop 00 does not equal 0000");
	end
	 
	#HALF_Period;
		 
	// Test ALUop = 2'b01
	ALUop = 2'b01;
	#HALF_Period;
	if(ALUOutOp != 4'b0001)begin
		$display("Output for ALUop 01 does not equal 0001");
	end
	 
	#HALF_Period;
		 
	//Test ALUop = 2'b11; AlterOp = 00000
	ALUop = 2'b11;
	AlterOp = 5'b00000;
	#HALF_Period;
	if(ALUOutOp != 4'b0000)begin
		$display("Output for ALUop 11, AlterOp 00000 does not equal 0000");
	end
	 
	#HALF_Period;
		 
	//Test ALUop = 2'b11; AlterOp = 00001
	ALUop = 2'b11;
	AlterOp = 5'b00001;
	#HALF_Period;
	if(ALUOutOp != 4'b0001)begin
		$display("Output for ALUop 11, AlterOp 00001 does not equal 0001");
	end
	 
	#HALF_Period;
		 
	//Test ALUop = 2'b11; AlterOp = 00111
	ALUop = 2'b11;
	AlterOp = 5'b00111;
	#HALF_Period;
	if(ALUOutOp != 4'b0100)begin
		$display("Output for ALUop 11, AlterOp 00111 does not equal 0100");
	end
	 
	#HALF_Period;
		 
	//Test ALUop = 2'b11; AlterOp = 00111
	ALUop = 2'b11;
	AlterOp = 5'b00110;
	#HALF_Period;
	if(ALUOutOp != 4'b0011)begin
		$display("Output for ALUop 11, AlterOp 00110 does not equal 0011");
	end
	
	#HALF_Period;
		 
	//Test ALUop = 2'b11; AlterOp = 01101
	ALUop = 2'b11;
	AlterOp = 5'b01101;
	#HALF_Period;
	if(ALUOutOp != 4'b1100)begin
		$display("Output for ALUop 11, AlterOp 01101 does not equal 1100");
	end
	
	
	#HALF_Period;
		 
	//Test ALUop = 2'b11; AlterOp = 01110
	ALUop = 2'b11;
	AlterOp = 5'b01110;
	#HALF_Period;
	if(ALUOutOp != 4'b1101)begin
		$display("Output for ALUop 11, AlterOp 01110 does not equal 1101");
	end
	

    $stop;
end

endmodule
