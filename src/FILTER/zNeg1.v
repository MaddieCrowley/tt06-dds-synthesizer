`timescale 1ns/100ps
/*
Title         :  z^-1 Transform
Project       :  tt06

Filename      :  zNeg1.v
Author        :  Madeline Crowley
Created       :  03/02/2024 16:52:19
Last Modified :  03/02/2024 17:39:19
Copyright (c) :  Madeline (Liam) Crowley

INPUTS        : in
OUTPUTS       : out
PARAMETERS    : n (bitwidth of input)

Description   : Performs unit delay z transform for filter design.

Mod History   : 03/02/2024 16:52:19 : created
*/
module zNeg1 # (
    // parameters
    parameter n = 12
)   (
    // ports
     in,
     out
);

    input wire [n-1:0] in;
    output reg  [n-1:0] out;
    reg [n-1:0] sto;
    always @(*) begin
        sto <= in;
        out <= sto;
    end
    
endmodule: zNeg1

