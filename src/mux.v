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
     input [m-1:0]      traing,
     input [m-1:0]      noi,
     input [m-1:0]      pwm,
     input [2:0]        sel,
     output reg [m-1:0] wave
     );
    always @(*)
      begin
          case(sel)
            3'b000:wave=sine;
            3'b001:wave=saw;
            3'b010:wave=pulse;
            3'b011:wave=traing;
            3'b100:wave=noi;
	        3'b101:wave=pwm;
            default:wave=sine;
          endcase
      end
    
endmodule
