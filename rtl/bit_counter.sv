module bit_counter #(parameter int WIDTH = 256)
(
    input  logic clk,
    input  logic rst,
    input  logic enable,
    input logic clear,

    output logic [$clog2(WIDTH)-1:0] bit_index,
    output logic done
);

always_ff @(posedge clk or posedge rst) begin
    if (rst)
        bit_index <='0;
    else if (clear)
        bit_index <= '0;
    else if (enable && !done)
        bit_index <= bit_index + 1'b1;
end

always_comb begin
    done = (bit_index == ($clog2(WIDTH))'(WIDTH-1));
end

// bit_index is 8 bits wide
// WIDTH-1 is a 32-bit integer by default
// Casting WIDTH-1 to the width of bit_index removes any width-mismatch warnings

endmodule
