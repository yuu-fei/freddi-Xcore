///////////////////////////////////////////////////////////////////////////////
//
// Copyright Freddi, UESTC 
//
///////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
//-----------------------------------------------------------------------------
//
// Project    : Alrithmatic Logic unit 
// File       : Xcore_exe_alu.v
// Module     : Xcore_exe_alu(alu)
// Author     : Yufei Fu(fuyufei083X@gmail.com)
// Date       : 2022-9-27
// Version    : v1.0
// Description:		Alrithmatic Logic Unit of Xcore
//					functions:
//					add and sub
//					shift logically/algorithmically left/right
//					compare two input data (imme data)
//					and or xor 
//					all the computing are down in combinational circuit and 
//					the reuired results will be selected by MUX8
// ----------------------------------------------------------------------------

`include "./rtl/include/params.v"

module Xcore_exe_alu(
//alu control input 
//the alu contrl unit is in CPU_ctrol unit
 input [2:0]    aluctrl,   //control mux output
 input		    a_l,
 input		    l_r,
 input		    u_s,
 input		    sub_add,

//data input 
 input [`WIDTH]  data_a,
 input [`WIDTH]  data_b,

//output 
 output [`WIDTH] alu_out,
//output state signals
 output			 less,
 output [`WIDTH]			 zero //whether the two data are equal
);
wire [31:0] adder; // data from add/sub
wire [31:0] shift; // data from barrel shift
wire [31:0] slt;   // data from smaller data in data a and b
wire [31:0] b;     // data from the second datapath 
wire [31:0] Xor;   // data from xor 
wire [31:0] And;   // data from and
wire [31:0] Or;    // data from or
// excess path ignore 
wire carry, overflow;
//set operation to each wire 

Xcore_exe_barrel barrel(
.barrel_data(data_a),
.a_l(a_l),
.l_r(l_r),
.shift(data_b[4:0]),
.barrel_dout(shift)
);
//adder 
wire [31:0] op_b;
//^({32{sub_add}})
assign op_b = {data_b^{32{sub_add}}} + {31'b0,sub_add};
assign {overflow,adder} = {1'b0,data_a} + {1'b0,op_b}; //0 is add and 1 is sub
assign carry = ((!adder[31])&(data_b[31]^data_a[31]))|((!data_a[31])&(!data_b[31])&(adder[31]))|(data_a[31]&data_b[31]&adder[31]); 
assign zero = data_a - data_b;

//logic operation
assign Xor = data_a^data_b;
assign And = data_a&data_b;
assign Or = data_a|data_b;
assign less = (u_s==1'b1) ? u_s^carry : overflow^adder[31];
assign slt = {31'd0,less};

assign b = data_b;
assign alu_out = (aluctrl==3'b000) ? adder : 
	(aluctrl==3'b001) ? shift :
	(aluctrl==3'b010) ? slt :
	(aluctrl==3'b011) ? b :
	(aluctrl==3'b100) ? Xor :
	(aluctrl==3'b101) ? And :
	(aluctrl==3'b110) ? Or :
	(aluctrl==3'b111) ? shift : 'd0;

endmodule
