//////////////////////////////////////////////////////////////////////////////////
// Company: Pink
// Engineer: 
// 
// Create Date:    02/13/2024 
// Module Name:  Headless Machine Test Bench
// Project Name: 
//
// Revision 0.01 - Created file
// Additional Comments: 
//	Memory_txt
// 0406
//	0126
//	00c6
//	ff99
//	0017
//	0137
//	00d4
//	0099
//	05d0
//	00ab
//	f0b0
//	01bd
//	001c
//	0018
//	0138
//	0046
//	0511
//	01bd
//	001c
//	0b30
//	0432
//	0a3e
//	f8b0
//	089e
//	f410
//	019d
//	001c
//	0049
//	00cd
//	00ce
//	ffb6
//	ffc0
//	ffc1
//	ffc3
//	ff95
//	ffd6
//	7ffb
//////////////////////////////////////////////////////////////////////////////////

module tb_headless_mahcine;

//Data input
	reg [15:0] Inputio;
	
	//Control Signal input
	reg [1:0]		  ALUOp;
   reg [1:0]        ALUSrcA;
   reg [1:0]        ALUSrcB;
   reg [1:0]        MemtoReg;
   reg              RegWrite;
   reg              MemRead;
   reg              MemWrite;
   reg [1:0]        IorD;
   reg              IRWrite;
   reg              PCWrite;
	reg              Jump;
	reg [1:0]        Branch;
	reg              shouldBranch;
	reg [1:0]        RegFileSrc;
	reg [2:0]        ReturnSrc;
	reg [1:0]        DataSrc;
	reg [1:0]        OperandSrc;
	reg              SPWrite;
	reg              CLK;
	reg              Reset;
	
	//Output
	wire [15:0] Outputio;
	wire Overflow;
	
	parameter HALF_PERIOD = 50;
	integer line_counter = 0;
	integer address = 0;
	integer failures = 0;
	integer cycle_counter = 0;
	integer currentSP = 16'h0000;
	integer tempALU = 16'h0;


headless_machine headless_machine_inst
(
	.Inputio(Inputio) ,	// input [15:0] Inputio
	.ALUOp(ALUOp) ,	// input [1:0] ALUOp
	.ALUSrcA(ALUSrcA) ,	// input [1:0] ALUSrcA
	.ALUSrcB(ALUSrcB) ,	// input [1:0] ALUSrcB
	.MemtoReg(MemtoReg) ,	// input [1:0] MemtoReg
	.RegWrite(RegWrite) ,	// input  RegWrite
	.MemRead(MemRead) ,	// input  MemRead
	.MemWrite(MemWrite) ,	// input  MemWrite
	.IorD(IorD) ,	// input [1:0] IorD
	.IRWrite(IRWrite) ,	// input  IRWrite
	.PCWrite(PCWrite) ,	// input  PCWrite
	.Jump(Jump) ,	// input  Jump
	.Branch(Branch) ,	// input [1:0] Branch
	.shouldBranch(shouldBranch) ,	// input  shouldBranch
	.RegFileSrc(RegFileSrc) ,	// input [1:0] RegFileSrc
	.ReturnSrc(ReturnSrc) ,	// input [1:0] ReturnSrc
	.DataSrc(DataSrc) ,	// input  DataSrc
	.OperandSrc(OperandSrc) ,	// input [1:0] OperandSrc
	.SPWrite(SPWrite) ,	// input  SPWrite
	.Reset(Reset) ,	// input  Reset
	.CLK(CLK) ,	// input  CLK
	.Opcode() ,
	.Outputio(Outputio) ,	// output [15:0] Outputio
	.Overflow(Overflow) 	// output  Overflow
);


initial begin
	 CLK = 1;
	 forever begin
		  #(HALF_PERIOD);
		  CLK = ~CLK;
		  if (CLK == 0) begin
			cycle_counter = cycle_counter + 1;
		end
	 end
end

