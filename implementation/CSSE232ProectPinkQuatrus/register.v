//////////////////////////////////////////////////////////////////////////////////
// Company: Pink
// Engineer: 
// 
// Create Date:    01/22/2024 
// Module Name:    Register
// Project Name: 
//
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module register(
    input [15:0] Input,
    input Reset,
	 input RegWrite,
    output reg [15:0] Output,
	 input [15:0] ResetTo,
    input CLK
    );

always @ (posedge(CLK))
begin
	if (Reset != 1) begin
		if(RegWrite == 1)
			Output = Input;
	end
	else
		Output = ResetTo;
end

endmodule
