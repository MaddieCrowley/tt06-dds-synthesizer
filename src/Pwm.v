`timescale 1ns/100ps
/*
Filename      : Pwm.v
Author        : Liam Crowley
Created       : Wed Nov  1 09:09:16 2023
INPUTS        : phase
                mod
OUTPUTS       : pulse
PARAMETERS    : n(phase reg width)
                m(waveform width)

Description   : PWM modulation module
*/

module Pwm 
  #(
  parameter n = 14,
  parameter m = 12,
  parameter MAX = 2**n
  )
 (/*AUTOARG*/
   // Outputs
   pwm,
   // Inputs
   clk, phase, mod
   ) ;
   input  clk;
   input [n-1:0] phase;
   input [m-1:0] mod;
   output wire [m-1:0] pwm;
   reg		      pul;
   always @ (posedge clk) begin
      if(phase[n-1:n-m] < mod) pul <= 1;
      else pul <= 0;
   end
   assign pwm = {m{pul}};
endmodule // pwm
