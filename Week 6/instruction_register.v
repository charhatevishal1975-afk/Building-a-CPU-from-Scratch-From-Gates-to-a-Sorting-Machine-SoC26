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

always @(posedge clk)
begin
    if(ir_write)
        $display(
            "IR LOAD  PC=%0d  instruction_in=%h",
            tb_cpu.uut.PC,
            instruction_in
        );

    if(reset)
        instruction_out = 16'd0;
    else if(ir_write)
        instruction_out = instruction_in;
end

endmodule