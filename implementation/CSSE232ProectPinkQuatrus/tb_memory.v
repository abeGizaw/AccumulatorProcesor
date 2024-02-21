//////////////////////////////////////////////////////////////////////////////////
// Company: Pink
// Engineer: 
// 
// Create Date:    02/08/2024 
// Module Name:    Test Bench Memory
// Project Name: 
//
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module tb_memory();

	reg [15:0] DataIn;
   reg [15:0] AddressIn;
   reg CLK, MemoryWrite, MemoryRead;
	wire [15:0] Output;
	wire Overflow;
	
	parameter HALF_PERIOD = 50;
	integer line_counter = 0;
	integer address = 0;
	integer failures = 0;

memory memory_inst
(
	.Data(DataIn) ,	// input [15:0] Data
	.Address(AddressIn) ,	// input [15:0] Address
	.MemoryWrite(MemoryWrite) ,	// input  MemoryWrite
	.MemoryRead(MemoryRead) ,	// input  MemoryRead
	.CLK(CLK) ,	// input  CLK
	.Output(Output) , 	// output [15:0] Output
	.Overflow(Overflow)
);


	initial begin
		 CLK = 0;
		 forever begin
			  #(HALF_PERIOD);
			  CLK = ~CLK;
		 end
	end
	
initial begin
	MemoryRead = 1;
	repeat (30) begin
		AddressIn = address;
		address = address + 2;
		line_counter = line_counter + 1;
		#(2*HALF_PERIOD);
		$display("Line %d: %h", line_counter, Output);
	end
	
	//Overflow test
	AddressIn = 16'hFFFF;
	#(2*HALF_PERIOD);
	if (Overflow != 1) begin
		$display("Overflow not detected!");
		failures = failures + 1;
	end
	
	//Write test
	MemoryWrite = 1;
	MemoryRead = 0;
	AddressIn = 16'h0000;
	DataIn = 16'h1145;
	#(2*HALF_PERIOD);
	
	$display("End of test. Total failure: %d", failures);
	$stop;
end
endmodule