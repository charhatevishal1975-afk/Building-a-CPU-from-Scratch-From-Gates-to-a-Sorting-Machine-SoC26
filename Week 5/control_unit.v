`timescale 1ns / 1ps
`include "isa_defines.vh"

module control_unit(

    input wire [15:0] instruction,

    // Decoder Inputs
    input wire LOADI_LOADP,
    input wire MOVE,
    input wire ADD,
    input wire ADDI,
    input wire SUB,
    input wire SUBI,
    input wire LOAD,
    input wire STORE,
    input wire CMP,
    input wire SHIFTL,
    input wire SHIFTR,
    input wire INPUTC,
    input wire INPUTCF,
    input wire INPUTD,
    input wire INPUTDF,
    input wire LOADF,
    input wire STOREF,

    // Register File
    output reg reg_write,
    output reg [1:0] write_sel,
    output reg [1:0] read_sel1,
    output reg [1:0] read_sel2,

    // ALU
    output reg [2:0] alu_op,

    // Memory
    output reg mem_write,

    // Flags
    output reg flag_write

   

);
always @(*) begin

    reg_write  = 0;
    mem_write  = 0;
    flag_write = 0;
    
    alu_op = `ALU_PASS_A;

    write_sel = instruction[11:10];
    if (SHIFTL || SHIFTR)
    begin
        read_sel1 = {instruction[9], instruction[7]};
    end
    else if (LOADF || STOREF)
    begin
        read_sel1 = instruction[11:10];
    end
    else
    begin
        read_sel1 = instruction[9:8];
    end

    read_sel2 = instruction[7:6];

    if(LOADI_LOADP) begin

    reg_write = 1;

    end
    else if(MOVE) begin
        reg_write = 1;
    end
    else if(ADD) begin
        reg_write = 1;
        flag_write = 1;
        alu_op = `ALU_ADD;

    end
    else if(SUB) begin
        reg_write = 1;
        flag_write = 1;
        alu_op = `ALU_SUB;
    end
    else if(ADDI) begin

        reg_write = 1;
        flag_write = 1;
        alu_op = `ALU_ADD;

    end    
        else if(SUBI) begin
        reg_write = 1;
        flag_write = 1;
        alu_op = `ALU_SUB;
    end
        else if(CMP) begin
        reg_write  = 0;
        flag_write = 1;
        alu_op = `ALU_CMP;

    end
        else if(SHIFTL) begin

        reg_write = 1;
        flag_write = 1;
        alu_op = `ALU_SHIFTL;

    end
        else if(SHIFTR) begin

        reg_write = 1;
        flag_write = 1;
        alu_op = `ALU_SHIFTR;

    end
        else if(LOAD) begin

        reg_write = 1;

    end
        else if(STORE) begin

        mem_write = 1;

    end
    else if (SHIFTL) begin
    reg_write  = 1;
    flag_write = 1;
    alu_op     = `ALU_SHIFTL;
    end

    else if (SHIFTR) begin
        reg_write  = 1;
        flag_write = 1;
        alu_op     = `ALU_SHIFTR;
    end
    else if (INPUTC) begin
        reg_write = 1;
    end

    else if (INPUTCF) begin
        reg_write  = 1;
        // flag_write = 1;
    end

    else if (INPUTD) begin
        reg_write = 1;
    end

    else if (INPUTDF) begin
        reg_write  = 1;
        // flag_write = 1;
    end
    else if (LOADF) begin
        reg_write = 1;
    end
    else if (STOREF) begin
     mem_write = 1;
    end

    // $display(
    // "CTRL: SHIFTL=%b SHIFTR=%b reg_write=%b alu_op=%0d",
    // SHIFTL,
    // SHIFTR,
    // reg_write,
    // alu_op
    // );
    


    end

endmodule