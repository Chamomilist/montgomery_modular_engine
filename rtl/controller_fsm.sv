module controller_fsm
(
    input logic clk,
    input logic rst,
    input logic start,

    output logic done
);

typedef enum logic [1:0] {
    IDLE,
    LOAD,
    COMPUTE,
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
            next_state = DONE;

        DONE:
            next_state = IDLE;

        default:
            next_state = IDLE;

    endcase
end

// Output logic

always_comb begin
    done = 1'b0;

    case (state)

        DONE:
            done = 1'b1;

        default:
            done = 1'b0;

    endcase
end

endmodule
