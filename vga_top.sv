module miniALU_top(
	input [9:0] switches,
	output [9:0] leds,
	output [7:0] displayBits [5:0]
);
	assign leds = switches;
	
	logic [19:0] result;
	miniALU alu(
		.op1(switches[9:6]),
		.op2(switches[5:2]),
		.operation(switches[1]),
		.sign(switches[0]),
		.result(result)
	);
	
	displayEncoder dispEnc(
		.result(result),
		.displayBits(displayBits)
	);
	

endmodule
