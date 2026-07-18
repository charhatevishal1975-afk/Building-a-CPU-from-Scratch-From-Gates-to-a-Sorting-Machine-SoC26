//====================================================
// cpu_minimal.v
// Stage 1 : Instruction Fetch
//====================================================

`include "isa_defines.vh"

module cpu_minimal(

    input wire clk,
    input wire reset

);

    //------------------------------------------------
    // Flag Register Signals
    //------------------------------------------------

    reg flags_write;

    wire zero_flag;
    wire carry_flag;
    wire negative_flag;

    //------------------------------------------------
    // ALU Signals
    //------------------------------------------------

    reg  [2:0] alu_op;

    wire [7:0] alu_result;

    wire zero;
    wire carry;
    wire overflow;
    wire negative;

    //------------------------------------------------
    // PC Signals
    //------------------------------------------------

    wire [7:0] current_pc;
    wire [7:0] next_pc;
    //------------------------------------------------
    // Register File Signals
    //------------------------------------------------

    wire [7:0] reg_data1;
    wire [7:0] reg_data2;

    wire [7:0] regA;
    wire [7:0] regB;
    wire [7:0] regC;
    wire [7:0] regD;

    wire [1:0] rs1;
    wire [1:0] rs2;
    wire [1:0] rd;
    //------------------------------------------------
    // Instruction
    //------------------------------------------------

    wire [15:0] instruction;

    //------------------------------------------------
    // Program Counter
    //------------------------------------------------
    assign rd  = instruction[11:10];
    assign rs1 = instruction[9:8];
    assign rs2 = instruction[7:6];

    //------------------------------------------------
    // Immediate
    //------------------------------------------------

    wire [7:0] immediate;

assign immediate = instruction[7:0];

reg reg_write;
reg [7:0] write_data;

flags FLAGS(

    .clk(clk),
    .reset(reset),

    .flag_write(flags_write),

    .zero_in(zero),
    .carry_in(carry),
    .negative_in(negative),

    .zero(zero_flag),
    .carry(carry_flag),
    .negative(negative_flag)

);

    alu ALU(

    .A(reg_data1),
    .B(reg_data2),

    .alu_op(alu_op),

    .result(alu_result),

    .zero(zero),
    .carry(carry),
    .negative(negative)

);

    register_file RF(

        .clk(clk),
        .reset(reset),

        .reg_write(reg_write),
        .write_data(write_data),          // No writes yet
        .write_sel(rd),
        .read_sel1(rs1),
        .read_sel2(rs2),
        .read_data1(reg_data1),
        .read_data2(reg_data2),

        .regA(regA),
        .regB(regB),
        .regC(regC),
        .regD(regD)

    );

    pc PC(

        .clk(clk),
        .reset(reset),

        .pc_write(1'b1),

        .pc_next(next_pc),

        .pc(current_pc)

    );

    //------------------------------------------------
    // PC Update Logic
    //------------------------------------------------

    pc_update_logic PC_NEXT(

        .current_pc(current_pc),

        .target_address(8'd0),

        .jump(1'b0),

        .branch(1'b0),

        .branch_taken(1'b0),

        .next_pc(next_pc)

    );

    //------------------------------------------------
    // Code Memory
    //------------------------------------------------

    code_memory IM(

        .address(current_pc),

        .instruction(instruction)

    );


    //------------------------------------------------
// Minimal Control Unit
//------------------------------------------------

always @(*) begin

    reg_write = 0;
    write_data = 0;

    alu_op = 3'b000;

    

    case(instruction[15:12])

        //----------------------------------------
        // LOADI
        //----------------------------------------

        `OP_LOADI:
        begin
            reg_write = 1'b1;
            write_data = immediate;
        end

        //----------------------------------------
        // MOVE
        //----------------------------------------

        `OP_MOVE:
        begin
            reg_write = 1'b1;
            write_data = reg_data1;
        end
        //----------------------------------------
        // ADD
        //----------------------------------------
        `OP_ADD:
        begin

            reg_write = 1'b1;

            flags_write = 1'b1;

            alu_op = `ALU_ADD;

            write_data = alu_result;

        end
       `OP_SUB:
        begin

            reg_write = 1'b1;

            flags_write = 1'b1;

            alu_op = `ALU_SUB;

            write_data = alu_result;

        end
        default:
        begin
            reg_write = 1'b0;
            write_data = 8'd0;
        end

    endcase

end

    //------------------------------------------------
    // Debug Display
    //------------------------------------------------

    always @(posedge clk)
begin
    $display("-------------------------------------------");
$display("PC          : %0d", current_pc);
$display("Instruction : %h", instruction);

$display("Opcode      : %h", instruction[15:12]);

$display("Immediate   : %0d", immediate);

$display("");

$display("Registers");

$display("ALU");

$display("A Input     : %0d", reg_data1);
$display("B Input     : %0d", reg_data2);
$display("ALU Result  : %0d", alu_result);

$display("");

$display("Registers");

$display("A = %0d", regA);
$display("B = %0d", regB);
$display("C = %0d", regC);
$display("D = %0d", regD);
$display("ALU Result : %0d", alu_result);
$display("");

$display("Flags");

$display("Z = %0d", zero_flag);
$display("C = %0d", carry_flag);
$display("N = %0d", negative_flag);
end

endmodule