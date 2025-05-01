`timescale 1ns / 1ps

module testbench;

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
    logic collision_out; // Output from DUT

    // Instantiate the Device Under Test (DUT)
    game_controller #(
        .SCREEN_WIDTH(SCREEN_WIDTH),
        .SCREEN_HEIGHT(SCREEN_HEIGHT),
        .PIPE_WIDTH(PIPE_WIDTH),
        .PIPE_GAP(PIPE_GAP),
        .PIPE_X_POS(PIPE_X_POS),
        .PIPE_GAP_Y_POS(PIPE_GAP_Y_POS),
        .BIRD_WIDTH(BIRD_WIDTH),
        .BIRD_HEIGHT(BIRD_HEIGHT),
        .CORDW(CORDW),
        .CORDH(CORDH),
        .BIRD_X(BIRD_X)
    ) dut (
        .clk(clk),
        .reset(reset),
        .start_button(start_button),
        .bird_y(bird_y),
        .collision_out(collision_out) // Connect the output
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns period (100 MHz clock)
    end

    // Test sequence
    initial begin
        // Initialize signals
        reset = 1;
        start_button = 0;
        bird_y = SCREEN_HEIGHT / 2; // Start bird in the middle

        // Apply reset
        #10 reset = 0; // Assert reset for 10ns
        #10 reset = 1; // Deassert reset

        // Wait for DUT to stabilize after reset
        #20;

        // Press start button
        $display("INFO: Pressing start button at time %0t", $time);
        start_button = 1;
        #10; // Hold start button for one clock cycle
        start_button = 0;

        // Add more stimulus and checks here
        // Example: Change bird_y based on simulated input
        #100 bird_y = bird_y - 10;
        #100 bird_y = bird_y + 20;

        // Monitor collision
        @(posedge collision_out);
        $display("INFO: Collision detected at time %0t", $time);

        // Simulation timeout
        #10000;
        $display("INFO: Simulation timeout reached.");
        $finish;
    end

    // Optional: Dump waveforms
    initial begin
        $dumpfile("testbench.vcd");
        $dumpvars(0, testbench);
    end

endmodule
