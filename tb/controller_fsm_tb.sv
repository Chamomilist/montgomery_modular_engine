`timescale 1ns/1ps

module controller_fsm_tb;

    logic clk;
    logic rst;
    logic start;

    logic done;

    controller_fsm dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .done(done)
    );

    // 10 ns clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin

        $dumpfile("waves/controller_fsm.vcd");
        $dumpvars(0, controller_fsm_tb);

        // Reset
        rst   = 1;
        start = 0;

        #12;
        rst = 0;

        // Start one operation
        #8;
        start = 1;

        #10;
        start = 0;

        // Wait long enough for FSM to finish
        #50;

        $display("--------------------------------");
        $display("FSM test completed.");
        $display("--------------------------------");

        $finish;

    end

endmodule
