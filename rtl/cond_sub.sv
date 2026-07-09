module cond_sub #(parameter int WIDTH = 256)
(
    input logic [WIDTH-1:0] value,
    input logic [WIDTH-1:0] modulus,
    output logic [WIDTH-1:0] result
);

// Performs one conditional modular reduction
// Assumes:
// 0 <= A < modulus
// 0 <= B < modulus
always_comb begin
    if (value >= modulus)
        result = value - modulus;
    else
        result = value;
end

endmodule
