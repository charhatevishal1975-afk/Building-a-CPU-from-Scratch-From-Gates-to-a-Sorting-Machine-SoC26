`timescale 1ns/1ps

module tb_flags;

reg clk;
reg reset;

reg flag_write;

reg zero_in;
reg carry_in;
reg negative_in;

wire zero;
wire carry;
wire negative;

integer passed;
integer failed;

flags uut(

    .clk(clk),
    .reset(reset),

    .flag_write(flag_write),

    .zero_in(zero_in),
    .carry_in(carry_in),
    .negative_in(negative_in),

    .zero(zero),
    .carry(carry),
    .negative(negative)

);

always #5 clk = ~clk;

initial
begin

    $dumpfile("flags.vcd");
    $dumpvars(0,tb_flags);

    clk = 0;

    reset = 1;

    flag_write = 0;

    zero_in = 0;
    carry_in = 0;
    negative_in = 0;

    passed = 0;
    failed = 0;

    #10;

    reset = 0;

    //--------------------------------------------------
    // Test 1
    //--------------------------------------------------

    flag_write = 1;

    zero_in = 1;
    carry_in = 0;
    negative_in = 1;

    #10;

    if(zero==1 && carry==0 && negative==1)
    begin
        $display("PASS : Flag Write");
        passed = passed + 1;
    end
    else
    begin
        $display("FAIL : Flag Write");
        failed = failed + 1;
    end

    //--------------------------------------------------
    // Test 2
    //--------------------------------------------------

    flag_write = 0;

    zero_in = 0;
    carry_in = 1;
    negative_in = 0;

    #10;

    if(zero==1 && carry==0 && negative==1)
    begin
        $display("PASS : Hold Flags");
        passed = passed + 1;
    end
    else
    begin
        $display("FAIL : Hold Flags");
        failed = failed + 1;
    end

    //--------------------------------------------------
    // Test 3
    //--------------------------------------------------

    flag_write = 1;

    zero_in = 0;
    carry_in = 1;
    negative_in = 0;

    #10;

    if(zero==0 && carry==1 && negative==0)
    begin
        $display("PASS : Update Flags");
        passed = passed + 1;
    end
    else
    begin
        $display("FAIL : Update Flags");
        failed = failed + 1;
    end

    //--------------------------------------------------

    $display("--------------------------------");
    $display("Tests Passed : %0d",passed);
    $display("Tests Failed : %0d",failed);

    if(failed==0)
        $display("ALL TESTS PASSED");
    else
        $display("SOME TESTS FAILED");

    $display("--------------------------------");

    #20;

    $finish;

end

endmodule