/*************************************************************************
    > File Name: arbitor_sim.cpp
    > Author: Freedi Fu
    > Mail: yufei083x@gmail.com 
    > Created Time: Tue 20 Sep 2022 10:25:13 PM PDT
 ************************************************************************/

#include<iostream>
#include "verilated.h"
#include "verilated_vcd_c.h"
#include "VXcore_gnrl_arbiter1.h"
using namespace std;
//initialization
VerilatedContext* contextp = NULL;
VerilatedVcdC* tfp = NULL;
static VXcore_gnrl_arbiter1* top;
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
	top = new VXcore_gnrl_arbiter1;
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
	top->signal=0;//first give a initial value to these ports (clk and rst)
	top->scl = 0;
	//reset();
	while((!(main_time>100))&&(!Verilated::gotFinish())){ //here is the loop for simulation,it is recommended
//	to use random function to generate data signal for full test
	if(main_time<=20){
	top->signal = rand() % 15 + 1;
	top->scl = 1;
	}
	else if((20<main_time)&&(main_time < 50)){
	top->signal = rand() % 15 + 1;
    top->scl = 2;	
	}
	else if((50<=main_time)&&(main_time < 80)){
    top->signal = rand() % 15 + 1;
    top->scl = 4;   
    }
	else if((80<=main_time)&&(main_time < 100)){
	top->signal = rand() % 15+1;
	top->scl = 8;
	}
	else
	{
		top->signal=0;
        top->scl = 0;
	}
eval_and_dump_wave();
main_time++;
	}
	sim_exit();
}