initial begin

	Reset = 1;
	clearsig;
	#(2.1*HALF_PERIOD);
	Reset = 0;
	fetch;
	$display("Fetch cycle done, loaded line: %d", headless_machine_inst.inte_stage1_part1_inst.PC.Output - 2);

	decode;
	$display("Decode cycle done, instruction: %h", headless_machine_inst.inte_stage1_part1_inst.IR.Output);
	
	//-------------------------------Set-------------------------------
	// Hex inst: 0406
	// Binary inst: 0000010000000110
	// Text Inst: set r0 8
	clearsig;
	RegFileSrc = 2'b11;
	RegWrite = 1;
	#(2*HALF_PERIOD);
	if(headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg0 != 16'h8) begin
		$display("set r0 8 failed. Expected r0 %h but got %h", 16'h8, headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg0);
		failures = failures + 1;
	end
	
	fetch;
	decode;
	
	//-------------------------------Set-------------------------------
	// Hex inst: 0126
	// Binary inst: 0000000100100110
	// Text Inst: set r1 2
	clearsig;
	RegFileSrc = 2'b11;
	RegWrite = 1;
	#(2*HALF_PERIOD);
	if(headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg1 != 16'h2) begin
		$display("set r0 8 failed. Expected r0 %h but got %h", 16'h2, headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg1);
		failures = failures + 1;
	end
	
	fetch;
	decode;
	
	
	//-------------------------------Set-------------------------------
	// Hex inst: 00c6
	// Binary inst: 0000000011000110
	// Text Inst: set r2 1
	clearsig;
	RegFileSrc = 2'b11;
	RegWrite = 1;
	#(2*HALF_PERIOD);
	if(headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg2 != 16'h1) begin
		$display("set r0 8 failed. Expected r0 %h but got %h", 16'h1, headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg2);
		failures = failures + 1;
	end
	
	fetch;
	decode;
	
		
	//-------------------------------movesp-------------------------------
	// Hex inst: ff99
	// Binary inst: 1111111110011001
	// Text Inst: movesp -4
	// Assuming SP starts at 0x07FF
	clearsig;
	ALUSrcA = 2'b11;
	ALUSrcB = 2'b01;
	ALUOp = 2'b10;
	#(2*HALF_PERIOD);

	clearsig;
   SPWrite = 1;
	
	#(2*HALF_PERIOD);
	
	if (headless_machine_inst.regFile_immgen_sp_inst.sp_reg.Output !== 16'h07fd) begin
		$display("Error: movesp - sp expected %h, received %h", 16'h07fd, headless_machine_inst.regFile_immgen_sp_inst.sp_reg.Output);
		failures = failures + 1;
	end
	
	fetch;
	decode;
	
	
	//-------------------------------Storesp-------------------------------
	// Hex inst: 0017
	// Binary inst: 0000000000010111
	// Text Inst: storesp r0 0x0
	clearsig;
	ALUSrcA = 2'b11;
	ALUSrcB = 2'b01;
	ALUOp = 2'b10;
	#(2*HALF_PERIOD);
	
	
	clearsig;
	MemWrite = 1;
	IorD = 2'b10;
	DataSrc = 2'b01;
	#(2*HALF_PERIOD);
		
	// Check memory 0x7FC = 8

	fetch;
	decode;
	
	//-------------------------------Storesp-------------------------------
	// Hex inst: 0137
	// Binary inst: 0000000100110111
	// Text Inst: storesp r1 0x2
	clearsig;
	ALUSrcA = 2'b11;
	ALUSrcB = 2'b01;
	ALUOp = 2'b10;
	#(2*HALF_PERIOD);
	
	
	clearsig;
	MemWrite = 1;
	IorD = 2'b10;
	DataSrc = 2'b01;
	#(2*HALF_PERIOD);
		
	// Check memory 0x7FF = 2

	fetch;
	decode;
	
	
	//-------------------------------jal-------------------------------
	// Hex inst: 00d4
	// Binary inst: 0000000011010100
	// Text Inst: jal GCD (0x1a)
	clearsig;
	ALUSrcA = 2'b11;
	ALUSrcB = 2'b11;
	ALUOp = 2'b10;
	#(2*HALF_PERIOD);
	if (headless_machine_inst.magenta_stage_ALUControl_ALU_ALUOut_RegA_RegB_inst.ALUOutComp.Output !== 16'h07fb) begin
		$display("Error: jal 0x1a - sp expected %h, received %h", 16'h07fb, headless_machine_inst.magenta_stage_ALUControl_ALU_ALUOut_RegA_RegB_inst.ALU.ALUOut);
		failures = failures + 1;
	end

	
	clearsig;
	MemWrite= 1;
	DataSrc = 2'b00;
	IorD = 2'b10;
	
	ALUSrcA = 2'b01;
	ALUSrcB = 2'b11; 
	ALUOp = 2'b10;
	
	OperandSrc = 2'b11;
	tempALU = headless_machine_inst.magenta_stage_ALUControl_ALU_ALUOut_RegA_RegB_inst.ALUOutComp.Output; //confirm that aluout is decremented by 2
	
	#(2*HALF_PERIOD);
	if (headless_machine_inst.magenta_stage_ALUControl_ALU_ALUOut_RegA_RegB_inst.ALUOutComp.Output !== 16'h07f9) begin
		$display("Error: jal 0x1a - sp expected %h, received %h", 16'h07f9, headless_machine_inst.magenta_stage_ALUControl_ALU_ALUOut_RegA_RegB_inst.ALU.ALUOut);
		failures = failures + 1;
	end
	
	if(16'h1 !== headless_machine_inst.regFile_immgen_sp_inst.reg_file.OutputA) begin
		$display("Error: Reg A expected %h, received %h", 16'h1, headless_machine_inst.regFile_immgen_sp_inst.reg_file.OutputA);
		failures = failures + 1;
	end
	
	
	clearsig;
	MemWrite = 1;
	DataSrc = 2'b01;
	IorD = 2'b10;
	
	ALUSrcA = 2'b01;
	ALUSrcB = 2'b11; 
	ALUOp = 2'b10;
	
	OperandSrc = 2'b10;

	#(2*HALF_PERIOD);
	if (headless_machine_inst.magenta_stage_ALUControl_ALU_ALUOut_RegA_RegB_inst.ALUOutComp.Output !== 16'h07f7) begin
		$display("Error: jal 0x1a - sp expected %h, received %h", 16'h07f7, headless_machine_inst.magenta_stage_ALUControl_ALU_ALUOut_RegA_RegB_inst.ALU.ALUOut);
		failures = failures + 1;
	end
	
	if(16'h2 !== headless_machine_inst.regFile_immgen_sp_inst.reg_file.OutputA) begin
		$display("Error: Reg A expected %h, received %h", 16'h2, headless_machine_inst.regFile_immgen_sp_inst.reg_file.OutputA);
		failures = failures + 1;
	end

	
	clearsig;
	MemWrite = 1;
	DataSrc = 2'b01;
	IorD = 2'b10;
	
	ALUSrcA = 2'b01;
	ALUSrcB = 2'b11; 
	ALUOp = 2'b10;
	
	OperandSrc = 2'b01;

	#(2*HALF_PERIOD);
	cycle_counter = cycle_counter + 1;
	if (headless_machine_inst.magenta_stage_ALUControl_ALU_ALUOut_RegA_RegB_inst.ALUOutComp.Output !== 16'h07f5) begin
		$display("Error: jal 0x1a - sp expected %h, received %h", 16'h07f5, headless_machine_inst.magenta_stage_ALUControl_ALU_ALUOut_RegA_RegB_inst.ALU.ALUOut);
		failures = failures + 1;
	end
	
	if(16'h8 !== headless_machine_inst.regFile_immgen_sp_inst.reg_file.OutputA) begin
		$display("Error: Reg A expected %h, received %h", 16'h8, headless_machine_inst.regFile_immgen_sp_inst.reg_file.OutputA);
		failures = failures + 1;
	end

	
	clearsig;
	MemWrite = 1;
	DataSrc = 2'b01;
	IorD = 2'b10;	
	
	SPWrite = 1;
	
	ALUSrcA = 2'b00;
	ALUSrcB = 2'b01;
	ALUOp = 2'b00;
	PCWrite = 1;


	#(2*HALF_PERIOD);
	
	if (16'h07f5 !== headless_machine_inst.regFile_immgen_sp_inst.sp_reg.Output) begin
		$display("Error: jal last cycle - SP expected %h, received %h", 16'h07f5, headless_machine_inst.regFile_immgen_sp_inst.sp_reg.Output);
		failures = failures + 1;
	end
	
	
	fetch;
	decode; 
	
	//-------------------------------Loadsp-------------------------------
	// Hex inst: 0018
	// Binary inst: 0000000000011000
	// Text Inst: loadsp r0 0
	
	clearsig;
	ALUSrcA = 2'b11;
	ALUSrcB = 2'b01;
	ALUOp = 2'b10;
	MemRead = 1'b0;
	#(2*HALF_PERIOD);


	clearsig;
	IorD = 2'b10;
	MemRead = 1'b1;
	#(2*HALF_PERIOD);

	clearsig;
	RegFileSrc = 2'b00;
	RegWrite = 1'b1;
	ReturnSrc = 3'b000;
	MemRead = 1'b0;
	#(2*HALF_PERIOD);
	 
	if (headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg0 !== 16'h8) begin
		$display("Error: reg0 expected %h, receieved %h", 16'h8, headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg0);
		failures = failures + 1;
	end

	fetch;
	decode;
	
	//-------------------------------Loadsp-------------------------------
	// Hex inst: 0138
	// Binary inst: 0000000100111000
	// Text Inst: loadsp r1 2
	
	clearsig;
	ALUSrcA = 2'b11;
	ALUSrcB = 2'b01;
	ALUOp = 2'b10;
	MemRead = 1'b0;
	#(2*HALF_PERIOD);


	clearsig;
	IorD = 2'b10;
	MemRead = 1'b1;
	#(2*HALF_PERIOD);

	clearsig;
	RegFileSrc = 2'b00;
	RegWrite = 1'b1;
	ReturnSrc = 3'b000;
	MemRead = 1'b0;
	#(2*HALF_PERIOD);
	 
	if (headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg1 !== 16'h2) begin
		$display("Error: reg1 expected %h, receieved %h", 16'h2, headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg1);
		failures = failures + 1;
	end

	fetch;
	decode;
	
	//-------------------------------Set-------------------------------
	// Hex inst: 0046
	// Binary inst: 0000000001000110 
	// Text Inst: set r2 0
	clearsig;
	RegFileSrc = 2'b11;
	RegWrite = 1;
	#(2*HALF_PERIOD);
	if(headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg2 != 16'h0) begin
		$display("set r2 0 failed. Expected r2 %h but got %h", 16'h0, headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg2);
		failures = failures + 1;
	end
	
	fetch;
	decode;
	
	//-------------------------------Bne-------------------------------
	// Hex inst: 0511
	// Binary inst: 0000010100010001 
	// Text Inst: bne r0 r2 continue
	// We will branch
	clearsig;
	ALUOp = 2'b10;
	ALUSrcA = 2'b10;
	ALUSrcB = 2'b00;
	Branch = 2'b01;
	#(2*HALF_PERIOD);
	if(headless_machine_inst.inte_stage1_part1_inst.PC.Output != 16'h26) begin
		$display("bne r0 r2 continue failed. Expected PC to be %h but got %h", 16'h26, headless_machine_inst.inte_stage1_part1_inst.PC.Output);
		failures = failures + 1;
	end
	
	fetch;
	decode;
	
	
	//-------------------------------Beq-------------------------------
	// Hex inst: 0b30
	// Binary inst: 0000101100110000 
	// Text Inst: beq r1 r2 done
	// We will not branch
	clearsig;
	ALUOp = 2'b10;
	ALUSrcA = 2'b10;
	ALUSrcB = 2'b00;
	Branch = 2'b01;
	#(2*HALF_PERIOD);
	if(headless_machine_inst.inte_stage1_part1_inst.PC.Output != 16'h28) begin
		$display("beq r1 r2 done failed. Expected PC to be %h but got %h", 16'h28, headless_machine_inst.inte_stage1_part1_inst.PC.Output);
		failures = failures + 1;
	end
	
	fetch;
	decode;
	
	//-------------------------------Blt-------------------------------
	// Hex inst: 0432
	// Binary inst: 0000010000110010 
	// Text Inst: blt r1 r0 changeA (0x2E)
	// We will branch
	clearsig;
	ALUOp = 2'b10;
	ALUSrcA = 2'b10;
	ALUSrcB = 2'b00;
	Branch = 2'b01;
	#(2*HALF_PERIOD);
	if(headless_machine_inst.inte_stage1_part1_inst.PC.Output != 16'h2E) begin
		$display("blt r1 r0 changeA failed. Expected PC to be %h but got %h", 16'h2E, headless_machine_inst.inte_stage1_part1_inst.PC.Output);
		failures = failures + 1;
	end
	
	fetch;
	decode;
	
	
	//-------------------------------Alter-------------------------------
	// Hex inst: 089e
	// Binary inst: 0000100010011110 
	// Text Inst: alter r0 r0 r1 -
	clearsig;
	ALUSrcA= 2'b10;
	ALUSrcB= 2'b00;
	ALUOp= 2'b11;
	#(2*HALF_PERIOD);
	
	clearsig;
	RegWrite = 1;
	ReturnSrc = 2'b01;
	RegFileSrc = 2'b10;
	#(2*HALF_PERIOD);
	if(headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg0 != 16'h6) begin
		$display("alter r0 r0 r1 - failed. Expected r0 %h but got %h", 16'h6, headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg0);
		failures = failures + 1;
	end
	$stop;
	
	fetch;
	decode;
	
	//-------------------------------Beq-------------------------------
	// Hex inst: f410
	// Binary inst: 1111010000010000 
	// Text Inst: beq r0 r0 continue
	// We will  branch
	clearsig;
	ALUOp = 2'b10;
	ALUSrcA = 2'b10;
	ALUSrcB = 2'b00;
	Branch = 2'b01;
	#(2*HALF_PERIOD);
	if(headless_machine_inst.inte_stage1_part1_inst.PC.Output != 16'h26) begin
		$display("beq r0 r0 continue failed. Expected PC to be %h but got %h", 16'h26, headless_machine_inst.inte_stage1_part1_inst.PC.Output);
		failures = failures + 1;
	end
	
	fetch;
	decode;
	
	
	//-------------------------------Beq-------------------------------
	// Hex inst: 0b30
	// Binary inst: 0000101100110000 
	// Text Inst: beq r1 r2 done
	// We will not branch
	ALUOp = 2'b10;
	ALUSrcA = 2'b10;
	ALUSrcB = 2'b00;
	Branch = 2'b01;
	#(2*HALF_PERIOD);
	if(headless_machine_inst.inte_stage1_part1_inst.PC.Output != 16'h28) begin
		$display("beq r1 r2 done failed. Expected PC to be %h but got %h", 16'h28, headless_machine_inst.inte_stage1_part1_inst.PC.Output);
		failures = failures + 1;
	end
	
	fetch;
	decode;
	
	//-------------------------------Blt-------------------------------
	// Hex inst: 0432
	// Binary inst: 0000010000110010 
	// Text Inst: blt r1 r0 changeA (0x2E)
	// We will branch
	ALUOp = 2'b10;
	ALUSrcA = 2'b10;
	ALUSrcB = 2'b00;
	Branch = 2'b01;
	#(2*HALF_PERIOD);
	if(headless_machine_inst.inte_stage1_part1_inst.PC.Output != 16'h2E) begin
		$display("blt r1 r0 changeA failed. Expected PC to be %h but got %h", 16'h2E, headless_machine_inst.inte_stage1_part1_inst.PC.Output);
		failures = failures + 1;
	end
	
	fetch;
	decode;
	
	
	//-------------------------------Alter-------------------------------
	// Hex inst: 089e
	// Binary inst: 0000100010011110 
	// Text Inst: alter r0 r0 r1 -
	ALUSrcA= 2'b10;
	ALUSrcB= 2'b00;
	ALUOp= 2'b11;
	#(2*HALF_PERIOD);
	
	clearsig;
	RegWrite = 1;
	ReturnSrc = 2'b01;
	RegFileSrc = 2'b10;
	#(2*HALF_PERIOD);
	if(headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg0 != 16'h4) begin
		$display("alter r0 r0 r1 - failed. Expected r0 %h but got %h", 16'h4, headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg0);
		failures = failures + 1;
	end
	
	fetch;
	decode;
	
	//-------------------------------Beq-------------------------------
	// Hex inst: f410
	// Binary inst: 1111010000010000 
	// Text Inst: beq r0 r0 continue
	// We will  branch
	ALUOp = 2'b10;
	ALUSrcA = 2'b10;
	ALUSrcB = 2'b00;
	Branch = 2'b01;
	#(2*HALF_PERIOD);
	if(headless_machine_inst.inte_stage1_part1_inst.PC.Output != 16'h26) begin
		$display("beq r0 r0 continue failed. Expected PC to be %h but got %h", 16'h26, headless_machine_inst.inte_stage1_part1_inst.PC.Output);
		failures = failures + 1;
	end
	
	fetch;
	decode;
	
	//-------------------------------Beq-------------------------------
	// Hex inst: 0b30
	// Binary inst: 0000101100110000 
	// Text Inst: beq r1 r2 done
	// We will not branch
	ALUOp = 2'b10;
	ALUSrcA = 2'b10;
	ALUSrcB = 2'b00;
	Branch = 2'b01;
	#(2*HALF_PERIOD);
	if(headless_machine_inst.inte_stage1_part1_inst.PC.Output != 16'h28) begin
		$display("beq r1 r2 done failed. Expected PC to be %h but got %h", 16'h28, headless_machine_inst.inte_stage1_part1_inst.PC.Output);
		failures = failures + 1;
	end
	
	fetch;
	decode;
	
	//-------------------------------Blt-------------------------------
	// Hex inst: 0432
	// Binary inst: 0000010000110010 
	// Text Inst: blt r1 r0 changeA (0x2E)
	// We will branch
	ALUOp = 2'b10;
	ALUSrcA = 2'b10;
	ALUSrcB = 2'b00;
	Branch = 2'b01;
	#(2*HALF_PERIOD);
	if(headless_machine_inst.inte_stage1_part1_inst.PC.Output != 16'h2E) begin
		$display("blt r1 r0 changeA failed. Expected PC to be %h but got %h", 16'h2E, headless_machine_inst.inte_stage1_part1_inst.PC.Output);
		failures = failures + 1;
	end
	
	fetch;
	decode;
	
	
	//-------------------------------Alter-------------------------------
	// Hex inst: 089e
	// Binary inst: 0000100010011110 
	// Text Inst: alter r0 r0 r1 -
	ALUSrcA= 2'b10;
	ALUSrcB= 2'b00;
	ALUOp= 2'b11;
	#(2*HALF_PERIOD);
	
	clearsig;
	RegWrite = 1;
	ReturnSrc = 2'b01;
	RegFileSrc = 2'b10;
	#(2*HALF_PERIOD);
	if(headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg0 != 16'h2) begin
		$display("alter r0 r0 r1 - failed. Expected r0 %h but got %h", 16'h2, headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg0);
		failures = failures + 1;
	end
	
	fetch;
	decode;
	
	//-------------------------------Beq-------------------------------
	// Hex inst: f410
	// Binary inst: 1111010000010000 
	// Text Inst: beq r0 r0 continue
	// We will  branch
	ALUOp = 2'b10;
	ALUSrcA = 2'b10;
	ALUSrcB = 2'b00;
	Branch = 2'b01;
	#(2*HALF_PERIOD);
	if(headless_machine_inst.inte_stage1_part1_inst.PC.Output != 16'h26) begin
		$display("beq r0 r0 continue failed. Expected PC to be %h but got %h", 16'h26, headless_machine_inst.inte_stage1_part1_inst.PC.Output);
		failures = failures + 1;
	end
	
	fetch;
	decode;
	
	
	//-------------------------------Beq-------------------------------
	// Hex inst: 0b30
	// Binary inst: 0000101100110000 
	// Text Inst: beq r1 r2 done
	// We will not branch
	ALUOp = 2'b10;
	ALUSrcA = 2'b10;
	ALUSrcB = 2'b00;
	Branch = 2'b01;
	#(2*HALF_PERIOD);
	if(headless_machine_inst.inte_stage1_part1_inst.PC.Output != 16'h28) begin
		$display("beq r1 r2 done failed. Expected PC to be %h but got %h", 16'h28, headless_machine_inst.inte_stage1_part1_inst.PC.Output);
		failures = failures + 1;
	end
	
	fetch;
	decode;
	
	//-------------------------------Blt-------------------------------
	// Hex inst: 0432
	// Binary inst: 0000010000110010 
	// Text Inst: blt r1 r0 changeA (0x2E)
	// We will not branch (orange)
	ALUOp = 2'b10;
	ALUSrcA = 2'b10;
	ALUSrcB = 2'b00;
	Branch = 2'b01;
	#(2*HALF_PERIOD);
	if(headless_machine_inst.inte_stage1_part1_inst.PC.Output != 16'h2a) begin
		$display("blt r1 r0 changeA failed. Expected PC to be %h but got %h", 16'h2a, headless_machine_inst.inte_stage1_part1_inst.PC.Output);
		failures = failures + 1;
	end
	
	fetch;
	decode;
	
	
	//-------------------------------Alter-------------------------------
	// Hex inst: 0a3e
	// Binary inst: 0000101000111110 
	// Text Inst: alter r1 r1 r0 -
	ALUSrcA= 2'b10;
	ALUSrcB= 2'b00;
	ALUOp= 2'b11;
	#(2*HALF_PERIOD);
	
	clearsig;
	RegWrite = 1;
	ReturnSrc = 2'b01;
	RegFileSrc = 2'b10;
	#(2*HALF_PERIOD);
	if(headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg1 != 16'h0) begin
		$display("alter r0 r0 r1 - failed. Expected r0 %h but got %h", 16'h0, headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg0);
		failures = failures + 1;
	end
	
	fetch;
	decode;
	
	//-------------------------------Beq-------------------------------
	// Hex inst: f8b0
	// Binary inst: 1111100010110000 
	// Text Inst: beq r1 r1 continue
	// We will branch
	ALUOp = 2'b10;
	ALUSrcA = 2'b10;
	ALUSrcB = 2'b00;
	Branch = 2'b01;
	#(2*HALF_PERIOD);
	if(headless_machine_inst.inte_stage1_part1_inst.PC.Output != 16'h26) begin
		$display("beq r1 r1 continue failed. Expected PC to be %h but got %h", 16'h26, headless_machine_inst.inte_stage1_part1_inst.PC.Output);
		failures = failures + 1;
	end
	
	fetch;
	decode;
	
	
	//-------------------------------Beq-------------------------------
	// Hex inst: 0b30
	// Binary inst: 0000101100110000 
	// Text Inst: beq r1 r2 done
	// We will branch
	ALUOp = 2'b10;
	ALUSrcA = 2'b10;
	ALUSrcB = 2'b00;
	Branch = 2'b01;
	#(2*HALF_PERIOD);
	if(headless_machine_inst.inte_stage1_part1_inst.PC.Output != 16'h32) begin
		$display("beq r1 r1 continue failed. Expected PC to be %h but got %h", 16'h32, headless_machine_inst.inte_stage1_part1_inst.PC.Output);
		failures = failures + 1;
	end
	
	fetch;
	decode;
	
	//-------------------------------Swap-------------------------------
	// Hex inst: 019d
	// Binary inst: 0000 0001 1001 1101 
	// Text Inst: swap r0 r3
	ALUSrcA = 2'b10;
	ALUOp = 2'b10;
	RegFileSrc = 2'b01;
	RegWrite = 1;
	ReturnSrc = 2'b00;
	#(2*HALF_PERIOD);
	
	clearsig;
	ReturnSrc = 2'b10;
	RegWrite = 1;
	RegFileSrc = 2'b10;
	#(2*HALF_PERIOD);
	
	if(headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg0 != 16'h0) begin
		$display("swap r0 r3 failed. Expected r0 %h but got %h", 16'h0, headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg0);
		failures = failures + 1;
	end
	
	if(headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg3 != 16'h2) begin
		$display("swap r0 r3 failed. Expected r3 %h but got %h", 16'h2, headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg0);
		failures = failures + 1;
	end
	
	fetch;
	decode;
	
	
	//-------------------------------Jb-------------------------------
	// Hex inst: 001c
	// Binary inst: 0000 0000 0001 1100 
	// Text Inst: jb 0
	MemRead = 1;
	IorD = 2'b11;
	ALUSrcA = 2'b11;
	ALUSrcB = 2'b11;
	ALUOp = 2'b10;
	#(2*HALF_PERIOD);
	
	if (headless_machine_inst.magenta_stage_ALUControl_ALU_ALUOut_RegA_RegB_inst.ALUOutComp.Output !== 16'h07f7) begin
		$display("Error: jb 0 ALUOut expected %h, received %h", 16'h07f7, headless_machine_inst.magenta_stage_ALUControl_ALU_ALUOut_RegA_RegB_inst.ALU.ALUOut);
		failures = failures + 1;
	end
	
	clearsig;
	RegFileSrc = 2'b00;
	ReturnSrc = 3'b101;
	RegWrite = 1;
	IorD = 2'b10;
	ALUSrcA = 2'b01;
	ALUSrcB = 2'b11;
	ALUOp = 2'b10;
	MemRead = 1;
	#(2*HALF_PERIOD);
	if (headless_machine_inst.magenta_stage_ALUControl_ALU_ALUOut_RegA_RegB_inst.ALUOutComp.Output !== 16'h07f9) begin
		$display("Error: jb 0 ALUOut expected %h, received %h", 16'h07f9, headless_machine_inst.magenta_stage_ALUControl_ALU_ALUOut_RegA_RegB_inst.ALU.ALUOut);
		failures = failures + 1;
	end
	
	clearsig;
	RegFileSrc = 2'b00;
	ReturnSrc = 3'b100;
	RegWrite = 1;
	IorD = 2'b10;
	ALUSrcA = 2'b01;
	ALUSrcB = 2'b11;
	ALUOp = 2'b10;
	MemRead = 1;
	#(2*HALF_PERIOD);
	if (headless_machine_inst.magenta_stage_ALUControl_ALU_ALUOut_RegA_RegB_inst.ALUOutComp.Output !== 16'h07fb) begin
		$display("Error: jb 0 ALUOut expected %h, received %h", 16'h07fb, headless_machine_inst.magenta_stage_ALUControl_ALU_ALUOut_RegA_RegB_inst.ALU.ALUOut);
		failures = failures + 1;
	end
	
	clearsig;
	RegFileSrc = 2'b00;
	ReturnSrc = 3'b011;
	RegWrite = 1;
	IorD = 2'b10;
	ALUSrcA = 2'b01;
	ALUSrcB = 2'b11;
	ALUOp = 2'b10;
	MemRead = 1;
	#(2*HALF_PERIOD);
	if (headless_machine_inst.magenta_stage_ALUControl_ALU_ALUOut_RegA_RegB_inst.ALUOutComp.Output !== 16'h07fd) begin
		$display("Error: jb 0 ALUOut expected %h, received %h", 16'h07fd, headless_machine_inst.magenta_stage_ALUControl_ALU_ALUOut_RegA_RegB_inst.ALU.ALUOut);
		failures = failures + 1;
	end
	
	clearsig;
	Branch = 2'b10;
	Jump = 1;
	SPWrite = 1;
	#(2*HALF_PERIOD);
	if (headless_machine_inst.inte_stage1_part1_inst.PC.Output !== 16'h000e) begin
		$display("Error: jb 0 PC expected %h, received %h", 16'h000e, headless_machine_inst.inte_stage1_part1_inst.PC.Output);
		failures = failures + 1;
	end
	
	if (16'h07fd !== headless_machine_inst.regFile_immgen_sp_inst.sp_reg.Output) begin
		$display("Error: jb 0 SP expected %h, received %h", 16'h07fd, headless_machine_inst.regFile_immgen_sp_inst.sp_reg.Output);
		failures = failures + 1;
	end
	
	if(headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg0 != 16'h8) begin
		$display("Error: jb 0 failed. Expected r0 to be %h but got %h", 16'h8, headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg0);
		failures = failures + 1;
	end
	
	if(headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg1 != 16'h2) begin
		$display("Error: jb 0 failed. Expected r1 to be %h but got %h", 16'h2, headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg1);
		failures = failures + 1;
	end
	
	if(headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg2 != 16'h1) begin
		$display("Error: jb 0 failed. Expected r2 to be %h but got %h", 16'h1, headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg2);
		failures = failures + 1;
	end
	
	if(headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg3 != 16'h2) begin
		$display("Error: jb 0 failed. Expected r3 to be %h but got %h", 16'h2, headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg3);
		failures = failures + 1;
	end
	
	fetch;
	decode;
	
	//-------------------------------movesp-------------------------------
	// Hex inst: 0099
	// Binary inst: 0000 0000 1001 1001
	// Text Inst: movesp 4
	clearsig;
	ALUSrcA = 2'b11;
	ALUSrcB = 2'b01;
	ALUOp = 2'b10;
	#(2*HALF_PERIOD);

	clearsig;
   SPWrite = 1;
	
	#(2*HALF_PERIOD);
	
	if (headless_machine_inst.regFile_immgen_sp_inst.sp_reg.Output !== 16'h0801) begin
		$display("Error: movesp 4 sp expected %h, received %h", 16'h0801, headless_machine_inst.regFile_immgen_sp_inst.sp_reg.Output);
		failures = failures + 1;
	end
	
	fetch;
	decode;
	
	//-------------------------------Beq-------------------------------
	// Hex inst: 05d0
	// Binary inst: 0000010111010000 
	// Text Inst: beq r2 r3 finish
	// We will not branch
	ALUOp = 2'b10;
	ALUSrcA = 2'b10;
	ALUSrcB = 2'b00;
	Branch = 2'b01;
	#(2*HALF_PERIOD);
	if(headless_machine_inst.inte_stage1_part1_inst.PC.Output != 16'h0012) begin
		$display("beq r2 r3 finish failed. Expected PC to be %h but got %h", 16'h0012, headless_machine_inst.inte_stage1_part1_inst.PC.Output);
		failures = failures + 1;
	end
	
	fetch;
	decode;
	
	//-------------------------------Addi-------------------------------
	// Hex inst: 00ab
	// Binary inst: 0000000010101011
	// Text Inst: addi r1 1
	
	clearsig;
	ALUSrcA = 2'b10;
	ALUSrcB = 2'b01;
	ALUOp = 2'b10;
	#(2*HALF_PERIOD);
	
	
	clearsig;
	RegWrite = 1'b1;
	RegFileSrc = 2'b10;
	ReturnSrc = 2'b00;
	#(2*HALF_PERIOD);


	if (headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg1 !== 16'h3) begin
		$display("addi r1 1 failed. r1 was expected to be %b, receieved %b", 16'h3, headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg1);
		failures = failures + 1;
	end


	fetch;
	decode;
	
	
	//-------------------------------Beq-------------------------------
	// Hex inst: f0b0
	// Binary inst: 1111000010110000 
	// Text Inst: beq r1 r1 SU
	// We will branch
	ALUOp = 2'b10;
	ALUSrcA = 2'b10;
	ALUSrcB = 2'b00;
	Branch = 2'b01;
	#(2*HALF_PERIOD);
	if(headless_machine_inst.inte_stage1_part1_inst.PC.Output != 16'h0006) begin
		$display("beq r1 r1 SU failed. Expected PC to be %h but got %h", 16'h0006, headless_machine_inst.inte_stage1_part1_inst.PC.Output);
		failures = failures + 1;
	end
	
	fetch;
	decode;
	
	//-------------------------------movesp-------------------------------
	// Hex inst: ff99
	// Binary inst: 1111111110011001
	// Text Inst: movesp -4
	// Assuming SP starts at 0x07FF
	clearsig;
	ALUSrcA = 2'b11;
	ALUSrcB = 2'b01;
	ALUOp = 2'b10;
	#(2*HALF_PERIOD);

	clearsig;
   SPWrite = 1;
	
	#(2*HALF_PERIOD);
	
	if (headless_machine_inst.regFile_immgen_sp_inst.sp_reg.Output !== 16'h07fd) begin
		$display("Error: movesp - sp expected %h, received %h", 16'h07fd, headless_machine_inst.regFile_immgen_sp_inst.sp_reg.Output);
		failures = failures + 1;
	end
	
	fetch;
	decode;
	
	
	//-------------------------------Storesp-------------------------------
	// Hex inst: 0017
	// Binary inst: 0000000000010111
	// Text Inst: storesp r0 0x0
	clearsig;
	ALUSrcA = 2'b11;
	ALUSrcB = 2'b01;
	ALUOp = 2'b10;
	#(2*HALF_PERIOD);
	
	
	clearsig;
	MemWrite = 1;
	IorD = 2'b10;
	DataSrc = 2'b01;
	#(2*HALF_PERIOD);
		
	// Check memory 0x7FC = 8

	fetch;
	decode;
	
	//-------------------------------Storesp-------------------------------
	// Hex inst: 0137
	// Binary inst: 0000000100110111
	// Text Inst: storesp r1 0x2
	clearsig;
	ALUSrcA = 2'b11;
	ALUSrcB = 2'b01;
	ALUOp = 2'b10;
	#(2*HALF_PERIOD);
	
	
	clearsig;
	MemWrite = 1;
	IorD = 2'b10;
	DataSrc = 2'b01;
	#(2*HALF_PERIOD);
		
	// Check memory 0x7FF = 3

	fetch;
	decode;
	
	
	//-------------------------------jal-------------------------------
	// Hex inst: 00d4
	// Binary inst: 0000000011010100
	// Text Inst: jal GCD (0x1a)
	clearsig;
	ALUSrcA = 2'b11;
	ALUSrcB = 2'b11;
	ALUOp = 2'b10;
	#(2*HALF_PERIOD);
	if (headless_machine_inst.magenta_stage_ALUControl_ALU_ALUOut_RegA_RegB_inst.ALUOutComp.Output !== 16'h07fb) begin
		$display("Error: jal 0x1a - sp expected %h, received %h", 16'h07fb, headless_machine_inst.magenta_stage_ALUControl_ALU_ALUOut_RegA_RegB_inst.ALU.ALUOut);
		failures = failures + 1;
	end

	
	clearsig;
	MemWrite= 1;
	DataSrc = 2'b00;
	IorD = 2'b10;
	
	ALUSrcA = 2'b01;
	ALUSrcB = 2'b11; 
	ALUOp = 2'b10;
	
	OperandSrc = 2'b11;
	tempALU = headless_machine_inst.magenta_stage_ALUControl_ALU_ALUOut_RegA_RegB_inst.ALUOutComp.Output; //confirm that aluout is decremented by 2
	
	#(2*HALF_PERIOD);
	if (headless_machine_inst.magenta_stage_ALUControl_ALU_ALUOut_RegA_RegB_inst.ALUOutComp.Output !== 16'h07f9) begin
		$display("Error: jal 0x1a - sp expected %h, received %h", 16'h07f9, headless_machine_inst.magenta_stage_ALUControl_ALU_ALUOut_RegA_RegB_inst.ALU.ALUOut);
		failures = failures + 1;
	end
	
	if(16'h1 !== headless_machine_inst.regFile_immgen_sp_inst.reg_file.OutputA) begin
		$display("Error: Reg A expected %h, received %h", 16'h1, headless_machine_inst.regFile_immgen_sp_inst.reg_file.OutputA);
		failures = failures + 1;
	end
	
	
	clearsig;
	MemWrite = 1;
	DataSrc = 2'b01;
	IorD = 2'b10;
	
	ALUSrcA = 2'b01;
	ALUSrcB = 2'b11; 
	ALUOp = 2'b10;
	
	OperandSrc = 2'b10;

	#(2*HALF_PERIOD);
	if (headless_machine_inst.magenta_stage_ALUControl_ALU_ALUOut_RegA_RegB_inst.ALUOutComp.Output !== 16'h07f7) begin
		$display("Error: jal 0x1a - sp expected %h, received %h", 16'h07f7, headless_machine_inst.magenta_stage_ALUControl_ALU_ALUOut_RegA_RegB_inst.ALU.ALUOut);
		failures = failures + 1;
	end
	
	if(16'h3 !== headless_machine_inst.regFile_immgen_sp_inst.reg_file.OutputA) begin
		$display("Error: Reg A expected %h, received %h", 16'h3, headless_machine_inst.regFile_immgen_sp_inst.reg_file.OutputA);
		failures = failures + 1;
	end

	
	clearsig;
	MemWrite = 1;
	DataSrc = 2'b01;
	IorD = 2'b10;
	
	ALUSrcA = 2'b01;
	ALUSrcB = 2'b11; 
	ALUOp = 2'b10;
	
	OperandSrc = 2'b01;

	#(2*HALF_PERIOD);
	cycle_counter = cycle_counter + 1;
	if (headless_machine_inst.magenta_stage_ALUControl_ALU_ALUOut_RegA_RegB_inst.ALUOutComp.Output !== 16'h07f5) begin
		$display("Error: jal 0x1a - sp expected %h, received %h", 16'h07f5, headless_machine_inst.magenta_stage_ALUControl_ALU_ALUOut_RegA_RegB_inst.ALU.ALUOut);
		failures = failures + 1;
	end
	
	if(16'h8 !== headless_machine_inst.regFile_immgen_sp_inst.reg_file.OutputA) begin
		$display("Error: Reg A expected %h, received %h", 16'h8, headless_machine_inst.regFile_immgen_sp_inst.reg_file.OutputA);
		failures = failures + 1;
	end

	
	clearsig;
	MemWrite = 1;
	DataSrc = 2'b01;
	IorD = 2'b10;	
	
	SPWrite = 1;
	
	ALUSrcA = 2'b00;
	ALUSrcB = 2'b01;
	ALUOp = 2'b00;
	PCWrite = 1;


	#(2*HALF_PERIOD);
	
	if (16'h07f5 !== headless_machine_inst.regFile_immgen_sp_inst.sp_reg.Output) begin
		$display("Error: jal last cycle - SP expected %h, received %h", tempALU, headless_machine_inst.regFile_immgen_sp_inst.sp_reg.Output);
		failures = failures + 1;
	end
	
	fetch;
	decode;


	//-------------------------------Loadsp-------------------------------
	// Hex inst: 0018
	// Binary inst: 0000000000011000
	// Text Inst: loadsp r0 0
	
	clearsig;
	ALUSrcA = 2'b11;
	ALUSrcB = 2'b01;
	ALUOp = 2'b10;
	MemRead = 1'b0;
	#(2*HALF_PERIOD);


	clearsig;
	IorD = 2'b10;
	MemRead = 1'b1;
	#(2*HALF_PERIOD);

	clearsig;
	RegFileSrc = 2'b00;
	RegWrite = 1'b1;
	ReturnSrc = 3'b000;
	MemRead = 1'b0;
	#(2*HALF_PERIOD);
	 
	if (headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg0 !== 16'h8) begin
		$display("Error: reg0 expected %h, receieved %h", 16'h8, headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg0);
		failures = failures + 1;
	end

	fetch;
	decode;
	
	//-------------------------------Loadsp-------------------------------
	// Hex inst: 0138
	// Binary inst: 0000000100111000
	// Text Inst: loadsp r1 2
	
	clearsig;
	ALUSrcA = 2'b11;
	ALUSrcB = 2'b01;
	ALUOp = 2'b10;
	MemRead = 1'b0;
	#(2*HALF_PERIOD);


	clearsig;
	IorD = 2'b10;
	MemRead = 1'b1;
	#(2*HALF_PERIOD);

	clearsig;
	RegFileSrc = 2'b00;
	RegWrite = 1'b1;
	ReturnSrc = 3'b000;
	MemRead = 1'b0;
	#(2*HALF_PERIOD);
	 
	if (headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg1 !== 16'h3) begin
		$display("Error: reg1 expected %h, receieved %h", 16'h3, headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg1);
		failures = failures + 1;
	end

	fetch;
	decode;
	
	//-------------------------------Set-------------------------------
	// Hex inst: 0046
	// Binary inst: 0000000001000110 
	// Text Inst: set r2 0
	clearsig;
	RegFileSrc = 2'b11;
	RegWrite = 1;
	#(2*HALF_PERIOD);
	if(headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg2 != 16'h0) begin
		$display("set r2 0 failed. Expected r2 %h but got %h", 16'h0, headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg2);
		failures = failures + 1;
	end
	
	fetch;
	decode;
	
	//-------------------------------Bne-------------------------------
	// Hex inst: 0511
	// Binary inst: 0000010100010001 
	// Text Inst: bne r0 r2 continue
	// We will branch
	ALUOp = 2'b10;
	ALUSrcA = 2'b10;
	ALUSrcB = 2'b00;
	Branch = 2'b01;
	#(2*HALF_PERIOD);
	if(headless_machine_inst.inte_stage1_part1_inst.PC.Output != 16'h26) begin
		$display("bne r0 r2 continue failed. Expected PC to be %h but got %h", 16'h26, headless_machine_inst.inte_stage1_part1_inst.PC.Output);
		failures = failures + 1;
	end
	
	fetch;
	decode;
	
	
	//-------------------------------Beq-------------------------------
	// Hex inst: 0b30
	// Binary inst: 0000101100110000 
	// Text Inst: beq r1 r2 done
	// We will not branch
	ALUOp = 2'b10;
	ALUSrcA = 2'b10;
	ALUSrcB = 2'b00;
	Branch = 2'b01;
	#(2*HALF_PERIOD);
	if(headless_machine_inst.inte_stage1_part1_inst.PC.Output != 16'h28) begin
		$display("beq r1 r2 done failed. Expected PC to be %h but got %h", 16'h28, headless_machine_inst.inte_stage1_part1_inst.PC.Output);
		failures = failures + 1;
	end
	
	fetch;
	decode;
	
	//-------------------------------Blt-------------------------------
	// Hex inst: 0432
	// Binary inst: 0000010000110010 
	// Text Inst: blt r1 r0 changeA (0x2E)
	// We will branch
	ALUOp = 2'b10;
	ALUSrcA = 2'b10;
	ALUSrcB = 2'b00;
	Branch = 2'b01;
	#(2*HALF_PERIOD);
	if(headless_machine_inst.inte_stage1_part1_inst.PC.Output != 16'h2E) begin
		$display("blt r1 r0 changeA failed. Expected PC to be %h but got %h", 16'h2E, headless_machine_inst.inte_stage1_part1_inst.PC.Output);
		failures = failures + 1;
	end
	
	fetch;
	decode;	
	
	
	//-------------------------------Alter-------------------------------
	// Hex inst: 089e
	// Binary inst: 0000100010011110 
	// Text Inst: alter r0 r0 r1 -
	ALUSrcA= 2'b10;
	ALUSrcB= 2'b00;
	ALUOp= 2'b11;
	#(2*HALF_PERIOD);
	
	clearsig;
	RegWrite = 1;
	ReturnSrc = 2'b01;
	RegFileSrc = 2'b10;
	#(2*HALF_PERIOD);
	if(headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg0 != 16'h5) begin
		$display("alter r0 r0 r1 - failed. Expected r0 %h but got %h", 16'h5, headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg0);
		failures = failures + 1;
	end
	
	fetch;
	decode;
	
	//-------------------------------Beq-------------------------------
	// Hex inst: f410
	// Binary inst: 1111010000010000 
	// Text Inst: beq r0 r0 continue
	// We will  branch
	ALUOp = 2'b10;
	ALUSrcA = 2'b10;
	ALUSrcB = 2'b00;
	Branch = 2'b01;
	#(2*HALF_PERIOD);
	if(headless_machine_inst.inte_stage1_part1_inst.PC.Output != 16'h26) begin
		$display("beq r0 r0 continue failed. Expected PC to be %h but got %h", 16'h26, headless_machine_inst.inte_stage1_part1_inst.PC.Output);
		failures = failures + 1;
	end
	
	fetch;
	decode;
	
	
	//-------------------------------Beq-------------------------------
	// Hex inst: 0b30
	// Binary inst: 0000101100110000 
	// Text Inst: beq r1 r2 done
	// We will not branch
	ALUOp = 2'b10;
	ALUSrcA = 2'b10;
	ALUSrcB = 2'b00;
	Branch = 2'b01;
	#(2*HALF_PERIOD);
	if(headless_machine_inst.inte_stage1_part1_inst.PC.Output != 16'h28) begin
		$display("beq r1 r2 done failed. Expected PC to be %h but got %h", 16'h28, headless_machine_inst.inte_stage1_part1_inst.PC.Output);
		failures = failures + 1;
	end
	
	fetch;
	decode;
	
	//-------------------------------Blt-------------------------------
	// Hex inst: 0432
	// Binary inst: 0000010000110010 
	// Text Inst: blt r1 r0 changeA (0x2E)
	// We will branch
	ALUOp = 2'b10;
	ALUSrcA = 2'b10;
	ALUSrcB = 2'b00;
	Branch = 2'b01;
	#(2*HALF_PERIOD);
	if(headless_machine_inst.inte_stage1_part1_inst.PC.Output != 16'h2E) begin
		$display("blt r1 r0 changeA failed. Expected PC to be %h but got %h", 16'h2E, headless_machine_inst.inte_stage1_part1_inst.PC.Output);
		failures = failures + 1;
	end
	
	fetch;
	decode;
	
	
	//-------------------------------Alter-------------------------------
	// Hex inst: 089e
	// Binary inst: 0000100010011110 
	// Text Inst: alter r0 r0 r1 -
	ALUSrcA= 2'b10;
	ALUSrcB= 2'b00;
	ALUOp= 2'b11;
	#(2*HALF_PERIOD);
	
	clearsig;
	RegWrite = 1;
	ReturnSrc = 2'b01;
	RegFileSrc = 2'b10;
	#(2*HALF_PERIOD);
	if(headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg0 != 16'h2) begin
		$display("alter r0 r0 r1 - failed. Expected r0 %h but got %h", 16'h2, headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg0);
		failures = failures + 1;
	end
	
	fetch;
	decode;
	
	//-------------------------------Beq-------------------------------
	// Hex inst: f410
	// Binary inst: 1111010000010000 
	// Text Inst: beq r0 r0 continue
	// We will  branch
	ALUOp = 2'b10;
	ALUSrcA = 2'b10;
	ALUSrcB = 2'b00;
	Branch = 2'b01;
	#(2*HALF_PERIOD);
	if(headless_machine_inst.inte_stage1_part1_inst.PC.Output != 16'h26) begin
		$display("beq r0 r0 continue failed. Expected PC to be %h but got %h", 16'h26, headless_machine_inst.inte_stage1_part1_inst.PC.Output);
		failures = failures + 1;
	end
	
	fetch;
	decode;
	
	//-------------------------------Beq-------------------------------
	// Hex inst: 0b30
	// Binary inst: 0000101100110000 
	// Text Inst: beq r1 r2 done
	// We will not branch
	ALUOp = 2'b10;
	ALUSrcA = 2'b10;
	ALUSrcB = 2'b00;
	Branch = 2'b01;
	#(2*HALF_PERIOD);
	if(headless_machine_inst.inte_stage1_part1_inst.PC.Output != 16'h28) begin
		$display("beq r1 r2 done failed. Expected PC to be %h but got %h", 16'h28, headless_machine_inst.inte_stage1_part1_inst.PC.Output);
		failures = failures + 1;
	end
	
	fetch;
	decode;
	
	//-------------------------------Blt-------------------------------
	// Hex inst: 0432
	// Binary inst: 0000010000110010 
	// Text Inst: blt r1 r0 changeA (0x2E)
	// We will not branch (orange)
	ALUOp = 2'b10;
	ALUSrcA = 2'b10;
	ALUSrcB = 2'b00;
	Branch = 2'b01;
	#(2*HALF_PERIOD);
	if(headless_machine_inst.inte_stage1_part1_inst.PC.Output != 16'h2a) begin
		$display("blt r1 r0 changeA failed. Expected PC to be %h but got %h", 16'h2a, headless_machine_inst.inte_stage1_part1_inst.PC.Output);
		failures = failures + 1;
	end
	
	fetch;
	decode;
	
	
	//-------------------------------Alter-------------------------------
	// Hex inst: 0a3e
	// Binary inst: 0000101000111110 
	// Text Inst: alter r1 r1 r0 -
	ALUSrcA= 2'b10;
	ALUSrcB= 2'b00;
	ALUOp= 2'b11;
	#(2*HALF_PERIOD);
	
	clearsig;
	RegWrite = 1;
	ReturnSrc = 2'b01;
	RegFileSrc = 2'b10;
	#(2*HALF_PERIOD);
	if(headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg1 != 16'h1) begin
		$display("alter r0 r0 r1 - failed. Expected r0 %h but got %h", 16'h1, headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg0);
		failures = failures + 1;
	end
	
	fetch;
	decode;
	
	//-------------------------------Beq-------------------------------
	// Hex inst: f8b0
	// Binary inst: 1111100010110000 
	// Text Inst: beq r1 r1 continue
	// We will branch
	ALUOp = 2'b10;
	ALUSrcA = 2'b10;
	ALUSrcB = 2'b00;
	Branch = 2'b01;
	#(2*HALF_PERIOD);
	if(headless_machine_inst.inte_stage1_part1_inst.PC.Output != 16'h26) begin
		$display("beq r1 r1 continue failed. Expected PC to be %h but got %h", 16'h26, headless_machine_inst.inte_stage1_part1_inst.PC.Output);
		failures = failures + 1;
	end
	
	fetch;
	decode;
	
	//-------------------------------Beq-------------------------------
	// Hex inst: 0b30
	// Binary inst: 0000101100110000 
	// Text Inst: beq r1 r2 done
	// We will not branch
	ALUOp = 2'b10;
	ALUSrcA = 2'b10;
	ALUSrcB = 2'b00;
	Branch = 2'b01;
	#(2*HALF_PERIOD);
	if(headless_machine_inst.inte_stage1_part1_inst.PC.Output != 16'h28) begin
		$display("beq r1 r2 done failed. Expected PC to be %h but got %h", 16'h28, headless_machine_inst.inte_stage1_part1_inst.PC.Output);
		failures = failures + 1;
	end
	
	fetch;
	decode;
	
	//-------------------------------Blt-------------------------------
	// Hex inst: 0432
	// Binary inst: 0000010000110010 
	// Text Inst: blt r1 r0 changeA (0x2E)
	// We will branch
	ALUOp = 2'b10;
	ALUSrcA = 2'b10;
	ALUSrcB = 2'b00;
	Branch = 2'b01;
	#(2*HALF_PERIOD);
	if(headless_machine_inst.inte_stage1_part1_inst.PC.Output != 16'h2E) begin
		$display("blt r1 r0 changeA failed. Expected PC to be %h but got %h", 16'h2E, headless_machine_inst.inte_stage1_part1_inst.PC.Output);
		failures = failures + 1;
	end
	
	fetch;
	decode;
	
	
	//-------------------------------Alter-------------------------------
	// Hex inst: 089e
	// Binary inst: 0000100010011110 
	// Text Inst: alter r0 r0 r1 -
	ALUSrcA= 2'b10;
	ALUSrcB= 2'b00;
	ALUOp= 2'b11;
	#(2*HALF_PERIOD);
	
	clearsig;
	RegWrite = 1;
	ReturnSrc = 2'b01;
	RegFileSrc = 2'b10;
	#(2*HALF_PERIOD);
	if(headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg0 != 16'h1) begin
		$display("alter r0 r0 r1 - failed. Expected r0 %h but got %h", 16'h1, headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg0);
		failures = failures + 1;
	end
	
	fetch;
	decode;
	
	//-------------------------------Beq-------------------------------
	// Hex inst: f410
	// Binary inst: 1111010000010000 
	// Text Inst: beq r0 r0 continue
	// We will  branch
	ALUOp = 2'b10;
	ALUSrcA = 2'b10;
	ALUSrcB = 2'b00;
	Branch = 2'b01;
	#(2*HALF_PERIOD);
	if(headless_machine_inst.inte_stage1_part1_inst.PC.Output != 16'h26) begin
		$display("beq r0 r0 continue failed. Expected PC to be %h but got %h", 16'h26, headless_machine_inst.inte_stage1_part1_inst.PC.Output);
		failures = failures + 1;
	end
	
	fetch;
	decode;
	
	//-------------------------------Beq-------------------------------
	// Hex inst: 0b30
	// Binary inst: 0000101100110000 
	// Text Inst: beq r1 r2 done
	// We will not branch
	ALUOp = 2'b10;
	ALUSrcA = 2'b10;
	ALUSrcB = 2'b00;
	Branch = 2'b01;
	#(2*HALF_PERIOD);
	if(headless_machine_inst.inte_stage1_part1_inst.PC.Output != 16'h28) begin
		$display("beq r1 r2 done failed. Expected PC to be %h but got %h", 16'h28, headless_machine_inst.inte_stage1_part1_inst.PC.Output);
		failures = failures + 1;
	end
	
	fetch;
	decode;
	
	//-------------------------------Blt-------------------------------
	// Hex inst: 0432
	// Binary inst: 0000010000110010 
	// Text Inst: blt r1 r0 changeA (0x2E)
	// We will not branch (orange)
	ALUOp = 2'b10;
	ALUSrcA = 2'b10;
	ALUSrcB = 2'b00;
	Branch = 2'b01;
	#(2*HALF_PERIOD);
	if(headless_machine_inst.inte_stage1_part1_inst.PC.Output != 16'h2a) begin
		$display("blt r1 r0 changeA failed. Expected PC to be %h but got %h", 16'h2a, headless_machine_inst.inte_stage1_part1_inst.PC.Output);
		failures = failures + 1;
	end
	
	fetch;
	decode;
	
	
	//-------------------------------Alter-------------------------------
	// Hex inst: 0a3e
	// Binary inst: 0000101000111110 
	// Text Inst: alter r1 r1 r0 -
	ALUSrcA= 2'b10;
	ALUSrcB= 2'b00;
	ALUOp= 2'b11;
	#(2*HALF_PERIOD);
	
	clearsig;
	RegWrite = 1;
	ReturnSrc = 2'b01;
	RegFileSrc = 2'b10;
	#(2*HALF_PERIOD);
	if(headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg1 != 16'h0) begin
		$display("alter r0 r0 r1 - failed. Expected r0 %h but got %h", 16'h0, headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg0);
		failures = failures + 1;
	end
	
	fetch;
	decode;
	
	//-------------------------------Beq-------------------------------
	// Hex inst: f8b0
	// Binary inst: 1111100010110000 
	// Text Inst: beq r1 r1 continue
	// We will branch
	ALUOp = 2'b10;
	ALUSrcA = 2'b10;
	ALUSrcB = 2'b00;
	Branch = 2'b01;
	#(2*HALF_PERIOD);
	if(headless_machine_inst.inte_stage1_part1_inst.PC.Output != 16'h26) begin
		$display("beq r1 r1 continue failed. Expected PC to be %h but got %h", 16'h26, headless_machine_inst.inte_stage1_part1_inst.PC.Output);
		failures = failures + 1;
	end
	
	fetch;
	decode;
	
	//-------------------------------Beq-------------------------------
	// Hex inst: 0b30
	// Binary inst: 0000101100110000 
	// Text Inst: beq r1 r2 done
	// We will branch
	ALUOp = 2'b10;
	ALUSrcA = 2'b10;
	ALUSrcB = 2'b00;
	Branch = 2'b01;
	#(2*HALF_PERIOD);
	if(headless_machine_inst.inte_stage1_part1_inst.PC.Output != 16'h32) begin
		$display("beq r1 r2 done failed. Expected PC to be %h but got %h", 16'h32, headless_machine_inst.inte_stage1_part1_inst.PC.Output);
		failures = failures + 1;
	end
	
	fetch;
	decode;
	
	
	//-------------------------------Swap-------------------------------
	// Hex inst: 019d
	// Binary inst: 0000 0001 1001 1101 
	// Text Inst: swap r0 r3
	ALUSrcA = 2'b10;
	ALUOp = 2'b10;
	RegFileSrc = 2'b01;
	RegWrite = 1;
	ReturnSrc = 2'b00;
	#(2*HALF_PERIOD);
	
	clearsig;
	ReturnSrc = 2'b10;
	RegWrite = 1;
	RegFileSrc = 2'b10;
	#(2*HALF_PERIOD);
	
	if(headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg0 != 16'h2) begin
		$display("swap r0 r3 failed. Expected r0 %h but got %h", 16'h2, headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg0);
		failures = failures + 1;
	end
	
	if(headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg3 != 16'h1) begin
		$display("swap r0 r3 failed. Expected r3 %h but got %h", 16'h1, headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg0);
		failures = failures + 1;
	end
	
	fetch;
	decode;
	
	
	//-------------------------------Jb-------------------------------
	// Hex inst: 001c
	// Binary inst: 0000 0000 0001 1100 
	// Text Inst: jb 0
	MemRead = 1;
	IorD = 2'b11;
	ALUSrcA = 2'b11;
	ALUSrcB = 2'b11;
	ALUOp = 2'b10;
	#(2*HALF_PERIOD);
	
	if (headless_machine_inst.magenta_stage_ALUControl_ALU_ALUOut_RegA_RegB_inst.ALUOutComp.Output !== 16'h07f7) begin
		$display("Error: jb 0 ALUOut expected %h, received %h", 16'h07f7, headless_machine_inst.magenta_stage_ALUControl_ALU_ALUOut_RegA_RegB_inst.ALU.ALUOut);
		failures = failures + 1;
	end
	
	clearsig;
	RegFileSrc = 2'b00;
	ReturnSrc = 3'b101;
	RegWrite = 1;
	IorD = 2'b10;
	ALUSrcA = 2'b01;
	ALUSrcB = 2'b11;
	ALUOp = 2'b10;
	#(2*HALF_PERIOD);
	if (headless_machine_inst.magenta_stage_ALUControl_ALU_ALUOut_RegA_RegB_inst.ALUOutComp.Output !== 16'h07f9) begin
		$display("Error: jb 0 ALUOut expected %h, received %h", 16'h07f9, headless_machine_inst.magenta_stage_ALUControl_ALU_ALUOut_RegA_RegB_inst.ALU.ALUOut);
		failures = failures + 1;
	end
	
	clearsig;
	RegFileSrc = 2'b00;
	ReturnSrc = 3'b100;
	RegWrite = 1;
	IorD = 2'b10;
	ALUSrcA = 2'b01;
	ALUSrcB = 2'b11;
	ALUOp = 2'b10;
	#(2*HALF_PERIOD);
	if (headless_machine_inst.magenta_stage_ALUControl_ALU_ALUOut_RegA_RegB_inst.ALUOutComp.Output !== 16'h07fb) begin
		$display("Error: jb 0 ALUOut expected %h, received %h", 16'h07fb, headless_machine_inst.magenta_stage_ALUControl_ALU_ALUOut_RegA_RegB_inst.ALU.ALUOut);
		failures = failures + 1;
	end
	
	clearsig;
	RegFileSrc = 2'b00;
	ReturnSrc = 3'b011;
	RegWrite = 1;
	IorD = 2'b10;
	ALUSrcA = 2'b01;
	ALUSrcB = 2'b11;
	ALUOp = 2'b10;
	#(2*HALF_PERIOD);
	if (headless_machine_inst.magenta_stage_ALUControl_ALU_ALUOut_RegA_RegB_inst.ALUOutComp.Output !== 16'h07fd) begin
		$display("Error: jb 0 ALUOut expected %h, received %h", 16'h07fd, headless_machine_inst.magenta_stage_ALUControl_ALU_ALUOut_RegA_RegB_inst.ALU.ALUOut);
		failures = failures + 1;
	end
	
	clearsig;
	Branch = 2'b10;
	Jump = 1;
	SPWrite = 1;
	#(2*HALF_PERIOD);
	if (headless_machine_inst.inte_stage1_part1_inst.PC.Output !== 16'h000e) begin
		$display("Error: jb 0 PC expected %h, received %h", 16'h000e, headless_machine_inst.inte_stage1_part1_inst.PC.Output);
		failures = failures + 1;
	end
	
	if (16'h07fd !== headless_machine_inst.regFile_immgen_sp_inst.sp_reg.Output) begin
		$display("Error: jb 0 SP expected %h, received %h", 16'h07fd, headless_machine_inst.regFile_immgen_sp_inst.sp_reg.Output);
		failures = failures + 1;
	end
	
	if(headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg0 != 16'h8) begin
		$display("Error: jb 0 failed. Expected r0 to be %h but got %h", 16'h8, headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg0);
		failures = failures + 1;
	end
	
	if(headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg1 != 16'h3) begin
		$display("Error: jb 0 failed. Expected r1 to be %h but got %h", 16'h3, headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg1);
		failures = failures + 1;
	end
	
	if(headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg2 != 16'h1) begin
		$display("Error: jb 0 failed. Expected r2 to be %h but got %h", 16'h1, headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg2);
		failures = failures + 1;
	end
	
	if(headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg3 != 16'h1) begin
		$display("Error: jb 0 failed. Expected r3 to be %h but got %h", 16'h1, headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg3);
		failures = failures + 1;
	end
	
	fetch;
	decode;
	
	//-------------------------------movesp-------------------------------
	// Hex inst: 0099
	// Binary inst: 0000 0000 1001 1001
	// Text Inst: movesp 4
	clearsig;
	ALUSrcA = 2'b11;
	ALUSrcB = 2'b01;
	ALUOp = 2'b10;
	#(2*HALF_PERIOD);

	clearsig;
   SPWrite = 1;
	
	#(2*HALF_PERIOD);
	
	if (headless_machine_inst.regFile_immgen_sp_inst.sp_reg.Output !== 16'h0801) begin
		$display("Error: movesp 4 sp expected %h, received %h", 16'h0801, headless_machine_inst.regFile_immgen_sp_inst.sp_reg.Output);
		failures = failures + 1;
	end
	
	fetch;
	decode;
	
	//-------------------------------Beq-------------------------------
	// Hex inst: 05d0
	// Binary inst: 0000010111010000 
	// Text Inst: beq r2 r3 finish
	// We will branch
	ALUOp = 2'b10;
	ALUSrcA = 2'b10;
	ALUSrcB = 2'b00;
	Branch = 2'b01;
	#(2*HALF_PERIOD);
	if(headless_machine_inst.inte_stage1_part1_inst.PC.Output != 16'h0016) begin
		$display("beq r2 r3 finish failed. Expected PC to be %h but got %h", 16'h0016, headless_machine_inst.inte_stage1_part1_inst.PC.Output);
		failures = failures + 1;
	end
	
	fetch;
	decode;
	
	
	//-------------------------------Swap-------------------------------
	// Hex inst: 01bd
	// Binary inst: 0000 0001 1011 1101 
	// Text Inst: swap r1 r3
	ALUSrcA = 2'b10;
	ALUOp = 2'b10;
	RegFileSrc = 2'b01;
	RegWrite = 1;
	ReturnSrc = 2'b00;
	#(2*HALF_PERIOD);
	
	clearsig;
	ReturnSrc = 2'b10;
	RegWrite = 1;
	RegFileSrc = 2'b10;
	#(2*HALF_PERIOD);
	
	if(headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg1 != 16'h1) begin
		$display("swap r0 r3 failed. Expected r0 %h but got %h", 16'h1, headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg0);
		failures = failures + 1;
	end
	
	if(headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg3 != 16'h3) begin
		$display("swap r0 r3 failed. Expected r3 %h but got %h", 16'h3, headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg0);
		failures = failures + 1;
	end
	
	fetch;
	decode;
	
	

	//-------------------------------Xori-------------------------------
	// Hex inst: 0049
	// Binary inst: 0000000001001001
	// Text Inst: xori r2 0


	clearsig;
	ALUSrcA = 2'b10;
	ALUSrcB = 2'b01;
	ALUOp = 2'b10;
	#(2*HALF_PERIOD);
	
	
	clearsig;
	RegWrite = 1'b1;
	RegFileSrc = 2'b10;
	ReturnSrc = 2'b00;
	#(2*HALF_PERIOD);
	

	if (headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg2 !== 16'h1) begin
		$display("xori r2 0 failed: reg2 expected %d, receieved %d", 1, headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg0);
		failures = failures + 1;
	end

	fetch;
	decode;



	//-------------------------------Srli-------------------------------
	// Hex inst: 00cd
	// Binary inst: 0000000011001101
	// Text Inst: srli r2 1

//
//	clearsig;
//	ALUSrcA = 2'b10;
//	ALUSrcB = 2'b01;
//	ALUOp = 2'b10;
//	MemRead = 1'b0;
//	#(2*HALF_PERIOD);
//	
//	
//	clearsig;
//	RegWrite = 1'b1;
//	RegFileSrc = 2'b10;
//	ReturnSrc = 00;
//	#(2*HALF_PERIOD);
//
//
//	if (headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg2 !== 16'b0) begin
//		$display("srli r2 1 failed: reg2 expected %d, receieved %d", 16'b0, headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg2);
//		failures = failures + 1;
//	end
//	
//
//	fetch;
//	decode;


	//-------------------------------SRAI-------------------------------
	// Hex inst: 
	// Binary inst: 
	// Text Inst: srai r1 0x4

// clearsig;
//	ALUSrcA = 2'b10;
//	ALUSrcB = 2'b01;
//	ALUOp = 2'b10;
//	MemRead = 1'b0;
//	#(2*HALF_PERIOD);
//	
//	
//	clearsig;
//	RegWrite = 1'b1;
//	RegFileSrc = 2'b10;
//	ReturnSrc = 00;
//	#(2*HALF_PERIOD);

//	if (headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg1 !== 16'b0) begin
//		$display("Error: reg1 expected %h, receieved %h", 0, headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg1);
//		failures = failures + 1;
//	end

//	fetch;
//
//	decode;





	//DOES NOT WORK RIGHT
	//-------------------------------Add-------------------------------
	// Hex inst: 0016, 0080
	// Binary inst: 0000000000010110 , 0000001000000000
	// Text Inst: Store R0 0x00, Add R0 0x00
	// Current Issue: Store works, when trying to pull value at Mem[0] it grabs the decimal value of 
	// the second inst & adds to it. 

	//fetch;
	//decode;

	//Cycle 3
	//ALUSrcA = 2'b10;
	//ALUSrcB = 2'b10;
	//ALUOp = 2'b10;
	//MemRead = 1'b0;
	//DataSrc = 2'b01;
	//#(2*HALF_PERIOD);

	//Cycle 4
	//RegWrite = 1'b1;
	//RegFileSrc = 2'b10;
	//ReturnSrc = 2'b00;
	//DataSrc = 2'b01;
	//#(2*HALF_PERIOD);

//	if(headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg0 != 16’b100000)begin
//		$display("Add did not add correctly");
//	end

	//DOES NOT WORK RIGHT
	//-------------------------------Sub-------------------------------
	// Hex inst: 0016, 0081
	// Binary inst: 0000000000010110 , 0000001000000001
	// Text Inst: Store R0 0x00, Sub R0 0x00
	// Current Issue: Store works, when trying to pull value at Mem[0] it grabs the decimal value of 
	// the second inst & adds to it. 

//	fetch;
//	decode;

	//Cycle 3
	//ALUSrcA = 2'b10;
	//ALUSrcB = 2'b10;
	//ALUOp = 2'b10;
	//MemRead = 1'b0;
	//DataSrc = 2'b01;
	//#(2*HALF_PERIOD);

	//Cycle 4
	//RegWrite = 1'b1;
	//RegFileSrc = 2'b10;
	//ReturnSrc = 2'b00;
	//DataSrc = 2'b01;
	//#(2*HALF_PERIOD);

//	if(headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg0 != 16’b11110)begin
//		$display("Sub did not sub correctly");
//	end


	//DOES NOT WORK RIGHT
	//-------------------------------OR-------------------------------
	// Hex inst: 0016, 0103
	// Binary inst: 0000000000010110 , 0000000100000011
	// Text Inst: Store R0 0x00, OR R0 0x00

	//fetch;
	//decode;

	//Cycle 3
	//ALUSrcA = 2'b10;
	//ALUSrcB = 2'b10;
	//ALUOp = 2'b10;
	//MemRead = 1'b0;
	//DataSrc = 2'b01;
	//#(2*HALF_PERIOD);

	//Cycle 4
	//RegWrite = 1'b1;
	//RegFileSrc = 2'b10;
	//ReturnSrc = 2'b00;
	//DataSrc = 2'b01;
	//#(2*HALF_PERIOD);
//	if(headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg0 != 16’b11111)begin
//		$display("OR did not OR correctly");
//	end



	//DOES NOT WORK RIGHT
	//-------------------------------Load-------------------------------
	// Hex inst: 0055
	// Binary inst: 0000000001010101
	// Text inst: Load R2 Mem[0]
	// Current Issue: Mem[0] is being rstored in reg0 instead of reg 2

	//fetch;
	//decode;

	//Cycle 6
	//RegWrite = 1'b1;
	//RegFileSrc = 2'b01;
	//ReturnSrc = 2'b01;
	//DataSrc = 2'b01;
	//OperandSrc = 2'b01;
	//#(2*HALF_PERIOD);
	

	//WORKS
	//-------------------------------Store-------------------------------
	// Hex inst: 0016
	// Binary inst: 0000000000010110
	// Text Inst: Sore R0 Mem[0]

//	fetch;
//	decode;

	//Cycle 5
//	MemWrite = 1'b1;
//	IorD = 2'b01;
//	IRWrite = 1'b0;
//	DataSrc = 2'b01;
//	#(2*HALF_PERIOD);
	

//SET LESS THAN INST
//== Branch
//!= Branch
//< brnach
// >= Branch




//	
//	//-------------------------------Lui-------------------------------
//	// Hex inst: 7ffb
//	// Binary inst: 0111111111111011
//	// Text Inst: LUI 0x3FF
//	clearsig;
//	RegWrite = 1;
//	RegFileSrc = 2'b11;
//	ReturnSrc = 3'b011;
//	#(2*HALF_PERIOD);
//	cycle_counter = cycle_counter + 2;
//	if (headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg2 !== 16'h7fe0) begin
//		$display("Error: reg2 expected %h, received %h", 16'h7fe0, headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg2);
//		failures = failures + 1;
//	end
//
//	
//	fetch;
//	decode;
		



	clearsig;
	#(HALF_PERIOD);
	$display("SP: %d", headless_machine_inst.regFile_immgen_sp_inst.sp_reg); //0x03FF
	$display("Registers: %d, %d, %d, %d",
	headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg0,
	headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg1,
	headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg2,
	headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg3,);
		
	
	
	$display("End of test. Total failure: %d", failures);
	$stop;

end



task clearsig;
	begin
		ALUOp = 0;
		ALUSrcA = 0;
		ALUSrcB = 0;
		MemtoReg = 0;
		RegWrite = 0;
		MemRead = 0;
		MemWrite = 0;
		IorD = 0;
		IRWrite = 0;
		PCWrite = 0;
		Jump = 0;
		Branch = 0;
		shouldBranch = 0;
		RegFileSrc = 0;
		ReturnSrc = 0;
		DataSrc = 0;
		OperandSrc = 0;
		SPWrite = 0;
	end
endtask

task fetch; 
	begin
		clearsig;
		PCWrite = 1'b1;
		IorD = 2'b00;
		MemRead = 1'b1;
		ALUSrcA = 2'b00;
		ALUSrcB = 2'b11;
		Branch = 2'b00;
		ALUOp = 2'b00;
		MemWrite = 1'b0;
		RegWrite = 1'b0;
		SPWrite = 1'b0;
		OperandSrc = 2'b00;
		ReturnSrc = 3'b000;
		#(2*HALF_PERIOD);
	end
endtask

task decode; //should we do a clearsig here?
	begin 
		clearsig;
		IRWrite = 1'b1;
		IorD = 2'b01;
		MemRead = 1'b1;
		ALUSrcA = 2'b00;
		ALUSrcB = 2'b01;
		ALUOp = 2'b00;
		PCWrite = 1'b0;
		#(2*HALF_PERIOD);
		clearsig;
	end
endtask 

// For debugging
initial begin
  $monitor("Time: %t, CLK: %b, Cycle: %d, Failures: %d",
			  $time, CLK, cycle_counter, failures);
end

endmodule