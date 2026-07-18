//====================================================
// pc.v
// i281 CPU Program Counter
//====================================================

module pc(

    input wire clk,
    input wire reset,

    input wire pc_write,

    input wire [7:0] pc_next,

    output reg [7:0] pc

);

always @(posedge clk or posedge reset)
begin

    if(reset)

        pc <= 8'd0;

    else if(pc_write)

        pc <= pc_next;

end

endmodule