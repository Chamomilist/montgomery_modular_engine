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
logic [WIDTH-1:0] sum_plus_N;

// NEW: carry-out of each internal add
// Must be kept — the running sum can briefly need one more bit than WIDTH, before the final shift brings it back down
// Dropping these truncates the result whenever N is large
logic sum_carry; // NEW: carry out T + operand
logic sum_plus_N_carry; // NEW: carry out sum + N

logic [WIDTH:0] adjusted_sum; // widened by 1 bit to hold the carry

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
    .carry_out(sum_carry) // CHANGED: before it was .carry_out(carry_out)
);

// NEW: preserves the original output port's behavior
assign carry_out = sum_carry;

// Check if sum is ODD
assign sum_is_odd = sum[0];

// Adjust sum based on condition
adder #(.WIDTH(WIDTH))
adder_N_inst (
    .A(sum),
    .B(N),
    .sum(sum_plus_N),
    .carry_out(sum_plus_N_carry) // CHANGED: before it was .carry_out()
);

always_comb begin
    if (sum_is_odd)
        adjusted_sum = {sum_plus_N_carry, sum_plus_N};
    else
        adjusted_sum = {sum_carry, sum};
end

// Shift right after adjusting the sum
assign result = adjusted_sum[WIDTH:1];

endmodule
