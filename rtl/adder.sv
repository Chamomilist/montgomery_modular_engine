module adder #(parameter int WIDTH = 256)
(
    input logic [WIDTH-1:0] A,
    input logic [WIDTH-1:0] B,
    output logic [WIDTH-1:0] sum,
    output logic carry_out
);

logic [WIDTH:0] result;

always_comb begin
    result = A + B;
    sum = result[WIDTH-1:0];
    carry_out = result[WIDTH];
end

endmodule
