module tb_magenta_stage_ALUControl_ALU_ALUOut_RegA_RegB();

//Inputs
reg [15:0] AIn;
reg [15:0] BIn;
reg [15:0] PCIn;
reg [15:0] SPIn;
reg [15:0] ImmGennIn;
reg [15:0] MDRIn;
reg [1:0] ALUOpIn;
reg [4:0] AlterOpIn;
reg [4:0] OpcodeIn;
reg CLK;

//Output
wire [15:0] ALUOutOut;
wire ShouldBranchOut;
wire [15:0] BranchOut;

//Input Signals
reg [1:0] ALUSrcASig;
reg [1:0] ALUSrcBSig;
reg [1:0] BranchSig;
reg [1:0] ShouldBranchSig;

parameter HALF_Period = 50;

magenta_stage_ALUControl_ALU_ALUOut_RegA_RegB magenta_stage_ALUControl_ALU_ALUOut_RegA_RegB_inst
(
	.AIn(AIn) ,	// input [15:0] AIn 
	.BIn(BIn) ,	// input [15:0] BIn 
	.PCIn(PCIn) ,	// input [15:0] PCIn 
	.SPIn(SPIn) ,	// input [15:0] SPIn 
	.ImmGennIn(ImmGennIn) ,	// input [15:0] ImmGennIn 
	.MDRIn(MDRIn) ,	// input [15:0] MDRIn 
	.ALUOpIn(ALUOpIn) ,	// input [1:0] ALUOpIn 
	.AlterOpIn(AlterOpIn) ,	// input [3:0] AlterOpIn 
	.OpcodeIn(OpcodeIn) ,	// input [4:0] OpcodeIn 
	.CLK(CLK) ,	// input  CLK 
	.ALUOutOut(ALUOutOut) ,	// output [15:0] ALUOutOut 
	.ShouldBranchOut(ShouldBranchOut) ,	// output  ShouldBranchOut 
	.BranchOut(BranchOut) ,	// output [15:0] BranchOut 
	.ALUSrcASig(ALUSrcASig) ,	// input [1:0] ALUSrcASig 
	.ALUSrcBSig(ALUSrcBSig) ,	// input [1:0] ALUSrcBSig 
	.BranchSig(BranchSig) ,	// input [1:0] BranchSig 
	.ShouldBranchSig(ShouldBranchSig) 	// input [1:0] ShouldBranchSig 
);

initial begin
    CLK = 0;
    forever begin
        #(50);
        CLK = ~CLK;
    end
end


