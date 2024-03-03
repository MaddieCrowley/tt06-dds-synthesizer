`timescale 1ns / 1ps
/**
 Author: Liam Crowley
 Date: 10/18/2023 12:57:30 PM
 Saw Wave Output for DDS Algorith
 INPUTS: Phase value
 OUTPUTS: Saw wave output

 Uses 12 MSB of phase input value for saw output
 */


module Saw
  #(
    parameter n = 14
    )
    (
     input [n-1:0]       phase,
     output wire [n-3:0] saw
     );
    assign saw = phase[n-1:2];
endmodule
