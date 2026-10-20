`timescale 1ns / 1ps

module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [3:0] count //declared as reg because it is used in always block
);

    always @(posedge clk) begin
        if (reset)
            count <= 4'b0000;
        else if (up_down)
            count <= count + 1;
        else
            count <= count - 1;
    end

endmodule




`timescale 1ns / 1ps

module up_down_counter_tb;

    reg clk;
    reg reset;
    reg up_down;

    wire [3:0] count;

    // Instantiate the DUT
    up_down_counter uut (
        .clk(clk),
        .reset(reset),
        .up_down(up_down),
        .count(count)
    );

    // Clock generation (10 ns period)
    always #5 clk = ~clk;

    // Test sequence
    initial begin
        $display("Time\tReset\tUp_Down\tCount");
        $monitor("%0t\t%b\t%b\t%b",
                 $time, reset, up_down, count);

        // Apply reset
        reset = 1;
        up_down = 1;
        #10;

        // Release reset and count up
        reset = 0;
        #50;

        // Count down
        up_down = 0;
        #50;

        // Reset again
        reset = 1;
        #10;

        reset = 0;

        // Count up again
        up_down = 1;
        #30;

        $finish;
    end

endmodule


A synchronous counter is a counter in which all flip-flops 
are triggered by the same clock signal