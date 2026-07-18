//====================================================
// instruction_encoder.vh
//====================================================

`ifndef INSTRUCTION_ENCODER_VH
`define INSTRUCTION_ENCODER_VH

//----------------------------------------------------
// Instruction Formats
//----------------------------------------------------

// LOADI
`define LOADI(rd,imm) \
{`OP_LOADI, rd, imm}

// MOVE
`define MOVE(rd,rs) \
{`OP_MOVE, rd, rs, 2'b00, 6'b0}

`define ADDI(rd, rs, imm) \
{`OP_ADDI, rd, rs, imm}

`define SUBI(rd, rs, imm) \
{`OP_SUBI, rd, rs, imm}     

`define STORE(rs,addr) \
{`OP_STORE, rs, addr}

`define SHIFTL(rd, rs) \
{`OP_SHIFT, rd, rs, 1'b0, 7'b0}

`define SHIFTR(rd, rs) \
{`OP_SHIFT, rd, rs, 1'b1, 7'b0}

`endif