`timescale 1ns / 1ps
/*========================================FILE_HEADER=====================================
# Author:  Freddi Fu(fuyufei083x@163.com)
#
# Critical Timing: 2022-2023 -
#
# date: 2022-12-24 01:48
#
# Filename: arbiter_strict_priority.v
#
# Module Name: arbiter_strict_priority.v
#
# VERSION      LAST MODIFID    Instance Modules           DESCRIPTION
#   1.0       2022-12-10        submodulehere         writesomethinghere
#
#
=========================================FILE_HEADER====================================*/
module arbiter_strict_priority(
	//input clk and reset
	input                i_clk,
	input                i_rst,
	//input request signal
	input   [3:0]        i_req_vector,
	input   [3:0]        i_end_access_vector,
	output  [3:0]        o_vector
);
//***********************************************************************************************
    reg  [1:0]  arbiter_state, arbiter_state_nxt;
	reg  [3:0]  vector_nxt;
	wire        any_request;
//***********************************************************************************************
parameter    IDLE = 2'b01,
	         END_ACCESS = 2'b10;
parameter    IDLE_B = 0,
	         END_ACCESS_B = 1;
//***********************************************************************************************
//get the request value 
    assign any_request = (i_req_vector!='d0);
always@(posedge i_clk or negedge i_rst)
begin
	if(i_rst==1'b0)
	begin
		arbiter_state_nxt <= IDLE;
	end
	else
	begin
		case(1'b1)
			arbiter_state[IDLE_B]:begin
				if(any_request)
				    arbiter_state_nxt <= END_ACCESS;
			    else
				begin
					arbiter_state_nxt <= IDLE;
				if(i_req_vector[0])
					vector_nxt <= 4'b0001;
				else if(i_req_vector[1])
					vector_nxt <= 4'b0010;
				else if(i_req_vector[2])
					vector_nxt <= 4'b0100;
				else if(i_req_vector[3])
					vector_nxt <= 4'b1000;
				else
					vector_nxt <= 4'b0000;
			end
           end
		   arbiter_state[END_ACCESS_B]:begin
			   if( (i_end_access_vector[0]&vector_nxt[0]) ||
                   (i_end_access_vector[1]&vector_nxt[1]) ||
				   (i_end_access_vector[2]&vector_nxt[2]) ||
				   (i_end_access_vector[3]&vector_nxt[3]))
			   begin
				    if(any_request)
					   arbiter_state_nxt <= END_ACCESS;
				   else
				   begin
					   arbiter_state_nxt <= IDLE;
				if(i_req_vector[0])
					vector_nxt <= 4'b0001;
				else if(i_req_vector[1])
					vector_nxt <= 4'b0010;
				else if(i_req_vector[2])
					vector_nxt <= 4'b0100;
				else if(i_req_vector[3])
					vector_nxt <= 4'b1000;
				else
					vector_nxt <= 4'b0000;
			    end
			end
			else
			begin
				arbiter_state_nxt <= END_ACCESS;
			end
		end
		default:begin
			arbiter_state_nxt <= IDLE;
		end
	endcase
	end
end
//**********************************************************************************************
always@(posedge i_clk or negedge i_rst)
begin
	if(i_rst==1'b0)
	begin
		arbiter_state <= 'd0;
		vector_nxt <= 'd0;
	end
	else
	begin
		arbiter_state <= arbiter_state_nxt;
	end
end
assign o_vector = vector_nxt;

endmodule

