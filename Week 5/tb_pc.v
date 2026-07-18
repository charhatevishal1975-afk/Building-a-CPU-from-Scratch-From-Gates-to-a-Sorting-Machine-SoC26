`timescale 1ns/1ps

module tb_pc;

reg clk;
reg reset;

reg pc_write;

reg [7:0] pc_next;

wire [7:0] pc;

integer passed;
integer failed;

pc uut(

    .clk(clk),
    .reset(reset),

    .pc_write(pc_write),

    .pc_next(pc_next),

    .pc(pc)

);

always #5 clk = ~clk;

initial
begin

    $dumpfile("pc.vcd");
    $dumpvars(0,tb_pc);

    clk = 0;

    reset = 1;

    pc_write = 0;

    pc_next = 0;

    passed = 0;
    failed = 0;

    //---------------------------------
    // Reset
    //---------------------------------

    #10;

    reset = 0;

    if(pc == 0)
    begin
        $display("PASS : Reset");
        passed = passed + 1;
    end
    else
    begin
        $display("FAIL : Reset");
        failed = failed + 1;
    end

    //---------------------------------
    // Load 15
    //---------------------------------

    pc_write = 1;
    pc_next = 8'd15;

    #10;

    if(pc == 15)
    begin
        $display("PASS : Load PC = 15");
        passed = passed + 1;
    end
    else
    begin
        $display("FAIL : Load PC = 15");
        failed = failed + 1;
    end

    //---------------------------------
    // Load 100
    //---------------------------------

    pc_next = 8'd100;

    #10;

    if(pc == 100)
    begin
        $display("PASS : Load PC = 100");
        passed = passed + 1;
    end
    else
    begin
        $display("FAIL : Load PC = 100");
        failed = failed + 1;
    end

    //---------------------------------
    // Hold Value
    //---------------------------------

    pc_write = 0;
    pc_next = 8'd200;

    #10;

    if(pc == 100)
    begin
        $display("PASS : Hold PC");
        passed = passed + 1;
    end
    else
    begin
        $display("FAIL : Hold PC");
        failed = failed + 1;
    end

    //---------------------------------

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