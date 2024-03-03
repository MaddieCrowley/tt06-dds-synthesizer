`timescale 1ns / 1ns
/**
 * SPI Command Decoder
 * 
 * Authors:
 * * Zach Baldwin 2023-11-02
 * 
 * **** USAGE ****
 * An 8-bit command word is entered and based on it's encoding,
 * the associated output control signals are asserted.
 * 
 * PARAMETERS:
 *   <none>
 * 
 * INPUTS:
 *   cmd_word  - The command word to decode
 *   data_word - The data portion of the spi command word
 *   cmd_valid - Assert (high) to read in the command data
 * 
 * OUTPUTS: (All active HIGH)
 *  **CONTROL SIGNALS**
 *   osc0_en       - Enable oscillator 0
 *   osc1_en       - Enable oscillator 1
 *  **DATA SIGNALS**
 *   osc0_tune     - Frequency (tuning word) for oscillator 0
 *   osc0_wave     - Waveform select for oscillator 0
 *   osc1_tune     - Frequency (tuning word) for oscillator 1
 *   osc1_pw       - Pulse width (for pulse mode) for oscillator 1
 *   osc1_wave     - Waveform select for oscillator 1
 *   mod_sel       - Modulation selection
 */
module cmd_decoder
  #(
    parameter DATAWORD_WIDTH = 16,
    parameter TUNING_WIDTH = 14,
    parameter WAVE_SEL_WIDTH = 3,
    parameter PULSEWIDTH_WIDTH = 12,
    parameter MODE_SEL_WIDTH = 2
    )
    (
     // Control signals in
     input [7:0]                       cmd_word,
     input [DATAWORD_WIDTH-1:0]        data_word,
     input                             cmd_valid,
     input                             sys_clk,
     // Oscillator
     output reg                        osc0_en,
     output reg                        osc1_en,
     // Data outputs
     output reg [TUNING_WIDTH-1:0]     osc0_tune, osc1_tune,
     output reg [WAVE_SEL_WIDTH-1:0]   osc0_wave, osc1_wave,
     output reg [PULSEWIDTH_WIDTH-1:0] osc1_pw,
     output reg [MODE_SEL_WIDTH-1:0]   mode_sel
     );
    
    /*
     *  **CONTROL SIGNALS**
     *   osc0_set_tune - Dataword load to tuning word of oscillator 0
     *   osc0_set_wave - Dataword load to oscillator 0 waveform selection
     *   osc1_set_tune - Dataword load to tuning word of oscillator 1
     *   osc1_set_pw   - Dataword load to oscillator 1 pulse width
     *   osc1_set_wave - Dataword load to oscillator 1 waveform selection
     *   set_mode      - Dataword load to output modulation selector
     */
    wire                               osc0_set_tune;
    wire                               osc0_set_wave;
    wire                               osc1_set_tune;
    wire                               osc1_set_pw;
    wire                               osc1_set_wave;
    wire                               set_mode;
    wire                               osc0_en_pre, osc1_en_pre;

    reg [7:0]                          cmd_word_reg;
    reg [DATAWORD_WIDTH-1:0]           data_word_reg;

    // Capture input controls when they are valid
    always @(posedge sys_clk) begin
        if (cmd_valid) begin
            cmd_word_reg <= cmd_word;
            data_word_reg <= data_word;
        end
    end

    // Decode the control signals
    assign osc0_en_pre   = cmd_word_reg[0];
    assign osc0_set_tune = cmd_word_reg[1];
    assign set_mode      = cmd_word_reg[2];
    assign osc0_set_wave = cmd_word_reg[3];
    assign osc1_en_pre   = cmd_word_reg[4];
    assign osc1_set_tune = cmd_word_reg[5];
    assign osc1_set_pw   = cmd_word_reg[6];
    assign osc1_set_wave = cmd_word_reg[7];

    // Dataword breakout
    wire [TUNING_WIDTH-1:0]     osc0_tune_pre, osc1_tune_pre;
    wire [WAVE_SEL_WIDTH-1:0]   osc0_wave_pre, osc1_wave_pre;
    wire [PULSEWIDTH_WIDTH-1:0] osc1_pw_pre;
    wire [MODE_SEL_WIDTH-1:0]   mode_sel_pre;
    
    assign osc0_tune_pre = data_word_reg[TUNING_WIDTH-1:0];
    assign osc0_wave_pre = data_word_reg[WAVE_SEL_WIDTH-1:0];
    assign osc1_tune_pre = data_word_reg[TUNING_WIDTH-1:0];
    assign osc1_wave_pre = data_word_reg[WAVE_SEL_WIDTH-1:0];
    assign osc1_pw_pre   = data_word_reg[PULSEWIDTH_WIDTH-1:0];
    assign mode_sel_pre  = data_word_reg[MODE_SEL_WIDTH-1:0];

    // Handle saving of control data
    // (completely ignoring dynamic power concerns...)
    always @(posedge sys_clk) begin
        osc0_en <= osc0_en_pre;
        osc1_en <= osc1_en_pre;
        if (osc0_set_tune) begin
            osc0_tune <= osc0_tune_pre;
        end
        if (osc0_set_wave) begin
            osc0_wave <= osc0_wave_pre;
        end
        if (osc1_set_tune) begin
            osc1_tune <= osc1_tune_pre;
        end
        if (osc1_set_pw) begin
            osc1_pw <= osc1_pw_pre;
        end
        if (osc1_set_wave) begin
            osc1_wave <= osc1_wave_pre;
        end
        if (set_mode) begin
            mode_sel <= mode_sel_pre;
        end
    end
    
endmodule // cmd_decoder
