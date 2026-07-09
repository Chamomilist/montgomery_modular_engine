`timescale 1ns/1ps

module montgomery_engine_tb;

    localparam int WIDTH = 256;

    logic clk;
    logic rst;
    logic start;

    logic [WIDTH-1:0] A;
    logic [WIDTH-1:0] B;
    logic [WIDTH-1:0] N;

    logic [WIDTH-1:0] result;
    logic done;

    montgomery_engine #(
        .WIDTH(WIDTH)
    ) dut (
        .clk(clk),
        .rst(rst),
        .start(start),

        .A(A),
        .B(B),
        .N(N),

        .result(result),
        .done(done)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin

        $dumpfile("waves/montgomery_engine.vcd");
        $dumpvars(0, montgomery_engine_tb);

        // Initial values
        rst   = 1;
        start = 0;

        A = 256'd7;
        B = 256'd11;
        N = 256'd13;

        // Release reset
        #20;
        rst = 0;

        // Start computation
        #10;
        start = 1;

        #10;
        start = 0;

        // Wait until engine finishes
        wait(done);

        $display("--------------------------------");
        $display("Engine Finished");
        $display("A      = %0d", A);
        $display("B      = %0d", B);
        $display("N      = %0d", N);
        $display("Result = %0d", result);
        $display("--------------------------------");

        #20;
        $finish;

    end

endmodule
