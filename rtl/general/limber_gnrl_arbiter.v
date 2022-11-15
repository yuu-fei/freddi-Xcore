`timescale 1ns / 1ps
//-------------------------------------------------------------------------------------------
//
// Project    : Limber IoT NP
// File       : limber_gnrl_arbiter.v
// Module     : limber_gnrl_arbiter(ARBI)
// Dependancy : 
// Software   : vivado2018.3
// Author     : Freddi Fu
// Date       : 2022-10-27
// Version    : v1.0
// Description: Limber general arbiter.
//
//-------------------------------------------------------------------------------------------
module limber_gnrl_arbiter#(
    parameter N = 4,
    parameter RR = 0 // 0 : prior 1 : round-robin
)(
    input   i_clk,
    input   i_rst,
    input [N-1:0] i_lhb_req_valid,
    output [N-1:0] o_lhb_req_grant
);
    wire [N-1:0] grant_thermom;
    wire [N-1:0] req_valid;
    genvar i;
    generate
        if(RR==0) begin
            assign req_valid = i_lhb_req_valid;
        end
        else begin
            wire [N-2:0] grant_mask_r;
            limber_gnrl_dffr #(N-1) dffr_gmask(i_clk, i_rst, ~grant_thermom[N-1:1], grant_mask_r);
            wire [N-2:0] req_valid_msked = i_lhb_req_valid[N-1:1] & grant_mask_r;
            wire grant_sel = |req_valid_msked;
            assign req_valid = grant_sel ? {req_valid_msked, 1'b0} : i_lhb_req_valid;
        end
        assign grant_thermom[0] = 1'b1;
        for(i=1; i<N; i=i+1)begin
            assign grant_thermom[i] = ~(|req_valid[i-1:0]);
        end
        assign o_lhb_req_grant = grant_thermom & req_valid;
    endgenerate
endmodule
