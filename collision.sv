module collision #(
    parameter int WIDTH = 10,
    parameter int HEIGHT = 10
) (
    input logic clk,
    input logic reset,
    input logic [WIDTH-1:0] bird_x,
    input logic [HEIGHT-1:0] bird_y,
    input logic [WIDTH-1:0] pipe_x,
    input logic [HEIGHT-1:0] pipe_y,
    output logic collision_out
);

always_ff @(posedge clk or negedge reset) begin
    if (reset) begin
        collision_out <= 0;
    end
    else begin
        collision_out <= 0;
    end
end

always_comb begin
    if (reset) begin
        collision_out = 0;
    end
    if (bird_x + BIRD_WIDTH > pipe_x && bird_x < pipe_x + PIPE_WIDTH &&
        (bird_y < pipe_y || bird_y > pipe_y + PIPE_HEIGHT)) begin
        collision_out = 1;
    end
    else begin
        collision_out = 0;
    end
end

endmodule