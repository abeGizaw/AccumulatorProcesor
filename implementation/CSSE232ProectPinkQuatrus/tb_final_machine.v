//////////////////////////////////////////////////////////////////////////////////
// Company: Pink
// Engineer: 
// 
// Create Date:    02/16/2024 
// Module Name:  Final Machine Test Bench
// Project Name: 
//
// Revision 0.01 - Created file
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module tb_final_mahcine;

//Data input
	reg [15:0] Inputio;
	
	
//Signal input
	reg              CLK;
	
	//Output
	wire [15:0] Outputio;
	wire 			Overflow;
	wire 			Output;
	
	parameter HALF_PERIOD = 50;
	integer line_counter = 0;
	integer address = 0;
	integer failures = 0;
	integer cycle_counter = 0;
	integer currentSP = 16'h0000;
	integer tempALU = 16'h0;


final_machine final_machine_inst
(
	.Inputio(Inputio) ,	// input [15:0] Inputio
	.CLK(CLK) ,	// input  CLK
	.Outputio(Outputio) ,	// output [15:0] Outputio
	.Overflow(Overflow) ,	// output  Overflow
	.Output(Output) 	// output  Output
);


initial begin
	 CLK = 1;
	 forever begin
		  #(HALF_PERIOD);
		  CLK = ~CLK;
		  if (CLK == 0) begin
			cycle_counter = cycle_counter + 1;
		end
	 end
end

initial begin
	Inputio = 0;

	//$display("End of test. Total failure: %d", failures);
	//$stop;
end

always @(Output)
begin
	if (Output == 1) begin
		$display("Got output: %d", Outputio);
		$stop;
	end
end


always @(final_machine_inst.control_unit_inst.current_state)
begin
/*
	if (final_machine_inst.control_unit_inst.current_state == 0)
		$display("At Restart cycle");
	else if (final_machine_inst.control_unit_inst.current_state == 1) begin
		$display("At Fetch cycle, fetching line %d", final_machine_inst.headless_machine_inst.inte_stage1_part1_inst.PC.Output/2);
		$stop;
	end
	else if (final_machine_inst.control_unit_inst.current_state == 2) begin
		#(1.1*HALF_PERIOD);
		$display("At Decode cycle, got instruction %h", final_machine_inst.headless_machine_inst.inte_stage1_part1_inst.IR.Output);
		$stop;
	end
	else
		$display("At cycle %d", final_machine_inst.control_unit_inst.current_state);
*/
end
endmodule