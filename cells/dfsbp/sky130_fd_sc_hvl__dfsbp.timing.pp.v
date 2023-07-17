/*
 * Copyright 2020 The SkyWater PDK Authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * SPDX-License-Identifier: Apache-2.0
*/


`ifndef SKY130_FD_SC_HVL__DFSBP_TIMING_PP_V
`define SKY130_FD_SC_HVL__DFSBP_TIMING_PP_V

/**
 * dfsbp: Delay flop, inverted set, complementary outputs.
 *
 * Verilog simulation timing model.
 */

`timescale 1ns / 1ps
`default_nettype none

// Import user defined primitives.
`include "../../models/udp_pwrgood_pp_pg/sky130_fd_sc_hvl__udp_pwrgood_pp_pg.v"
`include "../../models/udp_dff_ps_pp_pg_n/sky130_fd_sc_hvl__udp_dff_ps_pp_pg_n.v"

`celldefine
module sky130_fd_sc_hvl__dfsbp (
    Q    ,
    Q_N  ,
    CLK  ,
    D    ,
    SET_B,
    VPWR ,
    VGND ,
    VPB  ,
    VNB
);

    // Module ports
    output Q    ;
    output Q_N  ;
    input  CLK  ;
    input  D    ;
    input  SET_B;
    input  VPWR ;
    input  VGND ;
    input  VPB  ;
    input  VNB  ;

    // Local signals
    wire buf_Q        ;
    wire SET          ;
    reg  notifier     ;
    wire cond0        ;
    wire D_delayed    ;
    wire SET_B_delayed;
    wire CLK_delayed  ;
    wire buf0_out_Q   ;
    wire not1_out_qn  ;

    //                                   Name         Output       Other arguments
    not                                  not0        (SET        , SET_B_delayed                                    );
    sky130_fd_sc_hvl__udp_dff$PS_pp$PG$N dff0        (buf_Q      , D_delayed, CLK_delayed, SET, notifier, VPWR, VGND);
    assign cond0 = ( SET_B_delayed === 1'b1 );
    buf                                  buf0        (buf0_out_Q , buf_Q                                            );
    sky130_fd_sc_hvl__udp_pwrgood_pp$PG  pwrgood_pp0 (Q          , buf0_out_Q, VPWR, VGND                           );
    not                                  not1        (not1_out_qn, buf_Q                                            );
    sky130_fd_sc_hvl__udp_pwrgood_pp$PG  pwrgood_pp1 (Q_N        , not1_out_qn, VPWR, VGND                          );

endmodule
`endcelldefine

`default_nettype wire
`endif  // SKY130_FD_SC_HVL__DFSBP_TIMING_PP_V