module tutorial1(x1, x2, y1, y2, y3, y4, y5, y6);
  input x1;
  input x2;
  output y1;
  output y2;
  output reg y3;
  output y4;
  output y5;
  output reg y6;
  
    
  and(y1, x1, x2);
    
  assign y2 = x1 & x2;
  
  always @(x1 or x2) begin
    y3 = x1 & x2;
  end
  
  
  not(i1, x1);
  not(i2, x2);
  and(i3, i1, i2);
  and(i4, x1, x2);
  or(y4, i3, i4);
  
  assign y5 = (~x1 & ~x2) | (x1 & x2);
  
  always @(x1 or x2) begin
    y6 <= (~x1 & ~x2) | (x1 & x2);
  end

endmodule

`timescale 1ns/1ns

module tutorial1_tb();
  reg x1;
  reg x2;
  wire y1, y2, y3, y4, y5, y6;
  
  tutorial1 tutorial1_1(x1, x2, y1, y2, y3, y4, y5, y6);
  
  initial begin
    $dumpvars() ; //dumps the waveforms in dump.vcd i.e. transfers the results of the simulation to dump.vcd
    
    x1 <= 0; x2 <= 0;
    #10 x1 <= 0; x2 <= 1;
    #10 x1 <= 1; x2 <= 0;
    #10 x1 <= 1; x2 <= 1;    
    #10 $finish;
  
  end
  
endmodule