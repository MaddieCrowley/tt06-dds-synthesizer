`timescale 1ns / 1ps
/**
 Author: Liam Crowley
 Date: 10/18/2023 12:57:30 PM
 Sine Wave Output for DDS Algorith
 INPUTS: Phase value
 OUTPUTS: Sine wave output
 PARAMETERS: Input width
 Output width
 Radix of memory
 Max magnitude of sine wave

 Initializes LUT for quarter sine wave then replicates for other values
 */


module Sine
  #(
    parameter  n = 14,
    parameter  m = 12,
    localparam rad = 127
    )
    (
     input [n-1:0]      phase,
     output reg [m-1:0] sine
     );
    reg [m-1:0]         lut[0:rad];
    initial begin
        $readmemh("./sin_table.mem",lut);
    end
    always @(*)
      begin
   	      case(phase[n-1:n-2])
	   	    2'b00: sine = lut[phase[n-3:n-9]];
	   	    2'b01: sine = lut[~phase[n-3:n-9]];
	  	    2'b10: sine = ~lut[phase[n-3:n-9]];
	   	    2'b11: sine = ~lut[~phase[n-3:n-9]];
  	      endcase
      end    

endmodule

