//////////////////////////////////////////////////////////////////////////////////
// Company: Pink
// Engineer: 
// 
// Create Date:    01/22/2024 
// Module Name:    ALU
// Project Name: 
//
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module alu(
    input [15:0] InputA,
    input [15:0] InputB,
	 input [3:0] ALUOp,
    output reg [15:0] ALUOut,
	 output reg ShouldBranch,
    input CLK
    );

always @ (ALUOp, InputA, InputB)
begin
	case (ALUOp)
		4'b0000: ALUOut = InputA + InputB;
		4'b0001: ALUOut = InputA - InputB;
		4'b0010: ALUOut = InputA <<< InputB;
		4'b0011: ALUOut = InputA >>> InputB;
		4'b0100: ALUOut = InputA >> InputB;
		4'b0101: ALUOut = InputA | InputB;
		4'b0110: ALUOut = InputA & InputB;
		4'b0111: ALUOut = InputA ^ InputB;
		4'b1000: 
			begin
//				$display("%b == I%b", InputA, InputB);
				if (InputA == InputB)
					ShouldBranch  = 16'b1;
				else
					ShouldBranch  = 16'b0;
			end
		4'b1001: 
			begin
//				$display("%b != I%b", InputA, InputB);
				if (InputA != InputB) 
					ShouldBranch  = 1;
				else
					ShouldBranch  = 16'b0;
			end
		4'b1010: ShouldBranch = InputA < InputB;
		4'b1011: ShouldBranch = InputA >= InputB;
		4'b1100: ALUOut = 16'b0;
		4'b1101: ALUOut = 16'b1;
		4'b1110: ALUOut = InputA;
		4'b1111: ALUOut = InputA + InputB + 16'b1000;
	endcase
end

endmodule
