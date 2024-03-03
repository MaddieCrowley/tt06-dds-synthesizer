`timescale 1ns/1ns
/**
 * Test bench for the SPI Input device (receives commands in)
 * 
 * Authors:
 * * Zach Baldwin 2023-11-04
 */
module tb_spi_in ();

    parameter PW = 24,
              DW = 16;

    reg       sclk, mosi, csb;
    reg       sys_clk, load, speed_sel;
    wire [DW-1:0] data;
    wire [7:0]    cmd;
    wire          cmd_valid;

    // Module instantiation
    // spi_main
    spi_in
      #(
        .PACKET_WIDTH(PW),
        .DATA_WIDTH(16)
        )
    UUT
      (
       .sys_clk(sys_clk),
       .sclk(sclk),
       .mosi(mosi),
       .csb(csb),
       .cmd_word(cmd),
       .data_word(data),
       .cmd_valid(cmd_valid)
       );

    // Set up clock
    initial begin
        sys_clk = 1'b0;
        forever #10 sys_clk = ~sys_clk;
    end

    initial begin
        sclk = 1'b0;
        forever #30 sclk = ~sclk;
    end


    // Stimulus
    integer ii = PW-1;
    reg [PW-1:0] v = 24'h674089;
    initial begin
        csb = 1'b1;
        #40 csb = 1'b0;
        repeat (PW) begin
            @(posedge sclk) begin
                mosi = v[ii];
                ii = ii - 1;
            end
        end
        @(posedge sclk) csb = 1'b1;
        
        #5000 $stop();
    end

endmodule // tb_spi_main
