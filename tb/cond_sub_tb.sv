`timescale 1ns/1ps

module cond_sub_tb;

    localparam int WIDTH = 256;

    logic [WIDTH-1:0] value;
    logic [WIDTH-1:0] modulus;
    logic [WIDTH-1:0] result;
    logic [WIDTH-1:0] expected;

    cond_sub #(
        .WIDTH(WIDTH)
    ) dut (
        .value(value),
        .modulus(modulus),
        .result(result)
    );

    task automatic run_test(
        input logic [WIDTH-1:0] v,
        input logic [WIDTH-1:0] m
    );
    begin
        value    = v;
        modulus  = m;

        expected = (v >= m) ? (v - m) : v;

        #10;

        if (result !== expected) begin
            $display("--------------------------------");
            $display("FAIL");
            $display("Value    : %0d", v);
            $display("Modulus  : %0d", m);
            $display("Expected : %0d", expected);
            $display("Got      : %0d", result);
            $display("--------------------------------");
            $finish;
        end

        $display("PASS | Value=%0d Modulus=%0d Result=%0d",
                 v, m, result);
    end
    endtask

    initial begin

        $dumpfile("waves/cond_sub.vcd");
        $dumpvars(0, cond_sub_tb);

        // Value < Modulus
        run_test(256'd5, 256'd10);

        // Value == Modulus
        run_test(256'd10, 256'd10);

        // Value > Modulus
        run_test(256'd15, 256'd10);

        // Zero
        run_test(256'd0, 256'd7);

        // Large value
        run_test(256'd255, 256'd128);

        $display("--------------------------------");
        $display("All tests passed.");
        $display("--------------------------------");

        $finish;
    end

endmodule
