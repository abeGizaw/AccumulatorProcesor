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
//	Memory_txt:
// 001a
//	0034
//	007f
//	0018
//	008b
//	019d
//	001c
//////////////////////////////////////////////////////////////////////////////////

module tb_headless_machine_IO;
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
	decode;
	clearsig;
	
	//-------------------------------movesp-------------------------------
	// Hex inst: ffd9
	// Binary inst: 1111111111011001
	// Text Inst: movesp -2
	clearsig;
	ALUSrcA = 2'b11;
	ALUSrcB = 2'b01;
	ALUOp = 2'b10;
	#(2*HALF_PERIOD);

	clearsig;
   SPWrite = 1;
	
	#(2*HALF_PERIOD);
	
	if (headless_machine_inst.regFile_immgen_sp_inst.sp_reg.Output !== 16'h07ff) begin
		$display("Error: movesp -2 sp expected %h, received %h", 16'h07ff, headless_machine_inst.regFile_immgen_sp_inst.sp_reg.Output);
		failures = failures + 1;
	end
	
	fetch;
	decode;
	clearsig;
	
	
	
	//-------------------------------Input-------------------------------
	// Hex inst: 001a
	// Binary inst: 0000000000011010
	// Text Inst: Input 0
	Inputio = 16'h1;
	ALUSrcA = 2'b11;
	ALUSrcB = 2'b01;
	ALUOp = 2'b10;
	#(2*HALF_PERIOD);
	
	clearsig;
	DataSrc = 2'b10;
	MemWrite = 1;
	IorD = 2'b10;
	#(2*HALF_PERIOD);


	//Check if input 1 is loaded onto SP[0x07FF]
	
	fetch;
	decode;
	clearsig;
	
	//-------------------------------jal-------------------------------
	// Hex inst: 0034
	// Binary inst: 0000000000110100
	// Text Inst: jal TestInput (0x08)
	clearsig;
	ALUSrcA = 2'b11;
	ALUSrcB = 2'b11;
	ALUOp = 2'b10;
	#(2*HALF_PERIOD);
	if (headless_machine_inst.magenta_stage_ALUControl_ALU_ALUOut_RegA_RegB_inst.ALUOutComp.Output !== 16'h07fd) begin
		$display("Error: jal TestInput - sp expected %h, received %h", 16'h07fd, headless_machine_inst.magenta_stage_ALUControl_ALU_ALUOut_RegA_RegB_inst.ALU.ALUOut);
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
	if (headless_machine_inst.magenta_stage_ALUControl_ALU_ALUOut_RegA_RegB_inst.ALUOutComp.Output !== 16'h07fb) begin
		$display("Error: jal TestInput - sp expected %h, received %h", 16'h07fb, headless_machine_inst.magenta_stage_ALUControl_ALU_ALUOut_RegA_RegB_inst.ALU.ALUOut);
		failures = failures + 1;
	end
	
	if(16'h0 !== headless_machine_inst.regFile_immgen_sp_inst.reg_file.OutputA) begin
		$display("Error: jal TestInput - sp expected %h, received %h", 16'h0, headless_machine_inst.regFile_immgen_sp_inst.reg_file.OutputA);
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
	if (headless_machine_inst.magenta_stage_ALUControl_ALU_ALUOut_RegA_RegB_inst.ALUOutComp.Output !== 16'h07f9) begin
		$display("Error: jal TestInput - sp expected %h, received %h", 16'h07f9, headless_machine_inst.magenta_stage_ALUControl_ALU_ALUOut_RegA_RegB_inst.ALU.ALUOut);
		failures = failures + 1;
	end
	
	if(16'h0 !== headless_machine_inst.regFile_immgen_sp_inst.reg_file.OutputA) begin
		$display("Error: jal TestInput - sp expected %h, received %h", 16'h0, headless_machine_inst.regFile_immgen_sp_inst.reg_file.OutputA);
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
	if (headless_machine_inst.magenta_stage_ALUControl_ALU_ALUOut_RegA_RegB_inst.ALUOutComp.Output !== 16'h07f7) begin
		$display("Error: jal TestInput - sp expected %h, received %h", 16'h07f7, headless_machine_inst.magenta_stage_ALUControl_ALU_ALUOut_RegA_RegB_inst.ALU.ALUOut);
		failures = failures + 1;
	end
	
	if(16'h0 !== headless_machine_inst.regFile_immgen_sp_inst.reg_file.OutputA) begin
		$display("Error: jal TestInput - sp expected %h, received %h", 16'h0, headless_machine_inst.regFile_immgen_sp_inst.reg_file.OutputA);
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
	
	if (16'h07f7 !== headless_machine_inst.regFile_immgen_sp_inst.sp_reg.Output) begin
		$display("Error: jal TestInput last cycle - SP expected %h, received %h", 16'h07f7, headless_machine_inst.regFile_immgen_sp_inst.sp_reg.Output);
		failures = failures + 1;
	end
	
	
	fetch;
	decode; 
	clearsig;
	
	//-------------------------------Loadsp-------------------------------
	// Hex inst: 007F
	// Binary inst: 0000000001111111
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
	 
	if (headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg0 !== 16'h1) begin
		$display("Error: reg0 expected %h, receieved %h", 16'h1, headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg0);
		failures = failures + 1;
	end

	fetch;
	decode;
	clearsig;
	
	
	//-------------------------------Addi-------------------------------
	// Hex inst: 0018
	// Binary inst: 0000000000011000
	// Text Inst: addi r0 1
	
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


	if (headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg0 !== 16'h2) begin
		$display("addi r0 1 failed. r0 was expected to be %b, receieved %b", 16'h2, headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg1);
		failures = failures + 1;
	end


	fetch;
	decode;
	clearsig;
	
	//-------------------------------Swap-------------------------------
	// Hex inst: 008b
	// Binary inst: 0000000010001011
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
		$display("swap r0 r3 failed. Expected r3 %h but got %h", 16'h1, headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg3);
		failures = failures + 1;
	end
	
	fetch;
	decode;
	clearsig;
	
	
	//-------------------------------Jb-------------------------------
	// Hex inst: 019d
	// Binary inst: 0000000110011101 
	// Text Inst: jb 0
	MemRead = 1;
	IorD = 2'b11;
	ALUSrcA = 2'b11;
	ALUSrcB = 2'b11;
	ALUOp = 2'b10;
	#(2*HALF_PERIOD);
	
	clearsig;
	RegFileSrc = 2'b00;
	ReturnSrc = 3'b101;
	RegWrite = 1;
	IorD = 2'b10;
	ALUSrcA = 2'b01;
	ALUSrcB = 2'b11;
	ALUOp = 2'b10;
	#(2*HALF_PERIOD);
	
	clearsig;
	RegFileSrc = 2'b00;
	ReturnSrc = 3'b100;
	RegWrite = 1;
	IorD = 2'b10;
	ALUSrcA = 2'b01;
	ALUSrcB = 2'b11;
	ALUOp = 2'b10;
	#(2*HALF_PERIOD);
	
	clearsig;
	RegFileSrc = 2'b00;
	ReturnSrc = 3'b011;
	RegWrite = 1;
	IorD = 2'b10;
	ALUSrcA = 2'b01;
	ALUSrcB = 2'b11;
	ALUOp = 2'b10;
	#(2*HALF_PERIOD);
	
	clearsig;
	Branch = 2'b10;
	Jump = 1;
	SPWrite = 1;
	#(2*HALF_PERIOD);
	if (headless_machine_inst.inte_stage1_part1_inst.PC.Output !== 16'h0006) begin
		$display("Error: jb 0 PC expected %h, received %h", 16'h0006, headless_machine_inst.inte_stage1_part1_inst.PC.Output);
		failures = failures + 1;
	end
	
	if (16'h07ff !== headless_machine_inst.regFile_immgen_sp_inst.sp_reg.Output) begin
		$display("Error: jb 0 SP expected %h, received %h", 16'h07ff, headless_machine_inst.regFile_immgen_sp_inst.sp_reg.Output);
		failures = failures + 1;
	end
	
	if(headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg0 != 16'h0) begin
		$display("Error: jb 0 failed. Expected r0 to be %h but got %h", 16'h0, headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg0);
		failures = failures + 1;
	end
	
	if(headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg1 != 16'h0) begin
		$display("Error: jb 0 failed. Expected r1 to be %h but got %h", 16'h0, headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg1);
		failures = failures + 1;
	end
	
	if(headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg2 != 16'h0) begin
		$display("Error: jb 0 failed. Expected r2 to be %h but got %h", 16'h0, headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg2);
		failures = failures + 1;
	end
	
	if(headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg3 != 16'h2) begin
		$display("Error: jb 0 failed. Expected r3 to be %h but got %h", 16'h2, headless_machine_inst.regFile_immgen_sp_inst.reg_file.Reg3);
		failures = failures + 1;
	end
	
	fetch;
	decode;
	clearsig;
	
	//-------------------------------Output-------------------------------
	// Hex inst: 001c
	// Binary inst: 0000000000011100
	// Text Inst: output 3
	#(2*HALF_PERIOD);
	
	//Check output signal
	
	
	
	
	
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