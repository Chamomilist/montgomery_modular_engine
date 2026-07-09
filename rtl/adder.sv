module adder #(parameter int WIDTH = 256)
(
    input logic [WIDTH-1:0] A,
    input logic [WIDTH-1:0] B,
    output logic [WIDTH-1:0] sum,
    output logic carry_out
);

logic [WIDTH:0] result;

assign result = A + B;
assign sum = result[WIDTH-1:0];
assign carry_out = result[WIDTH];

endmodule
