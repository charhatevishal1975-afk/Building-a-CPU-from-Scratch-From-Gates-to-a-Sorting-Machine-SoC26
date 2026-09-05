`timescale 1ns/1ps
`include "isa_defines.vh"

module multicycle_cpu(

    input wire clk,
    input wire reset,

    input wire [15:0] input_c,
    input wire [15:0] input_d

);


wire NOOP;
wire MOVE;
wire LOADI_LOADP;
wire ADD;
wire ADDI;
wire SUB;
wire SUBI;
wire LOAD;
wire LOADF;
wire STORE;
wire STOREF;
wire CMP;
wire JUMP;

wire INPUTC;
wire INPUTCF;
wire INPUTD;
wire INPUTDF;

wire SHIFTL;
wire SHIFTR;

wire BRE_BRZ;
wire BRNE_BRNZ;
wire BRG;
wire BRGE;


wire [7:0] PC;

wire [15:0] IR;

wire [7:0] A_reg;
wire [7:0] B_reg;

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
assign write_sel = IR[11:10];

wire reg_write;

wire A_en;

wire B_en;

wire [1:0] rf_read_sel1;
wire [1:0] rf_read_sel2;

wire ALUSrcA;
wire [1:0] ALUSrcB;


assign rf_read_sel1 =
    (SHIFTL || SHIFTR) ?
        {IR[9],IR[7]} : (STOREF) ? IR[11:10] : IR[9:8];
       

assign rf_read_sel2 =
    (STOREF || LOADF) ? IR[9:8] :
    IR[7:6];

wire [2:0] alu_op;

wire [7:0] alu_B;

wire [7:0] alu_input_A;
wire [7:0] alu_input_B;

assign alu_input_A =
    ALUSrcA ? A_reg : PC;

assign alu_input_B =
    (ALUSrcB == 2'b00) ? B_reg :
    (ALUSrcB == 2'b01) ? 8'd1 :
    (ALUSrcB == 2'b10) ? IR[7:0] :
                         8'd4;


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
wire [7:0] effective_address;

assign effective_address =
    IR[7:0] + B_reg;

wire [2:0] flag_data;

assign flag_data = memory_data[2:0];    




opcode_decoder DECODER(

    .instruction(IR),

    .NOOP(NOOP),
    .MOVE(MOVE),
    .LOADI_LOADP(LOADI_LOADP),
    .ADD(ADD),
    .ADDI(ADDI),
    .SUB(SUB),
    .SUBI(SUBI),
    .LOAD(LOAD),
    .LOADF(LOADF),
    .STORE(STORE),
    .STOREF(STOREF),
    .CMP(CMP),
    .JUMP(JUMP),

    .INPUTC(INPUTC),
    .INPUTCF(INPUTCF),
    .INPUTD(INPUTD),
    .INPUTDF(INPUTDF),

    .SHIFTL(SHIFTL),
    .SHIFTR(SHIFTR),

    .BRE_BRZ(BRE_BRZ),
    .BRNE_BRNZ(BRNE_BRNZ),
    .BRG(BRG),
    .BRGE(BRGE)

);

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

    .read_sel1(rf_read_sel1),
    .read_sel2(rf_read_sel2),

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

    .q(A_reg)

);

pipeline_register #(8) B_REG(

    .clk(clk),
    .reset(reset),

    .enable(B_en),

    .d(reg_data2),
    
    .q(B_reg)

);

alu ALU(

    .A(alu_input_A),
    .B(alu_input_B),

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

    .loadf(LOADF),

    .flag_data(flag_data),

    .zero_in(zero),
    .carry_in(carry),
    .negative_in(negative),

    .zero(zero_flag),
    .carry(carry_flag),
    .negative(negative_flag)

);

wire [7:0] mem_write_data;

assign mem_write_data =
    STOREF ? A_reg :
             B_reg;

data_memory DATA(

    .clk(clk),

    .mem_write(mem_write),

    .address((LOADF || STOREF)
        ? effective_address
        : ALUOut),

    .write_data(mem_write_data),

    .read_data(memory_data)

);

pipeline_register #(8) MDR_REG(

    .clk(clk),
    .reset(reset),

    .enable(MDR_en),

    .d(memory_data),

    .q(MDR)

);

wire jump_gated;
wire branch_gated;

assign jump_gated   = JUMP & branch_resolve;    // NEW
assign branch_gated = branch & branch_resolve;  // NEW

