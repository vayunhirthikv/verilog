`timescale 1ns / 1ps

module mac_8bit (
    input clk,
    input reset,
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] acc //reg because we used that in always block
);

    wire [15:0] mult_out;

    assign mult_out = A * B;

    always @(posedge clk) begin  //sequential logic   <= : non blocking assignment
        if (reset)
            acc <= 16'b0;
        else
            acc <= acc + mult_out;
    end

endmodule





`timescale 1ns / 1ps

module tb_mac_8bit;

    reg clk;
    reg reset;
    reg [7:0] A;
    reg [7:0] B;

    wire [15:0] acc;

    mac_8bit uut (
        .clk(clk),
        .reset(reset),
        .A(A),
        .B(B),
        .acc(acc)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin

        $display("8-BIT MULTIPLY-ACCUMULATE UNIT");
        $display("Time\tReset\tA\tB\tACC");

        $monitor("%0t\t%b\t%0d\t%0d\t%0d",
                 $time, reset, A, B, acc);

        // Initial values
        clk = 0;
        reset = 1;
        A = 8'd0;
        B = 8'd0;

        #10;
        reset = 0;

        // Test 1
        A = 8'd5;
        B = 8'd3;
        #10;

        // Test 2
        A = 8'd2;
        B = 8'd4;
        #10;

        // Test 3
        A = 8'd3;
        B = 8'd2;
        #10;

        // Test 4
        A = 8'd10;
        B = 8'd5;
        #10;

        $finish;

    end

endmodule