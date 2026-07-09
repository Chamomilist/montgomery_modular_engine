module cond_sub #(parameter int WIDTH = 256)
(
    input logic [WIDTH-1:0] value,
    input logic [WIDTH-1:0] modulus,
    output logic [WIDTH-1:0] result
);

// If value >= modulus, subtract the modulus
// Else, pass the value through unchanged
always_comb begin
    if (value >= modulus)
        result = value - modulus;
    else
        result = value;
end

endmodule
