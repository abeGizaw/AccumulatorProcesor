module regFile_immgen_sp (
	input [1:0] OperandSrc,
   input [2:0] ReturnSrc,
   input [1:0] RegFileSrc,
   input [15:0] IRInput,
   input [15:0] MDRInput,
	input [15:0] RegBInput,
	input [15:0] ALUOutInput,
	input RegWrite,
   input SPWrite,
	input Reset,
	input CLK,
   output wire [15:0] RegAOut,
   output wire [15:0] RegBOut,
   output wire [15:0] SPOut,
   output wire [15:0] ImmGenValOut
);



// Instance of Immediate Generator
immediate_generator imm_gen(
  .Input(IRInput),
  .Output(ImmGenValOut),
  .CLK(CLK)
);




// Wires for Reg File Inputs
reg [1:0] R1Input;
reg [1:0] RdInput;
reg [15:0] WriteDataInput;
wire signed [15:0] OutputA;
wire signed [15:0] OutputB;



always @ (IRInput[6:5], OperandSrc)
begin
	// Deciding on R1 for Reg File
	case (OperandSrc)
		2'b00: R1Input = IRInput[6:5]; 
		2'b01: R1Input = 2'b00;
		2'b10: R1Input = 2'b01;
		2'b11: R1Input = 2'b10;
		default: R1Input = 2'b00; // Default
	endcase
end
	

always @ (IRInput, ReturnSrc)
begin
	// Rd for Reg File
	case (ReturnSrc)
		3'b000: RdInput = IRInput[6:5]; 
		3'b001: RdInput = IRInput[10:9]; 
		3'b010: RdInput = IRInput[8:7]; 
		3'b011: RdInput = 2'b10;
		3'b100: RdInput = 2'b01;
		3'b101: RdInput = 2'b00;
		default: RdInput = 2'b00; // Default 
	endcase
end

always @ (MDRInput, RegBInput, ALUOutInput,ImmGenValOut, RegFileSrc)
begin
	// Write Data for Reg File
	case (RegFileSrc)
		2'b00: WriteDataInput = MDRInput;
		2'b01: WriteDataInput = RegBInput;
		2'b10: WriteDataInput = ALUOutInput;
		2'b11: WriteDataInput = ImmGenValOut;
		default: WriteDataInput = 16'b0; // Default
	endcase
	
end



// Instance of Register File
register_file reg_file (
  .R1(R1Input),
  .R2(IRInput[8:7]),
  .Rd(RdInput),
  .Reset(Reset),
  .RegWrite(RegWrite),
  .WriteData(WriteDataInput),
  .OutputA(RegAOut),
  .OutputB(RegBOut),
  .CLK(CLK)
);


// Instance for SP 
register sp_reg (
  .Input(ALUOutInput),
  .Reset(Reset),
  .RegWrite(SPWrite),
  .Output(SPOut),
  .ResetTo(16'h0801),
  .CLK(CLK)
);
endmodule