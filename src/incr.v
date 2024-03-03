`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/21/2023 08:12:03 PM
// Design Name: 
// Module Name: incr
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module incr
  #(
    parameter n=16
    )
    (
     input               up,
     output wire [n-1:0] outp
     );
    reg [n-1:0]          cnt;
    initial cnt = 1;
    always @(posedge up)
      begin
          cnt = outp;
          if (up)
            cnt = outp + 1;
      end
    assign outp = cnt;
endmodule
