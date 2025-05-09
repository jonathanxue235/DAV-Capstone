module pitch_game_top (
    input logic clk,
    input logic reset,
    input logic start_button,
    input logic [11:0] mic,


     // output horizontal and vertical counters for communication with graphics module
	output logic [9:0] hc_out,
	output logic [9:0] vc_out,

    // VGA outputs
	output logic hsync,
	output logic vsync,
    // expects 12 bits for color
	output logic [3:0] red,
	output logic [3:0] green,
	output logic [3:0] blue
    
);

logic [9:0] bird_y;

microphone mic_inst (
    // Input
    .clk(clk),
    .reset(reset),
    .mic(mic),

    // Output
    .mic_out(bird_y)
);

logic collided;
logic position_reset;

assign position_reset = reset | collided;

position position_inst (
    // Input
    .clk(clk),
    .reset(position_reset),
    .start_button(start_button),
    .bird_y(bird_y),

    // Output
    .pipe_x(pipe_x),
    .pipe_y_top(pipe_y_top),
    .pipe_y_bot(pipe_y_bot)
);

collision collision_inst (
    // Input
    .clk(clk),
    .reset(reset),
    .bird_y(bird_y),
    .pipe_x(pipe_x),
    .pipe_y_top(pipe_y_top),
    .pipe_y_bot(pipe_y_bot),

    // Output
    .collided(collided)
);

clock_divider vga_clock_divider (
    .clk(clk),
    .reset(reset),
    .divisor(2),
    .clk_out(vga_clk)
);


vga vga_inst (
    // Input
    .vgaclk(vga_clk),
    .rst(reset),
    .input_red(3'b000),
    .input_green(3'b000),
    .input_blue(2'b00),
    
    // Output
    .hc_out(hc_out),
    .vc_out(vc_out),
    .hsync(hsync),
    .vsync(vsync),
    .red(red),
    .green(green),
    .blue(blue)
);


clock_divider game_clock_divider (
    .clk(clk),
    .reset(reset),
    .divisor(2), // Change it to 10000000 when actually running, keep as 2 for tb
    .clk_out(game_clk)
);







endmodule