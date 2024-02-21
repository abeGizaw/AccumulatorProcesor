//Mux TB

module tb_mux();

reg in0;
reg in1;
reg selector;
wire out;
reg CLK;

parameter HALF_PERIOD = 50;

Mux UUT (
    .din_0(in0),
    .din_1(in1),
    .sel(selector),
    .mux_out(out),
	 .CLK(CLK)
);

//Clock
initial begin
    CLK = 0;
    forever begin
        #(HALF_PERIOD);
        CLK = ~CLK;
    end
end



initial begin
    // Initialize Inputs
    in0 = 0;
    in1 = 0;
    selector = 0;

    #(2 * HALF_PERIOD);
    
     // Test Case 1: sel = 0, din_0 = 0, din_1 = 1
	in0 = 0;
	in1 = 1; 
	selector = 0;
   #10;
	if(out != 0)begin
		$display("Test 1: Error");
	end

	#(2 * HALF_PERIOD);
    
   // Test Case 2: sel = 1, din_0 = 0, din_1 = 1
   in0 = 0;
	in1 = 1; 
	selector = 1;
	#10;
	if(out != 1)begin
		$display("Test 2 Error");
	end

    
    $display("Tests Done");
    // Complete the simulation
    $finish;
end

endmodule
