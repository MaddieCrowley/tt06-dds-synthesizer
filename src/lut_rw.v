/**
 * Waveform Look Up Table which is "field" reprogrammable
 * 
 * Authors:
 * * Zach Baldwin 2023-10-26
 * 
 * **** USAGE ****
 * PARAMETERS:
 *   WW - Word Width
 *   DEPTH - Number of words to store
 * 
 * INPUTS:
 *   clk - system clock. Data is processed on the rising edge
 *   wa  - Write address
 *   ra  - Read address
 *   wd  - write data
 *   we  - Write enable
 *   re  - Read enable (allows output to be updated on next clock)
 * 
 * OUTPUTS:
 *   rd  - Read data
 */

module lut_rw
  #(
    parameter WW = 12,
    parameter DEPTH = 128
    )
   (
    input                     clk, we, re,
    input [$clog2(DEPTH)-1:0] wa, ra,
    input [WW-1:0]            wd,
    output reg [WW-1:0]       rd
    );

   reg [WW-1:0]               q [0:DEPTH-1];

   always @(posedge clk) begin
      if (re) begin
         rd <= q[ra];
      end
      if (we) begin
         q[wa] <= wd;
      end
   end
   
endmodule // lut_rw

