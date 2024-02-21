//////////////////////////////////////////////////////////////////////////////////
// Company: Pink
// Engineer: 
// 
// Create Date:    02/6/2024 
// Module Name:   Integraltion Stage 1 Part 1
// Project Name: 
//
// Revision 0.01 - Created file
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module inte_stage1_part1
(
	//Data input
	input [15:0] PCInput,
	input [15:0] Inputio,
	input [15:0] ALUOutIn,
	input [15:0] ImmIn,
	input [15:0] SPIn,
	input [15:0] RegAIn,
	input ShouldBranchIn,
	
	//Control Signal input
	input PCWrite,
	input Jump,
	input [1:0] Branch,
	input [1:0] IorD,
	input [1:0] DataSrc,
	input MemWrite,
	input MemRead,
	input IRWrite,
	input Reset,
	input CLK,
	
	//Output
	output [15:0] IROut,
	output [15:0] MDROut,
	output [15:0] PCOut,
	output Overflow
);


wire [15:0] MemoryDataOut;
reg PCFinalSignal;
reg [15:0] MemoryDataIn;
reg [15:0] AddressIn;

memory_wrap memory_inst
(
	.Data(MemoryDataIn) ,	// input [15:0] Data
	.Address(AddressIn) ,	// input [15:0] Address
	.MemoryWrite(MemWrite) ,	// input  MemoryWrite
	.MemoryRead(MemRead) ,	// input  MemoryRead
	.CLK(CLK) ,	// input  CLK
	.Output(MemoryDataOut) , 	// output [15:0] Output
	.Overflow(Overflow) ,
	.Reset(Reset)
);

register PC
(
	.Input(PCInput) ,	// input [15:0] Input
	.Reset(Reset) ,	// input  Reset
	.RegWrite(PCFinalSignal) ,	// input  RegWrite
	.Output(PCOut) ,	// output [15:0] Output
	.ResetTo(16'b0) ,	// input [15:0] ResetTo
	.CLK(CLK) 	// input  CLK
);

register IR
(
	.Input(MemoryDataOut) ,	// input [15:0] Input
	.Reset(Reset) ,	// input  Reset
	.RegWrite(IRWrite) ,	// input  RegWrite
	.Output(IROut) ,	// output [15:0] Output
	.ResetTo(16'b0) ,	// input [15:0] ResetTo
	.CLK(~CLK) 	// input  CLK
);

register MDR
(
	.Input(MemoryDataOut) ,	// input [15:0] Input
	.Reset(Reset) ,	// input  Reset
	.RegWrite(1'b1) ,	// input  RegWrite
	.Output() ,	// output [15:0] Output
	.ResetTo(16'b0) ,	// input [15:0] ResetTo
	.CLK(CLK) 	// input  CLK
);

assign MDROut = MemoryDataOut;

always @ (PCWrite, Jump, Branch, ShouldBranchIn)
begin
	PCFinalSignal = ((PCWrite || Jump) || (Branch & ShouldBranchIn));
end


always @ (IorD, PCOut, ImmIn, ALUOutIn, SPIn)
begin	
	case (IorD)
		2'b00: AddressIn = PCOut;
		2'b01: AddressIn = ImmIn;
		2'b10: AddressIn = ALUOutIn;
		2'b11: AddressIn = SPIn;
	endcase
end

always @ (DataSrc,PCOut, RegAIn, Inputio)	
begin
	case (DataSrc)
		2'b00: MemoryDataIn = PCOut;
		2'b01: MemoryDataIn = RegAIn;
		2'b10: MemoryDataIn = Inputio;
	endcase
end

endmodule

