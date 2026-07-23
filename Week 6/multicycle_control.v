`timescale 1ns/1ps
`include "isa_defines.vh"

module multicycle_control(

    input  wire        clk,
    input  wire        reset,
    input  wire [15:0] instruction,
     input  wire        branch_taken,   // NEW

    output reg         pc_write,
    output reg         ir_write,
    output reg         branch_resolve,

    output reg         A_en,
    output reg         B_en,

    output reg         ALUOut_en,
    output reg         MDR_en,

    output reg         reg_write,
    output reg         mem_write,
    output reg         flag_write,

    output reg         ALUSrcA,
    output reg [1:0]   ALUSrcB

);

localparam FETCH     = 3'd0;
localparam DECODE    = 3'd1;
localparam EXECUTE   = 3'd2;
localparam MEMORY    = 3'd3;
localparam WRITEBACK = 3'd4;

reg [2:0] state;
reg [2:0] next_state;

wire [3:0] opcode;
assign opcode = instruction[15:12];


//----------------------------------------------------
// State Register
//----------------------------------------------------

always @(posedge clk or posedge reset)
begin
    if(reset)
        state <= FETCH;
    else
        state <= next_state;
end


//----------------------------------------------------
// Next State Logic
//----------------------------------------------------

always @(*) begin

    next_state = FETCH;

    case(state)

        FETCH:
            next_state = DECODE;

        DECODE:
            next_state = EXECUTE;

        EXECUTE:
        begin
            case(opcode)

                4'b1000,
                4'b1001,
                4'b1010,
                4'b1011:
                    next_state = MEMORY;

                default:
                    next_state = WRITEBACK;

            endcase
        end

        MEMORY:
            next_state = WRITEBACK;

        WRITEBACK:
            next_state = FETCH;

    endcase

end


//----------------------------------------------------
// Output Logic
//----------------------------------------------------

always @(*) begin

    pc_write   = 0;
    ir_write   = 0;
    branch_resolve = 0;

    A_en       = 0;
    B_en       = 0;

    ALUOut_en  = 0;
    MDR_en     = 0;

    reg_write  = 0;
    mem_write  = 0;
    flag_write = 0;

    ALUSrcA    = 0;
    ALUSrcB    = 2'b00;

    case(state)

    //------------------------------------------------
    // FETCH
    //------------------------------------------------

    FETCH:
    begin
        pc_write = 1;
        ir_write = 1;

        ALUSrcA = 0;      // PC
        ALUSrcB = 2'b01;  // +1
    end


    //------------------------------------------------
    // DECODE
    //------------------------------------------------

    DECODE:
    begin
        A_en = 1;
       if (!(opcode == 4'b1001))
        B_en = 1;
    end


    //------------------------------------------------
    // EXECUTE
    //------------------------------------------------

    EXECUTE:
    begin

        case(opcode)
        4'b0011:
            ALUOut_en = 0;
        default:
            ALUOut_en = 1;
        endcase
        ALUSrcA = 1;      // Register A
        ALUSrcB = 2'b00;  // Register B

        case(opcode)

            4'b0011,   // LOADI
            4'b0101,   // ADDI
            4'b0111:   // SUBI
                ALUSrcB = 2'b10;

        endcase

        case(opcode)

            4'b0100, // ADD
            4'b0101, // ADDI
            4'b0110, // SUB
            4'b0111, // SUBI
            4'b1100, // SHIFT
            4'b1101: // CMP
                flag_write = 1;

        endcase

         // NEW: resolve jump/branch target one cycle earlier,
        // using the IR that was just loaded for THIS instruction
        // resolve jump/branch target using the IR just loaded for THIS instruction
        case(opcode)

            4'b1110: // JUMP — always taken
            begin
                pc_write = 1;
                branch_resolve = 1;
            end

            4'b1111: // BRANCH — only if condition is met
                if(branch_taken)
                begin
                    pc_write = 1;
                    branch_resolve = 1;
                end

        endcase

    end


    //------------------------------------------------
    // MEMORY
    //------------------------------------------------

    MEMORY:
    begin

        case(opcode)

            4'b1000,
            4'b1001:
                MDR_en = 1;

            4'b1010,
            4'b1011:
                mem_write = 1;

        endcase

    end


    //------------------------------------------------
    // WRITEBACK
    //------------------------------------------------

    WRITEBACK:
    begin

        case(opcode)

            4'b0001,
            4'b0010,
            4'b0011,
            4'b0100,
            4'b0101,
            4'b0110,
            4'b0111,
            4'b1000,
            4'b1001,
            4'b1100:
                reg_write = 1;

        endcase

    end

    endcase

end

always@(posedge clk) begin
    $display(
            "state=%0d",
            state
        );
end



endmodule