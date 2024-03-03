`timescale 1ns / 1ps
/**
 Author: Liam Crowley
 Date: 10/29/2023 06:49:21 PM
 Top wrapper file for the DDS algorithm
 INPUTS: 50/19MHz clk
 Tuning Word
 PWM modulation
 Selection
 OUTPUTS: Waveform post mux
 PARAMETERS: n (Phase Reg Width)
 m (Waveform width)
 TUNE_WIDTH (tuning word width)


 */

module Osc
  #(
    parameter n = 14,
    parameter m = 12,
    parameter TUNE_WIDTH = 16
    )
    //IO INSTATIATION
    (
     input wire            clk,
     input wire [TUNE_WIDTH-1:0] tuning_word,
     input wire [2:0]      wave_select,
     input wire            CE,
     input wire [m-1:0]    modulation,
     output wire [m-1:0]   wave_out
     );
    
    wire [n-1:0]           phase;
    wire [m-1:0]           triangle;
    wire [m-1:0]           pulse;
    wire [m-1:0]           saw;
    wire [m-1:0]           sine;
    wire [m-1:0]           lfsr;
    wire [m-1:0]           pwm;
    //PHASE ACCUMULATOR
    PhaseAccumulator
      #(
        .n(23),
        .m(n),
        .TUNE_WIDTH(TUNE_WIDTH)
        )
    PA
      (
       .ce(CE),
       .clk(clk),
       .tuning_word(tuning_word),
       .phaseReg(phase)
       );
    //TRIANGLE WAVEFORM
    Tri                    
      #(
        .n(n),
        .m(m)
        )
    TRI  
      (
       .phase(phase),
       .triang(triangle)
       );
    
    //PULSE WAVEFORM
    Pulse
      #(
        .n(n),
        .m(m)
        )
    PUL
      (
       .phase(phase),
       .pulse(pulse)
       );
    
    //SAW WAVEFORM
    Saw
      #(
        .n(n)
        )
    SAW
      (
       .phase(phase),
       .saw(saw)
       );

    //SINE WAVEFORM
    Sine
      #(
        .n(n),
        .m(m)
        )
    SINE
      (
       .phase(phase),
       .sine(sine)
       );

    //NOISE WAVEFORM
    Lfsr
      #(
        .n(n),
        .m(m)
        )
    LFSR
      (
       .clk(clk),
       .lfsr(lfsr)
       );

    //PWM MODULATION
    Pwm
      #(
        .n(n),
        .m(m))
    PWM
      (
       .clk(clk),
       .phase(phase),
       .modulation(modulation),
       .pwm(pwm)
       );

    //OUTPUT MUX
    mux
      #(
        .m(m)
        )
    MUX
      (
       .sine(sine),
       .saw(saw),
       .pulse(pulse),
       .traingle(triangle),
       .noise(lfsr),
       .pwm(pwm),
       .wave_select(wave_select),
       .wave_out(wave_out)
       );
endmodule
