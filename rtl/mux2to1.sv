module mux2to1 #(parameter int WIDTH = 256)
(
    input logic [WIDTH-1:0] A,
    input logic [WIDTH-1:0] B,
    input logic sel,
    output logic [WIDTH-1:0] out
);
always_comb begin
    if (sel)
        out = B;
    else
        out = A;
    end

endmodule
