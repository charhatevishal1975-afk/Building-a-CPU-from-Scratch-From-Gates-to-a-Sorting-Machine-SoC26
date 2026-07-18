`timescale 1ns/1ps

module tb_data_memory;

    //---------------------------------------
    // Inputs
    //---------------------------------------

    reg clk;
    reg mem_write;

    reg [7:0] address;
    reg [7:0] write_data;

    //---------------------------------------
    // Outputs
    //---------------------------------------

    wire [7:0] read_data;

    //---------------------------------------
    // Statistics
    //---------------------------------------

    integer passed;
    integer failed;

    //---------------------------------------
    // DUT
    //---------------------------------------

    data_memory uut(

        .clk(clk),

        .mem_write(mem_write),

        .address(address),

        .write_data(write_data),

        .read_data(read_data)

    );

    //---------------------------------------
    // Clock
    //---------------------------------------

    always #5 clk = ~clk;

    //---------------------------------------
    // Test Sequence
    //---------------------------------------

    initial begin

        $dumpfile("data_memory.vcd");
        $dumpvars(0,tb_data_memory);

        clk = 0;

        mem_write = 0;

        address = 0;
        write_data = 0;

        passed = 0;
        failed = 0;

        //-----------------------------------
        // Test 1
        // Write 55 at address 10
        //-----------------------------------

        address = 8'd10;
        write_data = 8'd55;
        mem_write = 1;

        #10;

        mem_write = 0;

        #1;

        if(read_data == 55)
        begin
            $display("PASS : Write/Read Address 10");
            passed = passed + 1;
        end
        else
        begin
            $display("FAIL : Write/Read Address 10");
            failed = failed + 1;
        end

        //-----------------------------------
        // Test 2
        // Write 99 at address 25
        //-----------------------------------

        address = 8'd25;
        write_data = 8'd99;
        mem_write = 1;

        #10;

        mem_write = 0;

        #1;

        if(read_data == 99)
        begin
            $display("PASS : Write/Read Address 25");
            passed = passed + 1;
        end
        else
        begin
            $display("FAIL : Write/Read Address 25");
            failed = failed + 1;
        end

        //-----------------------------------
        // Test 3
        // Verify previous value still exists
        //-----------------------------------

        address = 8'd10;

        #1;

        if(read_data == 55)
        begin
            $display("PASS : Memory Retains Data");
            passed = passed + 1;
        end
        else
        begin
            $display("FAIL : Memory Retains Data");
            failed = failed + 1;
        end

        //-----------------------------------
        // Test 4
        // Overwrite address 10
        //-----------------------------------

        address = 8'd10;
        write_data = 8'd200;
        mem_write = 1;

        #10;

        mem_write = 0;

        #1;

        if(read_data == 200)
        begin
            $display("PASS : Memory Overwrite");
            passed = passed + 1;
        end
        else
        begin
            $display("FAIL : Memory Overwrite");
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