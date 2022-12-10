/*///////////////////////////////////////////////////////////////////////////////////
> File Name: bim_sim.cpp
> Version : 1.0
> Author: Freddi Fu
> mail: fuyufei083x@163.com
///////////////////////////////////////////////////////////////////////////*/
//> Created Time: Sat 03 Dec 2022 05:03:54 AM PST
#include<iostream>
using namespace std;
#include "verilated.h"
#include "verilated_vcd_c.h"
#include "VXcore_if_bim.h"
//initialization
VerilatedContext* contextp = NULL;
VerilatedVcdC* tfp = NULL;
static VXcore_if_bim* top;
vluint64_t main_time = 0;
//single eval
void eval_and_dump_wave(){
	top->eval();
	contextp->timeInc(1);
	tfp->dump(contextp->time());
}
//single cycle of the clk:
void single_cycle() {
  top->i_sys_clk = 0; eval_and_dump_wave();
  top->i_sys_clk = 1; eval_and_dump_wave();
}
//reset_n
void reset(int n){
   top->i_sys_rst = 0;
   while(n-->0) single_cycle();
   top->i_sys_rst = 1;
}
//return time
double sc_time(){
	return main_time;
}
//sim init
void sim_init(){
	contextp = new VerilatedContext;
	tfp = new VerilatedVcdC;
	top = new VXcore_if_bim;
	contextp->traceEverOn(true);
	top->trace(tfp,0);
	tfp->open("dump.vcd");
}
//sim exit
void sim_exit(){
	eval_and_dump_wave();
	top->final();
	tfp->close();
	delete top;
}
int main(){//main simulation here
	sim_init();
	top->i_bpu_addr = 0;
	top->i_cmt_ghr = 0;
	top->i_cmt_req = 0;
	top->i_cmt_addr = 0;
	top->i_cmt_bits = 0;

	reset(10);
	while((!(main_time>100))&&(!Verilated::gotFinish())){ //here is the loop for simulation,it is recommended
//	to use random function to generate data signal for full test
	if(main_time<=50){
	//number = (rand()%(maxValue - minValue +1)) + minValue;
	top->i_bpu_addr = rand()% 1023 + 1;
	top->i_cmt_ghr = rand()% 1 + 1;
	top->i_cmt_req = 1;
	top->i_cmt_addr = rand()% 1023 + 1;
	top->i_cmt_bits = rand()% 3 + 1;
	single_cycle();
	}
	else
	{
	top->i_bpu_addr = rand()% 1023 + 1;
	top->i_cmt_ghr = rand()% 1 + 1;
	top->i_cmt_req = 0;
	top->i_cmt_addr = rand()% 1023 + 1;
	top->i_cmt_bits = rand()% 3 + 1;
	single_cycle();
	}
//eval_and_dump_wave();
main_time++;
	}
	sim_exit();
}


