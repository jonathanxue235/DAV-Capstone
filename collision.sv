module collision #(
    parameter int WIDTH = 10,
    parameter int HEIGHT = 10,
  	parameter int BIRD_WIDTH      = 20,  // Bird width in pixels
    parameter int BIRD_HEIGHT     = 20,  // Bird height in pixels
  	parameter int PIPE_WIDTH	  = 30,
  	parameter int PIPE_HEIGHT	  = 100,
	parameter logic [9:0] BIRD_X = 200
) (
    input logic clk,
    input logic reset,
    input logic [WIDTH-1:0] bird_x,
    input logic [HEIGHT-1:0] bird_y,
    input logic [WIDTH-1:0] pipe_x,
    input logic [HEIGHT-1:0] pipe_y,
    output logic collision_out
);
logic collision;
always_comb begin
    if (!reset) begin
        collision_out = 0;
    end
	 if (BIRD_X > pipe_x - PIPE_WIDTH && BIRD_X < pipe_x + PIPE_WIDTH) begin
		if (bird_y + BIRD_HEIGHT < pipe_y - PIPE_HEIGHT && bird_y - BIRD_HEIGHT > pipe_y + PIPE_HEIGHT) begin
			collision_out = 0;
		end
		else begin
			collision_out = 1;
		end
	 end
	 else begin
		collision_out = 0;
	end
end

endmodule