module data_register #(parameter int WIDTH = 256)
(
    input logic clk,
    input logic rst,
    input logic load,
    input logic [WIDTH-1:0] d,
    output logic [WIDTH-1:0] q
);

// Generic parameterized register with synchronous load
always_ff @(posedge clk or posedge rst) begin
    if (rst)
        q <= '0;
    else if (load)
        q <= d;
end

endmodule
