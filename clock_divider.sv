module clock_divider #(
    parameter int DIVISOR = 2
) (
    input logic clk,
    output logic enable
);

logic [31:0] count;

always_ff @(posedge clk) begin
    if (reset) begin
        clk_div <= 0;
    end
    else begin
        if (count == DIVISOR - 1) begin
            enable <= 1;
            count <= 0;
        end
        else begin
            count <= count + 1;
            enable <= 0;
        end
    end
end


endmodule