//====================================================
// decoder.v
//====================================================

//----------------------------------------------------
// 1-to-2 Decoder
//----------------------------------------------------
module decoder_1to2 (
    input  wire En,
    input  wire w0,
    output wire y0,
    output wire y1
);

assign y0 = En & (~w0);
assign y1 = En & ( w0);

endmodule


//----------------------------------------------------
// 2-to-4 Decoder
//----------------------------------------------------
module decoder_2to4 (
    input  wire En,
    input  wire w0,
    input  wire w1,

    output wire y0,
    output wire y1,
    output wire y2,
    output wire y3
);

assign y0 = En & (~w1) & (~w0);
assign y1 = En & (~w1) & ( w0);
assign y2 = En & ( w1) & (~w0);
assign y3 = En & ( w1) & ( w0);

endmodule


//----------------------------------------------------
// 4-to-16 Decoder
//----------------------------------------------------
module decoder_4to16 (
    input  wire En,
    input  wire w0,
    input  wire w1,
    input  wire w2,
    input  wire w3,

    output wire y0,
    output wire y1,
    output wire y2,
    output wire y3,
    output wire y4,
    output wire y5,
    output wire y6,
    output wire y7,
    output wire y8,
    output wire y9,
    output wire y10,
    output wire y11,
    output wire y12,
    output wire y13,
    output wire y14,
    output wire y15
);

wire en0;
wire en1;
wire en2;
wire en3;

// Decode upper two bits (w3,w2)
decoder_2to4 upper_decoder (
    .En(En),
    .w0(w2),
    .w1(w3),

    .y0(en0),
    .y1(en1),
    .y2(en2),
    .y3(en3)
);

// Decode lower two bits (w1,w0)

decoder_2to4 lower_decoder0 (
    .En(en0),
    .w0(w0),
    .w1(w1),

    .y0(y0),
    .y1(y1),
    .y2(y2),
    .y3(y3)
);

decoder_2to4 lower_decoder1 (
    .En(en1),
    .w0(w0),
    .w1(w1),

    .y0(y4),
    .y1(y5),
    .y2(y6),
    .y3(y7)
);

decoder_2to4 lower_decoder2 (
    .En(en2),
    .w0(w0),
    .w1(w1),

    .y0(y8),
    .y1(y9),
    .y2(y10),
    .y3(y11)
);

decoder_2to4 lower_decoder3 (
    .En(en3),
    .w0(w0),
    .w1(w1),

    .y0(y12),
    .y1(y13),
    .y2(y14),
    .y3(y15)
);

endmodule

//----------------------------------------------------
// Opcode Decoder
//----------------------------------------------------
module opcode_decoder(
    input  wire [15:0] instruction,

    // Main opcode outputs
    output wire NOOP,
    output wire MOVE,
    output wire LOADI_LOADP,
    output wire ADD,
    output wire ADDI,
    output wire SUB,
    output wire SUBI,
    output wire LOAD,
    output wire LOADF,
    output wire STORE,
    output wire STOREF,
    output wire CMP,
    output wire JUMP,

    // MOVE sub-opcodes
    output wire INPUTC,
    output wire INPUTCF,
    output wire INPUTD,
    output wire INPUTDF,

    // SHIFT sub-opcodes
    output wire SHIFTL,
    output wire SHIFTR,

    // BRANCH sub-opcodes
    output wire BRE_BRZ,
    output wire BRNE_BRNZ,
    output wire BRG,
    output wire BRGE
);

    // Unused outputs from the main decoder
    wire y1_unused;
    wire y12_enable;
    wire y15_enable;

    //------------------------------------------------
    // Main 4-to-16 Opcode Decoder
    //------------------------------------------------
    decoder_4to16 main_decoder (
        .En(1'b1),

        .w0(instruction[12]),
        .w1(instruction[13]),
        .w2(instruction[14]),
        .w3(instruction[15]),

        .y0(NOOP),
        .y1(y1_unused),
        .y2(MOVE),
        .y3(LOADI_LOADP),
        .y4(ADD),
        .y5(ADDI),
        .y6(SUB),
        .y7(SUBI),
        .y8(LOAD),
        .y9(LOADF),
        .y10(STORE),
        .y11(STOREF),
        .y12(y12_enable),
        .y13(CMP),
        .y14(JUMP),
        .y15(y15_enable)
    );

    //------------------------------------------------
    // MOVE Sub Decoder
    // Enabled when opcode = MOVE
    // Uses instruction[9:8]
    //------------------------------------------------
    decoder_2to4 move_decoder (
        .En(y1_unused),

        .w0(instruction[8]),
        .w1(instruction[9]),

        .y0(INPUTC),
        .y1(INPUTCF),
        .y2(INPUTD),
        .y3(INPUTDF)
    );

    //------------------------------------------------
    // SHIFT Decoder
    // Enabled by y12
    // Uses instruction[8]
    //------------------------------------------------
    decoder_1to2 shift_decoder (
        .En(y12_enable),

        .w0(instruction[8]),

        .y0(SHIFTL),
        .y1(SHIFTR)
    );

    //------------------------------------------------
    // Branch Decoder
    // Enabled by y15
    // Uses instruction[9:8]
    //------------------------------------------------
    decoder_2to4 branch_decoder (
        .En(y15_enable),

        .w0(instruction[8]),
        .w1(instruction[9]),

        .y0(BRE_BRZ),
        .y1(BRNE_BRNZ),
        .y2(BRG),
        .y3(BRGE)
    );

endmodule

// instruction[15:12]
//         │
//         ▼
//    decoder_4to16
//         │
//         ├── y0  → NOOP
//         ├── y1  ─────────► decoder_2to4 → INPUTC, INPUTCF, INPUTD, INPUTDF
//         ├── y2  → MOVE 
//         ├── y3  → LOADI_LOADP
//         ├── y4  → ADD
//         ├── y5  → ADDI
//         ├── y6  → SUB
//         ├── y7  → SUBI
//         ├── y8  → LOAD
//         ├── y9  → LOADF
//         ├── y10 → STORE
//         ├── y11 → STOREF
//         ├── y12 ────────────────► decoder_1to2 → SHIFTL, SHIFTR
//         ├── y13 → CMP
//         ├── y14 → JUMP
//         └── y15 ────────────────► decoder_2to4 → BRE_BRZ, BRNE_BRNZ, BRG, BRGE

