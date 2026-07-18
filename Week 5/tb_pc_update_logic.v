`timescale 1ns/1ps

module tb_pc_update_logic;

    //---------------------------------------
    // Inputs
    //---------------------------------------

    reg [7:0] current_pc;
    reg [7:0] target_address;

    reg jump;
    reg branch;
    reg branch_taken;

    //---------------------------------------
    // Outputs
    //---------------------------------------

    wire [7:0] next_pc;

    //---------------------------------------
    // Statistics
    //---------------------------------------

    integer passed;
    integer failed;

    //---------------------------------------
    // DUT
    //---------------------------------------

    pc_update_logic uut(

        .current_pc(current_pc),
        .target_address(target_address),

        .jump(jump),
        .branch(branch),
        .branch_taken(branch_taken),

        .next_pc(next_pc)

    );

    //---------------------------------------
    // Test Sequence
    //---------------------------------------

    initial begin

        $dumpfile("pc_update_logic.vcd");
        $dumpvars(0, tb_pc_update_logic);

        passed = 0;
        failed = 0;

        //-----------------------------------
        // TEST 1 : Sequential Execution
        //-----------------------------------

        current_pc = 8'd10;
        target_address = 8'd50;

        jump = 0;
        branch = 0;
        branch_taken = 0;

        #5;

        if(next_pc == 11)
        begin
            $display("PASS : Sequential PC");
            passed = passed + 1;
        end
        else
        begin
            $display("FAIL : Sequential PC");
            failed = failed + 1;
        end

        //-----------------------------------
        // TEST 2 : Jump
        //-----------------------------------

        current_pc = 8'd10;
        target_address = 8'd80;

        jump = 1;
        branch = 0;
        branch_taken = 0;

        #5;

        if(next_pc == 80)
        begin
            $display("PASS : Jump");
            passed = passed + 1;
        end
        else
        begin
            $display("FAIL : Jump");
            failed = failed + 1;
        end

        //-----------------------------------
        // TEST 3 : Taken Branch
        //-----------------------------------

        current_pc = 8'd20;
        target_address = 8'd100;

        jump = 0;
        branch = 1;
        branch_taken = 1;

        #5;

        if(next_pc == 100)
        begin
            $display("PASS : Branch Taken");
            passed = passed + 1;
        end
        else
        begin
            $display("FAIL : Branch Taken");
            failed = failed + 1;
        end

        //-----------------------------------
        // TEST 4 : Branch Not Taken
        //-----------------------------------

        current_pc = 8'd30;
        target_address = 8'd150;

        jump = 0;
        branch = 1;
        branch_taken = 0;

        #5;

        if(next_pc == 31)
        begin
            $display("PASS : Branch Not Taken");
            passed = passed + 1;
        end
        else
        begin
            $display("FAIL : Branch Not Taken");
            failed = failed + 1;
        end

        //-----------------------------------
        // TEST 5 : Jump has Priority
        //-----------------------------------

        current_pc = 8'd40;
        target_address = 8'd200;

        jump = 1;
        branch = 1;
        branch_taken = 1;

        #5;

        if(next_pc == 200)
        begin
            $display("PASS : Jump Priority");
            passed = passed + 1;
        end
        else
        begin
            $display("FAIL : Jump Priority");
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

        #10;

        $finish;

    end

endmodule