//////////////////////////////////////////////////////////////////////////////////
// Company: Pink
// Engineer: 
// 
// Create Date:    02/12/2024 
// Module Name:  Headless Machine
// Project Name: 
//
// Revision 0.01 - Created file
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module headless_machine
(
	//Data input
	input [15:0] Inputio,
	
	//Control Signal input
	input [1:0]		 	 ALUOp,
   input [1:0]        ALUSrcA,
   input [1:0]        ALUSrcB,
   input [1:0]        MemtoReg,
   input              RegWrite,
   input              MemRead,
   input              MemWrite,
   input [1:0]        IorD,
   input              IRWrite,
   input              PCWrite,
	input              Jump,
	input [1:0]        Branch,
	input              shouldBranch,
	input [1:0]        RegFileSrc,
	input [2:0]        ReturnSrc,
	input [1:0]   		 DataSrc,
	input [1:0]        OperandSrc,
	input              SPWrite,
	input Reset,
	input CLK,
	
	//Output
	output [4:0] Opcode,
	output [15:0] Outputio,
	output		  Overflow
);


wire [15:0] PCData_3t1;
wire [15:0] PC_1t3;
wire [15:0] ALU_3t12;
wire [15:0] Imm_2t13;
wire [15:0] SP_2t13;
wire [15:0] RegA_3t1;
wire [15:0] RegB_3t2;
wire [15:0] DataA_2t3;
wire [15:0] DataB_2t3;
wire			ShouldBranch_3t1;
wire [15:0] IR_1t23;
wire [15:0] MDR_1t23;


inte_stage1_part1 inte_stage1_part1_inst
(
	.PCInput(PCData_3t1) ,	// input [15:0] PCInput
	.Inputio(Inputio) ,	// input [15:0] Inputio
	.ALUOutIn(ALU_3t12) ,	// input [15:0] ALUOutIn
	.ImmIn(Imm_2t13) ,	// input [15:0] ImmIn
	.SPIn(SP_2t13) ,	// input [15:0] SPIn
	.RegAIn(RegA_3t1) ,	// input [15:0] RegAIn
	.ShouldBranchIn(ShouldBranch_3t1) ,	// input  ShouldBranchIn
	.PCWrite(PCWrite) ,	// input  PCWrite
	.Jump(Jump) ,	// input  Jump
	.Branch(Branch) ,	// input [1:0] Branch
	.IorD(IorD) ,	// input [1:0] IorD
	.DataSrc(DataSrc) ,	// input [1:0] DataSrc
	.MemWrite(MemWrite) ,	// input  MemWrite
	.MemRead(MemRead) ,	// input  MemRead
	.IRWrite(IRWrite) ,	// input  IRWrite
	.Reset(Reset) ,	// input  Reset
	.CLK(CLK) ,	// input  CLK
	.IROut(IR_1t23) ,	// output [15:0] IROut
	.MDROut(MDR_1t23) ,	// output [15:0] MDROut
	.PCOut(PC_1t3) ,	// output [15:0] PCOut
	.Overflow(Overflow) 	// output  Overflow
);

regFile_immgen_sp regFile_immgen_sp_inst
(
	.OperandSrc(OperandSrc) ,	// input [1:0] OperandSrc
	.ReturnSrc(ReturnSrc) ,	// input [2:0] ReturnSrc
	.RegFileSrc(RegFileSrc) ,	// input [1:0] RegFileSrc
	.IRInput(IR_1t23) ,	// input [15:0] IRInput
	.MDRInput(MDR_1t23) ,	// input [15:0] MDRInput
	.RegBInput(RegB_3t2) ,	// input [15:0] ALUSrcBInput
	.ALUOutInput(ALU_3t12) ,	// input [15:0] ALUOutInput
	.RegWrite(RegWrite) ,	// input  RegWrite
	.SPWrite(SPWrite) ,	// input  SPWrite
	.Reset(Reset) ,	// input  Reset
	.CLK(CLK) ,	// input  CLK
	.RegAOut(DataA_2t3) ,	// output [15:0] RegAOut
	.RegBOut(DataB_2t3) ,	// output [15:0] RegBOut
	.SPOut(SP_2t13) ,	// output [15:0] SPOut
	.ImmGenValOut(Imm_2t13) 	// output [15:0] ImmGenValOut
);

magenta_stage_ALUControl_ALU_ALUOut_RegA_RegB magenta_stage_ALUControl_ALU_ALUOut_RegA_RegB_inst
(
	.AIn(DataA_2t3) ,	// input [15:0] AIn
	.BIn(DataB_2t3) ,	// input [15:0] BIn
	.PCIn(PC_1t3) ,	// input [15:0] PCIn
	.SPIn(SP_2t13) ,	// input [15:0] SPIn
	.ImmGennIn(Imm_2t13) ,	// input [15:0] ImmGennIn
	.MDRIn(MDR_1t23) ,	// input [15:0] MDRIn
	.ALUOpIn(ALUOp) ,	// input [1:0] ALUOpIn
	.AlterOpIn(IR_1t23[15:11]) ,	// input [4:0] AlterOpIn
	.OpcodeIn(IR_1t23[4:0]) ,	// input [4:0] OpcodeIn
	.CLK(CLK) ,	// input  CLK
	.ALUOutOut(ALU_3t12) ,	// output [15:0] ALUOutOut
	.ShouldBranchOut(ShouldBranch_3t1) ,	// output  ShouldBranchOut
	.BranchOut(PCData_3t1) ,	// output [15:0] BranchOut
	.ALUSrcA(ALUSrcA) ,	// input [1:0] ALUSrcASig
	.ALUSrcB(ALUSrcB) ,	// input [1:0] ALUSrcBSig
	.Branch(Branch) ,	// input [1:0] BranchSig
	.RegAOut(RegA_3t1),
	.RegBOut(RegB_3t2)
);

assign Outputio = RegA_3t1;
assign Opcode = IR_1t23[4:0];

endmodule