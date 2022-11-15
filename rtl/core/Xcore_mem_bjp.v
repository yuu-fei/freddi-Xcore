///////////////////////////////////////////////////////////////////////////////
//
// Copyright Freddi, UESTC 
//
///////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
//-----------------------------------------------------------------------------
//
// Project    : Xcore bjp unit 
// File       : Xcore_mem_bjp.v
// Module     : Xcore_mem_bjp.v(BJP)
// Author     : Yufei Fu(fuyufei083X@gmail.com)
// Date       : 2022-11-5
// Version    : v1.0
// Description:  In BJP Unit, we can get the true result, some instruction must be overwrite:
    // prediction is taken : 
    //     if prediction is true, no need to jump and no need flush, type = 0.
    //     if prediction is false, need jump and flush, type = 1. Pipeline will resume if stall
    // prediction is not taken : 
    //     if prediction is true, no need to jump nor flush.
    //     if prediction is false, need jump and flush, type = 0. Pipeline will resume if stall
    //
//              
// ----------------------------------------------------------------------------
`timescale 1ns/1ps
//include params
`include "params.v"
//module definition
module Xcore_mem_bjp(
	input				i_ex_bjp_req,	 //request signal to activate bjp from exe stage 
	input				i_ex_beq_req,	 //beq instr signal as different branch signals have different criterion to judge
										 //whether it is taken or not 
	input				i_ex_bne_req,	 //bne signal 
	input				i_ex_blt_req,    //blt signal 
	input				i_ex_bgt_req,	 //bgt signal
	input				i_ex_blte_req,	 // blt and equal
	input				i_ex_bgte_req,	 // bgt and equal
	input				i_ex_fencei_req, // fence instruction
	
	input	[`WIDTH]	i_ex_alu_res,	 //alu result 
	input	[1:0]      	i_ex_alu_cmp_res,// alu compare result bit1 is compare res of l or g bit 0 is equal

	input   [`WIDTH]    i_ex_instr_pc,	 //pc from the pipeline as the bjp need to tell the next adress of the branch  
	input   [1:0]		i_ex_instr_skip, //used for pc callback which means target is not the next but the original 
	input   [2:0]       i_ex_instr_id,   //id of instr donot waht is this for

	output  [`WIDTH]	o_bjp_target,    //the adress of the next instr could be +4 or alu_result or pc callback 
	output				o_bjp_flush_req,
	output				o_bjp_flush_type,
	output	[2:0]		o_bjp_flush_id,

	output  [`WIDTH]	o_bjp_res,
	output				o_bjp_jump_req				
);

wire bjp_dir = i_ex_bjp_req
			   &((~(i_ex_beq_req&i_ex_alu_cmp_res[0]))|(~(i_ex_bne_req&~i_ex_alu_cmp_res[0]))|(~(i_ex_blt_req&i_ex_alu_cmp_res[1]))
			     |(~(i_ex_bgt_req&~i_ex_alu_cmp_res[1]))|(~(i_ex_blte_req&(i_ex_alu_cmp_res[1]|~i_ex_alu_cmp_res[0])))
				 |(~(i_ex_bgte_req&(~i_ex_alu_cmp_res[1]|~i_ex_alu_cmp_res[0]))));
wire instr_bp = |i_ex_instr_skip;

reg need_jump;
reg need_flush;
reg need_type;

always@(*) begin
	case({instr_bp,bjp_dir})
		2'b00: {need_jump,need_flush,need_type} = 3'b000; // not taken and true, do not flush
        2'b01: {need_jump,need_flush,need_type} = 3'b111; // not taken and false, do flush and jump back
		2'b11: {need_jump,need_flush,need_type} = 3'b000; // taken and true, do not flush
	    2'b10: {need_jump,need_flush,need_type} = 3'b011; // taken and false,flush but donot to jump
		default : {need_jump, need_flush, need_type} = 3'b000;
	endcase
end
wire [31:0] pc_callback = i_ex_instr_pc + {i_ex_instr_skip, 2'b0};

assign o_bjp_res          = i_ex_instr_pc + 4;
assign o_bjp_target       = i_ex_fencei_req ? o_bjp_res : bjp_dir ? i_ex_alu_res : pc_callback;
assign o_bjp_jump_req     = need_jump;
assign o_bjp_flush_req    = need_flush;
assign o_bjp_flush_type   = need_type;
assign o_bjp_flush_id     = i_ex_instr_id;

endmodule
