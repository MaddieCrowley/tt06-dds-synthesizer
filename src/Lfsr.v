`timescale 1ns / 1ps
/**
 Author: Liam Crowley
 Date: 10/22/2023 06:59:26 PM
 Noise Output for DDS Algorithm
 INPUTS: Clk
 OUTPUTS: Noise wave output
 PARAMETERS: Input width
 Output width

 Uses linear feedback shift register to produce noise waveform
 */

//taps come from wikipedia,14 bits is same as phase so only repeats once per complete slowest cycle
module Lfsr
  #(
    parameter n = 14,
    parameter m = 12
    )
    (
     //input [n-1:0] phase,
     //input [m-1:0] seed,
     input               clk,
     output wire [m-1:0] lfsr
     );
    reg [n-1:0]          shift = 0;
    always @(posedge clk)
      begin
          //if(&~phase) oot = 0;
          //else///CONCATE TO ONE LINE
          shift[n-1:1] <= shift[n-2:0];
          shift[0] <= shift[n-1]~^(shift[n-2]~^(shift[n-3]~^shift[1]));
      end
    assign lfsr = shift[n-1:2];
endmodule

//    reg feedback;
//    reg a,b,c,d,e,f,g,h,i,j,k,l;
//taps come from wikipedia for max repetion length
//initial oot[0]=1;
//always @(&phase) oot[0] = 1;
//    always @(phase[0])
//    begin
//        oot[m-1:1] = oot<<1;
//        oot[0] = oot[m-1]^oot[m-2]^oot[m-3]^oot[m-9];
//    end
//    always @(posedge phase[0]) oot = {oot[m-1:1],(oot[m-1]~^oot[m-2])~^(oot[3]~^oot[0])};
//    always @(posedge phase[0])
//    begin
//        b<=a;
//        c<=b;
//        d<=c;
//        e<=d;
//        f<=e;
//        g<=f;
//        h<=g;
//        i<=h;
//        j<=i;
//        k<=j;
//        l<=k;
//        a<=(l~^k)~^(d~^a);
//    end
//    assign oot = {a,b,c,d,e,f,g,h,i,j,k,l};
