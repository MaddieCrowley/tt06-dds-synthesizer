`timescale 1ns / 1ps

/**
 Author: Liam Crowley
 Date: 10/23/2023 08:14:02 PM
 Serial Output for DDS Algorith
 INPUTS: Waveform
 OUTPUTS: Serial value of waveform
 PARAMETERS: Input waveform width

 Takes waveform input, uses state machine to transfer into shift register then shifts towards MSB to output serial value
 */
//////WORK IN PROGRESS
//////DOOOOII STATE MACHINE
module serializer
  #(
    parameter m=12
    )
    (
     input [m-1:0] par,
     output reg    ser,
     input         clk,
     output reg    clkO
     );
    reg [m-1:0]    shift;
    localparam     s1 = 1'b0,s2=1'b1;//s1 = parallel load, s2 = shift out
    reg            cState,nState;
    integer        i;
    initial begin
        cState = 0;
        nState = 0;
        shift = 0;
        i = 0;
        //ser = 0;
        clkO =0;
    end
    //    always @(posedge clk)
    //    begin
    //        cState <= nState;
    //        if(cState)
    //            shift = shift<<1;
    //    end
    always @(clk)
      begin
          cState = nState;
          //nState = cState;
          case(cState)
            s1:begin
                shift = par;
                i=0;
                clkO = 0;
                ser = 0;
                nState = s2;
            end
            s2:begin
                if(i<m) clkO=clk;
                else clkO=0;
                if(clk) i=i+1;
                if(clk&clkO) begin
                    ser = shift[m-1];
                    shift = shift<<1;
                end
                //else ser=0;
                if(i==14) nState = s1;
                
                //                if(clkO) begin 
                //                    ser = shift[m-1];
                //                    shift = shift<<1;
                //                    i = i+1;
                //                end
                //                if (i<m) clkO=clk;
                //                if(i==14) nState = s1;
                else nState = s2;
            end
          endcase
      end
endmodule
