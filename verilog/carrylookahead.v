`timescale 1ns / 1ps

module carry_lookahead_adder(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    wire [3:0] P, G;
    wire C1, C2, C3, C4;

    assign P = A ^ B;
    assign G = A & B;

    assign C1 = G[0] | (P[0] & Cin);        //C1=G0+P0 C0  C2=G1+P1 C1==> C2=G1+P1(G0+P0 C0)==> C2=G1+P1G0+P1P0C0

    assign C2 = G[1] |
                (P[1] & G[0]) |
                (P[1] & P[0] & Cin);

    assign C3 = G[2] |
                (P[2] & G[1]) |
                (P[2] & P[1] & G[0]) |
                (P[2] & P[1] & P[0] & Cin);

    assign C4 = G[3] |
                (P[3] & G[2]) |
                (P[3] & P[2] & G[1]) |
                (P[3] & P[2] & P[1] & G[0]) |
                (P[3] & P[2] & P[1] & P[0] & Cin);

    assign Sum[0] = P[0] ^ Cin;
    assign Sum[1] = P[1] ^ C1;
    assign Sum[2] = P[2] ^ C2;
    assign Sum[3] = P[3] ^ C3;

    assign Cout = C4;

endmodule




`timescale 1ns / 1ps

module tb_carry_lookahead_adder;

    reg [3:0] A;
    reg [3:0] B;
    reg Cin;

    wire [3:0] Sum;
    wire Cout;

    carry_lookahead_adder uut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .Sum(Sum),
        .Cout(Cout)
    );

    initial begin

        $display("4-BIT CARRY LOOK-AHEAD ADDER");
        $display("Time\tA\tB\tCin\tSum\tCout");

        $monitor("%0t\t%b\t%b\t%b\t%b\t%b",
                 $time, A, B, Cin, Sum, Cout);

        // Test 1
        A = 4'b0000;
        B = 4'b0000;
        Cin = 0;
        #10;

        // Test 2
        A = 4'b0101;
        B = 4'b0011;
        Cin = 0;
        #10;

        // Test 3
        A = 4'b1010;
        B = 4'b0101;
        Cin = 0;
        #10;

        // Test 4
        A = 4'b1111;
        B = 4'b0001;
        Cin = 0;
        #10;

        // Test 5
        A = 4'b1111;
        B = 4'b1111;
        Cin = 1;
        #10;

        $finish;

    end

endmodule


//A Carry Look-Ahead Adder is a combinational circuit that generates
// carry signals in advance using propagate and generate signals, reducing 
//carry propagation delay.

// A Ripple Carry Adder waits for the carry to propagate through each full adder. 
// A CLA calculates carry signals
//  using Boolean expressions, reducing the delay.