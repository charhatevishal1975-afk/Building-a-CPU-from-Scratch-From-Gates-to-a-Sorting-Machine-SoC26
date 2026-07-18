`timescale 1ns / 1ps

module tb_register_file;

    // Inputs
    reg clk;
    reg reset;
    reg reg_write;

    reg [1:0] write_sel;
    reg [1:0] read_sel1;
    reg [1:0] read_sel2;

    reg [7:0] write_data;

    // Outputs
    wire [7:0] read_data1;
    wire [7:0] read_data2;

    wire [7:0] regA;
    wire [7:0] regB;
    wire [7:0] regC;
    wire [7:0] regD;

    //--------------------------------------------------
    // Instantiate Register File
    //--------------------------------------------------

    register_file uut (

        .clk(clk),
        .reset(reset),

        .reg_write(reg_write),

        .write_sel(write_sel),
        .read_sel1(read_sel1),
        .read_sel2(read_sel2),

        .write_data(write_data),

        .read_data1(read_data1),
        .read_data2(read_data2),

        .regA(regA),
        .regB(regB),
        .regC(regC),
        .regD(regD)

    );

    //--------------------------------------------------
    // Clock Generation
    //--------------------------------------------------

    always #5 clk = ~clk;

    //--------------------------------------------------
    // Test Sequence
    //--------------------------------------------------

    initial begin

        // Generate waveform
        $dumpfile("register_file.vcd");
        $dumpvars(0, tb_register_file);
        $monitor(
                    "t=%0t | A=%0d B=%0d C=%0d D=%0d | RD1=%0d RD2=%0d",
                    $time,
                    regA, regB, regC, regD,
                    read_data1, read_data2
                );

        clk = 0;
        reset = 1;
        reg_write = 0;

        write_sel = 2'b00;
        read_sel1 = 2'b00;
        read_sel2 = 2'b00;
        write_data = 8'd0;

        #10;

        //------------------------------------------
        // Release Reset
        //------------------------------------------

        reset = 0;

        //------------------------------------------
        // Write 25 to Register A
        //------------------------------------------

        reg_write = 1;
        write_sel = 2'b00;
        write_data = 8'd25;

        #10;

        //------------------------------------------
        // Write 40 to Register B
        //------------------------------------------

        write_sel = 2'b01;
        write_data = 8'd40;

        #10;

        //------------------------------------------
        // Write 75 to Register C
        //------------------------------------------

        write_sel = 2'b10;
        write_data = 8'd75;

        #10;

        //------------------------------------------
        // Write 100 to Register D
        //------------------------------------------

        write_sel = 2'b11;
        write_data = 8'd100;

        #10;

        reg_write = 0;

        //------------------------------------------
        // Read A and B
        //------------------------------------------

        read_sel1 = 2'b00;
        read_sel2 = 2'b01;

        #10;

        //------------------------------------------
        // Read C and D
        //------------------------------------------

        read_sel1 = 2'b10;
        read_sel2 = 2'b11;

        #10;

        //------------------------------------------
        // Read B and D
        //------------------------------------------

        read_sel1 = 2'b01;
        read_sel2 = 2'b11;

        #10;

        //------------------------------------------
        // Finish
        //------------------------------------------

        $finish;

    end

endmodule