////////////////////////////////////////////////////////////////////////////////////////
//  date: 2022/9/22
//  author : YUfei Fu
//  email: yufei083X@gmail.com
//
//  this is the testbench of moudle Xcore_gnrl_arbiter1
//  ////////////////////////////////////////////////////////////////////////////////////
`timescale 1ns/10ps

module arbitor_tb();
//declearation of connecting signals
//reg clk,rst_n;
parameter SIG_NUM = 4;
parameter SCL_NUM = 4;
reg [SIG_NUM-1:0] signal;
reg [SCL_NUM-1:0] scl;
wire dout;
integer numcycles;

//module arbiter
Xcore_gnrl_arbiter1 tb(
.signal(signal),
.scl(scl),
.dout(dout)
);

//vcd file dump
initial begin
 $dumpfile("dump.vcd");        //生成的vcd文件名称
    $dumpvars(0, arbitor_tb);  //tb模块名称
end
//useful tasks
//tasks are used for clock control and reset implementation

/*task clock;
	begin
	 #9 clk = 1'b0;
	 #10 clk = 1'b1;
	 numcycles = numcycles +1;
	 #1;
 end
endtask*/

/*task step;
	input integer n;
	integer i;
	begin
		for(i=0;i<n;i=i+1)
			clock();
	end
endtask*/

/*task reset;
	begin
	rst_n = 1'b0;
	clock();
	#10 rst_n = 1'b1;
	numcycles = 0;
end
endtask*/

/*task loadtestcase;  //load intstructions to instruction mem
  begin
    $readmemh({testcase, ".hex"},instructions.ram);
    $display("---Begin test case %s-----", testcase);
  end
endtask*/

/*task check; //only reg value can be checked 
	input [4:0] regid;
	input [31:0] results;
	reg [31:0] debugdata;
	begin
		debugdata = mucpu.myregfile.regs[rigid];
		if(debugdata == results)
		begin
			$display("OK:end of cycle %d reg %h need to be %h, get %h",numcycles-1, regid,results, debugdata);
		end
		else 
		begin
			$display("!!!ERROR: end of cycle %d reg %h need to be %h, get %h", numcycles-1, regid, results, debugdata);
		end
	end
endtask*/
task run;
	begin
		signal <= 4'b0000;
		scl <= 4'b0000;
		#10 signal <= 4'b1111;
		if(dout==1'b0) begin
			$display("one round simulation passed!!!");
		end
		scl <= 4'b0001;
		#10 scl = 4'b0010;
		if(dout==1'b1) begin
			$display("one round simulation passed!!!");
		end
		#10 scl = 4'b0100;
		#10 scl = 4'b1000;
		#10 signal = 4'b0111;
		if(dout==1'b0) begin
			$display("one round simulation passed!!!");
		end
	end
endtask

//run simualtion
initial begin : testbench
	run();
	$stop;//remember to stop the whole simulation!!!
end
endmodule
