
#set command type
VERILATOR = verilator
IVERILOG = iverilog
#set necessary parameters of commands
VERILATOR_FLAGS =  --cc --exe --trace --build  -x-assign 0 
IVERILOG_FLAGS = -o
#execute the target file
#you also need to change the obj name!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
OBJ_DIR_RUN = ./obj_dir/VXcore_gshare_bpu
#you should change above!!!
VVP = vvp -n dump -lxt2
#set the file set//here you should change the obj_dir !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#remember that all the dependencies should be concluded into the input path
VERILATOR_INPUT = ./rtl/core/Xcore_gshare_bpu.v
VERI_SIM_INPUT = ./sim/verilator_sim/gshare_sim.cpp
IVERILOG_INPUT = ./rtl/core/Xcore_gshare_bpu.v 
IVER_SIM_INPUT = ./sim/iverilog_sim/gshare_sim.v
GLOBAL = ./rtl/include/params.v
#set gtkwave to automatically open the vcd file to chexk the waveform
GTKWAVE = gtkwave
#set gtkwave file
GTKWAVE_INPUT = dump.vcd
#yosys synthesis target
YOSYSFILE = ./rtl/core/Xcore_gshare_bpu.v
MODULE = 	Xcore_gshare_bpu
#you need to change the synthesis target!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#verilator simulation
veri: run gtkwave
	#verilator simulation finished!

#iverilog simulation
iver: sim gtkwave
	#iverilog simulation finished!
.PHONY:sim
sim: 
	$(IVERILOG) $(IVERILOG_FLAGS) dump $(IVERILOG_INPUT) $(GLOBAL) $(IVER_SIM_INPUT)
	$(VVP)
run:
	$(VERILATOR) $(VERILATOR_FLAGS) $(VERILATOR_INPUT) $(GLOBAL) $(VERI_SIM_INPUT)
	$(OBJ_DIR_RUN)

.PHONY: clean
clean:
	$(shell rm -rf dump)
	$(shell rm -rf dump.vcd)
	$(shell rm -rf ./obj_dir)

gtkwave:
	@$(GTKWAVE) $(GTKWAVE_INPUT)

yosys:
	read -sv $(YOSYSFILE)
	hierarchy -top $(MODULE)
	write_ilang
	proc; opt; techmap; opt
	show
	write_verilog synth.v
	@#techmap; opt   #this is only for logic optimization
test:
	#this is a test
