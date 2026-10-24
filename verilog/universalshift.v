`timescale 1ns / 1ps

module usr_4bit (
    input clk,
    input reset,
    input [1:0] sel,
    input sin_left,//serial input l
    
    
    input sin_right, // serial right
    input [3:0] pdata,
    output reg [3:0] q
);

    always @(posedge clk or posedge reset) begin
        if (reset)
            q <= 4'b0000;
        else begin
            case (sel)

                2'b00: q <= q;                   // Hold
                2'b01: q <= {sin_left, q[3:1]};  // Shift Right
                2'b10: q <= {q[2:0], sin_right}; // Shift Left
                2'b11: q <= pdata;               // Parallel Load

            endcase
        end
    end

endmodule


`timescale 1ns / 1ps

module universal_shift_register_3bit (
    input clk,
    input reset,
    input [2:0] sel,
    input sin_left,
    input sin_right,
    input [2:0] pdata,
    output reg [2:0] q,
    output serial_left,
    output serial_right,
    output [2:0] parallel_out
);

    assign serial_right = q[0];
    assign serial_left  = q[2];
    assign parallel_out = q;

    always @(posedge clk or posedge reset) begin
        if (reset)
            q <= 3'b000;
        else begin
            case (sel)

                3'b000: q <= q;                    // No operation

                3'b001: q <= {sin_left, q[2:1]};  // Left in, right out

                3'b010: q <= {q[1:0], sin_right}; // Right in, left out

                3'b011: q <= {sin_left, q[2:1]};  // Left in, parallel out

                3'b100: q <= {q[1:0], sin_right}; // Right in, parallel out

                3'b101: q <= pdata;                // Parallel in, right out

                3'b110: q <= pdata;                // Parallel in, left out

                3'b111: q <= pdata;                // Parallel in, parallel out

                default: q <= q;

            endcase
        end
    end

endmodule




`timescale 1ns / 1ps

module usr_4bit_tb;

    reg clk;
    reg reset;
    reg [1:0] sel;
    reg sin_left;
    reg sin_right;
    reg [3:0] pdata;

    wire [3:0] q;

    // Instantiate the DUT
    usr_4bit uut (
        .clk(clk),
        .reset(reset),
        .sel(sel),
        .sin_left(sin_left),
        .sin_right(sin_right),
        .pdata(pdata),
        .q(q)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Test sequence
    initial begin

        $display("4-BIT UNIVERSAL SHIFT REGISTER");
        $display("Time\tReset\tSel\tPdata\tQ");

        $monitor("%0t\t%b\t%b\t%b\t%b",
                 $time, reset, sel, pdata, q);

        // Reset
        reset = 1;
        sel = 2'b00;
        sin_left = 0;
        sin_right = 0;
        pdata = 4'b0000;

        #10;
        reset = 0;

        // Parallel Load
        sel = 2'b11;
        pdata = 4'b1010;
        #10;

        // Hold
        sel = 2'b00;
        #10;

        // Shift Right
        sel = 2'b01;
        sin_left = 1;
        #10;

        sin_left = 0;
        #10;

        // Shift Left
        sel = 2'b10;
        sin_right = 1;
        #10;

        sin_right = 0;
        #10;

        $finish;

    end

endmodule