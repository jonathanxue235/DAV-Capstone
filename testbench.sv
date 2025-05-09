`timescale 1ns / 1ns

module testbench(
   output logic collision_out // Output from DUT
);

    // Parameters from game_controller (adjust if necessary)
    parameter int SCREEN_WIDTH    = 640;
    parameter int SCREEN_HEIGHT   = 480;
    parameter int PIPE_WIDTH      = 50;
    parameter int PIPE_GAP        = 100;
    parameter int PIPE_X_POS      = 300;
    parameter int PIPE_GAP_Y_POS  = 190;
    parameter int BIRD_WIDTH      = 20;
    parameter int BIRD_HEIGHT     = 20;
    parameter int CORDW           = $clog2(SCREEN_WIDTH);
    parameter int CORDH           = $clog2(SCREEN_HEIGHT);
    parameter logic [9:0] BIRD_X          = 500;

    // Testbench signals
    logic clk;
	 logic reset;
	 logic start_button;
	 logic [9:0] bird_y;
	 logic [9:0] pipe_x;
	 logic [9:0] pipe_y;
	 logic [1:0] state;
     logic [9:0] pipe_y_bot;
     logic [9:0] pipe_y_top;
     assign pipe_y_bot = pipe_y - PIPE_GAP;
     assign pipe_y_top = pipe_y + PIPE_GAP;

    // Instantiate the Device Under Test (DUT)
    game_controller #(
        .SCREEN_WIDTH(SCREEN_WIDTH),
        .SCREEN_HEIGHT(SCREEN_HEIGHT),
        .PIPE_WIDTH(PIPE_WIDTH),
        .PIPE_GAP(PIPE_GAP),
        .BIRD_WIDTH(BIRD_WIDTH),
        .BIRD_HEIGHT(BIRD_HEIGHT),
		  .BIRD_X(BIRD_X)
    ) dut (
        .clk(clk),
        .reset(reset),
        .start_button(start_button),
        .bird_y(bird_y),
		  .pipe_x_internal(pipe_x),
		  .pipe_y_bot(pipe_y_bot),
          .pipe_y_top(pipe_y_top),
        .collision_out(collision_out),
		 .state(state) // Connect the output
    );

    // Clock generation
    initial begin
        clk = 1;
		  for (integer i = 0; i < 250; i++) begin
			#1;
        clk = 0;
        #1;
		  clk = 1;
		end
    end

    // Test sequence
    initial begin
        // Initialize signals
        reset = 1;
        start_button = 0;
        bird_y = SCREEN_HEIGHT / 2; // Start bird in the middle

        // Apply reset
        #2 reset = 0; // Assert reset for 10ns
        #2 reset = 1; // Deassert reset

        // Wait for DUT to stabilize after reset
        #4;

        // Press start button
       // $display("INFO: Pressing start button at time %0t", $time);
        start_button = 1;
        #2; // Hold start button for one clock cycle
        start_button = 0;

        // Add more stimulus and checks here
        // Example: Change bird_y based on simulated input
        #20 bird_y = bird_y - 10;
        #20 bird_y = bird_y + 20;

        // Monitor collision
        //$display("INFO: Collision detected at time %0t", $time);

        // Simulation timeout
        #100;
       // $display("INFO: Simulation timeout reached.");
        $stop;
    end

endmodule
