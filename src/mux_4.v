`timescale 1ns/100ps
/*
 Filename      : mux_4.v
 Author        : Liam Crowley
 Created       : Tue Oct 31 10:28:23 2023
 INPUTS        : in0
 in1
 in2
 in3 
 OUTPUTS       : out
 PARAMETERS    : m

 Description   : Parameterized 4 input mux
 */

module mux_4 
  #(
    parameter m = 12
    )
    (
     // Outputs
     output reg [m-1:0] out;

     // Inputs
     input [m-1:0]      in0, in1, in2, in3;
     input [1:0]        sel;
     );
    
    always @ (*) begin
        case (sel) 
	      2'b00: begin
	          out = in0;
	      end
	      2'b01: begin
	          out = in1;
	      end
	      2'b10: begin
	          out = in2;
	      end
	      2'b11: begin
	          out = in3;
	      end
	      default: begin
	          out = in0;
	      end
        endcase
	    
    end
    
endmodule // mux_4
