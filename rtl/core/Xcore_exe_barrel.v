///////////////////////////////////////////////////////////////////////////////
//
// Copyright Freddi, UESTC 
//
///////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
//-----------------------------------------------------------------------------
//
// Project    : Xcore Barrel shifter
// File       : Xcore_exe_barrel.v
// Module     : Xcore_exe_barrel(BPU)
// Author     : Yufei Fu(fuyufei083X@gmail.com)
// Date       : 2022-9-26
// Version    : v1.0
// Description: data shifter
//				all the data we have are 32 bits
//				so we must get 32 mux a barrel and 5 barrels 
//				thus 1 2 4 8 16 and you can array them to get data shift from
//				1 - 31
//              
// ----------------------------------------------------------------------------
`include "./rtl/include/params.v"

module Xcore_exe_barrel(
//data input

	input [`WIDTH]  barrel_data,
//control signals

	input		 a_l,//0 is a and 1 is l
	input           l_r, //0 is right and 1 is left
	input [4:0]     shift,
//output data
	
	output [`WIDTH] barrel_dout
);
wire			 data_msb;
wire [31:0]             dout1;
wire [31:0]             dout2;
wire [31:0] 		 dout3;
wire [31:0] 		 dout4;
//set msb depend on a_l 
//assign  data_msb = (a_l==1'b1) ? 1'b0 : barrel_data[31]; 

genvar i;
//first stage
generate 
	for(i=0;i<32;i=i+1) begin: first_stage
		if(i==0) begin
			Xcore_mux4 mux(barrel_data[i],barrel_data[i+1],barrel_data[i],0,l_r,shift[0],dout1[i]);
		end
		else if(i==31) begin
			Xcore_mux4 mux(barrel_data[i],data_msb,barrel_data[i],barrel_data[i-1],l_r,shift[0],dout1[i]);
		end
		else begin
		Xcore_mux4 mux(barrel_data[i],barrel_data[i+1],barrel_data[i],barrel_data[i-1],l_r,shift[0],dout1[i]);
		end
	end
endgenerate

//second stage
genvar j;
generate 
	for(j=0;j<32;j=j+1) begin: second_stage
		if(j==0|j==1) begin
			Xcore_mux4 mux(dout1[j],dout1[j+2],dout1[j],0,l_r,shift[1],dout2[j]);
		end
		else if(j==31|j==30) begin
			Xcore_mux4 mux(dout1[j],data_msb,dout1[j],dout1[j-2],l_r,shift[1],dout2[j]);
		end
		else begin
		Xcore_mux4 mux(dout1[j],dout1[j+2],dout1[j],dout1[j-2],l_r,shift[1],dout2[j]);
		end
	end
endgenerate

//third stage
genvar k;
generate 
	for(k=0;k<32;k=k+1) begin: third_stage
		if(k==0|k==1|k==2|k==3) begin
			Xcore_mux4 mux(dout2[k],dout2[k+4],dout2[k],0,l_r,shift[2],dout3[k]);
		end
		else if(k==31|k==30|k==29|k==28) begin
			Xcore_mux4 mux(dout2[k],data_msb,dout2[k],dout2[k-4],l_r,shift[2],dout3[k]);
		end
		else begin
		Xcore_mux4 mux(dout2[k],dout2[k+4],dout2[k],dout2[k-4],l_r,shift[2],dout3[k]);
		end
	end
endgenerate

//forth stage
genvar l;
generate 
	for(l=0;l<32;l=l+1) begin: forth_stage
		if(l<8) begin
			Xcore_mux4 mux(dout3[l],dout3[l+8],dout3[l],0,l_r,shift[3],dout4[l]);
		end
		else if(l>23) begin
			Xcore_mux4 mux(dout3[l],data_msb,dout3[l],dout3[l-8],l_r,shift[3],dout4[l]);
		end
		else begin
		Xcore_mux4 mux(dout3[l],dout3[l+8],dout3[l],dout3[l-8],l_r,shift[3],dout4[l]);
		end
	end
endgenerate

//fifth stage
genvar m;
generate
	for(m=0;m<32;m=m+1) begin: fifth_stage
		if(m<16) begin
			Xcore_mux4 mux(dout4[m],dout4[m+16],dout4[m],0,l_r,shift[4],barrel_dout[m]);
		end
		else begin
			Xcore_mux4 mux(dout4[m],data_msb,dout4[m],dout4[m-16],l_r,shift[4],barrel_dout[m]);
		end
		
	end
endgenerate
assign  data_msb = (a_l==1'b1) ? 1'b0 : barrel_data[31]; 
endmodule
