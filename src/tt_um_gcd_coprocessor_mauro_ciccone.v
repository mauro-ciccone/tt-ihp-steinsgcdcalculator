/*
 * Copyright (c) 2024 Mauro Ciccone
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_gcd_coprocessor_mauro_ciccone (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  assign uio_out = 8'b0;
  assign uio_oe  = 8'b0;

  wire [3:0] gcd_result;
  wire fsm_done;
  wire [7:0] decoded_leds;

  euclideanSteinFSM my_fsm (
        .a_in    (ui_in[3:0]),  
        .b_in    (ui_in[7:4]),  
        .clk     (clk),
        .reset   (rst_n),       
        .start   (uio_in[0]),
        .gcd_out (gcd_result),
        .is_done (fsm_done)
    );

    decoderLED my_decoder (
        .a (gcd_result),
        .y (decoded_leds)
    );

    assign uo_out = fsm_done ? decoded_leds : 8'b01000000;

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, uio_in[7:1], 1'b0};

endmodule
