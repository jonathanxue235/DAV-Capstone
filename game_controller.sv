module game_controller #(
    parameter logic [9:0] SCREEN_WIDTH    = 640, // Screen width in pixels
    parameter logic [9:0] SCREEN_HEIGHT   = 480, // Screen height in pixels
    parameter logic [9:0] PIPE_WIDTH      = 30,  // Pipe width in pixels
    parameter logic [9:0] PIPE_GAP        = 100, // Vertical gap between pipes
    parameter logic [9:0] BIRD_WIDTH      = 20,  // Bird width in pixels
    parameter logic [9:0] BIRD_HEIGHT     = 20,  // Bird height in pixels
  	 parameter logic [9:0] BIRD_X          = 200
) (
    input logic clk,
    input logic reset,
    input logic start_button,
    input logic [9:0] bird_y,
    // input logic [9:0] pipe_x,
    // input logic [9:0] pipe_y,
  	output logic collision_out,
    output logic [9:0] pipe_x_internal,
    output logic [9:0] pipe_y_bot,
    output logic [9:0] pipe_y_top
);
localparam logic [1:0] STATE_IDLE = 2'b00;
localparam logic [1:0] STATE_PLAY = 2'b01;
localparam logic [1:0] STATE_GAME_OVER = 2'b10;

logic [1:0] state;
logic [1:0] next_state;

// Declare internal signals for pipe position
// logic [9:0] pipe_x_internal;
logic [9:0] pipe_y_internal;

logic [9:0] pipe_height;
//logic collision_out;

assign pipe_y_top = pipe_y_internal - PIPE_GAP;
assign pipe_y_bot = pipe_y_internal + PIPE_GAP;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= STATE_IDLE;
    end
    else begin
        state <= next_state;
    end
end

always_ff @(posedge clk) begin
    if (!reset) begin
			pipe_x_internal <= SCREEN_WIDTH;
			pipe_y_internal <= pipe_height;
    end
    else begin
        if (state == STATE_PLAY) begin
             if (pipe_x_internal > 0) begin
                 pipe_x_internal <= pipe_x_internal - 20;
             end else begin
                 pipe_x_internal <= SCREEN_WIDTH;
                 pipe_y_internal <= pipe_height;
             end
        end
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
            if (collision_out) begin
                next_state = STATE_GAME_OVER;
            end
            else begin
                next_state = STATE_PLAY;
            end
        end
        STATE_GAME_OVER: begin
            if (!reset) begin
                next_state = STATE_IDLE;
            end
            else begin
                next_state = STATE_GAME_OVER;
            end
        end
        default: next_state = STATE_IDLE;
    endcase
end

// TODO: PRNG for pipe height generation
prng pipe_heights(.clk(clk), .reset(reset), .prng_out(pipe_height));

// TOOD: Collision module
collision collision_module(
	.BIRD_WIDTH(BIRD_WIDTH),
	.BIRD_HEIGHT(BIRD_HEIGHT),
	.PIPE_WIDTH(PIPE_WIDTH),
	.PIPE_HEIGHT(PIPE_GAP),
   .BIRD_X(BIRD_X),
   .bird_y(bird_y),
   .pipe_x(pipe_x_internal),
   .pipe_y(pipe_y_internal),
   .collision_out(collision_out)
);

endmodule