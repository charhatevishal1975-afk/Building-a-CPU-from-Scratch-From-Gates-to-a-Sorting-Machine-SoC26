//====================================================
// data_memory.v
// i281 CPU Data Memory
//====================================================

module data_memory(

    input  wire        clk,

    // Write Enable
    input  wire        mem_write,

    // Address
    input  wire [7:0]  address,

    // Data to be written
    input  wire [7:0]  write_data,

    // Data read from memory
    output wire [7:0]  read_data

);

    //------------------------------------------------
    // Memory Array
    //------------------------------------------------

    reg [7:0] memory [0:255];
    integer i;
    initial begin 
    for(i=0;i<256;i=i+1)
        memory[i]=0;

    memory[0] = 5;
    memory[1] = 2;
    memory[2] = 8;
    memory[3] = 3;
    memory[4] = 9;
    memory[5] = 11;
    memory[6] = 1;
    memory[7] = 4;
end

    //------------------------------------------------
    // Asynchronous Read
    //------------------------------------------------

    assign read_data = memory[address];

    //------------------------------------------------
    // Synchronous Write
    //------------------------------------------------

    always @(posedge clk)
    begin

        if(mem_write)
            memory[address] <= write_data;    
    end

//temp check


// always @(*) begin
//     $display("READ addr=%0d data=%0d", address, read_data);
// end

endmodule