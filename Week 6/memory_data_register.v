module memory_data_register(

    input wire clk,
    input wire reset,
    input wire write,

    input wire [7:0] data_in,

    output reg [7:0] data_out

);

always @(posedge clk) begin

    if(reset)
        data_out <= 0;

    else if(write)
        data_out <= data_in;

end

endmodule