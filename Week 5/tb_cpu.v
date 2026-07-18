`timescale 1ns / 1ps

module tb_cpu;

    reg clk;
    reg reset;
    reg [15:0] input_c;
    reg [15:0] input_d;

    cpu uut (
        .clk(clk),
        .reset(reset),
        .input_c(input_c),
        .input_d(input_d)
    );

    //----------------------------------------
    // Clock
    //----------------------------------------

    always #5 clk = ~clk;

    //----------------------------------------
    // Test
    //----------------------------------------

    integer i;

    initial begin

        $dumpfile("cpu.vcd");
        $dumpvars(0, tb_cpu);
        $readmemh("input.mem", uut.DATA.memory);

        clk   = 0;
        reset = 1;
        input_c = 8'd55;
        input_d = 8'd100;

        #10;
        reset = 0;

        // Run for a few instructions
        #50000;

        $display("--------------------------------");
        $display("CPU Test Finished");
        $display("--------------------------------");
        $display("\nFinal Data Memory");
        $display("mem[0] = %0d", uut.DATA.memory[0]);
        $display("mem[1] = %0d", uut.DATA.memory[1]);
        $display("mem[2] = %0d", uut.DATA.memory[2]);
        $display("mem[3] = %0d", uut.DATA.memory[3]);
        $display("mem[4] = %0d", uut.DATA.memory[4]);
        $display("mem[5] = %0d", uut.DATA.memory[5]);
        $display("mem[6] = %0d", uut.DATA.memory[6]);
        $display("mem[7] = %0d", uut.DATA.memory[7]);

        for(i=0;i<7;i=i+1)
        begin
            if(uut.DATA.memory[i] > uut.DATA.memory[i+1])
            begin
                $display("FAIL");
                $finish;
            end
        end

        $display("PASS");

        $finish;

    end;

    //----------------------------------------
    // Monitor CPU State
    //----------------------------------------

    reg tmp;
    initial begin
        tmp<= 0;
    end
    always @(posedge clk) begin

        if(!uut.instruction)
            tmp <= 1;


        
        if (!tmp) begin

        $display("\n=================================================");

        $display("PC          : %0d", uut.pc);
        $display("Instruction : %h", uut.instruction);

        $display("");

        $display("Registers");
        $display("A = %0d", uut.regA);
        $display("B = %0d", uut.regB);
        $display("C = %0d", uut.regC);
        $display("D = %0d", uut.regD);

        // $display("");

        // $display("ALU");
        // $display("Result = %0d", uut.alu_result);

        // $display("");

        $display("Flags");
        $display("Zero=%b Carry=%b Negative=%b",
                 uut.zero_flag,
                 uut.carry_flag,
                 uut.negative_flag);
        // $display("Instruction : %h", uut.instruction);                 
        // $display("reg_write  = %b", uut.reg_write);
        // $display("write_sel  = %0d", uut.write_sel);
        // $display("reg_write_data = %0d", uut.reg_write_data);

        

        // $display("read_sel1  = %0d", uut.read_sel1);
        // $display("read_sel2  = %0d", uut.read_sel2);    
        // $display("NOOP        = %b", uut.NOOP);
        // $display("MOVE        = %b", uut.MOVE);
        // $display("LOADI_LOADP = %b", uut.LOADI_LOADP);
        // $display("ADD         = %b", uut.ADD);
        // $display("SUB         = %b", uut.SUB);
        // $display("LOAD        = %b", uut.LOAD);
        // $display("STORE       = %b", uut.STORE);
        // $display("BRE          = %b", uut.BRE_BRZ);
        // $display("branch       = %b", uut.branch);
        // $display("branch_taken = %b", uut.branch_taken);
        // $display("next_pc      = %d", uut.next_pc);
        // $display("\n------ SHIFT DEBUG ------");
        // $display("alu_op         = %0d", uut.alu_op);
        // $display("reg_data1      = %0d", uut.reg_data1);
        // $display("reg_data2      = %0d", uut.reg_data2);
        // $display("alu_result     = %0d", uut.alu_result);
        // $display("reg_write_data = %0d", uut.reg_write_data);

        // $display("instruction[15:12] = %b", uut.instruction[15:12]);
        // $display("instruction[11:10] = %b", uut.instruction[11:10]);
        // $display("instruction[9:8]   = %b", uut.instruction[9:8]);
        // $display("instruction[7]     = %b", uut.instruction[7]);

        // $display("SHIFTL = %b", uut.SHIFTL);
        // $display("SHIFTR = %b", uut.SHIFTR);
        // $display("LOAD=%b LOADF=%b STORE=%b STOREF=%b",
        //  uut.LOAD,
        //  uut.LOADF,
        //  uut.STORE,
        //  uut.STOREF);

        end
    end

endmodule