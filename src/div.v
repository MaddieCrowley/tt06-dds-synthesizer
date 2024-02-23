`timescale 1ns / 1ps
/**
Author: Liam Crowley
Date: 10/23/2023 04:54:43 PM
Clk divition for Phase Accumulator clk
INPUTS: Clk
OUTPUTS: Divided clk

Divides main 50MHz clock by 18 for phase accumulator to give overhead for parallel to serial conversion
*/

///DIVIDES 50MHz primary clock by 14 to give time for serialization w/ 2 clock cycles overhead
//NEEDS DIV 18 NOT 14
//Needs div 19 actually
module div
    (
    input clkI,
    output reg clkO=0
    );
   reg [4:0] i = 0;
   always @ (posedge clkI) begin
        i<=i+1;
        clkO<=i[4]&i[1];
        if(i[4]&i[1]&i[0]) i<=0;
   end
   
   /*
    * always @ (clkI) begin
      if(clkI) begin
	 i=i+1;
	 if (i[4]) begin
	    clkO=1;
	    i=0;
	 end
	 else clkO=0;
      end
   end
    */
   



/*
    * always @(posedge clkI)
    begin
        if(i<=7)
        begin 
            clkO=1;
        end
        else if(i<14)
            clkO=0;
        else i = 0;
        i=i+1;
    end
    */
 endmodule
