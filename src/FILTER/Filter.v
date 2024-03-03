`timescale 1ns / 100ps
/*
Title         :  Digital Filter for the design
Project       :  tt06

Filename      :  Filter.v
Author        :  Madeline Crowley
Created       :  02/25/2024 23:44:24
Last Modified :  03/02/2024 17:40:23
Copyright (c) :  Madeline (Liam) Crowley

INPUTS        : in
OUTPUTS       : out
PARAMETERS    : n (bit-width)

Description   : Hopefully an implementation of a filter in verilog

Mod History   : 02/25/2024 23:44:24 : created
                03/02/2024 17:31:14 : Wrote code
*/

module Filter #(
    //parameter m = 12,
    parameter n = 12
) (
    /*AUTOARG*/
    // Outputs
    out,
    // Inputs
    in,
    Clk,
    freq
);

    input wire [n-1:0] in;
    input wire Clk;
    input wire [n-1:0] freq;
    output reg [n-1:0] out;

    wire [n-1:0] zOUT1, zOUT2;

    wire [n-1:0] mult, SUM1, SUM2;

    assign SUM1 = zOUT1 + zOUT2;
    assign SUM2 = mult + in;


    zNeg1 #(
        // Parameters
        .n(n)
    ) I_ZNEG1_1 (
        // Outputs
        .out(zOUT1),
        // Inputs
        .in (in)
    );


    zNeg1 #(
        // Parameters
        .n(n)
    ) I_ZNEG1_2 (
        // Outputs
        .out(zOUT2),
        // Inputs
        .in (SUM2)
    );


    Mult #(
        // Parameters
        .m(n)
    ) I_MULT (
        // Outputs
        .mult  (mult),
        .update(update),
        // Inputs
        .a     (SUM1),
        .b     (freq),
        .clk   (Clk)
    );

endmodule : Filter
