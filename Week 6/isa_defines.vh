//====================================================
// isa_defines.vh
// i281 CPU ISA Definitions
//====================================================

`ifndef ISA_DEFINES_VH
`define ISA_DEFINES_VH

//----------------------------------------------------
// Main Opcodes (Matches opcode_decoder.v)
//----------------------------------------------------

`define OP_NOOP        4'b0000
`define OP_RESERVED    4'b0001
`define OP_MOVE        4'b0010
`define OP_LOADI       4'b0011
`define OP_ADD         4'b0100
`define OP_ADDI        4'b0101
`define OP_SUB         4'b0110
`define OP_SUBI        4'b0111
`define OP_LOAD        4'b1000
`define OP_LOADF       4'b1001
`define OP_STORE       4'b1010
`define OP_STOREF      4'b1011
`define OP_SHIFT       4'b1100
`define OP_CMP         4'b1101
`define OP_JUMP        4'b1110
`define OP_BRANCH      4'b1111
`define OP_BRE         4'b1001
`define OP_BRNE        4'b1011
`define OP_BRG         4'b1100
`define OP_BRGE        4'b1111

//----------------------------------------------------
// MOVE Sub-Opcodes (instruction[9:8])
//----------------------------------------------------

`define MOVE_INPUTC    2'b00
`define MOVE_INPUTCF   2'b01
`define MOVE_INPUTD    2'b10
`define MOVE_INPUTDF   2'b11

//----------------------------------------------------
// SHIFT Sub-Opcodes (instruction[8])
//----------------------------------------------------

`define SHIFT_LEFT     1'b0
`define SHIFT_RIGHT    1'b1

//----------------------------------------------------
// BRANCH Sub-Opcodes (instruction[9:8])
//----------------------------------------------------

`define BR_EQ          2'b00
`define BR_NE          2'b01
`define BR_GT          2'b10
`define BR_GE          2'b11

//----------------------------------------------------
// Register Encoding
//----------------------------------------------------

`define REG_A          2'b00
`define REG_B          2'b01
`define REG_C          2'b10
`define REG_D          2'b11

//----------------------------------------------------
// ALU Operations
//----------------------------------------------------

`define ALU_ADD        3'b000
`define ALU_SUB        3'b001
`define ALU_CMP        3'b010
`define ALU_SHIFTL     3'b011
`define ALU_SHIFTR     3'b100
`define ALU_PASS_A     3'b101
`define ALU_PASS_B     3'b110

`endif