`timescale 1ns / 1ns
/**
 * Tiny DDS Collab top-level module
 * 
 * Authors:
 * * Zach Baldwin 2023-10-26
 * * Liam Crowley 2023-10-PRESENTLY
 * 
 */

//26 INSTATIATES SEPARATE SINE LUTS//

`default_nettype none

module tt_um_LiamCrowley_Synthesizer 
  #(
    parameter TUNE_WIDTH = 16, //tuning word width
    parameter WAVE_WIDTH = 12, //waveform width
    parameter PHASE_WIDTH = 14,//phase from phase accumulator width
    parameter PACKET_WIDTH = 24, // Number of bits for the input SPI control word
    parameter CONTROL_DATA_WIDTH = PACKET_WIDTH-8 // Number of bits in the data portion of the SPI control word
    )
    (
     input wire [7:0]  ui_in, // Dedicated inputs - connected to the input switches
     output wire [7:0] uo_out, // Dedicated outputs - connected to the 7 segment display
     input wire [7:0]  uio_in, // IOs: Bidirectional Input path
     output wire [7:0] uio_out, // IOs: Bidirectional Output path
     output wire [7:0] uio_oe, // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
     input wire        ena, // will go high when the design is enabled
     input wire        clk, // clock
     input wire        rst_n     // reset_n - low to reset
     );

    wire [2:0]         osc0_wave_select, osc1_wave_select;
    wire [2:0]         modulation_select;
    wire [TUNE_WIDTH-1:0]   osc0_tune, osc1_tune;
    wire [WAVE_WIDTH-1:0]   osc0_wave_out, osc1_wave_out; //Wave out from voices
    wire               cDiv;
    wire [WAVE_WIDTH-1:0]   osc0_pulse_width,     // Modulation inputs for pwm
                       osc1_pulse_width,
                       osc0_ext_pulse_width;
    wire               E0, E1;      // Enables for voices
    wire               osc0_pw_select; // Select internal external pwm for voice 0
    wire [16-1:0]      wave_out;
    wire               dac_speed_select;
    reg [1:0]          dac_power_state;
    wire               dac_sclk, dac_mosi, dac_csb;
    wire               spi_sclk_in, spi_mosi, spi_csb;
    wire               spi_cmd_valid;
    wire [7:0]         spi_cmd_word;
    wire [CONTROL_DATA_WIDTH-1:0] spi_data_word;

    ///////////////////////////
    // I/O CONNECTIONS
    ///////////////////////////

    // INPUTS
    //ena
    //rst_n
    assign spi_sclk_in     = ui_in[0];
    assign spi_mosi        = ui_in[1];
    assign spi_csb         = ui_in[2];
    //ui_in[3]
    assign dac_power_state = ui_in[5:4];
    assign dac_speed_select = ui_in[6];
    assign osc0_pw_select  = ui_in[7];
    
    // OUTPUTS
    assign uo_out[4:0] = 5'b0;
    assign uo_out[5]   = dac_csb;
    assign uo_out[6]   = dac_mosi;
    assign uo_out[7]   = dac_sclk;

    // I/Os
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;
    assign osc0_ext_pulse_width = {uio_in, {(WAVE_WIDTH-8){1'b0}}};
    
    
    ///////////////////////////
    // INPUT SPI SHIFTER
    ///////////////////////////
    spi_in 
      #(
        .PACKET_WIDTH(PACKET_WIDTH),
        .DATA_WIDTH(CONTROL_DATA_WIDTH)
        ) SPI_SR_IN (
                     .sys_clk(clk),
                     .sclk(spi_sclk_in),
                     .mosi(spi_mosi),
                     .csb(spi_csb),
                     .cmd_word(spi_cmd_word),
                     .data_word(spi_data_word),
                     .cmd_valid(spi_cmd_valid)
                     );

    ///////////////////////////
    // INPUT SPI COMMAND AND DATA DECODE
    ///////////////////////////
    cmd_decoder
      #(
        .DATAWORD_WIDTH(CONTROL_DATA_WIDTH),
        .TUNING_WIDTH(TUNE_WIDTH),
        .WAVE_SELECT_WIDTH(3),
        .PULSEWIDTH_WIDTH(WAVE_WIDTH),
        .MODULATION_SELECT_WIDTH(3)
        ) CMD_DECODE (
                      .sys_clk(clk),
                      .cmd_word(spi_cmd_word),
                      .data_word(spi_data_word),
                      .cmd_valid(spi_cmd_valid),
                      .osc0_en(E0),
                      .osc1_en(E1),
                      .osc0_tune(osc0_tune),
                      .osc0_wave(osc0_wave_select),
                      .osc1_tune(osc1_tune),
                      .osc1_wave(osc1_wave_select),
                      .osc1_pw(osc1_pulse_width),
                      .modulation_select(modulation_select)
                      );

    ///////////////////////////
    // Master Clock Divider
    ///////////////////////////
    div DIV
      (
       .clkI(clk),
       .clkO(cDiv)
       );
    
    ///////////////////////////
    // OSCILLATOR VOICES
    ///////////////////////////
    Osc
      #(
        .n(PHASE_WIDTH),
        .m(WAVE_WIDTH),
        .TUNE_WIDTH(TUNE_WIDTH)
        ) VOICE0 (
                  .CE(E0 & ena),
                  .clk(cDiv),
                  .wave_out(osc0_wave_out),
                  .wave_select(osc0_wave_select),
                  .tuning_word(osc0_tune),
                  .modulation(osc0_pulse_width)
                  );
    
    Osc
      #(
        .n(PHASE_WIDTH),
        .m(WAVE_WIDTH),
        .TUNE_WIDTH(TUNE_WIDTH)
        ) VOICE1 (
                  .CE(E1 & ena),
                  .clk(cDiv),
                  .wave_out(osc1_wave_out),
                  .wave_select(osc1_wave_select),
                  .tuning_word(osc1_tune),
                  .modulation(osc1_pulse_width)
                  );

    ///////////////////////////
    // MODULATION
    ///////////////////////////
    mux_2 #( .m(WAVE_WIDTH) ) PULS_MUX
      (
       .in0(osc1_wave_out),
       .in1(osc0_ext_pulse_width),
       .sel(osc0_pw_select),
       .out(osc0_pulse_width)
       );
    
    Mod
      #(
        .m(WAVE_WIDTH),
        .o(16)
        ) MOD (
               .clk(clk),
               .OSC0(osc0_wave_out),
               .OSC1(osc1_wave_out),
               .modulation_select(modulation_select),
               .modulation_out(wave_out)
               );
    
    ///////////////////////////
    // SPI OUTPUT
    ///////////////////////////
    spi_main_x2 #(.WORD_WIDTH(16)) SPIO
      (
       .sys_clk(clk),
       .parallel_in(wave_out),
       .power_state(dac_power_state),
       .load(ena),
       .sclk(dac_sclk),
       .mosi(dac_mosi),
       .csb(dac_csb),
       .speed_select(dac_speed_select)
       );
    
    
endmodule // tt_um_LiamCrowley_Synthesizer
