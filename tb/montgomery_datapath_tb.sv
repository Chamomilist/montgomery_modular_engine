`timescale 1ns/1ps

module montgomery_datapath_tb;

    localparam int WIDTH = 256;

    logic [WIDTH-1:0] A;
    logic [WIDTH-1:0] N;
    logic [WIDTH-1:0] T;

    logic             current_bit;

    logic [WIDTH-1:0] result;
    logic             carry_out;
    logic             sum_is_odd;

    logic [WIDTH:0] expected;

    montgomery_datapath #(
        .WIDTH(WIDTH)
    ) dut (
        .A(A),
        .N(N),
        .T(T),
        .current_bit(current_bit),
        .result(result),
        .carry_out(carry_out),
        .sum_is_odd(sum_is_odd)
    );

    task automatic run_test(
        input logic [WIDTH-1:0] a,
        input logic [WIDTH-1:0] n,
        input logic [WIDTH-1:0] t,
        input logic             bit_in
    );
    begin
        A = a;
        N = n;
        T = t;
        current_bit = bit_in;

        // Expected datapath behavior
        if (bit_in)
            expected = t + a;
        else
            expected = {1'b0, t}; // Extend T by one bit because 'expected' is WIDTH+1 bits

        if (expected[0])
            expected = expected + n;

        expected = expected >> 1;

        #10;

        if (result !== expected[WIDTH-1:0]) begin
            $display("--------------------------------");
            $display("FAIL");
            $display("A            : %0d", a);
            $display("N            : %0d", n);
            $display("T            : %0d", t);
            $display("Current Bit  : %0d", bit_in);
            $display("Expected     : %0d", expected);
            $display("Got          : %0d", result);
            $display("--------------------------------");
            $finish;
        end

        $display("PASS | Bit=%0d Result=%0d", bit_in, result);
    end
    endtask

    initial begin

        $dumpfile("waves/montgomery_datapath.vcd");
        $dumpvars(0, montgomery_datapath_tb);

        // Don't add A
        run_test(256'd7, 256'd13, 256'd10, 1'b0);

        // Add A
        run_test(256'd7, 256'd13, 256'd10, 1'b1);

        // Odd T without adding A
        run_test(256'd5, 256'd9, 256'd3, 1'b0);

        // Odd T with adding A
        run_test(256'd5, 256'd9, 256'd3, 1'b1);

        $display("--------------------------------");
        $display("All tests passed.");
        $display("--------------------------------");

        $finish;

    end

endmodule
