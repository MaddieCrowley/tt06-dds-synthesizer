`timescale 1ns/100ps
/*
 Filename      : mux_5.v
 Author        : Liam Crowley
 Created       : Wed Nov  1 08:28:35 2023
 INPUTS        : in0
 in1
 in2
 in3
 in4
 OUTPUTS       : out
 PARAMETERS    : m (width of input)

 Description   : 5 input paramterized mux
 */

module mux_5 #(parameter m = 12)
    (
     // Outputs
     output [m-1:0] out; 
     // Inputs
     input [m-1:0]  in0, in1, in2, in3, in4;
     input [2:0]    sel;
     );
    
    reg            out;
    
    always @ (/*AUTOSENSE*/in0 or in1 or in2 or in3 or in4 or sel) begin
        case (sel) 
	      3'b000: begin
	          out = in0;
       	  end
	      3'b001: begin
	          out = in1;
       	  end
	      3'b010: begin
	          out = in2;
          end
	      3'b011: begin
	          out = in3;
       	  end
	      3'b100: begin
	          out = in4;
	      end
	      /*
	       * 3'b101: begin
	       * end
	       */
	      default: begin
	      end
        endcase
    end
    
endmodule // mux_5
