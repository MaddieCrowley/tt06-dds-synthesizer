`timescale 1ns/100ps
/*
 Filename      : Mod.v
 Author        : Liam Crowley
 Created       : Thu Nov  2 16:30:21 2023
 INPUTS        : OSC0 (Oscillator 0)
 OSC1 (Oscillator 1)
 modulation_select (select modulation form)
 clk (50MHz clk input)
 OUTPUTS       : modOUT (modulated waveform out)
 PARAMETERS    : m (wave width)
 0 (output width)

 Description   : Modulation module for the two oscillators, includes Amplitude modulation (multiplication), Polyphonic (summing), and XOR (each oscillator gets XOR'd together)
 */
module Mod #(parameter m = 12,parameter o=16)
    (
     // Outputs
     output reg [o-1:0] modulation_out,
     // Inputs
     input [m-1:0]      OSC0, OSC1,
     input              clk,
     input [2:0]        modulation_select
     );

    wire [o-1:0]       multO;

    Mult #(.m(o/2))
    MULT
      (
       .a(OSC0[(o/2)-1:0]),
       .b(OSC1[(o/2)-1:0]),
       .clk(clk),
       .mult(multO),
       .update() // TODO: Should this be connected?????????????????????????????????
       );
    
    always @ ( /*AUTOSENSE*/OSC0 or OSC1 or modulation_select or multO) begin
        case (modulation_select) 
	      3'b000: begin
	          modulation_out = {{1'b0, OSC0[m-1:1]} + {1'b0, OSC1[m-1:1]}, {(o-m){1'b0}}};
	      end
	      3'b001: begin
	          modulation_out = {{1'b0, OSC0[m-1:1]} + {1'b0, ~OSC1[m-1:1]}, {(o-m){1'b1}}};
	      end
	      3'b010: begin
	          modulation_out = {(OSC0+OSC1),{(o-m){1'b0}}};
	      end
	      3'b011: begin
	          modulation_out = {{(o-1){multO[o-1]}} ^ multO[o-2:0], 1'b0};
	      end
	      3'b100: begin
	          modulation_out = {OSC0, {(o-m){1'b1}}};
	      end
	      3'b101: begin
	          modulation_out = {OSC1, {(o-m){1'b1}}};
	      end
	      3'b110: begin
	          modulation_out = {OSC0,{(o-m){1'b0}}} ^ {OSC1,{(o-m){1'b0}}};
	      end
	      3'b111: begin
	          modulation_out = {OSC0,{(o-m){1'b0}}} & {OSC1,{(o-m){1'b0}}};
	      end
        endcase
    end
    
endmodule // Mod
