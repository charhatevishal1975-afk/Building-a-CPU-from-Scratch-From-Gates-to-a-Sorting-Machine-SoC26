`timescale 1ns/1ps
`include "isa_defines.vh"

module multicycle_cpu(

    input wire clk,
    input wire reset,

    input wire [15:0] input_c,
    input wire [15:0] input_d

);



wire [7:0] PC;

wire [15:0] IR;

wire [7:0] A;
wire [7:0] B;

wire [7:0] ALUOut;

wire [7:0] MDR;
wire [7:0] reg_data1;
wire [7:0] reg_data2;
wire [7:0] regA;
wire [7:0] regB;
wire [7:0] regC;
wire [7:0] regD;
wire [7:0] alu_result;

wire zero;
wire carry;
wire negative;
wire [15:0] instruction;

wire [7:0] memory_data;
wire pc_write;
wire [7:0] next_pc;




wire [1:0] write_sel;
wire [1:0] read_sel1;
wire [1:0] read_sel2;

wire reg_write;

wire A_en;

wire B_en;

assign A_en = 1'b1;
assign B_en = 1'b1;
assign write_sel = IR[11:10];
assign read_sel1 = IR[9:8];
assign read_sel2 = IR[7:6];
wire [2:0] alu_op;

wire [7:0] alu_B;

assign alu_B =
    (ADDI || SUBI) ? IR[7:0] : B;

wire ALUOut_en;
wire flag_write;

wire zero_flag;
wire carry_flag;
wire negative_flag;
wire [7:0] write_data;
wire mem_write;
wire MDR_en;
wire branch;
wire branch_taken;
wire [7:0] next_pc;



assign write_data = ALUOut;
assign pc_write = 1'b1;




// Temporary
assign ALUOut_en = 1'b1;
assign MDR_en = 1'b1;


//--------------------------------------------------
// Datapath Registers
//--------------------------------------------------

pc PC_REG(

    .clk(clk),
    .reset(reset),

    .pc_write(pc_write),

    .pc_next(next_pc),

    .pc(PC)

);
code_memory CODE(

    .address(PC),

    .instruction(instruction)

);
wire ir_write;

instruction_register IR_REG(

    .clk(clk),
    .reset(reset),

    .ir_write(ir_write),

    .instruction_in(instruction),

    .instruction_out(IR)

);

//--------------------------------------------------
// Register File
//--------------------------------------------------

register_file RF(

    .clk(clk),
    .reset(reset),

    .reg_write(reg_write),

    .write_sel(write_sel),

    .read_sel1(read_sel1),
    .read_sel2(read_sel2),

    .write_data(write_data),

    .read_data1(reg_data1),
    .read_data2(reg_data2),

    .regA(regA),
    .regB(regB),
    .regC(regC),
    .regD(regD)

);

pipeline_register #(8) A_REG(

    .clk(clk),
    .reset(reset),

    .enable(A_en),

    .d(reg_data1),

    .q(A)

);

pipeline_register #(8) B_REG(

    .clk(clk),
    .reset(reset),

    .enable(B_en),

    .d(reg_data2),
    
    .q(B)

);

alu ALU(

    .A(A),
    .B(alu_B),

    .alu_op(alu_op),

    .result(alu_result),

    .zero(zero),
    .carry(carry),
    .negative(negative)

);

pipeline_register #(8) ALUOUT_REG(

    .clk(clk),
    .reset(reset),

    .enable(ALUOut_en),

    .d(alu_result),

    .q(ALUOut)

);


flags FLAGS(

    .clk(clk),
    .reset(reset),

    .flag_write(flag_write),

    .loadf(1'b0),

    .flag_data(3'b000),

    .zero_in(zero),
    .carry_in(carry),
    .negative_in(negative),

    .zero(zero_flag),
    .carry(carry_flag),
    .negative(negative_flag)

);

data_memory DATA(

    .clk(clk),

    .mem_write(mem_write),

    .address(ALUOut),

    .write_data(B),

    .read_data(memory_data)

);

pipeline_register #(8) MDR_REG(

    .clk(clk),
    .reset(reset),

    .enable(MDR_en),

    .d(memory_data),

    .q(MDR)

);

pc_update_logic NEXT_PC(

    .current_pc(PC),

    .target_address(IR[7:0]),

    .jump(JUMP),

    .branch(branch),

    .branch_taken(branch_taken),

    .next_pc(next_pc)

);

assign flag_write =
    ADD ||
    ADDI ||
    SUB ||
    SUBI ||
    CMP ||
    SHIFTL ||
    SHIFTR;


assign alu_op =
    (ADD  || ADDI) ? `ALU_ADD :
    (SUB  || SUBI) ? `ALU_SUB :
    (CMP)          ? `ALU_CMP :
    (SHIFTL)       ? `ALU_SHIFTL :
    (SHIFTR)       ? `ALU_SHIFTR :
                     `ALU_PASS_A;

assign write_data =
    LOADI_LOADP ? IR[7:0] :
    LOAD        ? MDR :
    LOADF       ? MDR :
    INPUTC      ? input_c :
    INPUTCF     ? input_c :
    INPUTD      ? input_d :
    INPUTDF     ? input_d :
                  ALUOut;                     
                     
assign mem_write =
    STORE ||
    STOREF;                     


endmodule
