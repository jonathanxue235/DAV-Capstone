module prng #(
    parameter int WIDTH = 10
) (
    input logic clk,
    input logic reset,
    output logic [WIDTH-1:0] prng_out
);
assign prng_out = 500;

endmodule