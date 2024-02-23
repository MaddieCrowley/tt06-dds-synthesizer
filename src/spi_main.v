/**
 * SPI Main device (sends data out)
 * 
 * Authors:
 * * Zach Baldwin 2023-10-29
 * 
 * **** USAGE ****
 * Data is loaded on the RISING edge of the clock and should
 * be sampled on the output serial one on the FALLING edge 
 * of the output clock
 * 
 * PARAMETERS:
 *   WORD_WIDTH - The number of bits wide to set the input shift register
 * 
 * INPUTS:
 *   sys_clk - system clock. Data is processed on the rising edge
 *   load    - Set high to setart a shift cycle. On rising edge of sys_clk,
 *             the value of parallel_in is loaded.
 *   parallel_in - The dataword to shift
 *   power_state - The power state for the DAC8411 digital to analog 
 *             converter
 * 
 * OUTPUTS:
 *   sclk - SPI clock, data is intended to be sampled on the falling edge
 *   mosi - Serial data output
 *   csb  - Active low chip select output
 *   
 */

module spi_main
  #(
    parameter WORD_WIDTH = 16
    )
   (
    input                  sys_clk, load,
    input [WORD_WIDTH-1:0] parallel_in,
    input [1:0]            power_state,
    output                 sclk, mosi, csb
    );

   // +2 for power_state
   localparam              SR_WIDTH = WORD_WIDTH + 2;
   localparam              SR_COUNT_WIDTH = $clog2(SR_WIDTH);
   localparam [SR_COUNT_WIDTH:0] SR_COUNT_RESET = {1'b1, {SR_COUNT_WIDTH{1'b0}}},
                                 SR_COUNT_INIT = SR_COUNT_RESET - SR_WIDTH;
   
   reg [SR_WIDTH-1:0]              shift_reg;
   reg                             clk_div;
   reg [SR_COUNT_WIDTH:0]          shift_count;
   wire                            shift_done;

   assign shift_done = shift_count[SR_COUNT_WIDTH];
   assign csb = shift_done;
   assign mosi = shift_reg[SR_WIDTH-1];
   assign sclk = clk_div;

   // Sim
   initial shift_count = SR_COUNT_RESET;
   
   always @(posedge sys_clk) begin
      // Next value load and reset of shift counter
      if (shift_done && load) begin
         shift_count <= SR_COUNT_INIT;
         shift_reg <= {power_state, parallel_in};
         clk_div <= 1'b1;
      end
      // When we are busy shifting, generate a clock and shift on "rising" edge
      else if (!shift_done) begin
         clk_div <= ~clk_div;
         if (!clk_div) begin
            shift_count <= shift_count + {{(SR_COUNT_WIDTH-1){1'b0}}, {1'b1}};
            shift_reg <= {shift_reg[SR_WIDTH-2:0], 1'b0};
         end
      end
   end

endmodule // spi_main

