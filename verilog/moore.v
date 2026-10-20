`timescale 1ns / 1ps

module moore_seq ( //1011 with overlapping
    input clk,
    input reset,
    input x,
    output reg y
);

    parameter S0 = 0,
              S1 = 1,
              S2 = 2,
              S3 = 3,
              S4 = 4;

    reg [2:0] state, next_state;

    // State register
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Next-state logic
    always @(*) begin
        case (state)

            S0: next_state = (x) ? S1 : S0;

            S1: next_state = (x) ? S1 : S2;

            S2: next_state = (x) ? S3 : S0;

            S3: next_state = (x) ? S4 : S2;

            S4: next_state = (x) ? S1 : S2;

            default: next_state = S0;

        endcase
    end

    // Output logic
    always @(*) begin
        if (state == S4)
            y = 1'b1;
        else
            y = 1'b0;
    end

endmodule



`timescale 1ns / 1ps

module tb_moore;

    reg clk;
    reg reset;
    reg x;
    wire y;

    moore_seq uut (
        .clk(clk),
        .reset(reset),
        .x(x),
        .y(y)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Test sequence
    initial begin

        clk = 0;
        reset = 1;
        x = 0;

        #10 reset = 0;

        x = 1; #10;
        x = 0; #10;
        x = 1; #10;
        x = 1; #10;
        x = 0; #10;

        $finish;

    end

endmodule


//moore: output depends only on present state
//sequence detector: detect particular binary pattern in input stream
//mealy: present state and current input