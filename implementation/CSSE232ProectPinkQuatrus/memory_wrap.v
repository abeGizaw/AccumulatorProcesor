//////////////////////////////////////////////////////////////////////////////////
// Company: Pink
// Engineer: 
// 
// Create Date:    02/6/2024 
// Module Name:   Memory Wrap
// Project Name: 
//
// Revision 1.02 - Wrapping the memory template
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module memory_wrap
(
	input [15:0] Data,
	input [15:0] Address,
	input MemoryWrite, MemoryRead, CLK, Reset,
	output [15:0] Output,
	output reg Overflow
);
	
memory memory_inst
(
	.data(Data) ,	// input [DATA_WIDTH-1:0] data_sig
	.addr(Address[10:1]) ,	// input [ADDR_WIDTH-1:0] addr_sig
	.we(MemoryWrite) ,	// input  we_sig
	.clk(CLK) ,	// input  clk_sig
	.q(Output) 	// output [DATA_WIDTH-1:0] q_sig
);



endmodule
