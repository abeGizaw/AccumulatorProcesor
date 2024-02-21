//////////////////////////////////////////////////////////////////////////////////
// Company: Pink
// Engineer: 
// 
// Create Date:    01/22/2024 
// Module Name:    Test Bench Register File
// Project Name: 
//
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module tb_register_file();
 
reg [1:0] R1;
reg [1:0] R2;
reg [1:0] Rd;
reg Reset;
reg RegWrite;
reg [15:0] WriteData;
wire signed [15:0] OutputA;
wire signed [15:0] OutputB;
reg CLK;

   
parameter HALF_PERIOD = 50;
integer cycle_counter = 0;
integer counter = 0;
integer failures = 0;
integer expected;

initial begin
    CLK = 0;
    forever begin
        #(HALF_PERIOD);
        CLK = ~CLK;
    end
end

register_file uut(
	.R1(R1),
	.R2(R2),
	.Rd(Rd),
	.Reset(Reset),
	.RegWrite(RegWrite),
	.WriteData(WriteData),
	.OutputA(OutputA),
	.OutputB(OutputB),
	.CLK(CLK)
);


initial begin

	Reset = 1;
	WriteData = 1;
	#(HALF_PERIOD)
	repeat (4) begin 
		#(2*HALF_PERIOD)
		if(WriteData == 1)begin
			if(OutputA != R1 && OutputB != R2) 
				$display("Error!");
		end 
	end
	
	Reset = 0;
	RegWrite = 0;
	R1 = 0;
	R2 = 1;
	#(3*HALF_PERIOD);
	expected = 0;
	if (OutputA != expected) begin
		failures = failures + 1;
		$display("%t (COUNT UP) Wrong output forom Reg0, output = %d, expecting = %d", $time, expected, OutputA);
	end
	expected = 0;
	if (OutputB != expected) begin
		failures = failures + 1;
		$display("%t (COUNT UP) Wrong output forom Reg1, output = %d, expecting = %d", $time, expected, OutputB);
	end
	#(1*HALF_PERIOD);
	 
	R1 = 2;
	R2 = 3;
	#(3*HALF_PERIOD);
	expected = 0;
	if (OutputA != expected) begin
		failures = failures + 1;
		$display("%t (COUNT UP) Wrong output forom Reg2, output = %d, expecting = %d", $time, expected, OutputA);
	end
	expected = 0;
	if (OutputB != expected) begin
		failures = failures + 1;
		$display("%t (COUNT UP) Wrong output forom Reg3, output = %d, expecting = %d", $time, expected, OutputB);
	end
	#(1*HALF_PERIOD);
	
		
	RegWrite = 1;
	WriteData = 10;
	Rd = 0;
	#(2*HALF_PERIOD);
	
	
	Reset = 0;
	RegWrite = 0;
	R1 = 0;
	R2 = 1;
	#(3*HALF_PERIOD);
	expected = 10;
	if (OutputA != expected) begin
		failures = failures + 1;
		$display("%t (COUNT UP) Wrong output forom Reg0, output = %d, expecting = %d", $time, expected, OutputA);
	end
	expected = 0;
	if (OutputB != expected) begin
		failures = failures + 1;
		$display("%t (COUNT UP) Wrong output forom Reg1, output = %d, expecting = %d", $time, expected, OutputB);
	end
	#(1*HALF_PERIOD);
	 
	R1 = 2;
	R2 = 3;
	#(3*HALF_PERIOD);
	expected = 0;
	if (OutputA != expected) begin
		failures = failures + 1;
		$display("%t (COUNT UP) Wrong output forom Reg2, output = %d, expecting = %d", $time, expected, OutputA);
	end
	expected = 0;
	if (OutputB != expected) begin
		failures = failures + 1;
		$display("%t (COUNT UP) Wrong output forom Reg3, output = %d, expecting = %d", $time, expected, OutputB);
	end
	#(1*HALF_PERIOD);
	
	
	RegWrite = 0;
	WriteData = 11;
	Rd = 1;
	#(2*HALF_PERIOD);
	
	
	Reset = 0;
	RegWrite = 0;
	R1 = 0;
	R2 = 1;
	#(3*HALF_PERIOD);
	expected = 10;
	if (OutputA != expected) begin
		failures = failures + 1;
		$display("%t (COUNT UP) Wrong output forom Reg0, output = %d, expecting = %d", $time, expected, OutputA);
	end
	expected = 0;
	if (OutputB != expected) begin
		failures = failures + 1;
		$display("%t (COUNT UP) Wrong output forom Reg1, output = %d, expecting = %d", $time, expected, OutputB);
	end
	#(1*HALF_PERIOD);
	 
	R1 = 2;
	R2 = 3;
	#(3*HALF_PERIOD);
	expected = 0;
	if (OutputA != expected) begin
		failures = failures + 1;
		$display("%t (COUNT UP) Wrong output forom Reg2, output = %d, expecting = %d", $time, expected, OutputA);
	end
	expected = 0;
	if (OutputB != expected) begin
		failures = failures + 1;
		$display("%t (COUNT UP) Wrong output forom Reg3, output = %d, expecting = %d", $time, expected, OutputB);
	end
	#(1*HALF_PERIOD);
				
	
		
		$stop;		

	//Test Reset

end
endmodule
	 