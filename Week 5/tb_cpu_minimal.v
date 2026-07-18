`timescale 1ns/1ps

module tb_cpu_minimal;

reg clk;
reg reset;

cpu_minimal uut(

    .clk(clk),
    .reset(reset)

);

always #5 clk = ~clk;

initial
begin

    $dumpfile("cpu_minimal.vcd");
    $dumpvars(0,tb_cpu_minimal);

    clk = 0;
    reset = 1;

    #10;

    reset = 0;

    //----------------------------------
    // Run for a few instructions
    //----------------------------------

    #100;

    $display("--------------------------------");
    $display("Instruction Fetch Test Finished");
    $display("--------------------------------");

    $finish;

end

endmodule