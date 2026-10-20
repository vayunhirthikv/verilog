`timescale 1ns / 1ps

module alu_4bit (
    input [3:0] A,
    input [3:0] B,
    input [2:0] sel,
    output reg [3:0] Y,
    output reg Carry,
    output Zero
);

    assign Zero = (Y == 4'b0000);

    always @(*) begin
        Carry = 0;  //no assign

        case (sel)
                                    //no assign or something
            3'b000: begin
                {Carry, Y} = A + B;
            end

            3'b001: begin
                {Carry, Y} = A - B;
            end

            3'b010: begin
                Y = A & B;
            end

            3'b011: begin
                Y = A | B;
            end

            3'b100: begin
                Y = A ^ B;
            end

            3'b101: begin
                Y = ~A;
            end

            3'b110: begin
                Y = A << 1;
            end

            3'b111: begin
                Y = A >> 1;
            end

            default: begin
                Y = 4'b0000;
                Carry = 0;
            end

        endcase
    end

endmodule



`timescale 1ns / 1ps

module alu_4bit_tb;

    reg [3:0] A;
    reg [3:0] B;
    reg [2:0] sel;

    wire [3:0] Y;
    wire Carry;
    wire Zero;

    alu_4bit uut (
        .A(A),
        .B(B),
        .sel(sel),
        .Y(Y),
        .Carry(Carry),
        .Zero(Zero)
    );

    initial begin

        $display("4-BIT ALU");
        $display("A\tB\tSel\tY\tCarry\tZero");

        $monitor("%b\t%b\t%b\t%b\t%b\t%b",
                 A, B, sel, Y, Carry, Zero);

        // Addition
        A = 4'b0101;
        B = 4'b0011;
        sel = 3'b000;
        #10;

        // Subtraction
        sel = 3'b001;
        #10;

        // AND
        sel = 3'b010;
        #10;

        // OR
        sel = 3'b011;
        #10;

        // XOR
        sel = 3'b100;
        #10;

        // NOT A
        sel = 3'b101;
        #10;

        // Left Shift
        sel = 3'b110;
        #10;

        // Right Shift
        sel = 3'b111;
        #10;

        // Overflow Addition
        A = 4'b1111;
        B = 4'b0001;
        sel = 3'b000;
        #10;

        // Zero Result
        A = 4'b0101;
        B = 4'b0101;
        sel = 3'b001;
        #10;

        $finish;

    end

endmodule