`timescale 1ns / 1ps
/**
 Author: Liam Crowley
 Date: 10/21/2023 06:13:43 PM
 Mux for DDS Algorith
 INPUTS: Differnt Waveforms 
 OUTPUTS: Selected output


 */

module mux
  #(parameter m = 12)
    (
     input [m-1:0]      sine,
     input [m-1:0]      saw,
     input [m-1:0]      pulse,
     input [m-1:0]      traingle,
     input [m-1:0]      noise,
     input [m-1:0]      pwm,
     input [2:0]        wave_select,
     output reg [m-1:0] wave_out
     );
    
    always @(*)
      begin
          case(wave_select)
            3'b000: wave_out = sine;
            3'b001: wave_out = saw;
            3'b010: wave_out = pulse;
            3'b011: wave_out = traingle;
            3'b100: wave_out = noise;
	        3'b101: wave_out = pwm;
            default: wave_out = sine;
          endcase
      end
    
endmodule
