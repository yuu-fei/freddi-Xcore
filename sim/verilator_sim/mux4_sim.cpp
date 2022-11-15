/*************************************************************************
    > File Name: mux4_sim.cpp
    > Author: Freddi Fu
    > Mail: fuyufei083x@163.com 
    > Created Time: Sun 06 Nov 2022 08:01:34 PM PST
 ************************************************************************/

#include"verilated.h"
#include"verilated_vcd_c.h"
#include"VXcore_mux4.h"
//initialization
VerilatedContext* contextp = NULL;
VerilatedVcdC* tfp = NULL;
static VXcore_mux4* top;
vluint64_t main_time = 0;
//singal eval
void eval_and_dump_wave(){
	top->eval();
	contextp->timeInc(1);
	tfp->dump(main_time);
}

double sc_time(){
 return main_time;
}

void sim_init(){
	contextp = new VerilatedContext;
	tfp = new VerilatedVcdC;
	top = new VXcore_mux4;
	contextp->traceEverOn(true);
	top->trace(tfp,0);
	tfp->open("dump.vcd");
}

void sim_exit(){
	eval_and_dump_wave();
	top->final();
	tfp->close();
	delete top;
}

int main(){
	sim_init();
	top->signal0=0;
	top->signal1=0;
	top->signal2=0;
	top->signal3=0;
	while((!(main_time>50))&&(!Verilated::gotFinish())){
		if(main_time<=10){
			top->scl=1;
			top->dir_en=0;
			top->signal2=1;
		}
		else if((10<main_time)&&(main_time<=20)){
			top->scl=1;
			top->dir_en=1;
			top->signal2=0;
			top->signal3=1;
		}
		else if((20<main_time)&&(main_time<=30)){
			top->scl=1;
			top->dir_en=0;
			top->signal3=1;
		}
		else if((30<main_time)&&(main_time<=40)){
			top->scl=0;
			top->dir_en=1;
			top->signal1=1;
			top->signal3=0;
		}
		else if((40<main_time)&&(main_time<=50)){
			top->scl=0;
			top->dir_en=0;
			top->signal1=1;
			top->signal2=1;
		}
		else{
			top->scl=0;
			top->dir_en=0;
		}
		eval_and_dump_wave();
		main_time++;
	}
	sim_exit();

}
