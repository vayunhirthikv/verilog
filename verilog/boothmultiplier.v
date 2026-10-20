`timescale 1ns / 1ps

module booth_multiplier_4bit (
    input signed [3:0] M, //multiplicand
    input signed [3:0] Q, //multiplier
    output signed [7:0] P
);

    reg signed [3:0] A;
    reg signed [3:0] Q_reg;
    reg Q_1;
    reg signed [3:0] M_reg;
    reg signed [8:0] temp;
    integer i;

    always @(*) begin  //combinational logic
        A = 4'b0000;
        Q_reg = Q;
        Q_1 = 1'b0;
        M_reg = M;
        temp = 9'b0;

        // Booth Algorithm
        for (i = 0; i < 4; i = i + 1) begin
            case ({Q_reg[0], Q_1})

                2'b01: A = A + M_reg;
                2'b10: A = A - M_reg;
                default: A = A;

            endcase

            // Arithmetic Right Shift
            temp = {A, Q_reg, Q_1};
            temp = temp >>> 1;
            {A, Q_reg, Q_1} = temp;
        end
    end

    assign P = {A, Q_reg};

endmodule


`timescale 1ns / 1ps

module booth_multiplier_4bit_tb;

    reg signed [3:0] M;
    reg signed [3:0] Q;
    wire signed [7:0] P;

    booth_multiplier_4bit DUT (
        .M(M),
        .Q(Q),
        .P(P)
    );

    task display_result;
    begin
        #10;
        $display("Time=%0t M=%0d Q=%0d P=%0d",
                 $time, M, Q, P);
    end
    endtask

    initial begin

        // Test 1: Positive x Positive
        M = 4'sd3;
        Q = 4'sd2;
        display_result;

        // Test 2: Positive x Negative
        M = 4'sd3;
        Q = -4'sd2;
        display_result;

        // Test 3: Negative x Positive
        M = -4'sd3;
        Q = 4'sd2;
        display_result;

        // Test 4: Negative x Negative
        M = -4'sd3;
        Q = -4'sd2;
        display_result;

        // Test 5
        M = 4'sd7;
        Q = 4'sd7;
        display_result;

        #10 $finish;

    end

endmodule
