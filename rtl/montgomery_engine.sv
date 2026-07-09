module montgomery_engine #(parameter int WIDTH = 256)
(
    input logic clk,
    input logic rst,
    input logic start,

    input logic [WIDTH-1:0] A,
    input logic [WIDTH-1:0] B,
    input logic [WIDTH-1:0] N,

    output logic [WIDTH-1:0] result,
    output logic done
);

// Internal Signals

logic [WIDTH-1:0] datapath_result;

logic [WIDTH-1:0] reg_A;
logic [WIDTH-1:0] reg_B;
logic [WIDTH-1:0] reg_N;
logic [WIDTH-1:0] reg_T;

logic current_bit;
logic sum_is_odd;
logic carry_out;
logic counter_done;

logic [$clog2(WIDTH)-1:0] bit_index;

logic load_A;
logic load_B;
logic load_N;
logic load_T;

logic counter_enable;
logic compute_enable;


// Controller FSM

controller_fsm controller (
    .clk(clk),
    .rst(rst),
    .start(start),
    .counter_done(counter_done),

    .load_A(load_A),
    .load_B(load_B),
    .load_N(load_N),
    .load_T(load_T),

    .counter_enable(counter_enable),
    .compute_enable(compute_enable),

    .done(done)
);

// Bit Counter

bit_counter #(.WIDTH(WIDTH))
counter (
    .clk(clk),
    .rst(rst),
    .enable(counter_enable),

    .bit_index(bit_index),
    .done(counter_done)
);

// Register Bank

register_bank #(.WIDTH(WIDTH))
registers (
    .clk(clk),
    .rst(rst),

    .load_A(load_A),
    .load_B(load_B),
    .load_N(load_N),
    .load_T(load_T),

    .A_in(A),
    .B_in(B),
    .N_in(N),
    .T_in(datapath_result),

    .bit_index(bit_index),

    .A(reg_A),
    .B(reg_B),
    .N(reg_N),
    .T(reg_T),

    .current_bit(current_bit)
);

// Montgomery Datapath

montgomery_datapath #(.WIDTH(WIDTH))
datapath (
    .A(reg_A),
    .N(reg_N),
    .T(reg_T),

    .current_bit(current_bit),

    .result(datapath_result),
    .carry_out(carry_out),
    .sum_is_odd(sum_is_odd)
);

// Conditional subtraction

cond_sub #(.WIDTH(WIDTH))
final_reduction (
    .value(datapath_result),
    .modulus(reg_N),
    .result(result)
);

endmodule
