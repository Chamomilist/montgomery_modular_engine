`timescale 1ns/1ps

module adder_tb;

    localparam int WIDTH = 256;

    logic [WIDTH-1:0] A;
    logic [WIDTH-1:0] B;
    logic [WIDTH-1:0] sum;
    logic             carry_out;

    logic [WIDTH:0] expected;

    adder #(
        .WIDTH(WIDTH)
    ) dut (
        .A(A),
        .B(B),
        .sum(sum),
        .carry_out(carry_out)
    );

    task automatic run_test(
        input logic [WIDTH-1:0] a,
        input logic [WIDTH-1:0] b
    );
    begin
        A = a;
        B = b;

        expected = a + b;

        #10;

        if ({carry_out, sum} !== expected) begin
            $display("--------------------------------");
            $display("FAIL");
            $display("A         : %0d", a);
            $display("B         : %0d", b);
            $display("Expected  : %0d", expected);
            $display("Got       : {%0d, %0d}", carry_out, sum);
            $display("--------------------------------");
            $finish;
        end

        $display("PASS | A=%0d B=%0d Sum=%0d Carry=%0d",
                 a, b, sum, carry_out);
    end
    endtask

    initial begin

        $dumpfile("waves/adder.vcd");
        $dumpvars(0, adder_tb);

        // Basic addition
        run_test(256'd5, 256'd10);

        // Zero
        run_test(256'd0, 256'd0);

        // Carry generation
        run_test({WIDTH{1'b1}}, 256'd1);

        // Large values
        run_test(256'd255, 256'd128);

        // Equal values
        run_test(256'd100, 256'd100);

        $display("--------------------------------");
        $display("All tests passed.");
        $display("--------------------------------");

        $finish;
    end

endmodule
