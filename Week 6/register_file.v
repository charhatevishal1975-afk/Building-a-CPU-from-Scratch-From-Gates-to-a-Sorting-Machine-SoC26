//====================================================
// register_file.v
// i281 CPU Register File
//====================================================

module register_file(

    input wire clk,
    input wire reset,

    // Register Write Enable
    input wire reg_write,

    // Destination Register Select
    input wire [1:0] write_sel,

    // Source Register 1 Select
    input wire [1:0] read_sel1,

    // Source Register 2 Select
    input wire [1:0] read_sel2,

    // Data to be written
    input wire [7:0] write_data,

    // Outputs
    output wire [7:0] read_data1,
    output wire [7:0] read_data2,

    // Debug Outputs
    output wire [7:0] regA,
    output wire [7:0] regB,
    output wire [7:0] regC,
    output wire [7:0] regD

);
    //------------------------------------------------
    // Registers
    //------------------------------------------------
    reg [7:0] A;
    reg [7:0] B;
    reg [7:0] C;
    reg [7:0] D;
    //------------------------------------------------
    // Reset + Write
    //------------------------------------------------
    always @(posedge clk or posedge reset)
    begin
        if(reset)
        begin
            A <= 8'd0;
            B <= 8'd0;
            C <= 8'd0;
            D <= 8'd0;
        end
        else if(reg_write)
        begin
            case(write_sel)

                2'b00:
                    A <= write_data;

                2'b01:
                    B <= write_data;

                2'b10:
                    C <= write_data;

                2'b11:
                    D <= write_data;
            endcase
        end
    end
    //------------------------------------------------
    // Read Port 1
    //------------------------------------------------
    assign read_data1 =
            (read_sel1 == 2'b00) ? A :
            (read_sel1 == 2'b01) ? B :
            (read_sel1 == 2'b10) ? C :
                                  D;
    //------------------------------------------------
    // Read Port 2
    //------------------------------------------------
    assign read_data2 =
            (read_sel2 == 2'b00) ? A :
            (read_sel2 == 2'b01) ? B :
            (read_sel2 == 2'b10) ? C :
                                  D;
    //------------------------------------------------
    // Debug Outputs
    //------------------------------------------------
    assign regA = A;
    assign regB = B;
    assign regC = C;
    assign regD = D;

// always @(posedge clk)
// begin
//     if(reg_write)
//         $display(
//             "WRITE R%0d <= %0d",
//             write_sel,
//             write_data
//         );
// end
// always @(posedge clk)
// begin
//     if(reg_write)
//         $display("RF: reg_write=%b write_data=%h",
//                  reg_write,
//                  write_data);
//                  $display(
//             "read_sel1=%0d read_data1=%0d read_sel2=%0d read_data2=%0d",
//             read_sel1,
//             read_data1,
//             read_sel2,
//             read_data2
//             );
// end



endmodule