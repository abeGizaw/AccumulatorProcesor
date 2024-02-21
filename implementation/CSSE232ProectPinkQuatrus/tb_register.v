// Regsiter Test bench 

module tb_register();

reg r;
reg CLK;
reg rw;
reg signed [15:0]d;

wire signed [15:0]dout;

parameter HALF_PERIOD = 50;
integer cycle_counter = 0;
integer counter = 0;
integer failures = 0;

register uut(
	.Input(d),
	.Reset(r),
	.CLK(CLK),
	.Output(dout),
	.ResetTo(),
	.RegWrite(rw)
);


initial begin
    CLK = 0;
    forever begin
        #(HALF_PERIOD);
        CLK = ~CLK;
    end
end


initial begin
	//-----PC TEST 1-----
	//Testing PC 
	$display("Testing register");
	r = 1;
	counter = 0;
	cycle_counter = 0;
	#(2*HALF_PERIOD);
	r = 0;
	d = 0; //we are testing counting up
	
	#(3*HALF_PERIOD);
	if(!(d == dout && d == 0))begin
		failures = failures + 1;
		$display("%t (COUNT UP) Error at cycle %d, output = %d, expecting = %d", $time, cycle_counter, dout, failures);
	end
	#(HALF_PERIOD);
	
	r = 0;
	d = 1;
	rw = 1;
	
	#(3*HALF_PERIOD);
	if(!(d == dout && d == 1)) begin
		cycle_counter = cycle_counter + 1;
		failures = failures + 1;
		$display("%t (COUNT UP) Error at cycle %d, output = %d, expecting = %d", $time, cycle_counter, dout, failures);
	end
	#(HALF_PERIOD);
	
	r = 0;
	d = 1;
	rw = 1;
	#(3*HALF_PERIOD);
	
	if(!(d == dout && d == 1)) begin
		cycle_counter = cycle_counter + 1;
		failures = failures + 1;
		$display("%t (COUNT UP) Error at cycle %d, output = %d, expecting = %d", $time, cycle_counter, dout, failures);
	end
	#(HALF_PERIOD);
	
	
	r = 0;
	d = 2;
	rw = 0;
	#(3*HALF_PERIOD);
	
	if((d == dout && d == 2)) begin
		cycle_counter = cycle_counter + 1;
		failures = failures + 1;
		$display("%t (COUNT UP) Error at cycle %d, output = %d, expecting = %d", $time, cycle_counter, dout, failures);
	end
	#(HALF_PERIOD);
	
	
	
	
	$stop;
end
endmodule 