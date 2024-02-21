module tb_reg_immediate_generator();

reg [15:0] Input;
reg CLK;
wire [15:0] Output;
immediate_generator uut (
    .Input(Input),
    .Output(Output),
    .CLK(CLK)
);

reg [15:0] reg1;
wire [15:0] result;
assign result = Output + reg1;

integer HALF_PERIOD = 50;

// Clock 
initial begin
    CLK = 0;
    forever begin
        #(HALF_PERIOD);
        CLK = ~CLK;
    end
end


initial begin
    Input = 0;
    reg1 = 16'h0005;
    #(2*HALF_PERIOD);
    
    // SEImmGenOutput (assuming sign-extended immediate)
    Input = 16'h0088;
    #10; // Wait for a clock cycle to see the change
    if (result !== 1) begin
        $display("Error: SEImmGenOutput + reg1 result incorrect. Expected: %h, Got: %h", EXPECTED_RESULT_1, result);
    end
    
    // MEImmGenOutput (assuming another type of immediate generation)
    Input = 16'hXXXX;
    #10;
    if (result !== 1) begin
        $display("Error: MEImmGenOutput + reg1 result incorrect. Expected: %h, Got: %h", EXPECTED_RESULT_2, result);
    end
    
    // End of test
    $finish;
end

endmodule