pc_update_logic NEXT_PC(

    .current_pc(PC),

    .target_address(IR[7:0]),

    .jump(jump_gated),

    .branch(branch_gated),

    .branch_taken(branch_taken),

    .next_pc(next_pc)

);

wire branch_resolve;   // NEW


multicycle_control CONTROL(

    .clk(clk),
    .reset(reset),

    .instruction(IR),
    .branch_taken(branch_taken),   // NEW

    .pc_write(pc_write),
    .ir_write(ir_write),
    .branch_resolve(branch_resolve),   // NEW

    .A_en(A_en),
    .B_en(B_en),

    .ALUOut_en(ALUOut_en),
    .MDR_en(MDR_en),

    .reg_write(reg_write),
    .mem_write(mem_write),
    .flag_write(flag_write),
    .ALUSrcA(ALUSrcA),
    .ALUSrcB(ALUSrcB)

);

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

assign branch =
    BRE_BRZ |
    BRNE_BRNZ |
    BRG |
    BRGE;

assign branch_taken =

        (BRE_BRZ   && zero_flag) ||

        (BRNE_BRNZ && !zero_flag) ||

        (BRG  && !zero_flag && !carry_flag) ||

        (BRGE && !carry_flag);

// always @(posedge clk)
// begin
//     if(MDR_en)
//         $display("MDR LOAD d=%0d", memory_data);
// end

// always @(*) begin
//     $display(
//         "LOADF=%b STOREF=%b B_reg=%0d EA=%0d ALUOut=%0d addr=%0d",
//         LOADF,
//         STOREF,
//         B_reg,
//         effective_address,
//         ALUOut,
//         (LOADF || STOREF) ? effective_address : ALUOut
//     );
// end

// always @(*) begin
//     $display(
//         "LOADF=%b rf_read_sel2=%0d reg_data2=%0d B_reg=%0d",
//         LOADF,
//         rf_read_sel2,
//         reg_data2,
//         B_reg
//     );
// end

// always@(posedge clk) begin
//     $display(
//     " PC=%0d IR=%h Areg=%0d Breg=%0d ALUinA=%0d ALUinB=%0d ALU=%0d ALUOut=%0d",
//     PC,
//     IR,
//     A_reg,
//     B_reg,
//     alu_input_A,
//     alu_input_B,
//     alu_result,
//     ALUOut
//     );
// end


// always @(posedge clk)
// begin
//     $display(
//         "IR=%h write_sel=%b reg_write=%b write_data=%0d",
//         IR,
//         write_sel,
//         reg_write,
//         write_data
//     );
// end

// always @(posedge clk)
// begin
//     $display(
//     "CTRL state=%0d A_en=%b B_en=%b",
//     CONTROL.state,
//     A_en,
//     B_en
//     );
// end
// always @(posedge clk) begin
//     $display(
//     "RF outputs: read1=%0d read2=%0d",
//     reg_data1,
//     reg_data2
//     );
// end

// always @(posedge clk)
// begin
//     $display(
//         "rf_read_sel1=%b rf_read_sel2=%b",
//         rf_read_sel1,
//         rf_read_sel2
//     );
// end

// always @(posedge clk)
// begin
//     $display(
//         "ADD=%b ADDI=%b SUB=%b SUBI=%b LOADI=%b alu_op=%0d",
//         ADD,
//         ADDI,
//         SUB,
//         SUBI,
//         LOADI_LOADP,
//         alu_op
//     );
// end

// always @(posedge clk)
// begin
//     $display(
//         "CMP=%b BRE=%b Z=%b branch_taken=%b",
//         CMP,
//         BRE_BRZ,
//         zero_flag,
//         branch_taken
//     );
// end

// always @(posedge clk)
// begin
//     $display(
//         "PC=%0d IR=%h",
//         PC,
//         IR
//     );
// end                  
// always @(posedge clk)
// begin
//     $display("LOADI=%b reg_write=%b write_data=%d",
//              LOADI_LOADP,
//              reg_write,
//              write_data);
//     $display("IR = %h  immediate = %h", IR, IR[7:0]);
// end
// always @(posedge clk)
// begin
//     $display(
//     "A=%0d  B=%0d  ALU=%0d  ALUOut=%0d",
//     A_reg,
//     B_reg,
//     alu_result,
//     ALUOut
//     );
// end
// always @(posedge clk) begin
//     $display(
//         "ALUSrcA=%b ALUSrcB=%b Ain=%0d Bin=%0d",
//         ALUSrcA,
//         ALUSrcB,
//         alu_input_A,
//         alu_input_B
//     );
// end

endmodule
