`timescale 1ns/100ps
/*
 Filename      : Mod.v
 Author        : Liam Crowley
 Created       : Thu Nov  2 16:30:21 2023
 INPUTS        : OSC0 (Oscillator 0)
 OSC1 (Oscillator 1)
 modSel (select modulation form)
 clk (50MHz clk input)
 OUTPUTS       : modOUT (modulated waveform out)
 PARAMETERS    : m (wave width)
 0 (output width)

 Description   : Modulation module for the two oscillators, includes Amplitude modulation (multiplication), Polyphonic (summing), and XOR (each oscillator gets XOR'd together)
 */
module Mod #(parameter m = 12,parameter o=16)(/*AUTOARG*/
                                              // Outputs
                                              modOut,
                                              // Inputs
                                              OSC0, OSC1, clk, modSel
                                              ) ;
    input  [m-1:0] OSC0, OSC1;
    input          clk;
    output reg [o-1:0] modOut;
    //input	  cDiv;
    input [2:0]        modSel;
    wire [o-1:0]       multO;
    Mult #(.m(o/2))
    MULT
      (.a(OSC0[(o/2)-1:0]),
       .b(OSC1[(o/2)-1:0]),
       .clk(clk),
       .mult(multO));
    always @ ( /*AUTOSENSE*/OSC0 or OSC1 or modSel or multO) begin
        case (modSel) 
	      3'b000: begin
	          modOut = {{1'b0, OSC0[m-1:1]} + {1'b0, OSC1[m-1:1]}, {(o-m){1'b0}}};
	      end
	      3'b001: begin
	          modOut = {{1'b0, OSC0[m-1:1]} + {1'b0, ~OSC1[m-1:1]}, {(o-m){1'b1}}};
	      end
	      3'b010: begin
	          modOut = {(OSC0+OSC1),{(o-m){1'b0}}};
	      end
	      3'b011: begin
	          modOut = {{(o-1){multO[o-1]}} ^ multO[o-2:0], 1'b0};
	      end
	      3'b100: begin
	          modOut = {OSC0, {(o-m){1'b1}}};
	      end
	      3'b101: begin
	          modOut = {OSC1, {(o-m){1'b1}}};
	      end
	      3'b110: begin
	          modOut = {OSC0,{(o-m){1'b0}}} ^ {OSC1,{(o-m){1'b0}}};
	      end
	      3'b111: begin
	          modOut = {OSC0,{(o-m){1'b0}}} & {OSC1,{(o-m){1'b0}}};
	      end
        endcase
    end
    
endmodule // Mod
