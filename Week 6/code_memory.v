//====================================================
// code_memory.v
// i281 CPU Instruction Memory
//====================================================

module code_memory(

    input  wire [7:0] address,

    output wire [15:0] instruction

);

    //------------------------------------------------
    // Instruction Memory
    //------------------------------------------------

    reg [15:0] memory [0:255];

    //------------------------------------------------
    // Program Initialization
    //------------------------------------------------

    initial begin

        // Load instructions from file
        $readmemh("program.mem", memory);

    end 

    //------------------------------------------------
    // Asynchronous Read
    //------------------------------------------------

    assign instruction = memory[address];

endmodule