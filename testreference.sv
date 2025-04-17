`timescale 1ns/1ns
module butterfly_tb(
	output logic [31:0] out0,
	output logic [31:0] out1
);

    logic clk;
    initial begin
		for (integer i = 0; i < 10; i++) begin
			#5;
        clk = 0;
        #5;
		  clk = ~clk;
		end
    end

	 logic [31:0] A = 0;
	 logic [31:0] B = 0;
	 logic [31:0] W = 0;

    butterfly DUT (
		.A(A),
		.B(B),
		.W(W),
		.out0(out0),
		.out1(out1)
	);

    initial begin
        A = 0;
		  B = 0;
		  W = 0;
		  #20;
        A = {16'd100, 16'd0};  // 100 + 0j
        // = {16'd150, 16'd0};  // 150 + 0j
        B = {16'd100, 16'd0};  // 200 + 0j
        //x3 = {16'd250, 16'd0};  // 250 + 0j
		  W = 32'b00000000000000001000000000000001;
        #10;
       
        
        #10;
       
		  
		  #100;
        $stop;
    end

endmodule