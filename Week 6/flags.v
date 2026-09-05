//====================================================
// flags.v
// i281 CPU Flags Register
//====================================================

module flags(

    input wire clk,
    input wire reset,

    input wire flag_write,
    input loadf,
    input [2:0]flag_data,
    input wire zero_in,
    input wire carry_in,
    input wire negative_in,


    output reg zero, 
    output reg carry,
    output reg negative

);

always @(posedge clk or posedge reset)
begin

    if(reset)
    begin

        zero <= 0;
        carry <= 0;
        negative <= 0;

    end

    else if(loadf)
    begin
        zero     <= flag_data[2];
        carry    <= flag_data[1];
        negative <= flag_data[0];
    end

    else if(flag_write)
    begin

        zero <= zero_in;
        carry <= carry_in;
        negative <= negative_in;

    end
// $display("stored flags: Z=%b C=%b N=%b", zero, carry, negative);

end

// always @(posedge clk)
// begin
//     if(flag_write)
//         $display(
//             "FLAGS WRITE Z=%b C=%b N=%b",
//             zero_in,
//             carry_in,
//             negative_in
//         );
// end
// always @(posedge clk)
// begin
//     $display(
//         "FLAGS REG Z=%b C=%b N=%b",
//         zero,
//         carry,
//         negative
//     );
// end

endmodule