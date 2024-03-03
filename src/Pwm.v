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
    (
     // Outputs
     output wire [m-1:0] pwm,
     // Inputs
     input               clk,
     input [n-1:0]       phase,
     input [m-1:0]       mod
     ) ;
    reg                 pul;
    always @ (posedge clk) begin
        if(phase[n-1:n-m] < mod) pul <= 1;
        else pul <= 0;
    end
    assign pwm = {m{pul}};
endmodule : Pwm
