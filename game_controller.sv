module game_controller #(
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
    parameter int CORDH           = $clog2(SCREEN_HEIGHT)
) (
    input logic clk,
    input logic reset,
    input logic start_button,
    input logic [9:0] bird_y,
    input logic [9:0] pipe_x,
    input logic [8:0] pipe_y,
);
localparam logic [1:0] STATE_IDLE = 2'b00;
localparam logic [1:0] STATE_PLAY = 2'b01;
localparam logic [1:0] STATE_GAME_OVER = 2'b10;

logic [1:0] state;
logic [1:0] next_state;

logic [8:0] pipe_height;
input logic collision_out;

always_ff @(posedge clk or negedge reset) begin
    if (reset) begin
        state <= STATE_IDLE;
    end
    else begin
        state <= next_state;
    end
end

always_ff @(posedge clk or negedge reset) begin
    if (reset) begin
        pipe_x <= SCREEN_WIDTH;
        pipe_y <= pipe_height;
    end
    else begin
        pipe_x <= pipe_x - PIPE_WIDTH;
    end
end

always_comb begin
    case (state)
        STATE_IDLE: begin
            if (start_button) begin
                next_state = STATE_PLAY;
            end
            else begin
                next_state = STATE_IDLE;
            end
        end
        STATE_PLAY: begin
            // TODO: Replace with collision module
            if (pipe_x == 0) begin
                next_state = STATE_GAME_OVER;
            end
            else begin
                next_state = STATE_PLAY;
            end
        end
        STATE_GAME_OVER: begin
            if (reset) begin
                next_state = STATE_IDLE;
            end
            else begin
                next_state = STATE_GAME_OVER;
            end
        end
    endcase
end

// TODO: PRNG for pipe height generation
// prng pipe_height(clk, reset, pipe_height);

// TOOD: Collision module
// collision collision_module(clk, reset, bird_y, pipe_x, pipe_y, collision_out);



endmodule