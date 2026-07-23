//====================================================
// alu.v
// i281 CPU Arithmetic Logic Unit
//====================================================

module alu(

    input  wire [7:0] A,
    input  wire [7:0] B,
    input  wire [2:0] alu_op,

    output reg  [7:0] result,

    output reg  zero,
    output reg  carry,
    output reg  negative

);

    // Internal 9-bit register to detect carry
    reg [8:0] temp;

    always @(*) begin

        // Default values
        result   = 8'd0;
        temp     = 9'd0;

        zero     = 1'b0;
        carry    = 1'b0;
        negative = 1'b0;

        // $display(
        //     "ALU DEBUG A=%0d B=%0d op=%0d",
        //     A,
        //     B,
        //     alu_op
        // );

        case(alu_op)

            //------------------------------------------------
            // ADD
            //------------------------------------------------
            3'b000: begin

                temp   = A + B;
                result = temp[7:0];
                carry  = temp[8];

            end

            //------------------------------------------------
            // SUB
            //------------------------------------------------
            3'b001: begin

                temp   = {1'b0,A} - {1'b0,B};
                result = temp[7:0];
                carry  = temp[8];

            end

            //------------------------------------------------
            // CMP (same as SUB, only flags matter later)
            //------------------------------------------------
            3'b010: begin

                temp   = {1'b0,A} - {1'b0,B};
                result = temp[7:0];
                carry  = temp[8];

            end

            //------------------------------------------------
            // SHIFT LEFT
            //------------------------------------------------
            3'b011: begin

                result = A << 1;
                carry  = A[7];

            end

            //------------------------------------------------
            // SHIFT RIGHT
            //------------------------------------------------
            3'b100: begin

                result = A >> 1;
                carry  = A[0];

            end

            //------------------------------------------------
            // PASS A
            //------------------------------------------------
            3'b101: begin

                result = A;

            end

            //------------------------------------------------
            // PASS B
            //------------------------------------------------
            3'b110: begin

                result = B;

            end

            //------------------------------------------------
            // Reserved
            //------------------------------------------------
            default: begin

                result = 8'd0;

            end

        endcase

        //------------------------------------------------
        // Common Flag Generation
        //------------------------------------------------

        zero = (result == 8'd0);

        negative = result[7];

    end

endmodule