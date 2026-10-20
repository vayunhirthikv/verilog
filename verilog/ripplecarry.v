`timescale 1ns / 1ps

module ripple_carry_adder_8bit (
    input [7:0] A,
    input [7:0] B,
    input Cin,
    output [7:0] Sum,
    output Cout
);

    wire c1, c2, c3, c4, c5, c6, c7;

    full_adder f1 (Sum[0], c1, A[0], B[0], Cin);
    full_adder f2 (Sum[1], c2, A[1], B[1], c1);
    full_adder f3 (Sum[2], c3, A[2], B[2], c2);
    full_adder f4 (Sum[3], c4, A[3], B[3], c3);
    full_adder f5 (Sum[4], c5, A[4], B[4], c4);
    full_adder f6 (Sum[5], c6, A[5], B[5], c5);
    full_adder f7 (Sum[6], c7, A[6], B[6], c6);
    full_adder f8 (Sum[7], Cout, A[7], B[7], c7);

endmodule


module full_adder (
    output Sum,
    output Cout,
    input A,
    input B,
    input Cin
);

    assign Sum = A ^ B ^ Cin;
    assign Cout = (A & B) | (B & Cin) | (A & Cin);

endmodule



`timescale 1ns / 1ps

module ripple_carry_adder_8bit_tb;

    reg [7:0] A;
    reg [7:0] B;   //input --> reg   output-->wire
    reg Cin;

    wire [7:0] Sum;
    wire Cout;

    // DUT (Device Under Test)
    ripple_carry_adder_8bit uut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .Sum(Sum),
        .Cout(Cout)
    );

    // Common Display
    task display_result;
    begin
        #10;
        $display("Time=%0t A=%d B=%d Cin=%b Sum=%d Cout=%b",
                 $time, A, B, Cin, Sum, Cout);
    end
    endtask

    initial begin

        // Test 1
        A = 8'd10;
        B = 8'd20;
        Cin = 0;
        display_result;

        // Test 2
        A = 8'd50;
        B = 8'd25;
        Cin = 0;
        display_result;

        // Test 3
        A = 8'd100;
        B = 8'd50;
        Cin = 0;
        display_result;

        // Test 4
        A = 8'd255;
        B = 8'd1;
        Cin = 0;
        display_result;

        // Test 5
        A = 8'd100;
        B = 8'd50;
        Cin = 1;
        display_result;

        #10 $finish;

    end

endmodule


