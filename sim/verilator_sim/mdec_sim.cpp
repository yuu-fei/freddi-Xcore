/*///////////////////////////////////////////////////////////////////////////////////
> File Name: mdec_sim.cpp
> Author: Freddi Fu
> mail: fuyufei083x@163.com
> Created Time: Fri 17 Feb 2023 06:22:39 PM PST
> Version : 1.0
///////////////////////////////////////////////////////////////////////////*/
#include<iostream>
using namespace std;
#include "verilated.h"
#include "verilated_vcd_c.h"
#include "VXcore_if_mdec.h"
//initialization
VerilatedContext* contextp = NULL;
VerilatedVcdC* tfp = NULL;
static VXcore_if_mdec* top;
vluint64_t main_time = 0;
//single eval
void eval_and_dump_wave(){
	top-> eval();
	contextp -> timeInc(1);
	tfp -> dump(contextp->time());
}
//signle cycle of the clk
//void single_cycle(){
//	top->i_sys_clk = 0; eval_and_dump_wave();
//	top->i_sys_clk = 1; eval_and_dump_wave();
//}
//reset_n
//void reset(int n){
//	top->i_sys_rst = 0;
//	while(n-->0) single_cycle();
//	top->i_sys_rst = 1;
//}
//return time
double sc_time(){
	return main_time;
}
//sim init
void sim_init(){
	contextp = new VerilatedContext;
	tfp = new VerilatedVcdC;
	top = new VXcore_if_mdec;
	contextp -> traceEverOn(true);
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
int main(){
	sim_init();
	top->i_pref_instr = 0;
	top->i_pc_instr_vld = 0;
	while((!(main_time>50))&&(!Verilated::gotFinish())){
		top->i_pc_instr_vld = rand()%(1 - 0 + 1) + 0;
		top->i_pref_instr = rand()%(1024 - 0 + 1) + 0;
		main_time++;
    	eval_and_dump_wave();
	}
	sim_exit();
}
