//////////////////////////////////////////////////////////////////////////////////
// Company: Pink
// Engineer: 
// 
// Create Date:    01/22/2024 
// Module Name:    Register File
// Project Name: 
//
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module register_file(
    input [1:0] R1,
    input [1:0] R2,
    input [1:0] Rd,
    input Reset,
	 input RegWrite,
	 input [15:0] WriteData,
    output reg [15:0] OutputA,
    output reg [15:0] OutputB,
    input CLK
    );
	 
	 
reg [15:0] Reg0, Reg1, Reg2, Reg3;

always @ (posedge(CLK))
begin
	if (Reset != 1) begin 
		
		if (RegWrite == 1) begin
			case (Rd)
				0: Reg0 <= WriteData;
				1: Reg1 <= WriteData;
				2: Reg2 <= WriteData;
				3: Reg3 <= WriteData;
				default: Reg0 <= 16'h6969;
			endcase
		end
	end else begin
		Reg0 <= 0000;
		Reg1 <= 0000;
		Reg2 <= 0000;
		Reg3 <= 0000;
	end
end


always @ (R1, R2, Reset)
begin
		case (R1)
			0: OutputA = Reg0;
			1: OutputA = Reg1;
			2: OutputA = Reg2;
			3: OutputA = Reg3;
			default: OutputA = 660;
		endcase
			
		case (R2)
			0: OutputB = Reg0;
			1: OutputB = Reg1;
			2: OutputB = Reg2;
			3: OutputB = Reg3;
			default: OutputB = 660;
		endcase
end
		
endmodule
