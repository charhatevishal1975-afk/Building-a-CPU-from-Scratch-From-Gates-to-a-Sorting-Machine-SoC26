`timescale 1ns/1ps

`define RED    "\033[31m"
`define GREEN  "\033[32m"
`define RESET  "\033[0m"

module decoder_tb;

reg [15:0] instruction;

// Main opcode outputs
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

// MOVE sub-opcodes
wire INPUTC;
wire INPUTCF;
wire INPUTD;
wire INPUTDF;

// SHIFT sub-opcodes
wire SHIFTL;
wire SHIFTR;

// BRANCH sub-opcodes
wire BRE_BRZ;
wire BRNE_BRNZ;
wire BRG;
wire BRGE;


//----------------------------------------------
// Instantiate DUT
//----------------------------------------------
opcode_decoder DUT (

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


//----------------------------------------------
// Test Task
//----------------------------------------------
task check;

input expected;
input actual;
input [127:0] name;

begin

if (actual === expected)
    $display("%s : %sPASS%s", name, `GREEN, `RESET);
else
    $display("%s : %sFAIL%s", name, `RED, `RESET);

end

endtask


initial begin
    $dumpfile("decoder.vcd");
    $dumpvars(0, decoder_tb);
end

//----------------------------------------------
// Test Sequence
//----------------------------------------------
initial begin

//------------------------------------------------
// Main Opcodes
//------------------------------------------------

instruction = 16'b0000_0000_00000000;
#10;
check(1,NOOP,"NOOP");

instruction = 16'b0010_0000_00000000;
#10;
check(1,MOVE,"MOVE");

instruction = 16'b0011_0000_00000000;
#10;
check(1,LOADI_LOADP,"LOADI_LOADP");

instruction = 16'b0100_0000_00000000;
#10;
check(1,ADD,"ADD");

instruction = 16'b0101_0000_00000000;
#10;
check(1,ADDI,"ADDI");

instruction = 16'b0110_0000_00000000;
#10;
check(1,SUB,"SUB");

instruction = 16'b0111_0000_00000000;
#10;
check(1,SUBI,"SUBI");

instruction = 16'b1000_0000_00000000;
#10;
check(1,LOAD,"LOAD");

instruction = 16'b1001_0000_00000000;
#10;
check(1,LOADF,"LOADF");

instruction = 16'b1010_0000_00000000;
#10;
check(1,STORE,"STORE");

instruction = 16'b1011_0000_00000000;
#10;
check(1,STOREF,"STOREF");

instruction = 16'b1101_0000_00000000;
#10;
check(1,CMP,"CMP");

instruction = 16'b1110_0000_00000000;
#10;
check(1,JUMP,"JUMP");


//------------------------------------------------
// MOVE Sub Decoder
//------------------------------------------------

instruction = 16'b0001_0000_00000000;
#10;
check(1,INPUTC,"INPUTC");

instruction = 16'b0001_0001_00000000;
#10;
check(1,INPUTCF,"INPUTCF");

instruction = 16'b0001_0010_00000000;
#10;
check(1,INPUTD,"INPUTD");

instruction = 16'b0001_0011_00000000;
#10;
check(1,INPUTDF,"INPUTDF");


//------------------------------------------------
// SHIFT Decoder
//------------------------------------------------

instruction = 16'b1100_0000_00000000;
#10;
check(1,SHIFTL,"SHIFTL");

instruction = 16'b1100_0001_00000000;
#10;
check(1,SHIFTR,"SHIFTR");


//------------------------------------------------
// Branch Decoder
//------------------------------------------------

instruction = 16'b1111_0000_00000000;
#10;
check(1,BRE_BRZ,"BRE_BRZ");

instruction = 16'b1111_0001_00000000;
#10;
check(1,BRNE_BRNZ,"BRNE_BRNZ");

instruction = 16'b1111_0010_00000000;
#10;
check(1,BRG,"BRG");

instruction = 16'b1111_0011_00000000;
#10;
check(1,BRGE,"BRGE");


$display("");
$display("==================================");
$display(" ALL TESTS COMPLETED ");
$display("==================================");

$finish;

end

endmodule