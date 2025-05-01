module pitch_top #(
    parameter int SCREEN_WIDTH    = 640, // Screen width in pixels
    parameter int SCREEN_HEIGHT   = 480, // Screen height in pixels
    parameter int PIPE_WIDTH      = 50,  // Pipe width in pixels
    parameter int PIPE_GAP        = 100, // Vertical gap between pipes
    parameter int PIPE_X_POS      = 300, // Horizontal position of the left edge of the pipes
    parameter int PIPE_GAP_Y_POS  = 190, // Vertical position of the top edge of the gap (0 = top)
    parameter int BIRD_WIDTH      = 20,  // Bird width in pixels
    parameter int BIRD_HEIGHT     = 20,  // Bird height in pixels
    // Calculate coordinate widths based on screen dimensions
    parameter int CORDW           = $clog2(SCREEN_WIDTH),
    parameter int CORDH           = $clog2(SCREEN_HEIGHT),
  	parameter logic [9:0] BIRD_X          = 500
)
(
    input logic clk,
    input [11:0] mic

    output logic hsync,
	output logic vsync,
    // expects 12 bits for color
	output logic [3:0] red,
	output logic [3:0] green,
	output logic [3:0] blue,
    
    output logic collision_out
);
    logic start_button;
    logic [9:0] bird_x;
    logic [9:0] bird_y;
    logic [9:0] pipe_x;
    logic [9:0] pipe_y_top;
    logic [9:0] pipe_y_bot;

    game_controller game_controller(
        .clk(game_clk),
        .reset(1'b0),
        .start_button(start_button),
        .bird_y(bird_y),
        .collision_out(collision_out),
        .pipe_x_internal(pipe_x),
        .pipe_y_top(pipe_y_top),
        .pipe_y_bot(pipe_y_bot)
    );
    
    assign bird_y = 300;
    
    logic [2:0] input_red;
    logic [2:0] input_green;
    logic [1:0] input_blue;

    logic vga_clk;
    logic game_clk;
    clock_divider #(
        .DIVISOR(2)
    ) vga_clk(
        .clk(clk),
        .reset(1'b0),
        .clk_out(vga_clk)
    );
    

    clock_divider #(
        .DIVISOR(10000000)
    ) game_clk(
        .clk(clk),
        .reset(1'b0),
        .clk_out(game_clk)
    );

    vga vga(
        .vga_clk(vga_clk),
        .rst(1'b0),
        .input_red(input_red),
        .input_green(input_green),
        .input_blue(input_blue),
        .hc_out(xpos),
        .vc_out(ypos),
        .hsync(hsync),
        .vsync(vsync),
        .red(red),
        .green(green),
        .blue(blue)
    );
    
    always_comb begin
        if (bird_x - 20 <= xpos && xpos >= bird_x + 20 && bird_y - 20 <= ypos && bird_y + 20 >= ypos) begin
            input_red = 3'b111;
            input_green = 3'b000;
            input_blue = 2'b00;
        end
        else if (pipe_x - 50 <= xpos && xpos >= pipe_x + 50 && (pipe_y_bot >= ypos || pipe_y_top <= ypos)) begin
            input_red = 3'b000;
            input_green = 3'b111;
            input_blue = 2'b00;
        end
        else begin
            input_red = 3'b111;
            input_green = 3'b111;
            input_blue = 2'b11;
        end
    end

endmodule