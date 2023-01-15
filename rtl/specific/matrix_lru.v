`timescale 1ns / 1ps
/*========================================FILE_HEADER=====================================
# Author:  Freddi Fu(fuyufei083x@163.com)
#
# Critical Timing: 2022-2023 -
#
# date: 2022-12-25 03:49
#
# Filename: matrix_lru.v
#
# Module Name: matrix_lru.v
#
# VERSION      LAST MODIFID    Instance Modules           DESCRIPTION
#   1.0       2022-12-25        none                 lru algorithm implemented by matirx scheme
#
#
=========================================FILE_HEADER====================================*/
module matrix_lru #(
//matrix size
    parameter SIZE = 8
)
(
//clk and rst signals
    input          i_clk,
	input          i_rst,
//input access vectors and the update signal
    input          i_entry_update,
	input  [2:0]   i_entry_index,
//output the signal with least recently used block information
    output [2:0]   o_lru_index
);
//reg signals for index and matrix
  reg [SIZE-1:0]   matrix [0:SIZE-1];
  reg [2:0]        lru_index;
//***********************************************************************************************
//initialization
genvar i;
generate
	for(i=0;i<=(SIZE-1);i=i+1)
	begin
		always@(posedge i_clk or negedge i_rst)
		begin
			if(i_rst==1'b0)
			begin
				lru_index <= 'd0;
				matrix[i] <= 'd0;
			end
			else
				matrix[i] <= matrix[i];
		end
	end
endgenerate
//**********************************************************************************************
genvar j,k;
generate 
	for(j=0;j<=(SIZE-1);j=j+1)
	begin
	for(k=0;k<=(SIZE-1);k=k+1)
	begin
		always@(*)
		begin
			matrix[j][k] = matrix[j][k];
			if(i_entry_update&&(j==i_entry_index)&&(k!=i_entry_index))
				matrix[j][k] = 1'b1;
			else if(i_entry_update&&(k==i_entry_index))
				matrix[j][k] = 1'b0;
		end
		end
	end
endgenerate
//***********************************************************************************************
// determine the least recently used block in formal 8 periods 
always@(*)
begin
	if(matrix[0]==8'd0)
		lru_index = 3'd0;
	else if(matrix[1]==8'd0)
		lru_index = 3'd1;
	else if(matrix[2]==8'd0)
		lru_index = 3'd2;
	else if(matrix[3]==8'd0)
		lru_index = 3'd3;
	else if(matrix[4]==8'd0)
		lru_index = 3'd4;
	else if(matrix[5]==8'd0)
		lru_index = 3'd5;
	else if(matrix[6]==8'd0)
		lru_index = 3'd6;
	else if(matrix[7]==8'd0)
		lru_index = 3'd7;
	else
		$display("there is something wrong!!!");
end
assign o_lru_index = lru_index;


endmodule

