`timescale 1ns / 1ps

module mealy_1110_nonoverlap (
    input clk,
    input reset,
    input x,
    output reg y
);

    // State Declaration
    parameter S0 = 2'b00,
              S1 = 2'b01,
              S2 = 2'b10,
              S3 = 2'b11;

    reg [1:0] state, next_state;

    // State Register
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Next-State Logic
    always @(*) begin
        case (state)

            S0: begin
                if (x)
                    next_state = S1;
                else
                    next_state = S0;
            end

            S1: begin
                if (x)
                    next_state = S2;
                else
                    next_state = S0;
            end

            S2: begin
                if (x)
                    next_state = S3;
                else
                    next_state = S0;
            end

            S3: begin
                if (x)
                    next_state = S3;
                else
                    next_state = S0;
            end

            default: next_state = S0;

        endcase
    end

    // Output Logic (Mealy Machine)
    always @(*) begin
        if ((state == S3) && (x == 1'b0))
            y = 1'b1;
        else
            y = 1'b0;
    end

endmodule



`timescale 1ns / 1ps

module mealy_1110_nonoverlap_tb;

    reg clk;
    reg reset;
    reg x;
    wire y;

    // Instantiate the DUT
    mealy_1110_nonoverlap DUT (
        .clk(clk),
        .reset(reset),
        .x(x),
        .y(y)
    );

    // Clock Generation
    always #5 clk = ~clk;

    // Monitor Output
    initial begin
        $monitor("Time=%0t x=%b state=%b y=%b",
                 $time, x, DUT.state, y);
    end

    // Test Sequence
    initial begin
        clk = 0;
        reset = 1;
        x = 0;

        #10 reset = 0;

        // Sequence: 1110 (Detected)
        #10 x = 1;
        #10 x = 1;
        #10 x = 1;
        #10 x = 0;

        // Additional bits
        #10 x = 1;
        #10 x = 0;

        // Another detection: 1110
        #10 x = 1;
        #10 x = 1;
        #10 x = 1;
        #10 x = 0;

        #20 $finish;
    end

endmodule