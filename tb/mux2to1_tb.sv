`timescale 1ns/1ps

module mux2to1_tb;

    localparam int WIDTH = 256;

    logic [WIDTH-1:0] A;
    logic [WIDTH-1:0] B;
    logic sel;
    logic [WIDTH-1:0] out;
    logic [WIDTH-1:0] expected;

    mux2to1 #(
        .WIDTH(WIDTH)
    ) dut (
        .A(A),
        .B(B),
        .sel(sel),
        .out(out)
    );

    task automatic run_test(
        input logic [WIDTH-1:0] a,
        input logic [WIDTH-1:0] b,
        input logic             s
    );
    begin
        A = a;
        B = b;
        sel = s;

        expected = s ? b : a;

        #10;

        if (out !== expected) begin
            $display("--------------------------------");
            $display("FAIL");
            $display("A        : %0d", a);
            $display("B        : %0d", b);
            $display("Select   : %0d", s);
            $display("Expected : %0d", expected);
            $display("Got      : %0d", out);
            $display("--------------------------------");
            $finish;
        end

        $display("PASS | Sel=%0d Out=%0d", s, out);
    end
    endtask

    initial begin

        $dumpfile("waves/mux2.vcd");
        $dumpvars(0, mux2to1_tb);

        // Select A
        run_test(256'd10, 256'd20, 1'b0);

        // Select B
        run_test(256'd10, 256'd20, 1'b1);

        // Both equal
        run_test(256'd100, 256'd100, 1'b0);

        // Large values
        run_test(256'd255, 256'd128, 1'b1);

        $display("--------------------------------");
        $display("All tests passed.");
        $display("--------------------------------");

        $finish;
    end

endmodule
