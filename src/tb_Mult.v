`timescale 1ns/100ps
/*
 Filename      : tb_Mult.v
 Author        : Liam Crowley
 Created       : Thu Nov  2 18:42:04 2023
 INPUTS        : 
 OUTPUTS       : 
 PARAMETERS    : 

 Description   : Testbench for the multiplier module.
 */
module tb_Mult (/*AUTOARG*/) ;
    parameter W = 12;
    
    wire [2*W-1:0] M;
    reg [2*W-1:0]  correct_val;
    reg [W:0]      a, b;
    reg            clk;
    wire           update;
    
    Mult #(.m(W)) UUT 
      (
       .clk(clk),
       .a(a[W-1:0]),
       .b(b[W-1:0]),
       .mult(M),
       .update(update)
       );
    
    initial begin
        clk = 0;
        forever #10 clk=~clk;
    end

    initial begin
        a = 0;
        b = 0;
        
        for (a = 0; a < 2**W; a = a + 1) begin
            for (b = 0; b < 2**W; b = b + 1) begin
                @(posedge update) begin
                    correct_val = a * b;
                    if (M !== correct_val) begin
                        $display("ERROR! %d * %d == %d (got %d)", a, b, correct_val, M);
                    end
                    // else begin
                    // $display("...... %u * %u == %u (got %u)", a, b, M, a * b);
                    // end
                end
            end // for (b = 0; b < 2**W; b = b + 1)
        end // for (a = 0; a < 2**W; a = a + 1)
        
        #50 $display("COMPLETE");
        $stop();
    end
    
endmodule // tb_Mult
