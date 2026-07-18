//====================================================
// instruction_register.v
//====================================================

module instruction_register(

    input wire clk,
    input wire reset,
    input wire ir_write,

    input wire [15:0] instruction_in,

    output reg [15:0] instruction_out

);

always @(posedge clk) begin

    if(reset)
        instruction_out <= 16'd0;

    else if(ir_write)
        instruction_out <= instruction_in;

end

endmodule