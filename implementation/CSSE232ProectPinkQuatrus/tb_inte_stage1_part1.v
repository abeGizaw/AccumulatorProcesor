//////////////////////////////////////////////////////////////////////////////////
// Company: Pink
// Engineer: 
// 
// Create Date:    02/6/2024 
// Module Name:   Integraltion Stage 1 Part 1 test bench
// Project Name: 
//
// Revision 0.01 - Created file
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module tb_inte_stage1_part1();

	//Data input
	reg [15:0] PCInput;
	reg [15:0] Inputio;
	reg [15:0] ALUOutIn;
	reg [15:0] ImmIn;
	reg [15:0] SPIn;
	reg [15:0] RegAIn;
	reg ShouldBranchIn;
	
	//Control Signal input
	reg PCWrite;
	reg Jump;
	reg [1:0] Branch;
	reg [1:0] IorD;
	reg [1:0] DataSrc;
	reg MemWrite;
	reg MemRead;
	reg IRWrite;
	reg Reset;
	reg CLK;
	
	//Output
	wire [15:0] IROut;
	wire [15:0] MDROut;
	wire [15:0] PCOut;
	wire Overflow;
	
	parameter HALF_PERIOD = 50;
	integer line_counter = 0;
	integer address = 0;
	integer failures = 0;


inte_stage1_part1 inte_stage1_part1_inst
(
	.PCInput(PCInput) ,	// input [15:0] PCInput
	.Inputio(Inputio) ,	// input [15:0] Inputio
	.ALUOutIn(ALUOutIn) ,	// input [15:0] ALUOutIn
	.ImmIn(ImmIn) ,	// input [15:0] ImmIn
	.SPIn(SPIn) ,	// input [15:0] SPIn
	.RegAIn(RegAIn) ,	// input [15:0] RegAIn
	.ShouldBranchIn(ShouldBranchIn) ,	// input  ShouldBranchIn
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
	.IROut(IROut) ,	// output [15:0] IROut
	.MDROut(MDROut) ,	// output [15:0] MDROut
	.PCOut(PCOut) ,	// output [15:0] PCOut
	.Overflow(Overflow) 	// output  Overflow
);


initial begin
	 CLK = 0;
	 forever begin
		  #(HALF_PERIOD);
		  CLK = ~CLK;
	 end
end

initial begin
	Reset = 1;
	#(2*HALF_PERIOD);
	Reset = 0;
	
	//Reading the second line
	PCWrite = 1;
	PCInput = 2;
	IorD = 0;
	MemWrite = 0;
	MemRead = 1;
	IRWrite = 1;
	#(5*HALF_PERIOD);
	
	
	//Writing the
	PCWrite = 1;
	PCInput = 2;
	IorD = 0;
	MemWrite = 0;
	MemRead = 1;
	IRWrite = 1;
	#(5*HALF_PERIOD);
	
	
	$display("End of test. Total failure: %d", failures);
	$stop;
end

endmodule
