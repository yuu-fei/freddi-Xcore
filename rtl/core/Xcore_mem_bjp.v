///////////////////////////////////////////////////////////////////////////////
//
// Copyright Freddi, UESTC 
//
///////////////////////////////////////////////////////////////////////////////
//-----------------------------------------------------------------------------
//
// Project    : Xcore bjp unit 
// File       : Xcore_mem_bjp.v
// Module     : Xcore_mem_bjp.v(BJP)
// Author     : Yufei Fu(fuyufei083X@gmail.com)
// Date       : 2022-1-4
// Version    : v2.0
// Description:  In BJP Unit, we can get the true result, some instruction must be overwrite:
// prediction is taken : 
//     if prediction is true, no need to jump and no need flush, type = 0.
//     if prediction is false, need jump and flush, type = 1. Pipeline will resume if stall
// prediction is not taken : 
//     if prediction is true, no need to jump nor flush.
//     if prediction is false, need jump and flush, type = 0. Pipeline will resume if stall
//     about status signal- i_ex_alu_cmp_res:
//	    there are two bits
//		bit 0 : 1 is equal (zero =0)  0 is not equal (zero !=0)
//		bit 1 : 1 is less than (slt =1) 0 is greater than(slt =0)
//      backend update is done in this module        
// ----------------------------------------------------------------------------
`timescale 1ns/1ps
//include params
//****************************************************************************************  
//`include "/rtl/include/params.v"
//module definition
module Xcore_mem_bjp(
	input				i_ex_bjp_req,	 //request signal to activate bjp from exe stage  
	//valid signal      
	input               i_ex_b_req,
	input				i_ex_beq_req,
	input               i_ex_jal_req,  //type of branch instr from IF stage(a chain to transfer the info
	//beq instr signal as different branch signals have different criterion to judge	 
	input				i_ex_bne_req,	 //bne signal 
	input				i_ex_blt_req,    //blt signal 
	input				i_ex_bgt_req,	 //bgt signal
	input				i_ex_blte_req,	 // blt and equal
	input				i_ex_bgte_req,	 // bgt and equal
	input				i_ex_fencei_req, // fence instruction   
	//the creterion of judging whether the branch should be taken or not 
	input	[31:0]	    i_ex_alu_res,	 //alu result 
	input	[1:0]       i_ex_alu_cmp_res,/* alu compare result bit1 is compare res of l or g bit 0 i
				s equal*/
	input   [31:0]    	i_ex_instr_pc,	 /*pc from the pipeline as the bjp need to tell the 
			   next adress of the branch*/
	input         		i_ex_instr_deci, /*the decision of whether taking the branch 1 or not 0 made
				  in bpu*/
	input   [1:0]       i_ex_bim_bits,
//************************************************************************************************
	output  [31:0]		    o_bjp_target,    /*the adress of the next instr could be +4 or alu_result
					 or pc callback*/ 
	output				    o_bjp_flush_req,
	output				    o_bjp_flush_type,
    //backend update
	output                  o_bjp_predict_res, //whether the branch is predicted true ot not
	output  [31:0]	        o_bjp_instr_pc,
	output  [2:0]           o_bjp_instr_type,
	output  [1:0]           o_bjp_ghr_val,
	output  [1:0]           o_bjp_update_bits,
	output  [31:0]          o_bjp_res,  //whether the branch is taken or not
	output                  o_bjp_req,
	output                  o_bjp_jump_target, //whether the last branch is jumped or not
    output				    o_bjp_jump_req
						);
//*******************************************************************************************  
						//decide the status of branch instr
						wire bjp_dir_taken = i_ex_bjp_req
						&((i_ex_beq_req&i_ex_alu_cmp_res[0])|(i_ex_bne_req&~i_ex_alu_cmp_res[0])|(i_ex_blt_req&i_ex_alu_cmp_res[1])
						|(i_ex_bgt_req&~
						i_ex_alu_cmp_res[1])|(i_ex_blte_req&(i_ex_alu_cmp_res[1]|i_ex_alu_cmp_res[0]))
						|(i_ex_bgte_req&(~i_ex_alu_cmp_res[1]|i_ex_alu_cmp_res[0])));  
						//Does the branch taken? 1 is has a branch and taken 0 is else
						wire bjp_dir_notaken = i_ex_bjp_req
						&((i_ex_beq_req&(~i_ex_alu_cmp_res[0]))|(i_ex_bne_req&i_ex_alu_cmp_res[0])|(i_ex_blt_req&(~i_ex_alu_cmp_res[1]))
						|(i_ex_bgt_req&i_ex_alu_cmp_res[1])|(i_ex_blte_req&(~i_ex_alu_cmp_res[1]&(~i_ex_alu_cmp_res[0])))

						|(i_ex_bgte_req&(i_ex_alu_cmp_res[1]&~i_ex_alu_cmp_res[0])))&(~i_ex_jal_req);  
						wire bjp_jal_taken = i_ex_jal_req;
						wire instr_bp = i_ex_instr_deci; 
						//whether is taken or not in bpu (2 states counter)
						wire bjp_dir = bjp_dir_taken|bjp_jal_taken;
						reg need_jump;
						reg need_flush;
						reg need_type;
//*******************************************************************************************
						always@(*) begin
							case({instr_bp,bjp_dir,bjp_dir_notaken})
						
								3'b001: {need_jump,need_flush,need_type} = 3'b000; // not taken and true, do not flush
								3'b010: {need_jump,need_flush,need_type} = 3'b111; // not taken and false, do flush and jump back
								3'b110: {need_jump,need_flush,need_type} = 3'b000; // taken and true, do not flush
								3'b101: {need_jump,need_flush,need_type} = 3'b011; // taken and false,flush but donot to jump
							
								default : {need_jump, need_flush, need_type} = 3'b000;
							
							endcase
						end
//*******************************************************************************************
	reg [1:0] bjp_bits;
    always@(*)
	begin
		case({bjp_dir,i_ex_bim_bits})
			3'b000:begin
				bjp_bits = 2'b00;
			end
			3'b100:begin
				bjp_bits = 2'b01;
			end
			3'b001:begin
				bjp_bits = 2'b00;
			end
			3'b101:begin
				bjp_bits = 2'b10;
			end
			3'b010:begin
				bjp_bits = 2'b01;
			end
			3'b110:begin
				bjp_bits = 2'b11;
			end
			3'b011:begin
				bjp_bits = 2'b10;
			end
			3'b111:begin
				bjp_bits = 2'b11;
			end
			default: bjp_bits = 2'b00;
		endcase
	end

    assign o_bjp_instr_pc = i_ex_instr_pc; //the adress of the branch  
    assign o_bjp_req = i_ex_jal_req|i_ex_b_req; //as long as there is a beq or
	assign o_bjp_predict_res = i_ex_instr_deci^bjp_dir;
	assign o_bjp_ghr_val = o_bjp_predict_res ? {1'b0,bjp_dir} : 2'b00;
	assign o_bjp_update_bits = bjp_bits;
	assign o_bjp_instr_type = i_ex_b_req ? 3'b100 : i_ex_jal_req ? 3'b010 : 3'b000; 
	assign o_bjp_jump_target = bjp_dir&(~bjp_dir_notaken);
	assign o_bjp_res = i_ex_instr_pc + 'd4;
	assign o_bjp_target = bjp_dir ? i_ex_alu_res : o_bjp_res;
	assign o_bjp_jump_req = need_jump;
	assign o_bjp_flush_req = need_flush;
	assign o_bjp_flush_type = need_type;

endmodule
