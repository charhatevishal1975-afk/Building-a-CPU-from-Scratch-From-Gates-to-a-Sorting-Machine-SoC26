// Week 2 — Parameterized MUX
// ===========================
// Parameterized modules let you reuse the same code for 1-bit,
// 8-bit, or any-bit-wide signals — important in a CPU datapath.
//
// Run: iverilog -o sim ../testbenches/tb_mux.v mux.v && vvp sim

// 2:1 MUX — WIDTH bits wide
module mux2 #(parameter WIDTH = 8) (
    input  [WIDTH-1:0] a, b,
    input              sel,
    output [WIDTH-1:0] y
);
    // YOUR CODE HERE
    assign y = (sel) ? b : a;
    // Hint: one line with assign and ternary operator is perfect here
endmodule

// 4:1 MUX — WIDTH bits wide
module mux4 #(parameter WIDTH = 8) (
    input  [WIDTH-1:0] d0, d1, d2, d3,
    input  [1:0]       sel,
    output [WIDTH-1:0] y
);
    // YOUR CODE HERE
    reg [WIDTH-1:0]x;
    
    always @(*) begin
        case (sel)
        2'b00 : x = d0;
        2'b01 : x = d1;
        2'b10 : x = d2;
        2'b11 : x = d3;
        endcase

    end
    assign y = x;
    
        
endmodule
