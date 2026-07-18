`timescale 1ns/1ps

module tb_code_memory;

    //---------------------------------------
    // Inputs
    //---------------------------------------

    reg [7:0] address;

    //---------------------------------------
    // Outputs
    //---------------------------------------

    wire [15:0] instruction;

    //---------------------------------------
    // Statistics
    //---------------------------------------

    integer passed;
    integer failed;

    //---------------------------------------
    // DUT
    //---------------------------------------

    code_memory uut(

        .address(address),
        .instruction(instruction)

    );

    //---------------------------------------
    // Test
    //---------------------------------------

    initial begin

        $dumpfile("code_memory.vcd");
        $dumpvars(0,tb_code_memory);

        passed = 0;
        failed = 0;

        //-----------------------------------
        // Test Address 0
        //-----------------------------------

        address = 8'd0;

        #5;

        if(instruction == 16'h3125)
        begin
            $display("PASS : Address 0");
            passed = passed + 1;
        end
        else
        begin
            $display("FAIL : Address 0");
            $display("Expected : 3125");
            $display("Received : %h", instruction);
            failed = failed + 1;
        end

        //-----------------------------------
        // Test Address 1
        //-----------------------------------

        address = 8'd1;

        #5;

        if(instruction == 16'h4124)
        begin
            $display("PASS : Address 1");
            passed = passed + 1;
        end
        else
        begin
            $display("FAIL : Address 1");
            failed = failed + 1;
        end

        //-----------------------------------
        // Test Address 2
        //-----------------------------------

        address = 8'd2;

        #5;

        if(instruction == 16'h8A01)
        begin
            $display("PASS : Address 2");
            passed = passed + 1;
        end
        else
        begin
            $display("FAIL : Address 2");
            failed = failed + 1;
        end

        //-----------------------------------
        // Summary
        //-----------------------------------

        $display("--------------------------------");
        $display("Tests Passed : %0d", passed);
        $display("Tests Failed : %0d", failed);

        if(failed == 0)
            $display("ALL TESTS PASSED");
        else
            $display("SOME TESTS FAILED");

        $display("--------------------------------");

        #20;

        $finish;

    end

endmodule