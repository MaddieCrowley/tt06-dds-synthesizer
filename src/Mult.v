`timescale 1ns/100ps
/*
Filename      : Mult.v
Author        : Liam Crowley
Created       : Thu Nov  2 17:03:09 2023
INPUTS        : a
                b
                clk
OUTPUTS       : mult (a*b)
PARAMETERS    : m(width of a and b)

Description   : Parameterized sequential multiplier 
*/
module Mult #(parameter m = 12) (/*AUTOARG*/
   // Outputs
   mult, update,
   // Inputs
   a, b, clk
   ) ;
   input  [m-1:0] a, b;
   input	  clk;
   output reg [2*m-1:0]	mult;
   output reg           update;
   reg [$clog2(m):0]	cnt;
   reg [2*m:0]	pA;
   //reg [m:0]		sum;
   //reg [2*m:0]	TEMP;
   
   
   localparam		s0 = 2'b00, //DATA LOAD
			s1 = 2'b01, //SEQUENTIAL ADDITION
			s2 = 2'b10, //DATA OUT
			s3_PLACEHOLDER = 2'b11;
   reg [1:0]		cState, nState;
   
   initial begin 
      cnt = 0;
      pA = 0;
      //sum = 0;
      cState = s0;
   end
   
   always @(posedge clk) begin
      cState <= nState;
      case (cState) 
	s0: begin
	   cnt <= 0;
	   pA <= {{m+1{1'b0}},a};
	   nState <= s1;
       update <= 1'b0;
	end
	s1: begin
	   // if(cnt==(m[$clog2(m)-1:0])) begin
	   if(cnt==m) begin
	      nState <= s2;
	   end
	   else begin : shift_thing
          reg dummy;
	      cnt<=cnt+1;
	      nState <= cState;
	      if(pA[0]) begin
		     {pA, dummy} <= {1'b0, {1'b0,pA[2*m-1:m]}+{1'b0,b},pA[m-1:0]};
	      end
	      else begin
             pA <= pA >> 1;
          end
	   end
	end
	s2: begin
	   mult <= pA[2*m-1:0];
       update <= 1'b1;
	   nState <= s0;
	end
	default: begin
	   nState <= s0;
	end 
      endcase
	  
   end
   /*
    * always @(posedge clk)
     begin
	if(cnt==12-1)//m[$clog2(m)-1:0]-1)
	  begin
	     cnt<=0;
	     pA<={{(m){1'b0}},a};
	  end
	else begin
	   if(pA[0]) begin
	      sum=pA[2*m-1:m]+b;
	      pA<={sum,pA[m-1:1]}>>1;
	   end
	   else pA<=pA>>1;
	   cnt <= cnt+1;
	end
     end
   always @ (pA) begin
      mult = pA[2*m-1:0];
   end
   
    */
   
endmodule // Mult
