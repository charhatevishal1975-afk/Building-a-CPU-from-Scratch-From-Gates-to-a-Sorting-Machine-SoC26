module alu_out_register(

    input wire clk,
    input wire reset,
    input wire write,

    input wire [7:0] data_in,

    output reg [7:0] alu_out

);

always @(posedge clk) begin

    if(reset)
        alu_out <= 0;

    else if(write)
        alu_out <= data_in;

end

endmodule