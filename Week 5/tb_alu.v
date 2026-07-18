`timescale 1ns/1ps

module tb_alu;

    //---------------------------------------
    // Inputs
    //---------------------------------------

    reg [7:0] A;
    reg [7:0] B;
    reg [2:0] alu_op;

    //---------------------------------------
    // Outputs
    //---------------------------------------

    wire [7:0] result;
    wire zero;
    wire carry;
    wire negative;

    //---------------------------------------
    // Statistics
    //---------------------------------------

    integer passed;
    integer failed;

    //---------------------------------------
    // Instantiate ALU
    //---------------------------------------

    alu uut(

        .A(A),
        .B(B),
        .alu_op(alu_op),

        .result(result),

        .zero(zero),
        .carry(carry),
        .negative(negative)

    );

    //---------------------------------------
    // Test Procedure
    //---------------------------------------

    initial begin

        $dumpfile("alu.vcd");
        $dumpvars(0, tb_alu);

        passed = 0;
        failed = 0;

        $display("");
        $display("======================================");
        $display("        ALU TESTBENCH START");
        $display("======================================");

        //-----------------------------------
        // TEST 1 : ADD
        //-----------------------------------

        A = 8'd20;
        B = 8'd10;
        alu_op = 3'b000;

        #5;

        if(result == 30 && carry == 0 && zero == 0)
        begin
            $display("PASS : ADD");
            passed = passed + 1;
        end
        else
        begin
            $display("FAIL : ADD");
            $display("Expected Result = 30");
            $display("Obtained Result = %0d", result);
            failed = failed + 1;
        end

        //-----------------------------------
        // TEST 2 : ADD with Carry
        //-----------------------------------

        A = 8'd255;
        B = 8'd1;
        alu_op = 3'b000;

        #5;

        if(result == 0 && carry == 1 && zero == 1)
        begin
            $display("PASS : ADD Carry");
            passed = passed + 1;
        end
        else
        begin
            $display("FAIL : ADD Carry");
            failed = failed + 1;
        end

        //-----------------------------------
        // TEST 3 : SUB
        //-----------------------------------

        A = 8'd50;
        B = 8'd20;
        alu_op = 3'b001;

        #5;

        if(result == 30)
        begin
            $display("PASS : SUB");
            passed = passed + 1;
        end
        else
        begin
            $display("FAIL : SUB");
            failed = failed + 1;
        end

        //-----------------------------------
        // TEST 4 : CMP
        //-----------------------------------

        A = 8'd25;
        B = 8'd25;
        alu_op = 3'b010;

        #5;

        if(zero == 1)
        begin
            $display("PASS : CMP Equal");
            passed = passed + 1;
        end
        else
        begin
            $display("FAIL : CMP Equal");
            failed = failed + 1;
        end

        //-----------------------------------
        // TEST 5 : SHIFT LEFT
        //-----------------------------------

        A = 8'b00001111;
        B = 0;
        alu_op = 3'b011;

        #5;

        if(result == 8'b00011110)
        begin
            $display("PASS : SHIFT LEFT");
            passed = passed + 1;
        end
        else
        begin
            $display("FAIL : SHIFT LEFT");
            failed = failed + 1;
        end

        //-----------------------------------
        // TEST 6 : SHIFT RIGHT
        //-----------------------------------

        A = 8'b00001110;
        B = 0;
        alu_op = 3'b100;

        #5;

        if(result == 8'b00000111)
        begin
            $display("PASS : SHIFT RIGHT");
            passed = passed + 1;
        end
        else
        begin
            $display("FAIL : SHIFT RIGHT");
            failed = failed + 1;
        end

        //-----------------------------------
        // TEST 7 : PASS A
        //-----------------------------------

        A = 8'd99;
        B = 8'd15;
        alu_op = 3'b101;

        #5;

        if(result == 99)
        begin
            $display("PASS : PASS A");
            passed = passed + 1;
        end
        else
        begin
            $display("FAIL : PASS A");
            failed = failed + 1;
        end

        //-----------------------------------
        // TEST 8 : PASS B
        //-----------------------------------

        A = 8'd12;
        B = 8'd44;
        alu_op = 3'b110;

        #5;

        if(result == 44)
        begin
            $display("PASS : PASS B");
            passed = passed + 1;
        end
        else
        begin
            $display("FAIL : PASS B");
            failed = failed + 1;
        end

        //-----------------------------------
        // SUMMARY
        //-----------------------------------

        $display("");
        $display("======================================");
        $display("Tests Passed : %0d", passed);
        $display("Tests Failed : %0d", failed);
        $display("======================================");

        if(failed == 0)
            $display("ALL TESTS PASSED");
        else
            $display("SOME TESTS FAILED");

        $display("======================================");

        #10;

        $finish;

    end

endmodule