//////////////////////////////////////////////////////////////////////////////////
// Company: Pink
// Engineer: 
// 
// Create Date:    01/22/2024 
// Module Name:    Test Bench ALU
// Project Name: 
//
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module tb_alu();

	reg [15:0] InputA;
   reg [15:0] InputB;
	reg [3:0] ALUOp;
   reg [15:0] ALUOut;
	wire ShouldBranch;
   reg CLK;
	
	integer Expected = 0;
	parameter HALF_PERIOD = 50;
	integer cycle_counter = 0;
	integer counter = 0;
	integer failures = 0;

alu uut(
	.InputA(InputA),
   .InputB(InputB),
	.ALUOp(ALUOp),
   .ALUOut(ALUOut),
	.ShouldBranch(ShouldBranch),
   .CLK(CLK)
);

	initial begin
		 CLK = 0;
		 forever begin
			  #(HALF_PERIOD);
			  CLK = ~CLK;
		 end
	end
	
initial begin
	
	//Case 0
	InputA = 1;
	InputB = 1;
	ALUOp = 0000;
	#(3*HALF_PERIOD);
	Expected = 2;
	if(Expected != ALUOut)begin 
		$display("Error");
	end
	
	//Case 1
	InputA = 1;
	InputB = 1;
	ALUOp = 0001;
	#(3*HALF_PERIOD);
	Expected = 0;
	if(Expected != ALUOut)begin 
		$display("Error");
	end
	
	//Case 2
	InputA = 1;
	InputB = 1;
	ALUOp = 0010;
	#(3*HALF_PERIOD);
	Expected = 2;
	if(Expected != ALUOut)begin 
		$display("Error");
	end
	
	//Case 3
	InputA = 1;
	InputB = 1;
	ALUOp = 0011;
	#(3*HALF_PERIOD);
	Expected = 0;
	if(Expected != ALUOut)begin 
		$display("Error");
	end
	
	//Case 4
	InputA = 1;
	InputB = 1;
	ALUOp = 0100;
	#(3*HALF_PERIOD);
	Expected = 0;
	if(Expected != ALUOut)begin 
		$display("Error");
	end
	
	//Case 5
	InputA = 1;
	InputB = 1;
	ALUOp = 0101;
	#(3*HALF_PERIOD);
	Expected = (1 | 1);
	if(Expected != ALUOut)begin 
		$display("Error");
	end
	
	//Case 6
	InputA = 1;
	InputB = 1;
	ALUOp = 0110;
	#(3*HALF_PERIOD);
	Expected = (1 & 1);
	if(Expected != ALUOut)begin 
		$display("Error");
	end
	
	//Case 7
	InputA = 1;
	InputB = 1;
	ALUOp = 0111;
	#(3*HALF_PERIOD);
	Expected = (1 ^ 1);
	if(Expected != ALUOut)begin 
		$display("Error");
	end
	
	//Case 8
	InputA = 1;
	InputB = 1;
	ALUOp = 1000;
	#(3*HALF_PERIOD);
	Expected = 1;
	if(Expected != ALUOut)begin 
		$display("Error");
	end
	
	//Case 9
	InputA = 1;
	InputB = 1;
	ALUOp = 1001;
	#(3*HALF_PERIOD);
	Expected = 0;
	if(Expected != ALUOut)begin 
		$display("Error");
	end
	
	//Case 10
	InputA = 1;
	InputB = 1;
	ALUOp = 1010;
	#(3*HALF_PERIOD);
	Expected = 0;
	if(Expected != ALUOut)begin 
		$display("Error");
	end
	
	//Case 11
	InputA = 1;
	InputB = 1;
	ALUOp = 1011;
	#(3*HALF_PERIOD);
	Expected = 1;
	if(Expected != ALUOut)begin 
		$display("Error");
	end
	
	//Case 12
	InputA = 1;
	InputB = 1;
	ALUOp = 1101;
	#(3*HALF_PERIOD);
	Expected = 0;
	if(Expected != ALUOut)begin 
		$display("Error");
	end

	//Case 13
	InputA = 1;
	InputB = 1;
	ALUOp = 1110;
	#(3*HALF_PERIOD);
	Expected = 1;
	if(Expected != ALUOut)begin 
		$display("Error");
	end
	
	
	$stop;
end
endmodule