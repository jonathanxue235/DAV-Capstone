module prng #(
    parameter int WIDTH = 10
) (
    input logic clk,
    input logic reset,
    output logic [WIDTH-1:0] prng_out
);

always_ff @(posedge clk or negedge reset) begin
    if (reset) begin
        prng_out <= 0;
    end
end

endmodule