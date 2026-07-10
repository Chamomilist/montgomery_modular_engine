`timescale 1ns/1ps

module montgomery_engine_random_tb;

    localparam int WIDTH = 256;   // must match generated_vectors.mem's width (montgomery_reference.py)
    localparam string VECTOR_FILE = "generated_vectors.mem";

    logic clk;
    logic rst;
    logic start;

    logic [WIDTH-1:0] A;
    logic [WIDTH-1:0] B;
    logic [WIDTH-1:0] N;

    logic [WIDTH-1:0] result;
    logic done;

    // Vector storage
    logic [WIDTH-1:0] vec_A;
    logic [WIDTH-1:0] vec_B;
    logic [WIDTH-1:0] vec_N;
    logic [WIDTH-1:0] vec_expected;

    int fd;
    int scan_code;
    int vector_index;
    int pass_count;
    int fail_count;

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

    // Drive one vector through the DUT and check the result.
    // Assumes the DUT is currently idle (done low, state == IDLE) on entry.
    task automatic run_vector(
        input  logic [WIDTH-1:0] a_in,
        input  logic [WIDTH-1:0] b_in,
        input  logic [WIDTH-1:0] n_in,
        input  logic [WIDTH-1:0] expected_in,
        input  int               idx
    );
        A = a_in;
        B = b_in;
        N = n_in;

        @(posedge clk);
        start = 1;
        @(posedge clk);
        start = 0;

        wait (done == 1'b1);
        @(posedge clk); // let result settle for a full cycle while done is high

        if (result === expected_in) begin
            pass_count++;
        end
        else begin
            fail_count++;
            $display("--------------------------------");
            $display("MISMATCH on vector %0d", idx);
            $display("  A        = 0x%0h", a_in);
            $display("  B        = 0x%0h", b_in);
            $display("  N        = 0x%0h", n_in);
            $display("  Expected = 0x%0h", expected_in);
            $display("  Got      = 0x%0h", result);
            $display("--------------------------------");
        end

        // Wait for the FSM to return to IDLE (done deasserts) before the next vector
        wait (done == 1'b0);
    endtask

    initial begin

        $dumpfile("waves/montgomery_engine_random.vcd");
        $dumpvars(0, montgomery_engine_random_tb);

        rst   = 1;
        start = 0;
        A     = '0;
        B     = '0;
        N     = '0;

        pass_count   = 0;
        fail_count   = 0;
        vector_index = 0;

        // Release reset
        #20;
        rst = 0;
        #10;

        fd = $fopen(VECTOR_FILE, "r");
        if (fd == 0) begin
            $display("ERROR: could not open vector file '%s'", VECTOR_FILE);
            $finish;
        end

        while (!$feof(fd)) begin
            scan_code = $fscanf(fd, "%h %h %h %h", vec_A, vec_B, vec_N, vec_expected);

            // A malformed/blank trailing line at EOF won't match all 4 fields; skip it.
            if (scan_code != 4)
                continue;

            run_vector(vec_A, vec_B, vec_N, vec_expected, vector_index);
            vector_index++;
        end

        $fclose(fd);

        $display("--------------------------------");
        $display("Randomized Verification Summary");
        $display("--------------------------------");
        $display("Vectors run = %0d", vector_index);
        $display("Passed      = %0d", pass_count);
        $display("Failed      = %0d", fail_count);
        if (fail_count == 0)
            $display("RESULT: ALL VECTORS PASSED");
        else
            $display("RESULT: %0d VECTOR(S) FAILED", fail_count);
        $display("--------------------------------");

        #20;
        $finish;

    end

endmodule
