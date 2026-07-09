module mod_sub #(parameter int WIDTH = 256)
(
    input  logic [WIDTH-1:0] A,
    input  logic [WIDTH-1:0] B,
    input  logic [WIDTH-1:0] modulus,
    output logic [WIDTH-1:0] result
);

// Modular subtraction without producing a negative result
always_comb begin
    if (A >= B)
        result = A - B;
    else
        result = A + modulus - B;
end

endmodule
