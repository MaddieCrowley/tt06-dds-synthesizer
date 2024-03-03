`timescale 1ns / 1ns
/**
 * SPI Input Shifter
 * 
 * Authors:
 * * Zach Baldwin 2023-11-02
 * 
 * **** USAGE ****
 * Data is loaded on the RISING edge of the clock and should
 * be sampled on the output serial one on the FALLING edge 
 * of the output clock
 * 
 * PARAMETERS:
 *   PACKET_WIDTH - The number of bits to shift per packet
 *   DATA_WIDTH   - The number of bits wide to set the input shift register
 * 
 * INPUTS:
 *   sys_clk - system clock. Data is processed on the rising edge
 *   sclk    - SPI clock, data is intended to be sampled on the falling edge
 *   mosi    - Serial data output
 *   csb     - Active low chip select input. A rising edge loads in data
 * 
 * OUTPUTS:
 *  **NOTE: THESE OUTPUTS ARE ONLY VALID WHEN `cmd_valid` IS ACTIVE**
 *   cmd_word  - Command word (first 8 bits of data shifted in)
 *   data_word - Data value associated with command word
 *   cmd_valid - High = data on cmd_word and data_word is valid. 
 *               Low = output data invalid
 */
module spi_in
  #(
    parameter PACKET_WIDTH = 24,
    parameter DATA_WIDTH = 16
    )
    (
     input                   sys_clk,
     input                   sclk, mosi, csb,
     output [7:0]            cmd_word,
     output [DATA_WIDTH-1:0] data_word,
     output reg              cmd_valid
     );

    localparam               SR_WIDTH = PACKET_WIDTH;

    reg [SR_WIDTH-1:0]       shift_reg;
    wire                     csb_sync;

    // The internals of this module operate on the external
    // SPI clock domain. We will synchronize the outputs of
    // the module with the system clock domain instead of
    // synchronizing the input lines.
    cdc_generic #( .STAGES(3), .W(SR_WIDTH) ) CDC_DATA
      ( 
        .clk_in(sclk),
        .clk_out(sys_clk),
        .d_in(shift_reg),
        .d_out({cmd_word, data_word})
        );

    cdc_generic #( .STAGES(3), .W(1) ) CDC_CSB
      ( 
        .clk_in(sclk),
        .clk_out(sys_clk),
        .d_in(csb),
        .d_out(csb_sync)
        );   

    // Just keep shifting until we get data
    always @(posedge sclk) begin
        if (!csb) begin
            shift_reg <= {shift_reg[SR_WIDTH-2:0], mosi};
        end
    end

    // Output a pulse in the system's clock domain
    // when the chip select line is deasserted
    localparam S0 = 2'b01,
               S1 = 2'b11,
               S2 = 2'b10;

    reg [1:0]  state;

    // Sim:
    initial state = 2'b0;
    
    always @(posedge sys_clk) begin
        case (state)
          S0 : begin
              if (csb_sync) begin
                  state <= S1;
              end
          end
          S1 : begin
              state <= S2;
              cmd_valid <= 1'b1;
          end
          S2 : begin
              cmd_valid <= 1'b0;
              if (!csb_sync) begin
                  state <= S0;
              end
          end
          default : state <= S0;
        endcase
    end
    
endmodule // spi_in

