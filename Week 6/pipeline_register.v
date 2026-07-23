module pipeline_register #(parameter WIDTH = 8)
(
    input wire clk,
    input wire reset,
    input wire enable,

    input wire [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);

always @(posedge clk or posedge reset)
begin
    if(reset)
        q <= 0;
    else if(enable)
        q <= d;
end

// always @(posedge clk)
// begin
//     if(enable)
//         $display("PIPE REG enable=%b d=%h q(old)=%h", enable, d, q);
// end


endmodule