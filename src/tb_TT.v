`timescale 1ns/1ns
/**
 * Test bench for the ENTIRE PROJECT (!)
 * 
 * Authors:
 * * Zach Baldwin 2023-11-04
 */
module tb_tt ();

   parameter PW = 24,
             DW = 16;

   reg       sclk, mosi, csb;
   reg       sys_clk;
   reg [DW-1:0] data, out_sr;
   reg          osc0_pw_sel;
   reg          dac_speed_sel;
   reg [7:0]    osc0_ext_pw;
   wire         dac_sclk, dac_mosi, dac_csb;
   wire [4:0]   out_dummy;
   reg          rst_n, ena;
   reg [1:0]    dac_power_state;

   // Module instantiation
   tt_um_LiamCrowley_Synthesizer #() tt05
   (
    .ui_in({
            osc0_pw_sel,
            dac_speed_sel,
            1'b0,
            dac_power_state,
            csb,
            mosi,
            sclk
            }),
    .uo_out({
             dac_sclk,
             dac_mosi,
             dac_csb,
             out_dummy
             }),
    .uio_in(osc0_ext_pw),
    .uio_out(),
    .uio_oe(),
    .ena(ena),
    .clk(sys_clk),
    .rst_n(rst_n)
    );
                                             

   // Reset & enable
   initial begin
      rst_n = 1'b0;
      ena = 1'b1;
      #30 rst_n = 1'b1;
   end

   
   // Set up clock
   initial begin
      sys_clk = 1'b0;
      forever #20 sys_clk = ~sys_clk;
   end

   initial begin
      sclk = 1'b0;
      forever #30 sclk = ~sclk;
   end


   // Stimulus
   initial begin
      dac_power_state = 2'b0;
      osc0_pw_sel = 1'b0;
      osc0_ext_pw = 8'h50;
      dac_speed_sel = 1'b1;
      csb = 1'b1;
      // Set frequency of voice 0
      sendCmd( 24'h02ffff );
      // Set waveform
      sendCmd( 24'h080003 );
      // Set modulation
      sendCmd( 24'h040007 );
      // Enable voice 0
      sendCmd( 24'h010000 );

      // Set frequency of voice 1
      sendCmd( 24'h214000 );
      // Set waveform
      sendCmd( 24'h810000 );
      // Set pulse to 800
      sendCmd( 24'h410800 );
      // Enable voices 0 and 1
      sendCmd( 24'h110000 );
        
        
      // #500 $stop();
   end // initial begin

   // OUTPUT SR
   always @(negedge dac_sclk or posedge dac_csb) begin
      if (!dac_csb) begin
         out_sr <= {out_sr[DW-2:0] , dac_mosi};
      end
      else begin
         data <= out_sr;
      end
   end

   task automatic sendCmd(input [PW-1:0] in);
      integer ii = PW-1;

      begin
         @(posedge sclk) csb = 1'b0;
         repeat (PW) begin
            @(posedge sclk) begin
               mosi = in[ii];
               ii = ii - 1;
            end
         end
         @(posedge sclk) csb = 1'b1;
      end
   endtask  

endmodule // tb_spi_main
