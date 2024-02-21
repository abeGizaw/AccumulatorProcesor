
//Input -> In at the end
//Ouput -> Out at the end 

//case for mux 

module magenta_stage_ALUControl_ALU_ALUOut_RegA_RegB(
	
	input [15:0] AIn,
	input [15:0] BIn,
	input [15:0] PCIn,
	input [15:0] SPIn,
	input [15:0] ImmGennIn,
	input [15:0] MDRIn,
	input [1:0] ALUOpIn,
	input [4:0] AlterOpIn,
	input [4:0] OpcodeIn,
	input CLK,

	
	output wire [15:0] ALUOutOut,
	output wire ShouldBranchOut,
	output reg [15:0] BranchOut,
	output [15:0] RegAOut,
	output [15:0] RegBOut,
	
	input wire [1:0] ALUSrcA,
	input wire [1:0] ALUSrcB,
	input wire [1:0] Branch
	
    );
	 
	wire [15:0] ALUOut;
	wire [15:0] MuxAWire;
	wire [15:0] MuxBWire;
	reg [15:0] MuxAReg;
	reg [15:0] MuxBReg;
	wire [3:0] ALUOpWire;
	wire [15:0] ALUOutWire;
	
	assign MuxAWire = MuxAReg;
	assign MuxBWire = MuxBReg;
	
	


alu_control alu_control_inst
(
	.Opcode(OpcodeIn) ,
	.ALUOp(ALUOpIn) ,	
	.AlterOp(AlterOpIn) ,	
	.out(ALUOpWire)
);

register regA
(
	.Input(AIn) ,
	.Reset(1'b0) ,
	.RegWrite(1'b1) ,
	.Output(RegAOut) ,
	.ResetTo(16'b0) ,
	.CLK(CLK)
);

register regB
(
	.Input(BIn) ,
	.Reset(1'b0) ,
	.RegWrite(1'b1) ,
	.Output(RegBOut) ,
	.ResetTo(16'b0) ,
	.CLK(CLK) 
);

register ALUOutComp
(
	.Input(ALUOutWire) ,
	.Reset(1'b0) ,	
	.RegWrite(1'b1) ,	
	.Output(ALUOutOut) ,
	.ResetTo(16'b0000000000000000) ,	
	.CLK(CLK) 
);

alu ALU
(
	.InputA(MuxAReg) ,	
	.InputB(MuxBReg) ,	
	.ALUOp(ALUOpWire) ,	
	.ALUOut(ALUOutWire) ,	
	.ShouldBranch(ShouldBranchOut) ,	
	.CLK(CLK) 
);


always @ (ALUSrcA,RegAOut,PCIn,ALUOutOut,ALUOutOut)
begin

	case (ALUSrcA)
		2'b00: MuxAReg = PCIn;
		2'b01: MuxAReg = ALUOutOut;
		2'b10: MuxAReg = RegAOut;
		2'b11: MuxAReg = SPIn;
	endcase
end
	
always @ (ALUSrcB,RegBOut,PCIn,ImmGennIn,MDRIn)
begin
	case (ALUSrcB)
		2'b00: MuxBReg = RegBOut;
		2'b01: MuxBReg = ImmGennIn;
		2'b10: MuxBReg = MDRIn;
		2'b11: MuxBReg = 2;
	endcase
end

always @ (Branch,PCIn,ALUOutOut,MDRIn, ALUOutWire)
begin
	case(Branch)
		2'b00: BranchOut = ALUOutWire;
		2'b01: BranchOut = ALUOutOut;
		2'b10: BranchOut = MDRIn;
	endcase
	
	
end

endmodule
