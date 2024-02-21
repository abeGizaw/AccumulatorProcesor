// test bench for control unit

module tb_control_unit();

reg [4:0] Input;
reg CLK;
wire [15:0] Output;

	wire [1:0]		  ALUOp;
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
	wire [1:0]        ReturnSrc;
	wire        		  DataSrc;
	wire [1:0]        OperandSrc;
	wire        		  SPWrite;


	integer HALF_PERIOD = 50;
	
control_unit control_unit_inst
(
	.ALUOp(ALUOp) ,	// output [1:0] ALUOp_sig
	.ALUSrcA(ALUSrcA) ,	// output [1:0] ALUSrcA_sig
	.ALUSrcB(ALUSrcB) ,	// output [1:0] ALUSrcB_sig
	.MemtoReg(MemtoReg) ,	// output [1:0] MemtoReg_sig
	.RegWrite(RegWrite) ,	// output  RegWrite_sig
	.MemRead(MemRead) ,	// output  MemRead_sig
	.MemWrite(MemWrite) ,	// output  MemWrite_sig
	.IorD(IorD) ,	// output [1:0] IorD_sig
	.IRWrite(IRWrite) ,	// output  IRWrite_sig
	.PCWrite(PCWrite) ,	// output  PCWrite_sig
	.Opcode(Input) ,	// input [5:0] Opcode_sig
	.CLK(CLK) ,	// input  CLK_sig
	.Reset(Reset) ,	// input  Reset_sig
	.Jump(Jump) ,	// output  Jump_sig
	.Branch(Branch) ,	// output [1:0] Branch_sig
	.shouldBranch(shouldBranch) ,	// output  shouldBranch_sig
	.RegFileSrc(RegFileSrc) ,	// output [1:0] RegFileSrc_sig
	.ReturnSrc(ReturnSrc) ,	// output [1:0] ReturnSrc_sig
	.DataSrc(DataSrc) ,	// output  DataSrc_sig
	.OperandSrc(OperandSrc) ,	// output [1:0] OperandSrc_sig
	.SPWrite(SPWrite), 	// output  SPWrite_sig
	.Output()
);

// Clock 
initial begin
    CLK = 0;
    while (1) begin
        #(HALF_PERIOD);
        CLK = ~CLK;
    end
end

initial begin
    
    // R-Types not load and store
    // Testing 00000
    Input = 5'b00000;
    #(16*HALF_PERIOD); // Wait for a clock cycle to see the change
	 

    // Testing 00001
    Input = 5'b00001;
    #(16*HALF_PERIOD); // Wait for a clock cycle to see the change
$display("====End====");$stop;
    // Testing 00010
    Input = 5'b00010;
    #(16*HALF_PERIOD); // Wait for a clock cycle to see the change
$display("====End====");$stop;
    // Testing 00011
    Input = 5'b00011;
    #(16*HALF_PERIOD); // Wait for a clock cycle to see the change\
$display("====End====");$stop;
    // Testing 00100
    Input = 5'b00100;
    #(16*HALF_PERIOD); // Wait for a clock cycle to see the change
$display("====End====");$stop;
    // Testing 00101
    Input = 5'b00101;
    #(16*HALF_PERIOD); // Wait for a clock cycle to see the change
$display("====End====");$stop;

    // Testing 00110
    Input = 5'b00110;
    #(16*HALF_PERIOD); // Wait for a clock cycle to see the change
$display("====End====");$stop;
    // Testing 01111
    Input = 5'b01111;
    #(16*HALF_PERIOD); // Wait for a clock cycle to see the change

    // R-Types that are load and store
$display("====End====");$stop;
    // Testing 10101
    Input = 5'b10101;
    #(16*HALF_PERIOD); // Wait for a clock cycle to see the change

	 $display("====End====");$stop;
    // Testing 10110
    Input = 5'b10110;
    #(16*HALF_PERIOD); // Wait for a clock cycle to see the change

    // B-Types

	 $display("====End====");$stop;
    // Testing 10000
    Input = 5'b10000;
    #(16*HALF_PERIOD); // Wait for a clock cycle to see the change

	 $display("====End====");$stop;
    // Testing 10001
    Input = 5'b10001;
    #(16*HALF_PERIOD); // Wait for a clock cycle to see the change

	 $display("====End====");$stop;
    // Testing 10010
    Input = 5'b10010;
    #(16*HALF_PERIOD); // Wait for a clock cycle to see the change

	 $display("====End====");$stop;
    // Testing 10011
    Input = 5'b10011;
    #(16*HALF_PERIOD); // Wait for a clock cycle to see the change

// I Types
$display("====End====");$stop;
// Testing 01000

Input = 5'b01000;

#(16*HALF_PERIOD);
 $display("====End====");$stop;
// Testing 01001

Input = 5'b01001;

#(16*HALF_PERIOD);
 $display("====End====");$stop;
// Testing 01010

Input = 5'b01010;

#(16*HALF_PERIOD);
 $display("====End====");$stop;
// Testing 01011

Input = 5'b01011;

#(16*HALF_PERIOD);
 $display("====End====");$stop;
// Testing 01100

Input = 5'b01100;

#(16*HALF_PERIOD);
 $display("====End====");$stop;
// Testing 01101

Input = 5'b01101;

#(16*HALF_PERIOD);
 $display("====End====");$stop;
// Testing 01110

Input = 5'b01110;

#(16*HALF_PERIOD);
 $display("====End====");$stop;
// Testing 10111

Input = 5'b10111;

#(16*HALF_PERIOD);
 $display("====End====");$stop;
// Testing 11000

Input = 5'b11000;

#(16*HALF_PERIOD);

// J Types: 
 $display("====End====");$stop;
// Testing 00111

Input = 5'b00111;

#(16*HALF_PERIOD);
 $display("====End====");$stop;
// Testing 11001

Input = 5'b11001;

#(16*HALF_PERIOD);
 $display("====End====");$stop;
// Testing 11010

Input = 5'b11010;

#(16*HALF_PERIOD);
 $display("====End====");$stop;
// Testing 11011

Input = 5'b11011;

#(16*HALF_PERIOD);
 $display("====End====");$stop;
// Testing 11100

Input = 5'b11100;

#(16*HALF_PERIOD);
 $display("====End====");$stop;
// Testing 10100
Input = 5'b10100;


// Testing 11111

Input = 5'b11111;

#(16*HALF_PERIOD);

$display("====End====");$stop;
// C Type: 
// Testing 11101
Input = 5'b11101;
#(16*HALF_PERIOD);
 
 $display("====End====");$stop;
// A Type:
// Testing 11110
Input = 5'b11110;
#(16*HALF_PERIOD);
    
    // End of test
    $display("====End====");$stop;
end

endmodule