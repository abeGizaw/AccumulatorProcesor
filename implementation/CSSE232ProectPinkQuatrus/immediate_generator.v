//////////////////////////////////////////////////////////////////////////////////
// Company: Pink
// Engineer: 
// 
// Create Date:    01/22/2024 
// Module Name:    Immediate Generator
// Project Name: 
//
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module immediate_generator(
    input [15:0] Input,
    output reg [15:0] Output,
    input CLK
    );
	
wire [6:0] branchBits = Input[15:9]; // Extract bits [15:9] for potential branching 
wire [7:0] shiftedBranchBits = {branchBits, 1'b0}; // Shift left by one bit for potential branching 

always @ (Input)
begin
	//R type hard-coded address extend
	if (Input[4:0] <= 5 | Input[4:0] == 15 | Input[4:0] == 21 | Input[4:0] == 22) begin
		Output[15:9] = 7'b0000000;
		Output[8:0] = Input[15:7];
	end
	//I type sign extended
	else if (Input[4:0] == 6 | Input[4:0] >= 8 & Input[4:0] <= 14 | Input[4:0] == 23 | Input[4:0] == 24) begin
		if (Input[15] == 1)
			Output[15:8] = 8'b11111111;
		else
			Output[15:8] = 8'b00000000;
		Output[7:0] = Input[14:7];
	end
	//B type sign extended & shift left by 1
	else if (Input[4:0] >= 16 & Input[4:0] <= 19) begin
		Output = { {8{shiftedBranchBits[7]}}, shiftedBranchBits };
	end
	//jal (J type) sign extended & shift left by 1
	else if (Input[4:0] == 20) begin
		if (Input[15] == 1)
			Output[15:11] = 5'b11111;
		else
			Output[15:11] = 5'b00000;
		Output[10:1] = Input[14:5];
		Output[0] = 0;
	end
	//lui (J type) shift left by 5
	else if (Input[4:0] == 27) begin
		Output[15:5] = Input[15:5];
		Output[4:0] = 5'b00000;
	end
	//movesp & input (J type) sign extended
	else if (Input[4:0] == 25 | Input[4:0] == 26) begin
		if (Input[15] == 1)
			Output[15:10] = 6'b111111;
		else
			Output[15:10] = 6'b000000;
		Output[9:0] = Input[14:5];
	end
	else
		Output = 6969;
end
endmodule
