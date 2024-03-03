`timescale 1ns/100ps
/*
 Filename      : mux_2.v
 Author        : Liam Crowley
 Created       : Wed Nov  1 08:17:42 2023
 INPUTS        : in0
 in1
 sel
 OUTPUTS       : out
 PARAMETERS    : m (width of input)

 Description   : Parameterized 2 input mux
 */

module mux_2 #(parameter m = 12)
    (
     // Outputs
     output reg [m-1:0] out; 
     // Inputs
     input [m-1:0]      in0, in1;
     input              sel;
     );
    
    always @ ( /*AUTOSENSE*/in0 or in1 or sel) begin
        case (sel) 
	      1'b0: begin
	          out = in0;
	      end
	      1'b1: begin
	          out = in1;
	      end
	      default: begin
	          out = in0;
          end
        endcase	  
    end
endmodule // mux_2
