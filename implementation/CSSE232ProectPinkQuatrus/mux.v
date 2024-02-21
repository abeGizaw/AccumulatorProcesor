//////////////////////////////////////////////////////////////////////////////////
// Company: Pink
// Engineer: 
// 
// Create Date:    02/3/2024 
// Module Name:    Test Bench ALU
// Project Name: 
//
// Revision 0.01 - File Created
// Additional Comments: 
//		//-----------------------------------------------------
//		// Design Name : mux_using_case
//		// File Name   : mux_using_case.v
//		// Function    : 2:1 Mux using Case
//		// Coder       : Deepak Kumar Tala
//		//-----------------------------------------------------
//
//////////////////////////////////////////////////////////////////////////////////


module  mux(
din_0      , // Mux first input
din_1      , // Mux Second input
sel           , // Select input
mux_out,   // Mux output
CLK
);
input din_0, din_1, sel ;
output mux_out;
reg  mux_out;
input CLK;
always @ (sel or din_0 or din_1)
begin : MUX
 case(sel ) 
    1'b0 : mux_out = din_0;
    1'b1 : mux_out = din_1;
 endcase 
end

endmodule