initial begin

	//---------------------------Add Test Starts Here---------------------------
	//Test ADD 1 + 8
	AIn = 16'b0000000000000001;
	BIn = 16'b0000000000001000;
	PCIn = 16'b0000000000000000;
	SPIn = 16'b0000000000000000;
	ImmGennIn = 16'b0000000000000000;
	MDRIn = 16'b0000000000000000;
	ALUOpIn = 2'b10;
	OpcodeIn = 5'b00000;
	
	ALUSrcASig = 2'b10;
	ALUSrcBSig = 2'b00;
	BranchSig = 2'b00;
	ShouldBranchSig = 2'b00;
	
	#500;
	if(ALUOutOut != 16'b0000000000001001) begin
		$display("ADD Result does not equal 1001, its: %b", ALUOutOut);
	end
	
	//Test ADD 2^15 + 2^15
	//Overflow
	AIn = 16'b1000000000000000;
	BIn = 16'b1000000000000000;
	PCIn = 16'b0000000000000000;
	SPIn = 16'b0000000000000000;
	ImmGennIn = 16'b0000000000000000;
	MDRIn = 16'b0000000000000000;
	ALUOpIn = 2'b10;
	OpcodeIn = 5'b00000;
	
	ALUSrcASig = 2'b10;
	ALUSrcBSig = 2'b00;
	BranchSig = 2'b00;
	ShouldBranchSig = 2'b00;
	
	#500;
	if(ALUOutOut != 16'b0000000000000000) begin
		$display("ADD Result does not equal 1001, its: %b", ALUOutOut);
	end
	
	//Test ADD 2^16-1 + 2^16-1 
	//Overflow
	AIn = 16'b1111111111111111;
	BIn = 16'b1111111111111111;
	PCIn = 16'b0000000000000000;
	SPIn = 16'b0000000000000000;
	ImmGennIn = 16'b0000000000000000;
	MDRIn = 16'b0000000000000000;
	ALUOpIn = 2'b10;
	OpcodeIn = 5'b00000;
	
	ALUSrcASig = 2'b10;
	ALUSrcBSig = 2'b00;
	BranchSig = 2'b00;
	ShouldBranchSig = 2'b00;
	
	#500;
	if(ALUOutOut != 16'b1111111111111110) begin
		$display("ADD Result does not equal 0, its: %b", ALUOutOut);
	end
	
	
	//---------------------------Sub Test Starts Here---------------------------
	//Test Sub 8-8
	AIn = 16'b0000000000001000;
	BIn = 16'b0000000000000010;
	PCIn = 16'b0000000000000000;
	SPIn = 16'b0000000000000000;
	ImmGennIn = 16'b0000000000000000;
	MDRIn = 16'b0000000000000000;
	ALUOpIn = 2'b10;
	OpcodeIn = 5'b00001;
	
	ALUSrcASig = 2'b10;
	ALUSrcBSig = 2'b00;
	BranchSig = 2'b00;
	ShouldBranchSig = 2'b00;
	
	#500;
	if(ALUOutOut != 16'b110) begin
		$display("Sub Result does not equal 1110, its: %b", ALUOutOut);
	end
	
	//Test SUB 2^15 - 2^15
	//Overflow
	AIn = 16'b1111111111111111;
	BIn = 16'b11111111;
	PCIn = 16'b1111111111111111;
	SPIn = 16'b11111111;
	ImmGennIn = 16'b11111111;
	MDRIn = 16'b0000000000000000;
	ALUOpIn = 2'b10;
	OpcodeIn = 5'b00001;
	
	ALUSrcASig = 2'b00;
	ALUSrcBSig = 2'b0;
	BranchSig = 2'b00;
	ShouldBranchSig = 2'b00;
	
	#500;
	if(ALUOutOut != 16'b01111111100000000) begin
		$display("SUB Result does not equal 01111111100000000, its: %b", ALUOutOut);
	end
	
	//Test Sub 2^16-1 - 2^16-1 
	//Overflow
	AIn = 16'b1111111111111111;
	BIn = 16'b1111111111111111;
	PCIn = 16'b0000000000000000;
	SPIn = 16'b1111111111111111;
	ImmGennIn = 16'b0000000000000000;
	MDRIn = 16'b0000000000000000;
	ALUOpIn = 2'b10;
	OpcodeIn = 5'b00001;
	
	ALUSrcASig = 2'b11;
	ALUSrcBSig = 2'b00;
	BranchSig = 2'b00;
	ShouldBranchSig = 2'b00;
	
	#500;
	if(ALUOutOut != 16'b0) begin
		$display("Sub Result does not equal 0, its: %b", ALUOutOut);
	end
	
	
	//---------------------------XOR Test Starts Here---------------------------
	
	//XOR does not work
	
	//Test XOR 1100 & 10
	//Overflow
	AIn = 16'b1100;
	BIn = 16'b10;
	PCIn = 16'b0;
	SPIn = 16'b0;
	ImmGennIn = 16'b0;
	MDRIn = 16'b0;
	ALUOpIn = 2'b10;
	OpcodeIn = 5'b00010;
	
	ALUSrcASig = 2'b10;
	ALUSrcBSig = 2'b00;
	BranchSig = 2'b00;
	ShouldBranchSig = 2'b00;
	
	#500;
	
	if(ALUOutOut != (16'b1110)) begin
		$display("XOR Result does not equal 1110, its: %b", ALUOutOut);
	end
	
	//Test XOR 1111111111111111 & 10
	//Overflow
	AIn = 16'b1111111111111111;
	BIn = 16'b10;
	PCIn = 16'b0;
	SPIn = 16'b0;
	ImmGennIn = 16'b0;
	MDRIn = 16'b0;
	ALUOpIn = 2'b10;
	OpcodeIn = 5'b00010;
	
	ALUSrcASig = 2'b10;
	ALUSrcBSig = 2'b00;
	BranchSig = 2'b00;
	ShouldBranchSig = 2'b00;
	
	#500;
	
	if(ALUOutOut != (16'b1111111111111101)) begin
		$display("XOR Result does not equal 1111111111110101, its: %b", ALUOutOut);
	end
	
	//---------------------------OR Test Starts Here---------------------------
	
	AIn = 16'b1100;
	BIn = 16'b10;
	PCIn = 16'b0;
	SPIn = 16'b0;
	ImmGennIn = 16'b0;
	MDRIn = 16'b0;
	ALUOpIn = 2'b10;
	OpcodeIn = 5'b00011;
	
	ALUSrcASig = 2'b10;
	ALUSrcBSig = 2'b00;
	BranchSig = 2'b00;
	ShouldBranchSig = 2'b00;
	
	#500;
	
	if(ALUOutOut != (16'b1110)) begin
		$display("OR Result does not equal 1110, its: %b", ALUOutOut);
	end
	
	AIn = 16'b1100110011001100;
	BIn = 16'b10;
	PCIn = 16'b0;
	SPIn = 16'b0;
	ImmGennIn = 16'b1100110011001100;
	MDRIn = 16'b0;
	ALUOpIn = 2'b10;
	OpcodeIn = 5'b00011;
	
	ALUSrcASig = 2'b10;
	ALUSrcBSig = 2'b01;
	BranchSig = 2'b00;
	ShouldBranchSig = 2'b00;
	
	#500;
	
	if(ALUOutOut != (16'b1100110011001100)) begin
		$display("OR Result does not equal 1100110011001100, its: %b", ALUOutOut);
	end
	

	//---------------------------AND Test Starts Here---------------------------
	AIn = 16'b1100110011001100;
	BIn = 16'b10;
	PCIn = 16'b0;
	SPIn = 16'b0;
	ImmGennIn = 16'b0;
	MDRIn = 16'b1111000011110000;
	ALUOpIn = 2'b10;
	OpcodeIn = 5'b00100;
	
	ALUSrcASig = 2'b10;
	ALUSrcBSig = 2'b10;
	BranchSig = 2'b00;
	ShouldBranchSig = 2'b00;
	
	#500;
	
	if(ALUOutOut != (16'b1100000011000000)) begin
		$display("AND Result does not equal 1100000011000000, its: %b", ALUOutOut);
	end
	
	AIn = 16'b1100110011001100;
	BIn = 16'b10;
	PCIn = 16'b0;
	SPIn = 16'b0;
	ImmGennIn = 16'b0000000011111111;
	MDRIn = 16'b00;
	ALUOpIn = 2'b10;
	OpcodeIn = 5'b00100;
	
	ALUSrcASig = 2'b10;
	ALUSrcBSig = 2'b01;
	BranchSig = 2'b00;
	ShouldBranchSig = 2'b00;
	
	#500;
	
	if(ALUOutOut != (16'b0000000011001100)) begin
		$display("AND Result does not equal 16'b0000000011001100, its: %b", ALUOutOut);
	end





	//---------------------------SLL Test Starts Here---------------------------

	AIn = 16'b110;
	BIn = 16'b10;
	PCIn = 16'b0;
	SPIn = 16'b0;
	ImmGennIn = 16'b10;
	MDRIn = 16'b00;
	ALUOpIn = 2'b10;
	OpcodeIn = 5'b00101;
	
	ALUSrcASig = 2'b10;
	ALUSrcBSig = 2'b00;
	BranchSig = 2'b00;
	ShouldBranchSig = 2'b00;
	
	#500;
	
	if(ALUOutOut != (16'b0000000000011000)) begin
		$display("SLL Result does not equal 16'b0000000000001100, its: %b", ALUOutOut);
	end


	AIn = 16'b1000000000000000;
	BIn = 16'b10;
	PCIn = 16'b0;
	SPIn = 16'b0;
	ImmGennIn = 16'b10;
	MDRIn = 16'b100;
	ALUOpIn = 2'b10;
	OpcodeIn = 5'b00101;
	
	ALUSrcASig = 2'b10;
	ALUSrcBSig = 2'b10;
	BranchSig = 2'b00;
	ShouldBranchSig = 2'b00;
	
	#500;
	
	if(ALUOutOut != (16'b0000000000000000)) begin
		$display("SLL Result does not equal 16'b0000000000000000, its: %b", ALUOutOut);
	end


	//---------------------------SRL Test Starts Here---------------------------
	
		// In alter need to ask before I do anything here

	//---------------------------SRA Test Starts Here---------------------------

		// In alter need to ask before I do anything here

	//---------------------------ORI Test Starts Here---------------------------

	AIn = 16'b0;
	BIn = 16'b10;
	PCIn = 16'b1000000000000000;
	SPIn = 16'b0;
	ImmGennIn = 16'b0011001011101111;
	MDRIn = 16'b100;
	ALUOpIn = 2'b10;
	OpcodeIn = 5'b01000;
	
	ALUSrcASig = 2'b00;
	ALUSrcBSig = 2'b01;
	BranchSig = 2'b00;
	ShouldBranchSig = 2'b00;
	
	#500;
	
	if(ALUOutOut != (16'b1011001011101111)) begin
		$display("ORI Result does not equal 16'b1011001011101111, its: %b", ALUOutOut);
	end


	AIn = 16'b0;
	BIn = 16'b10;
	PCIn = 16'b0;
	SPIn = 16'b1010101010101010;
	ImmGennIn = 16'b1111111111110000;
	MDRIn = 16'b0;
	ALUOpIn = 2'b10;
	OpcodeIn = 5'b01000;
	
	ALUSrcASig = 2'b11;
	ALUSrcBSig = 2'b01;
	BranchSig = 2'b00;
	ShouldBranchSig = 2'b00;
	
	#500;
	
	if(ALUOutOut != (16'b1111111111111010)) begin
		$display("ORI Result does not equal 16'b1111111111111010, its: %b", ALUOutOut);
	end

	//---------------------------XORI Test Starts Here---------------------------

	AIn = 16'b1010101010101010;
	BIn = 16'b10;
	PCIn = 16'b0;
	SPIn = 16'b0;
	ImmGennIn = 16'b0101010101010101;
	MDRIn = 16'b0;
	ALUOpIn = 2'b10;
	OpcodeIn = 5'b01001;
	
	ALUSrcASig = 2'b10;
	ALUSrcBSig = 2'b01;
	BranchSig = 2'b00;
	ShouldBranchSig = 2'b00;
	
	#500;
	
	if(ALUOutOut != (16'b1111111111111111)) begin
		$display("XORI Result does not equal 16'b1111111111111111, its: %b", ALUOutOut);
	end


	AIn = 16'b0;
	BIn = 16'b10;
	PCIn = 16'b0;
	SPIn = 16'b1100110011001100;
	ImmGennIn = 16'b0101010101010101;
	MDRIn = 16'b0;
	ALUOpIn = 2'b10;
	OpcodeIn = 5'b01001;
	
	ALUSrcASig = 2'b11;
	ALUSrcBSig = 2'b01;
	BranchSig = 2'b00;
	ShouldBranchSig = 2'b00;
	
	#500;
	
	if(ALUOutOut != (16'b1001100110011001)) begin
		$display("XORI Result does not equal 16'b1001100110011001, its: %b", ALUOutOut);
	end
	


	//---------------------------ANDI Test Starts Here---------------------------

	AIn = 16'b0;
	BIn = 16'b10;
	PCIn = 16'b0;
	SPIn = 16'b1010101010101010;
	ImmGennIn = 16'b1100110000110011;
	MDRIn = 16'b0;
	ALUOpIn = 2'b10;
	OpcodeIn = 5'b01010;
	
	ALUSrcASig = 2'b11;
	ALUSrcBSig = 2'b01;
	BranchSig = 2'b00;
	ShouldBranchSig = 2'b00;
	
	#500;
	
	if(ALUOutOut != (16'b1000100000100010)) begin
		$display("ANDI Result does not equal 16'b1000100000100010, its: %b", ALUOutOut);
	end


	AIn = 16'b0;
	BIn = 16'b10;
	PCIn = 16'b1111000011110000;
	SPIn = 16'b0;
	ImmGennIn = 16'b0000111100001111;
	MDRIn = 16'b0;
	ALUOpIn = 2'b10;
	OpcodeIn = 5'b01010;
	
	ALUSrcASig = 2'b00;
	ALUSrcBSig = 2'b01;
	BranchSig = 2'b00;
	ShouldBranchSig = 2'b00;
	
	#500;
	
	if(ALUOutOut != (16'b0000000000000000)) begin
		$display("ANDI Result does not equal 16'b0000000000000000, its: %b", ALUOutOut);
	end


	//---------------------------SLLI Test Starts Here---------------------------

	AIn = 16'b1010101010101010;
	BIn = 16'b10;
	PCIn = 16'b0;
	SPIn = 16'b0;
	ImmGennIn = 16'b0000000000000100;
	MDRIn = 16'b0;
	ALUOpIn = 2'b10;
	OpcodeIn = 5'b01100;
	
	ALUSrcASig = 2'b10;
	ALUSrcBSig = 2'b01;
	BranchSig = 2'b00;
	ShouldBranchSig = 2'b00;
	
	#500;
	
	if(ALUOutOut != 16'b1010101010100000) begin
		$display("SLLI Result does not equal 16'b1010101010100000, its: %b", ALUOutOut);
	end


	AIn = 16'b0;
	BIn = 16'b10;
	PCIn = 16'b0;
	SPIn = 16'b1010101010101010;
	ImmGennIn = 16'b0000000000001000;
	MDRIn = 16'b0;
	ALUOpIn = 2'b10;
	OpcodeIn = 5'b01100;
	
	ALUSrcASig = 2'b11;
	ALUSrcBSig = 2'b01;
	BranchSig = 2'b00;
	ShouldBranchSig = 2'b00;
	
	#500;
	
	if(ALUOutOut != 16'b1010101000000000) begin
		$display("SLLI Result does not equal 16'b1010101000000000, its: %b", ALUOutOut);
	end
	

	//---------------------------SRLI Test Starts Here---------------------------

	AIn = 16'b0;
	BIn = 16'b10;
	PCIn = 16'b0;
	SPIn = 16'b1010101010101010;
	ImmGennIn = 16'b0000000000000011;
	MDRIn = 16'b0;
	ALUOpIn = 2'b10;
	OpcodeIn = 5'b01101;
	
	ALUSrcASig = 2'b11;
	ALUSrcBSig = 2'b01;
	BranchSig = 2'b00;
	ShouldBranchSig = 2'b00;
	
	#500;
	
	if(ALUOutOut != (16'b0001010101010101)) begin
		$display("SRLI Result does not equal 16'b0001010101010101, its: %b", ALUOutOut);
	end


	AIn = 16'b1111000011110000;
	BIn = 16'b10;
	PCIn = 16'b0;
	SPIn = 16'b0;
	ImmGennIn = 16'b0000000000000101;
	MDRIn = 16'b0;
	ALUOpIn = 2'b10;
	OpcodeIn = 5'b01101;
	
	ALUSrcASig = 2'b10;
	ALUSrcBSig = 2'b01;
	BranchSig = 2'b00;
	ShouldBranchSig = 2'b00;
	
	#500;
	
	if(ALUOutOut != (16'b0000011110000111)) begin
		$display("SRLI Result does not equal 16'b0000011110000111, its: %b", ALUOutOut);
	end


	//---------------------------ADDI Test Starts Here---------------------------

	AIn = 16'b0101010101010101;
	BIn = 16'b10;
	PCIn = 16'b0;
	SPIn = 16'b0;
	ImmGennIn = 16'b0000000000000011;
	MDRIn = 16'b0;
	ALUOpIn = 2'b10;
	OpcodeIn = 5'b01011;
	
	ALUSrcASig = 2'b10;
	ALUSrcBSig = 2'b01;
	BranchSig = 2'b00;
	ShouldBranchSig = 2'b00;
	
	#500;
	
	if(ALUOutOut != (16'b0101010101011000)) begin
		$display("ADDI Result does not equal 16'b0101010101011000, its: %b", ALUOutOut);
	end

	AIn = 16'b0;
	BIn = 16'b10;
	PCIn = 16'b1010101010101010;
	SPIn = 16'b0;
	ImmGennIn = 16'b0000000000001100;
	MDRIn = 16'b0;
	ALUOpIn = 2'b10;
	OpcodeIn = 5'b01011;
	
	ALUSrcASig = 2'b00;
	ALUSrcBSig = 2'b01;
	BranchSig = 2'b00;
	ShouldBranchSig = 2'b00;
	
	#500;
	
	if(ALUOutOut != (16'b1010101010110110)) begin
		$display("ADDI Result does not equal 16'b1010101010110110, its: %b", ALUOutOut);
	end
	
	
	//Liz's
	//---------------------------SRAI Test Starts Here---------------------------

	//Basic 1100 SRAI by 10
	AIn = 16'b1100;
	BIn = 16'b10;
	MDRIn = 16'b0;
	ALUOpIn = 2'b10;
	OpcodeIn = 5'b01110;
	
	ALUSrcASig = 2'b10;
	ALUSrcBSig = 2'b01;
	BranchSig = 2'b00;
	ShouldBranchSig = 2'b00;
	
	#500;
	
	if(ALUOutOut != (16'b00)) begin
		$display("SRAI Result does not equal 0000000000000000, its: %b", ALUOutOut);
	end
	
	//Overflow 1111 1111 1111 1111 SRAI by 10
	AIn = 16'b1111111111111111;
	BIn = 16'b1111111111111111;
	ALUOpIn = 2'b10;
	OpcodeIn = 5'b01110;
	
	ALUSrcASig = 2'b10;
	ALUSrcBSig = 2'b00;
	BranchSig = 2'b00;
	ShouldBranchSig = 2'b00;
	
	#500;
	
	if(ALUOutOut != (16'b0)) begin
		$display("SRAI Result does not equal 0, its: %b", ALUOutOut);
	end
	//---------------------------SLT Test Starts Here---------------------------
	//Test 1111 1111 1111 1111 > 0
	//Set less than doesn't work -> need?
	AIn = 16'b1111111111111111;
	BIn = 16'b0;
	ALUOpIn = 2'b10;
	OpcodeIn = 5'b01111;
	
	ALUSrcASig = 2'b10;
	ALUSrcBSig = 2'b00;
	BranchSig = 2'b00;
	ShouldBranchSig = 2'b00;
	
	#500;
	
	if(ALUOutOut != (16'b0)) begin
		$display("SLT Result does not equal 0, its: %b", ALUOutOut);
	end
	
	//---------------------------BEQ Test Starts Here---------------------------
	//Test 1111 1111 1111 1111 == 1111 1111 1111 1111
	//BEQ = 1
	AIn = 16'b1111111111111111;
	BIn = 16'b1111111111111111;
	ALUOpIn = 2'b10;
	OpcodeIn = 5'b10000;
	
	ALUSrcASig = 2'b10;
	ALUSrcBSig = 2'b00;
	BranchSig = 2'b00;
	ShouldBranchSig = 2'b00;
	
	#500;
	
	if(ShouldBranchOut != 16'b0000000000000001) begin
		$display("BEQ Result does not equal 1, its: %b", ShouldBranchOut);
	end
	
	//BEQ = 0
	AIn = 16'b1111111111111111;
	BIn = 16'b1111111111111110;
	ALUOpIn = 2'b10;
	OpcodeIn = 5'b10000;
	
	ALUSrcASig = 2'b10;
	ALUSrcBSig = 2'b00;
	BranchSig = 2'b00;
	ShouldBranchSig = 2'b00;
	
	#500;
	
	if(ShouldBranchOut != 16'b0) begin
		$display("BEQ Result does not equal 0, its: %b", ShouldBranchOut);
	end
	
	
	//---------------------------BNE Test Starts Here---------------------------
	
	//Test 1111 1111 1111 1111 != 1111 1111 1111 1110
	//BNE = 1
	AIn = 16'b1111111111111111;
	BIn = 16'b1111111111111110;
	ALUOpIn = 2'b10;
	OpcodeIn = 5'b10001;
	
	ALUSrcASig = 2'b10;
	ALUSrcBSig = 2'b00;
	BranchSig = 2'b00;
	ShouldBranchSig = 2'b00;
	
	#500;
	
	if(ShouldBranchOut != 16'b0000000000000001) begin
		$display("BNE Result does not equal 1, its: %b", ShouldBranchOut);
	end
	
	//BNE = 0
	AIn = 16'b1111111111111111;
	BIn = 16'b1111111111111111;
	ALUOpIn = 2'b10;
	OpcodeIn = 5'b10001;
	
	ALUSrcASig = 2'b10;
	ALUSrcBSig = 2'b00;
	BranchSig = 2'b00;
	ShouldBranchSig = 2'b00;
	
	#500;
	
	if(ShouldBranchOut != 16'b0) begin
		$display("BNE Result does not equal 0, its: %b", ShouldBranchOut);
	end
	//---------------------------BLT Test Starts Here---------------------------
	//Test 1111 1111 1111 1110 < 1111 1111 1111 1111
	//BLT = 1
	AIn = 16'b1111111111111110;
	BIn = 16'b1111111111111111;
	ALUOpIn = 2'b10;
	OpcodeIn = 5'b10010;
	
	ALUSrcASig = 2'b10;
	ALUSrcBSig = 2'b00;
	BranchSig = 2'b00;
	ShouldBranchSig = 2'b00;
	
	#500;
	
	if(ShouldBranchOut == 16'b0000000000000001) begin
		$display("BLT Result does not equal 0, its: %b", ShouldBranchOut);
	end
	//BLT = 0
	AIn = 16'b1111111111111111;
	BIn = 16'b1111111111111110;
	ALUOpIn = 2'b10;
	OpcodeIn = 5'b10010;
	
	ALUSrcASig = 2'b10;
	ALUSrcBSig = 2'b00;
	BranchSig = 2'b00;
	ShouldBranchSig = 2'b00;
	
	#500;
	
	if(ShouldBranchOut == 16'b0000000000000000) begin
		$display("BLT Result does not equal 1, its: %b", ShouldBranchOut);
	end
	//---------------------------BGE Test Starts Here---------------------------
	//Test 1111 1111 1111 1111 >= 1111 1111 1111 1110
	//BLT = 1
	AIn = 16'b1111111111111111;
	BIn = 16'b1111111111111111;
	ALUOpIn = 2'b10;
	OpcodeIn = 5'b10011;
	
	ALUSrcASig = 2'b10;
	ALUSrcBSig = 2'b00;
	BranchSig = 2'b00;
	ShouldBranchSig = 2'b00;
	
	#500;
	
	if(ShouldBranchOut != 16'b1) begin
		$display("BGE Result does not equal 1, its: %b", ShouldBranchOut);
	end
	
	//BLT = 0
	AIn = 16'b1111111111111110;
	BIn = 16'b1111111111111111;
	ALUOpIn = 2'b10;
	OpcodeIn = 5'b10011;
	
	ALUSrcASig = 2'b10;
	ALUSrcBSig = 2'b00;
	BranchSig = 2'b00;
	ShouldBranchSig = 2'b00;
	
	#500;
	
	if(ShouldBranchOut != 16'b0000000000000000) begin
		$display("BGE Result does not equal 0, its: %b", ShouldBranchOut);
	end
	//---------------------------StoreSP Test Starts Here---------------------------
	//Test StoreSP 0000 0000 0000 0000 @ 0010
	AIn = 16'b0000000000000000;
	BIn = 16'b0010;
	ALUOpIn = 2'b10;
	OpcodeIn = 5'b10111;
	
	ALUSrcASig = 2'b10;
	ALUSrcBSig = 2'b00;
	BranchSig = 2'b00;
	ShouldBranchSig = 2'b00;
	
	#500;
	
	if(ALUOutOut != 16'b10) begin
		$display("StoreSP Result does not equal 0010, its: %b", ALUOutOut);
	end
	//---------------------------LoadSP Test Starts Here---------------------------
	//Test LoadSP 0000 0000 0000 0000
	AIn = 16'b0000000000000000;
	ALUOpIn = 2'b10;
	OpcodeIn = 5'b10111;
	
	ALUSrcASig = 2'b10;
	ALUSrcBSig = 2'b00;
	BranchSig = 2'b00;
	ShouldBranchSig = 2'b00;
	
	#500;
	
	if(ALUOutOut == 16'b0000000000001000) begin
		$display("LoadSP Result does not equal 1000, its: %b", ALUOutOut);
	end
	
	//Test LoadSP 1111 1111 1111 1111
	AIn = 16'b1111111111111111;
	ALUOpIn = 2'b10;
	OpcodeIn = 5'b10111;
	
	ALUSrcASig = 2'b10;
	ALUSrcBSig = 2'b00;
	BranchSig = 2'b00;
	ShouldBranchSig = 2'b00;
	
	#500;
	
	if(ALUOutOut == 16'b0000000000000111) begin
		$display("LoadSP Result does not equal 0000000000000111, its: %b", ALUOutOut);
	end
	
	//---------------------------MoveSP Test Starts Here---------------------------
	//Test MoveSP 0000 0000 0000 0000 @ 0010
	AIn = 16'b0000000000000000;
	BIn = 16'b0010;
	ALUOpIn = 2'b10;
	OpcodeIn = 5'b11001;
	
	ALUSrcASig = 2'b10;
	ALUSrcBSig = 2'b00;
	BranchSig = 2'b00;
	ShouldBranchSig = 2'b00;
	
	#500;
	
	if(ALUOutOut != 16'b10) begin
		$display("MoveSP Result does not equal 0010, its: %b", ALUOutOut);
	end
	//---------------------------Swap Test Starts Here---------------------------
	//Test Swap 01 & 10
	AIn = 16'b0000000000000001;
	BIn = 16'b0010;
	ALUOpIn = 2'b10;
	OpcodeIn = 5'b11101;
	
	ALUSrcASig = 2'b10;
	ALUSrcBSig = 2'b00;
	BranchSig = 2'b00;
	ShouldBranchSig = 2'b00;
	
	#500;
	
	if(ALUOutOut != 16'b01) begin
		$display("SWAP Result does not equal 0001, its: %b", ALUOutOut);
	end
	
	//---------------------------ALUOp == 00 Test Starts Here---------------------------
	AIn = 16'b0000000000000001;
	BIn = 16'b0000000000001000;
	ALUOpIn = 2'b00;
	
	ALUSrcASig = 2'b10;
	ALUSrcBSig = 2'b00;
	
	#500;
	if(ALUOutOut != 16'b0000000000001001) begin
		$display("ALUOp == 00 Result does not equal 1001, its: %b", ALUOutOut);
	end
	//---------------------------ALUOp == 01 Test Starts Here---------------------------
	AIn = 16'b1000;
	BIn = 16'b1;
	ALUOpIn = 2'b01;
	
	ALUSrcASig = 2'b10;
	ALUSrcBSig = 2'b00;
	
	#500;
	if(ALUOutOut != 16'b0000000000000111) begin
		$display("ALUOp == 01 Result does not equal 0111, its: %b", ALUOutOut);
	end
	//---------------------------ALUOp == 11 Test Starts Here---------------------------
	//Test add
	AIn = 16'b0000000000000001;
	BIn = 16'b0000000000001000;
	AlterOpIn = 5'b00000;
	OpcodeIn = 5'b11110;
	
	ALUOpIn = 2'b11;
	ALUSrcASig = 2'b10;
	ALUSrcBSig = 2'b00;
	
	#500;
	if(ALUOutOut != 16'b0000000000001001) begin
		$display("ALTER ADD Result does not equal 1001, its: %b", ALUOutOut);
	end
	//Test sub
	AIn = 16'b0000000000001000;
	BIn = 16'b0000000000000001;
	AlterOpIn = 5'b00001;
	OpcodeIn = 5'b11110;
	ALUOpIn = 2'b11;
	ALUSrcASig = 2'b10;
	ALUSrcBSig = 2'b00;
	
	#500;
	if(ALUOutOut != 16'b0000000000000111) begin
		$display("ALTER SUB Result does not equal 1001, its: %b", ALUOutOut);
	end
	//Test load 0 
	AIn = 16'b0000000000000001;
	AlterOpIn = 5'b01101;
	OpcodeIn = 5'b11110;
	ALUOpIn = 2'b11;
	ALUSrcASig = 2'b10;
	ALUSrcBSig = 2'b00;
	
	#500;
	if(ALUOutOut != 16'b0) begin
		$display("ALTER LOAD0 Result does not equal 0, its: %b", ALUOutOut);
	end

	//Test load 1
	AIn = 16'b0000000000000001;
	AlterOpIn = 5'b01110;
	OpcodeIn = 5'b11110;
	ALUOpIn = 2'b11;
	ALUSrcASig = 2'b10;
	ALUSrcBSig = 2'b00;
	
	#500;
	if(ALUOutOut != 16'b1) begin
		$display("ALTER LOAD1 Result does not equal 1, its: %b", ALUOutOut);
	end
	
	//Test SRL 1
	AIn = 16'b1100110011001100;
	BIn = 16'b10;
	AlterOpIn = 5'b00110;
	OpcodeIn = 5'b11110;
	ALUOpIn = 2'b11;
	ALUSrcASig = 2'b10;
	ALUSrcBSig = 2'b00;
	
	#500;
	if(ALUOutOut != 16'b0011001100110011) begin
		$display("ALTER LOAD1 Result does not equal 16'b0011001100110011, its: %b", ALUOutOut);
	end
	

	//Test SRA 1
	AIn = 16'b1100110011001100;
	BIn = 16'b100;
	AlterOpIn = 5'b00111;
	OpcodeIn = 5'b11110;
	ALUOpIn = 2'b11;
	ALUSrcASig = 2'b10;
	ALUSrcBSig = 2'b00;
	
	#500;
	if(ALUOutOut != 16'b1111110011001100) begin
		$display("ALTER LOAD1 Result does not equal 16'b1111110011001100, its: %b", ALUOutOut);
	end
	
	
	$stop;

    
end

endmodule