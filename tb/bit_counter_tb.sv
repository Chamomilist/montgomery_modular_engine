`timescale 1ns/1ps

module bit_counter_tb;

    localparam int WIDTH = 256;

    logic clk;
    logic rst;
    logic enable;

    logic [$clog2(WIDTH)-1:0] bit_index;
    logic done;

    bit_counter #(
        .WIDTH(WIDTH)
    ) dut (
        .clk(clk),
        .rst(rst),
        .enable(enable),
        .bit_index(bit_index),
        .done(done)
    );

    // 10 ns clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin

        $dumpfile("waves/bit_counter.vcd");
        $dumpvars(0, bit_counter_tb);

        // Reset
        rst = 1;
        enable = 0;

        #12;
        rst = 0;

        // Count for 5 clocks
        enable = 1;
        repeat (5) @(posedge clk);

        // Pause for 2 clocks
        enable = 0;
        repeat (2) @(posedge clk);

        // Resume for 3 clocks
        enable = 1;
        repeat (3) @(posedge clk);

        $display("--------------------------------");
        $display("Bit Counter Test Completed");
        $display("--------------------------------");

        $finish;

    end

endmodule
