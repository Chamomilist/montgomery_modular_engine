`timescale 1ns/1ps

module mod_sub_tb;

    localparam int WIDTH = 256;

    logic [WIDTH-1:0] A;
    logic [WIDTH-1:0] B;
    logic [WIDTH-1:0] modulus;
    logic [WIDTH-1:0] result;
    logic [WIDTH-1:0] expected;

    mod_sub #(
        .WIDTH(WIDTH)
    ) dut (
        .A(A),
        .B(B),
        .modulus(modulus),
        .result(result)
    );

    task automatic run_test(
        input logic [WIDTH-1:0] a,
        input logic [WIDTH-1:0] b,
        input logic [WIDTH-1:0] m
    );
    begin
        A       = a;
        B       = b;
        modulus = m;

        expected = (a >= b) ? (a - b) : (a + m - b);

        #10;

        if (result !== expected) begin
            $display("--------------------------------");
            $display("FAIL");
            $display("A        : %0d", a);
            $display("B        : %0d", b);
            $display("Modulus  : %0d", m);
            $display("Expected : %0d", expected);
            $display("Got      : %0d", result);
            $display("--------------------------------");
            $finish;
        end

        $display("PASS | A=%0d B=%0d Modulus=%0d Result=%0d",
                 a, b, m, result);
    end
    endtask

    initial begin

        $dumpfile("waves/mod_sub.vcd");
        $dumpvars(0, mod_sub_tb);

        // A > B
        run_test(256'd15, 256'd10, 256'd20);

        // A == B
        run_test(256'd10, 256'd10, 256'd20);

        // A < B
        run_test(256'd5, 256'd10, 256'd20);

        // Zero
        run_test(256'd0, 256'd0, 256'd17);

        // Wraparound
        run_test(256'd2, 256'd15, 256'd17);

        $display("--------------------------------");
        $display("All tests passed.");
        $display("--------------------------------");

        $finish;
    end

endmodule
