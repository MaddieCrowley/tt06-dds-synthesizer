`timescale 1 ns / 100 ps
/*
Filename      : tb_top.v
Author        : Liam Crowley
Created       : Mon Oct 30 17:44:01 2023
INPUTS        : 
OUTPUTS       : 
PARAMETERS    : 

Description   : Top testbench file for the DDS algorithm.
*/
module tb_top (/*AUTOARG*/ ) ;
   parameter tune = 16;
   parameter n = 14;
   parameter m = 12;   
   reg   clk;
   reg   [tune-1:0] tuningW;
   reg   [2:0] sel;
   wire  [m-1:0] OUT;
   top 
     #(
       .n(n),.m(m),.tune(tune)
       )
   UUT
     (
      .clk(clk),
      .tuningW(tuningW),
      .sel(sel),
      .OUT(OUT)
      );
   initial begin
      clk = 1'b0;
      forever #10 clk=~clk;
   end
   initial begin
      tuningW=16'hffff;
      sel = 3'b000;
   end
endmodule // tb_top
