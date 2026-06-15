// Week 2 — 8-bit ALU
// op: 000=ADD 001=SUB 010=AND 011=OR 100=XOR 101=SHIFTL 110=SHIFTR
// Run: iverilog -o sim ../testbenches/tb_alu.v alu.v && vvp sim

module alu(
    input  [7:0]     a, b,
    input  [2:0]     op,
    output reg [7:0] result,
    output           zero,
    output reg       carry,
    output reg       overflow
);
always @(*) begin
    case (op)
    3'h0 : begin
        {carry, result} = a + b;
    end
    3'h1 : begin
        {carry, result} = a - b;
    end
    3'h2 : begin
        result = a & b;
        carry = 0;
    end
    3'h3 : begin        
        result = a | b;
        carry = 0;
    end
    3'h4 : begin
        result = a ^ b;
        carry = 0;
    end
    3'h5 : begin
        result = a << 1;
        carry = a[7];
    end
    3'h6 : begin
        result = a >> 1;
        carry = a[0];
    end
    default : begin
        result = 0;
        carry = 0;
    end
    endcase
    overflow = (op == 3'h0 && a[7] == b[7] && result[7] != a[7]) || (op == 3'h1 && a[7] != b[7] && result[7] != a[7]);
end
assign zero = (result == 0);

endmodule
