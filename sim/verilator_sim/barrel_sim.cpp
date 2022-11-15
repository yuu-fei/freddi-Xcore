/*************************************************************************
    > File Name: barrel_sim.cpp
    > Author: Freddi Fu
    > Mail: fuyufei083x@163.com 
    > Created Time: Mon 07 Nov 2022 11:34:25 PM PST
 ************************************************************************/

#include<iostream>
#include "verilated.h"
#include "verilated_vcd_c.h"
#include"VXcore_exe_barrel.h"
using namespace std;
//initialization
VerilatedContext* contextp = NULL;
VerilatedVcdC* tfp = NULL;
static VXcore_exe_barrel* top;
vluint64_t main_time = 0;
//single eval
void eval_and_dump_wave(){
	top->eval();
	contextp->timeInc(1);
	tfp->dump(main_time);
}
//single cycle of the clk
//void single_cycle() {
//  top->clk = 0; eval_and_dump_wave();
//  top->clk = 1; eval_and_dump_wave();
//}
//reset_n
//void reset(int n){
//   top->reset = 0;
//   while(n-->0) single_cycle();
//   top->reset = 1;
//}
//return time
double sc_time(){
	return main_time;
}
//sim init
void sim_init(){
	contextp = new VerilatedContext;
	tfp = new VerilatedVcdC;
	top = new VXcore_exe_barrel;
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
	top->barrel_data=0;//first give a initial value to these ports (clk and rst)
	top->a_l =1;
	top->l_r =0;
	top->shift=0;
	//reset();
	while((!(main_time>120))&&(!Verilated::gotFinish())){ //here is the loop for simulation,it is recommended
//	to use random function to generate data signal for full test
	if(main_time<=20){
	top->barrel_data =0xA00FF000;
	top->shift = 1;
	}
	else if((20<main_time)&&(main_time < 50)){
	top->barrel_data = 0x000FF000;
    top->shift = 2;
	}
	else if((50<=main_time)&&(main_time < 80)){
    top->barrel_data = 0x000FF000;
    top->shift = 4;
    }
	else if((80<=main_time)&&(main_time < 100)){
	top->barrel_data = 0x000FF000;
	top->shift = 8;
	}
	else if((100<=main_time)&&(main_time < 120)){
	top->barrel_data= 0x000FF000;
	top->shift = 16;
	}
	else
	{
		top->barrel_data = 0;
        top->shift = 0;
	}
eval_and_dump_wave();
main_time++;
	}
	sim_exit();
}
