//////////////////////////////////////////////////////////////////////////////////
// Company: Pink
// Engineer: 
// 
// Create Date:    02/16/2024 
// Module Name:  Final Machine
// Project Name: 
//
// Revision 0.01 - Created file
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module final_machine
(
	//Data input
	input [15:0] Inputio,
	
	//Control Signal input
	input CLK,
	
	//Output
	output [15:0] Outputio,
	output		  Overflow,
	output		  Output
);


wire [1:0]		 	ALUOp;
wire [1:0]        ALUSrcA;
wire [1:0]        ALUSrcB;
wire [1:0]        MemtoReg;
wire              RegWrite;
wire              MemRead;
wire              MemWrite;
wire [1:0]        IorD;
wire              IRWrite;
wire              PCWrite;
wire              Jump;
wire [1:0]        Branch;
wire              shouldBranch;
wire [1:0]        RegFileSrc;
wire [2:0]        ReturnSrc;
wire [1:0]   		DataSrc;
wire [1:0]        OperandSrc;
wire              SPWrite;
wire 					Reset;
wire [4:0]			Opcode;

control_unit control_unit_inst
(
	.ALUOp(ALUOp) ,	// output [1:0] ALUOp
	.ALUSrcA(ALUSrcA) ,	// output [1:0] ALUSrcA
	.ALUSrcB(ALUSrcB) ,	// output [1:0] ALUSrcB
	.MemtoReg(MemtoReg) ,	// output [1:0] MemtoReg
	.RegWrite(RegWrite) ,	// output  RegWrite
	.MemRead(MemRead) ,	// output  MemRead
	.MemWrite(MemWrite) ,	// output  MemWrite
	.IorD(IorD) ,	// output [1:0] IorD
	.IRWrite(IRWrite) ,	// output  IRWrite
	.PCWrite(PCWrite) ,	// output  PCWrite
	.Opcode(Opcode) ,	// input [4:0] Opcode
	.CLK(CLK) ,	// input  CLK
	.Jump(Jump) ,	// output  Jump
	.Branch(Branch) ,	// output [1:0] Branch
	.shouldBranch(shouldBranch) ,	// output  shouldBranch
	.RegFileSrc(RegFileSrc) ,	// output [1:0] RegFileSrc
	.ReturnSrc(ReturnSrc) ,	// output [1:0] ReturnSrc
	.DataSrc(DataSrc) ,	// output  DataSrc
	.OperandSrc(OperandSrc) ,	// output [1:0] OperandSrc
	.SPWrite(SPWrite) ,	// output  SPWrite
	.Output(Output) ,	// output  Output
	.Reset(Reset) 	// output  Reset
);

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
	.ReturnSrc(ReturnSrc) ,	// input [2:0] ReturnSrc
	.DataSrc(DataSrc) ,	// input [1:0] DataSrc
	.OperandSrc(OperandSrc) ,	// input [1:0] OperandSrc
	.SPWrite(SPWrite) ,	// input  SPWrite
	.Reset(Reset) ,	// input  Reset
	.CLK(CLK) ,	// input  CLK
	.Outputio(Outputio) ,	// output [15:0] Outputio
	.Overflow(Overflow), 	// output  Overflow
	.Opcode(Opcode)
);

endmodule