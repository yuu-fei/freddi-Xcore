//copyright 2022-2023 Yufei FU(Freedi),UESTC
//
//github"git@github.com:yuu-fei/freddi-Xcore.git"
////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps
//------------------------------------------------------------------
//
//project : Freedi_Xcore CPU
//module : Xcore_gnrl_ramdp_nr.v
//
//author : Yufei Fu
//data : 2022/9/29
//version : 1.0
//
//description: this is the general double port ram with write enable chip scl
//and no reset signal
//
//------------------------------------------------------------------

module Xcore_gnrl_ramdp_nr #(
	parameter DL = 4,
	parameter DW = 3,
	parameter AW = 2,
	parameter FORCE_ZERO = 0
)(
	input			clk,
	input [DW-1:0]  din,
	input [AW-1:0]	raddr,
	input [AW-1:0]	waddr,
	input			we,
	input			cs,

	output [DW-1:0] dout
);

//initial ram size
	reg [DW-1:0] ram_r [0:DL-1]; //data length is defined in front of and number of data is defined behind
	reg [AW-1:0] addr_r;
	wire wen,ren;

	assign wen = we&cs;
	assign ren = cs;

	always@(*) begin
		if(ren) begin
			addr_r <= raddr;
		end
	end

	always@(posedge clk) begin
		if(wen) 
			ram_r[waddr] <= din;
	end
	
	wire [DW-1:0] dout_w;
	assign dout_w = ram_r[addr_r];

	genvar i;
	generate 
		if(FORCE_ZERO == 1) begin: force_x_to_zero
            for (i = 0; i < DW; i = i+1) begin:force_x_gen 
                assign dout[i] = (dout_w[i] === 1'bx) ? 1'b0 : dout_w[i];
            end
        end
        else begin:no_force_x_to_zero
            assign dout = dout_w;
		end
	endgenerate
	endmodule

