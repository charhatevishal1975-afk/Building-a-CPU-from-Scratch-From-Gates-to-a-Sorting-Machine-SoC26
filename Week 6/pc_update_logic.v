//====================================================
// pc_update_logic.v
// i281 CPU PC Update Logic
//====================================================

module pc_update_logic(

    input  wire [7:0] current_pc,
    input  wire [7:0] target_address,

    input  wire jump,
    input  wire branch,
    input  wire branch_taken,

    output reg  [7:0] next_pc

);

always @(*) begin

    //------------------------------------------------
    // Priority:
    // 1. Jump
    // 2. Taken Branch
    // 3. Sequential Execution (PC + 1)
    //------------------------------------------------

    if(jump)
        next_pc = target_address;

    else if(branch && branch_taken)
        next_pc = target_address;

    else
        next_pc = current_pc + 8'd1;

end

endmodule