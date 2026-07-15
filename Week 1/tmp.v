module top_module(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
); 

    reg [15:0] q_2d [15:0];
    reg [15:0] next_q_2d [15:0];
    integer i, j, ni, nj;
    reg [3:0] neighbors;

    // Convert 1D q to 2D for easier indexing
    always @(*) begin
        for (i = 0; i < 16; i = i + 1) begin
            q_2d[i] = q[i*16 +: 16];
        end
    end

    // Combinational logic for next state
    always @(*) begin
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                neighbors = 0;
                // Count 8 neighbors with toroidal wrapping
                for (int di = -1; di <= 1; di = di + 1) begin
                    for (int dj = -1; dj <= 1; dj = dj + 1) begin
                        if (di != 0 || dj != 0) begin
                            ni = (i + di + 16) % 16;
                            nj = (j + dj + 16) % 16;
                            neighbors = neighbors + q_2d[ni][nj];
                        end
                    end
                end

                // Apply Game of Life rules
                case (neighbors)
                    2: next_q_2d[i][j] = q_2d[i][j];
                    3: next_q_2d[i][j] = 1'b1;
                    default: next_q_2d[i][j] = 1'b0;
                endcase
            end
        end
    end

    // Sequential logic for loading and updating
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            for (i = 0; i < 16; i = i + 1) begin
                q[i*16 +: 16] <= next_q_2d[i];
            end
        end
    end

endmodule
