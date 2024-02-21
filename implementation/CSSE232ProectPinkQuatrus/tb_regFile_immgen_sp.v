module tb_regFile_immgen_sp();

reg [1:0] OperandSrc_tb;
reg [2:0] ReturnSrc_tb;
reg [1:0] RegFileSrc_tb;
reg [15:0] IRInput_tb;
reg [15:0] MDRInput_tb;
reg [15:0] ALUSrcBInput_tb;
reg [15:0] ALUOutInput_tb;
reg RegWrite_tb;
reg SPWrite_tb;
reg Reset_tb;
reg CLK;
wire [15:0] ALUSrcAOut_tb;
wire [15:0] ALUSrcBOut_tb;
wire [15:0] SPOut_tb;
wire [15:0] ImmGenValOut_tb;

// Parameters to keep track of test status
parameter HALF_PERIOD = 50;
integer cycle_counter = 0;
integer counter = 0;
integer failures = 0;
integer expected;
reg [15:0] rdRegister; //for testing in task




// UUT instantiation
regFile_immgen_sp uut (
  .OperandSrc(OperandSrc_tb),
  .ReturnSrc(ReturnSrc_tb),
  .RegFileSrc(RegFileSrc_tb),
  .IRInput(IRInput_tb),
  .MDRInput(MDRInput_tb),
  .ALUSrcBInput(ALUSrcBInput_tb),
  .ALUOutInput(ALUOutInput_tb),
  .RegWrite(RegWrite_tb),
  .SPWrite(SPWrite_tb),
  .Reset(Reset_tb),
  .CLK(CLK),
  .ALUSrcAOut(ALUSrcAOut_tb),
  .ALUSrcBOut(ALUSrcBOut_tb),
  .SPOut(SPOut_tb),
  .ImmGenValOut(ImmGenValOut_tb)
);

// Clock definition
initial begin
    CLK = 0;
    forever begin
        #(HALF_PERIOD);
        CLK = ~CLK;
    end
end


