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
 tune (tuning word width)


 */

module Osc
  #(
    parameter n = 14,
    parameter m = 12,
    parameter tune = 16
    )
    //IO INSTATIATION
    (
     input wire            clk,
     input wire [tune-1:0] tuningW,
     input wire [2:0]      sel,
     input wire            CE,
     input wire [m-1:0]    mod,
     output wire [m-1:0]   OUT	  
     );
    
    wire [n-1:0]           phase;
    wire [m-1:0]           triang;
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
        .tune(tune)
        )
    PA
      (
       .ce(CE),
       .clk(clk),
       .tuning(tuningW),
       .phaseReg(phase)
       );
    //TRIANGLE WAVEFORM
    Tri                    
                           #(
                             .n(n),
                             .m(m)
                             )
    TRI                    (
                            .phase(phase),
                            .triang(triang)
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
       .mod(mod),
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
       .traing(triang),
       .noi(lfsr),
       .pwm(pwm),
       .sel(sel),
       .wave(OUT)
       );
endmodule
