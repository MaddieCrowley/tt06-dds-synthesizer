`timescale 1ns / 1ps
/**
 Author: Liam Crowley
 Date: 10/18/2023 12:57:30 PM
 Pulse Output for DDS Algorith
 INPUTS: Phase value
 OUTPUTS: Pulse

 Replicates MSB of phase input value for pulse output
 */


module Pulse
  #(
    parameter n=14,
    parameter m=12
    )
    (
     input [n-1:0]       phase,
     output wire [m-1:0] pulse
     );
    assign pulse = {m{phase[n-1]}};
endmodule
