`timescale 1ns/100ps
/*
 Filename      : I_mux.v
 Author        : Liam Crowley
 Created       : Tue Oct 31 08:24:49 2023
 INPUTS        : in
 sel
 OUTPUTS       : out0
 out1
 out2
 out3
 PARAMETERS    : m

 Description   : I MUX for testing multiple voices
 */
module I_mux
  #(
    parameter m = 12
    )
    (
     /*AUTOARG*/
     // Outputs
     out0, out1,
     // Inputs
     in, sel
     ) ;
    input [m-1:0] in;
    output reg [m-1:0] out0, out1;// out2, out3;
    input [1:0]        sel;
    always @(*) begin
        case (sel) 
          2'b00: begin
	          out0 = in;	
          end
          2'b01: begin
	          out1 = in;
          end
          /*
           * 2'b10: begin
	       out2 = in;
end
           2'b11: begin
	       out3 = in;
end*/
          default: begin
	          out0 = in;
              
          end
        endcase // case (sel)
    end
endmodule // i_mux
