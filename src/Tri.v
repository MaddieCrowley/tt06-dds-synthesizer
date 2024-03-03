`timescale 1ns / 1ps

/**
 Author: Liam Crowley
 Date: 10/22/2023 12:55:55 PM
 Triangle Wave Output for DDS Algorith
 INPUTS: Phase value
 OUTPUTS: Triangle wave output

 Uses bits of phase to produce triangle waveform; takes largest bit and replicates it m times, then uses that xor(0,x)=x and xor(1,x)=~x
 */

module Tri
  #(
    parameter n=14,
    parameter m=12
    )
    (
     input [n-1:0]       phase,
     output wire [m-1:0] triang
     );
    assign triang = {m{phase[n-1]}}^phase[n-2:1];
endmodule
