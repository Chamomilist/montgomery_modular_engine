module controller_fsm
(
    input logic clk,
    input logic rst,
    input logic start,

    input logic counter_done,

    output logic load_A,
    output logic load_B,
    output logic load_N,
    output logic load_T,

    output logic counter_enable,
    output logic compute_enable,

    output logic done
);

typedef enum logic [2:0] {
    IDLE,
    LOAD,
    COMPUTE,
    UPDATE_T,
    NEXT_BIT,
    DONE
} state_t;

state_t state, next_state;

// State register

always_ff @(posedge clk or posedge rst) begin
    if (rst)
        state <= IDLE;
    else
        state <= next_state;
end

// Next-state logic

always_comb begin
    next_state = state;

    case (state)

        IDLE: begin
            if (start)
                next_state = LOAD;
        end

        LOAD:
            next_state = COMPUTE;

        COMPUTE:
            next_state = UPDATE_T;

        UPDATE_T:
            next_state = NEXT_BIT;

        NEXT_BIT: begin
            if (counter_done)
                next_state = DONE;
            else
                next_state = COMPUTE;
        end

        DONE:
            next_state = IDLE;

        default:
            next_state = IDLE;

    endcase
end

// Output logic

always_comb begin

    // Default outputs
    load_A = 1'b0;
    load_B = 1'b0;
    load_N = 1'b0;
    load_T = 1'b0;
    counter_enable = 1'b0;
    compute_enable = 1'b0;
    done = 1'b0;

    case (state)

        IDLE: begin
            // Wait for start
        end

        LOAD: begin
            load_A = 1'b1;
            load_B = 1'b1;
            load_N = 1'b1;
            load_T = 1'b1;
        end

        COMPUTE: begin
            compute_enable = 1'b1;
        end

        UPDATE_T: begin
            load_T = 1'b1;
        end

        NEXT_BIT: begin
            counter_enable = 1'b1;
        end

        DONE: begin
            done = 1'b1;
        end

        default: begin
        end

    endcase

end

endmodule
