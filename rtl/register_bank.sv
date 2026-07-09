module register_bank #(parameter int WIDTH = 256)
(
    input logic clk,
    input logic rst,

    input logic load_A,
    input logic load_B,
    input logic load_N,
    input logic load_T,

    input logic [WIDTH-1:0] A_in,
    input logic [WIDTH-1:0] B_in,
    input logic [WIDTH-1:0] N_in,
    input logic [WIDTH-1:0] T_in,

    input logic [$clog2(WIDTH)-1:0] bit_index,

    output logic [WIDTH-1:0] A,
    output logic [WIDTH-1:0] B,
    output logic [WIDTH-1:0] N,
    output logic [WIDTH-1:0] T,

    output logic current_bit
);


data_register #(.WIDTH(WIDTH))
reg_A (
    .clk(clk),
    .rst(rst),
    .load(load_A),
    .d(A_in),
    .q(A)
);

data_register #(.WIDTH(WIDTH))
reg_B (
    .clk(clk),
    .rst(rst),
    .load(load_B),
    .d(B_in),
    .q(B)
);

data_register #(.WIDTH(WIDTH))
reg_N (
    .clk(clk),
    .rst(rst),
    .load(load_N),
    .d(N_in),
    .q(N)
);

data_register #(.WIDTH(WIDTH))
reg_T (
    .clk(clk),
    .rst(rst),
    .load(load_T),
    .d(T_in),
    .q(T)
);

// Read the current bit of B selected by the bit counter
assign current_bit = B[bit_index];

endmodule
