module collision (
	input logic [9:0] BIRD_WIDTH,
	input logic [9:0] BIRD_HEIGHT,
	input logic [9:0] PIPE_WIDTH,
	input logic [9:0] PIPE_HEIGHT,
   input logic [9:0] BIRD_X,
   input logic [9:0] bird_y,
   input logic [9:0] pipe_x,
   input logic [9:0] pipe_y,
   output logic collision_out
);
logic collision;
always_comb begin
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