// Test cases here
initial begin
   // Initial signal setup
   Reset_tb = 1;
   OperandSrc_tb = 0;
   ReturnSrc_tb = 0;
   RegFileSrc_tb = 0;
   IRInput_tb = 0;
   MDRInput_tb = 0;
   ALUSrcBInput_tb = 0;
   ALUOutInput_tb = 0;
   RegWrite_tb = 0;
   SPWrite_tb = 0;

   // Apply reset
   #(HALF_PERIOD * 2);
   Reset_tb = 0;
   #(HALF_PERIOD * 2);
   
   
   //BATCH 1
   batch1tests(2'b00,       // operand_src
               16'h0000,    // ir_input add r0 0x1E00
               0,           // reg_write
               16'h0000,    // expected_alu_src_a
               16'h0000,    // expected_alu_src_b
               16'h07FF,    // expected_sp
               16'h1E00);   // expected_imm_gen_val
					
	batch1tests(2'b01,       // operand_src
               16'h3dab,    // addi r1 123  
               0,           // reg_write
               16'h0000,    // expected_alu_src_a
               16'h0000,    // expected_alu_src_b
               16'h07FF,    // expected_sp
               16'h007b);   // expected_imm_gen_val
					
	batch1tests(2'b00,       // operand_src
               16'h7d31,    // bne r1 r2 0x007C -> 0111110 10 01 10001 -> 7d31. Jumping 62 lines from 0x00
               0,           // reg_write
               16'h0000,    // expected_alu_src_a
               16'h0000,    // expected_alu_src_b
               16'h07FF,    // expected_sp
               16'h007C);   // expected_imm_gen_val
					
	batch1tests(2'b00,       // operand_src
               16'h00f4,    // jal 0x000E -> 00000000111 10100 -> 00f4
               0,           // reg_write
               16'h0000,    // expected_alu_src_a
               16'h0000,    // expected_alu_src_b
               16'h07FF,    // expected_sp
               16'h000e);   // expected_imm_gen_val
					
	batch1tests(2'b00,       // operand_src
               16'h017d,    // swap r3 r2
               0,           // reg_write
               16'h0000,    // expected_alu_src_a
               16'h0000,    // expected_alu_src_b
               16'h07FF,    // expected_sp
               16'hFFFF);   // expected_imm_gen_val
					
	batch1tests(2'b00,       // operand_src
               16'h0e9e,    // alter r3 r0 r1 -
               0,           // reg_write
               16'h0000,    // expected_alu_src_a
               16'h0000,    // expected_alu_src_b
               16'h07FF,    // expected_sp
               16'hFFFF);   // expected_imm_gen_val
					
  batchWritetests(2'b00,		// operand_src
						16'h018b, 	// ir_input addi r0 3
						2'b11,		// regFileSrc
						3'b000,		// write on inst[6:5]
						1,				//regWrite
						2'b11,		// expected output: r0 = 3
						16'h07FF,	// expected_sp
						16'hFFFF);	// expected_imm_gen_val
						
	batchWritetests(2'b00,		// operand_src
						16'h018b, 	// ir_input addi r0 3
						2'b11,		// regFileSrc
						3'b001,		// write on inst[10:9]
						1,				//regWrite
						2'b11,		// expected output: r0 = 3
						16'h07FF,	// expected_sp
						16'hFFFF);	// expected_imm_gen_val
				
	batchWritetests(2'b00,		// operand_src
						16'h018b, 	// ir_input addi r0 3
						2'b11,		// regFileSrc
						3'b010,		// write on inst[8:6]
						1,				//regWrite
						2'b11,		// expected output: r0 = 3
						16'h07FF,	// expected_sp
						16'hFFFF);	// expected_imm_gen_val
		
	batchWritetests(2'b00,		// operand_src
						16'h018b, 	// ir_input addi r0 3
						2'b11,		// regFileSrc
						3'b011,		// Reg[2]
						1,				//regWrite
						2'b11,		// expected output: r0 = 3
						16'h07FF,	// expected_sp
						16'hFFFF);	// expected_imm_gen_val
  

  
  $stop;		

end
always @ (ReturnSrc_tb, rdRegister, uut.reg_file.Reg0,uut.reg_file.Reg1,uut.reg_file.Reg2,uut.reg_file.Reg3) begin
// Deciding on Rd for Reg File based on ReturnSrc
			case (ReturnSrc_tb)
			3'b000: 
			  begin
				 case (IRInput_tb[6:5])
					2'b00: rdRegister = uut.reg_file.Reg0;
					2'b01: rdRegister = uut.reg_file.Reg1;
					2'b10: rdRegister = uut.reg_file.Reg2;
					2'b11: rdRegister = uut.reg_file.Reg3;
					default: rdRegister = 16'h6969; 
				 endcase
			  end
			3'b001: 
			  begin
				 case (IRInput_tb[10:9])
					2'b00: rdRegister = uut.reg_file.Reg0;
					2'b01: rdRegister = uut.reg_file.Reg1;
					2'b10: rdRegister = uut.reg_file.Reg2;
					2'b11: rdRegister = uut.reg_file.Reg3;
					default: rdRegister = 16'h6969; 
				 endcase
			  end
			3'b010: 
			  begin
				 case (IRInput_tb[8:7])
					2'b00: rdRegister = uut.reg_file.Reg0;
					2'b01: rdRegister = uut.reg_file.Reg1;
					2'b10: rdRegister = uut.reg_file.Reg2;
					2'b11: rdRegister = uut.reg_file.Reg3;
					default: rdRegister = 16'h6969; 
				 endcase
			  end
			3'b011: 
			  begin
				 rdRegister = uut.reg_file.Reg2;
			  end 
			3'b100: 
			  begin
				 rdRegister = uut.reg_file.Reg1;
			  end
			3'b101: 
			  begin
				 rdRegister = uut.reg_file.Reg0;
			  end  
			
			default: rdRegister = 16'h6969;
			endcase

end
task batchWritetests;
	input [1:0] operand_src;
	input [15:0] ir_input;
	input [1:0] regFile_src;
	input [2:0] return_src;
	input reg_write;
	input [15:0] expected_output;
	input [15:0] expected_sp;
	input [15:0] expected_imm_gen_val;
	
	begin
			// Set the inputs
			OperandSrc_tb = operand_src;
			IRInput_tb = ir_input;
			RegFileSrc_tb = regFile_src;
			ReturnSrc_tb = return_src;
			RegWrite_tb = reg_write;
			
			
			// Wait for the values to propagate
			#(HALF_PERIOD * 6);
			if (rdRegister !== expected_output) begin
				$display("Error: RegFile Write expected %h, received %h", expected_output, rdRegister);
				failures = failures + 1;
			end
			
			if (SPOut_tb !== expected_sp) begin
				$display("Error: SPOut_tb expected %h, received %h", expected_sp, SPOut_tb);
				failures = failures + 1;
			end
			if (ImmGenValOut_tb !== expected_imm_gen_val && expected_imm_gen_val != 16'hFFFF) begin
				$display("Error: ImmGenValOut_tb expected %h, received %h", expected_imm_gen_val, ImmGenValOut_tb);
				failures = failures + 1;
			end
	end
endtask


task batch1tests;
	input [1:0] operand_src;
	input [15:0] ir_input;
	input reg_write;
	input [15:0] expected_alu_src_a;
	input [15:0] expected_alu_src_b;
	input [15:0] expected_sp;
	input [15:0] expected_imm_gen_val;
	begin
			// Set the inputs
			OperandSrc_tb = operand_src;
			IRInput_tb = ir_input;
			RegWrite_tb = reg_write;
		
			// Wait for the values to propagate
			#(HALF_PERIOD * 4);
		
			if (ALUSrcAOut_tb !== expected_alu_src_a) begin
				$display("Error: ALUSrcAOut_tb expected %h, received %h", expected_alu_src_a, ALUSrcAOut_tb);
				failures = failures + 1;
			end
			if (ALUSrcBOut_tb !== expected_alu_src_b) begin
				$display("Error: ALUSrcBOut_tb expected %h, received %h", expected_alu_src_b, ALUSrcBOut_tb);
				failures = failures + 1;
			end
			if (SPOut_tb !== expected_sp) begin
				$display("Error: SPOut_tb expected %h, received %h", expected_sp, SPOut_tb);
				failures = failures + 1;
			end
			if (ImmGenValOut_tb !== expected_imm_gen_val && expected_imm_gen_val != 16'hFFFF) begin
				$display("Error: ImmGenValOut_tb expected %h, received %h", expected_imm_gen_val, ImmGenValOut_tb);
				failures = failures + 1;
			end
	end
endtask



// For debugging
initial begin
  $monitor("Time: %t, CLK: %b, OperandSrc: %b, ReturnSrc: %b, IRInput: %h, Failures: %d",
			  $time, CLK, OperandSrc_tb, ReturnSrc_tb, IRInput_tb, failures);
end

endmodule 