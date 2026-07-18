`timescale 1ns / 1ps
`include "isa_defines.vh"

module cpu(

    input wire clk,
    input wire reset,
    input wire [15:0] input_c,
    input wire [15:0] input_d

);

//--------------------------------------------------
// Program Counter
//--------------------------------------------------

wire [7:0] pc;
wire [7:0] next_pc;

//--------------------------------------------------
// Instruction
//--------------------------------------------------

wire [15:0] instruction_from_mem;
wire [15:0] instruction;

//--------------------------------------------------
// Register File
//--------------------------------------------------

wire [7:0] reg_data1;
wire [7:0] reg_data2;

wire [7:0] regA;
wire [7:0] regB;
wire [7:0] regC;
wire [7:0] regD;
wire reg_write;

wire [1:0] write_sel;
wire [1:0] read_sel1;
wire [1:0] read_sel2;

//--------------------------------------------------
// ALU
//--------------------------------------------------


wire [2:0] alu_op;

wire [7:0] alu_result;

wire zero;
wire carry;
wire negative;

//--------------------------------------------------
// Flags
//--------------------------------------------------

wire flag_write;

wire zero_flag;
wire carry_flag;
wire negative_flag;

//--------------------------------------------------
// Data Memory
//--------------------------------------------------

wire mem_write;

wire [7:0] memory_data;

//--------------------------------------------------
// Opcode Decoder
//--------------------------------------------------

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
wire [7:0] reg_write_data;
wire branch;
wire branch_taken;
wire [7:0] immediate;
assign immediate = instruction[7:0];
wire [7:0] base_address;
wire [1:0] offset_reg;
wire [7:0] effective_address;
assign base_address = instruction[7:0];
assign offset_reg   = instruction[9:8];
wire [1:0] rf_read_sel1;
wire [1:0] rf_read_sel2;

assign rf_read_sel1 = read_sel1;

assign rf_read_sel2 =
    (LOADF || STOREF) ? offset_reg : read_sel2;

assign effective_address = base_address + reg_data2[7:0];
wire [2:0] flag_data;
assign flag_data = memory_data[2:0];

//--------------------------------------------------
// Program Counter
//--------------------------------------------------

pc PC(

    .clk(clk),
    .reset(reset),

    .pc_write(1'b1),

    .pc_next(next_pc),

    .pc(pc)

);

//--------------------------------------------------
// Code Memory
//--------------------------------------------------

code_memory CODE(

    .address(pc),

    .instruction(instruction_from_mem)

);

//--------------------------------------------------
// Opcode Decoder
//--------------------------------------------------
opcode_decoder DECODER(

    .instruction(instruction),

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
// Register File
//--------------------------------------------------

register_file RF(

    .clk(clk),
    .reset(reset),

    .reg_write(reg_write),

    .write_sel(write_sel),

    .read_sel1(rf_read_sel1),
    .read_sel2(rf_read_sel2),

    .write_data(reg_write_data),

    .read_data1(reg_data1),
    .read_data2(reg_data2),

    .regA(regA),
    .regB(regB),
    .regC(regC),
    .regD(regD)

);
//--------------------------------------------------
// ALU
//--------------------------------------------------

wire [7:0] alu_B;
assign alu_B =
        (ADDI || SUBI) ? instruction[7:0] :
                         reg_data2;
                         
alu ALU(

    .A(reg_data1),
    .B(alu_B),

    .alu_op(alu_op),

    .result(alu_result),    

    .zero(zero),
    .carry(carry),
    .negative(negative)

);
//--------------------------------------------------
// Flags Register
//--------------------------------------------------

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
//--------------------------------------------------
// Data Memory
//--------------------------------------------------

data_memory DATA(

    .clk(clk),

    .mem_write(mem_write),

    .address( (LOADF || STOREF)
        ? effective_address
        : instruction[7:0]),

    .write_data(reg_data1),

    .read_data(memory_data)

);
//--------------------------------------------------
// PC Update Logic
//--------------------------------------------------

pc_update_logic NEXT_PC(

    .current_pc(pc),

    .target_address(instruction[7:0]),

    .jump(JUMP),

    .branch(branch),

    .branch_taken(branch_taken),

    .next_pc(next_pc)

);
control_unit control (
.instruction(instruction),
.LOADI_LOADP(LOADI_LOADP),
.MOVE(MOVE),
.ADD(ADD),
.ADDI(ADDI),
.SUB(SUB),
.SUBI(SUBI),
.LOAD(LOAD),
.STORE(STORE),
.CMP(CMP),
.SHIFTL(SHIFTL),
.SHIFTR(SHIFTR),
.INPUTC(INPUTC),
.INPUTCF(INPUTCF),
.INPUTD(INPUTD),
.INPUTDF(INPUTDF),
.LOADF(LOADF),
.STOREF(STOREF),
.reg_write(reg_write),
.write_sel(write_sel),
.read_sel1(read_sel1),
.read_sel2(read_sel2),
.alu_op(alu_op),
.mem_write(mem_write),
.flag_write(flag_write)

);


assign reg_write_data =
    LOADI_LOADP ? immediate :
    INPUTC      ? input_c :
    INPUTCF     ? input_c :
    INPUTD      ? input_d :
    INPUTDF     ? input_d :
    LOAD        ? memory_data :
    LOADF       ? memory_data :
    alu_result;

assign branch =
        BRE_BRZ |
        BRNE_BRNZ |
        BRG |
        BRGE;

assign branch_taken =

        (BRE_BRZ     && zero_flag) ||

        (BRNE_BRNZ   && !zero_flag) ||

        (BRG  && !zero_flag && !carry_flag) ||

            (BRGE && !carry_flag);

always @(posedge clk) begin
        if(mem_write)
        begin
            $display(
                "WRITE addr=%0d data=%0d rs1=%0d",
                (LOADF || STOREF)
        ? effective_address
        : instruction[7:0],
                reg_data1,
                rf_read_sel1
            );
        end
    end            

endmodule
