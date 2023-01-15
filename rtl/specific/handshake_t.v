`timescale 1ns / 1ps
/*========================================FILE_HEADER=====================================
# Author:  Freddi Fu(fuyufei083x@163.com)
#
# Critical Timing: 2022-2023 -
#
# date: 2022-12-23 06:53
#
# Filename: handshake_t.v
#
# Module Name: handshake_t.v
#
# VERSION      LAST MODIFID    Instance Modules           DESCRIPTION
#   1.0       2022-12-23        none            this is the handshake module for transmission part 
#
#
=========================================FILE_HEADER====================================*/
module handshake_t(
//input clk and reset signal
    input             i_tclk,
    input             i_trst,
//input data pack and data available signal
    input   [31:0]    i_t_data,
	input             i_data_avail,
//input ack signal
    input             i_r_ack,
//output
    output  [31:0]    o_t_data,
	output            o_t_rdy
);
//three transmission states 
    localparam IDLE_T = 2'd0;
	localparam ASSERT_TRDY = 2'd1;
	localparam DEASSERT_TRDY = 2'd2;
//**********************************************************************************************
/* four reg are needed : the state and the state next; r_ack should have
 a synchronization step; the input data should be loaded ; to make the synchronization we need a
 register to load the t_rdy signal*/
    reg [31:0]  data_r;
	reg         t_rdy_r;
	reg [1:0]   trans_state,trans_state_nxt;
	reg         r_ack_r1,r_ack_r2;
//**********************************************************************************************
//state_machine
always@(posedge i_tclk or negedge i_trst)
begin
	if(i_trst==1'b0)
	begin
		data_r <= 'd0;
		t_rdy_r <= 'd0;
		trans_state_nxt <= 'd0;
	end
	else
		begin
			case(trans_state)
				IDLE_T:begin
					if(i_data_avail) //whether the data is ready and change to the nxt state
					begin
						trans_state_nxt <= ASSERT_TRDY;
						t_rdy_r <= 1'b1;
						data_r <= i_t_data;
					end
				end
				ASSERT_TRDY:begin
					if(r_ack_r2) //whether synchronized ready signal is received
					begin
						trans_state_nxt <= DEASSERT_TRDY;
						t_rdy_r <= 'd0;
						data_r <= 'd0;
					end
					else
					begin
						t_rdy_r <= 1'b1;
						data_r <= i_t_data;
					end
				end
				DEASSERT_TRDY:begin
					if(r_ack_r2==1'b0)
					begin
						if(i_data_avail)
						begin
						trans_state_nxt <= ASSERT_TRDY;
						t_rdy_r <= 1'b1;
						data_r <= i_t_data;
				    	end
				    	else
				    	begin
						trans_state_nxt <= IDLE_T;
					    end
				   end
					else
					begin
						trans_state_nxt <= DEASSERT_TRDY;
						t_rdy_r <= 'd0;
						data_r <= 'd0;
					end
				end
				default:begin
					trans_state_nxt <= IDLE_T;
				end
			endcase
		end
	end
//************************************************************************************************
// the next state apply 
always@(posedge i_tclk or negedge i_trst)
begin
	if(i_trst) 
		begin
        trans_state <= IDLE_T;
		r_ack_r1 <= 'd0;
		r_ack_r2 <= 'd0;
	end
	else
	begin
		trans_state <= trans_state_nxt;
		r_ack_r1 <= i_r_ack;
		r_ack_r2 <= r_ack_r1;
	end
end 
assign o_t_data = data_r;
assign o_t_rdy = t_rdy_r;
endmodule

