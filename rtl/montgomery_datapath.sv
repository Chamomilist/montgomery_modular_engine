module montgomery_datapath #(parameter int WIDTH = 256)
(
    input logic [WIDTH-1:0] A,
    input logic [WIDTH-1:0] N,
    input logic [WIDTH-1:0] T,
    input logic current_bit,

    output logic [WIDTH-1:0] result,
    output logic carry_out,
    output logic sum_is_odd
);

// Wire between MUX and adder
logic [WIDTH-1:0] operand;
// Internal wire between adder and shifter
logic [WIDTH-1:0] sum;
// Intermediate results used during Montgomery reduction
logic [WIDTH-1:0] adjusted_sum;
logic [WIDTH-1:0] sum_plus_N;

// Select whether to add A or N
mux2to1 #(.WIDTH(WIDTH))
operand_mux (
    .A('0),
    .B(A),
    .sel(current_bit),
    .out(operand)
);

// Add the selected operand to T
adder #(.WIDTH(WIDTH))
adder_inst (
    .A(T),
    .B(operand),
    .sum(sum),
    .carry_out(carry_out)
);

// Check if sum is ODD
assign sum_is_odd = sum[0];

// Adjust sum based on condition
adder #(.WIDTH(WIDTH))
adder_N_inst (
    .A(sum),
    .B(N),
    .sum(sum_plus_N),
    .carry_out()
);

always_comb begin
    if (sum_is_odd)
        adjusted_sum = sum_plus_N;
    else
        adjusted_sum = sum;
end

// Shift right after adjusting the sum
assign result = adjusted_sum >> 1;

endmodule
