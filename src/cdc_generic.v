`timescale 1ns / 1ns
/**
 * Clock Domain Crossing generic module
 * 
 * Authors:
 * * Zach Baldwin 2023-06-02
 * *              (Backported to Verilog 2023-11-02)
 * 
 * **** USAGE ****
 * PARAMETERS:
 *   STAGES - The number of synchronization flops on the output clock domain
 *   W      - The width of the data to synchronize
 * 
 * INPUTS:
 *   clk_in - Input clock
 *   d_in   - Data which is synchronized to the clk_in clock domain
 * 
 * OUTPUTS:
 *   clk_out - Output clock
 *   d_out   - Data synchronized to the clk_out clock domain
 */

module cdc_generic 
  #(
    parameter STAGES = 2,
    parameter W = 1
    ) (
       input wire          clk_in, clk_out,
       input wire [W-1:0]  d_in,
       output wire [W-1:0] d_out
       );

    reg [W-1:0]            cdc_stages [0:STAGES-1];
    reg [W-1:0]            cdc_input;

    always @(posedge clk_in) begin
        cdc_input <= d_in;
    end

    generate
        genvar ii;
        for (ii = 0; ii < STAGES; ii = ii + 1) begin : cdc_stage_expansion
            always @(posedge clk_out) begin
                if (ii == 0) begin
                    cdc_stages[ii] <= cdc_input;
                end
                else begin
                    cdc_stages[ii] <= cdc_stages[ii-1];
                end
            end
        end
    endgenerate

    assign d_out = cdc_stages[STAGES-1];

endmodule : cdc_generic
