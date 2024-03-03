`timescale 1ns / 1ps
/**
 Author: Liam Crowley
 Date: 10/18/2023 01:25:28 PM
 Phase Accumulator For the DDS algorithm
 INPUTS: tuning word
 clk
 ce
 OUTPUTS: phase register value (Truncated from primary phase register)

 phase registere is large for added precision, ideally achieves about 1/3 Hz precision, from 1/3 Hz to ~22kHz

 */

////MATH SAYS THAT for ~0-20kHz range, at 50/14 MHz, tune needs to be 17 bits
////OR n=21
//For fixed 16 bit tune
/// at 50/18MHz clk, n = 23 for a 21.7kHz range with 331.1mHz resolution

/// at 50MHz clk, n = 27 for a 24.41kHz range with 372.5mHz resolution

/// at 50/19MHz clk, n = 23 for a 20.56kHz range with 313.7mHz resolution
//// MATH FOR OVERHEAD IF NEED TO SLOW CLK
/// at 25/19MHz clk, n = 22 for a 20.56kHz range with 313.7mHz resolution
/// with that at full speed(50/19MHz) give a range of 41.12kHz with 627.4mHz resolution
module PhaseAccumulator
  #(
    parameter n = 23,
    parameter m = 14,
    parameter TUNE_WIDTH = 16
    )
    (
     input [TUNE_WIDTH-1:0]    tuning_word,
     input               clk,
     input               ce,
     output wire [m-1:0] phaseReg
     );
    
    reg [n-1:0]          phase;
    
    initial phase = 0;
    always @(posedge clk) 
      begin
          if (ce) phase <= phase + {{n-TUNE_WIDTH{1'b0}},tuning_word};
      end
    assign phaseReg = phase[n-1:n-m];
endmodule

