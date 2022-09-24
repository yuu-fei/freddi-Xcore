
#set command type
VERILATOR = verilator
IVERILOG = iverilog
#set necessary parameters of commands
VERILATOR_FLAGS = -Wall --cc --exe --trace --build -Os -x-assign 0
IVERILOG_FLAGS = -o
#execute the target file
OBJ_DIR_RUN = ./obj_dir/VXcore_bpu 
#you should change above!!!
VVP = vvp -n dump -lxt2
#set the file set//here you should change the obj_dir !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
VERILATOR_INPUT = ./rtl/core/Xcore_bpu.v ./sim/verilator_sim/bpu_sim.cpp
IVERILOG_INPUT = ./rtl/general/Xcore_gnrl_arbiter1.v ./sim/iverilog_sim/arbitor_sim.v
#set gtkwave to automatically open the vcd file to chexk the waveform
GTKWAVE = gtkwave
#set gtkwave file
GTKWAVE_INPUT = dump.vcd
#verilator simulation
veri: run gtkwave
	#verilator simulation finished!

#iverilog simulation
iver: sim gtkwave
	#iverilog simulation finished!
.PHONY:sim
sim: 
	$(IVERILOG) $(IVERILOG_FLAGS) dump $(IVERILOG_INPUT)
	$(VVP)
run:
	$(VERILATOR) $(VERILATOR_FLAGS) $(VERILATOR_INPUT)
	$(OBJ_DIR_RUN)

.PHONY: clean
clean:
	$(shell rm -rf dump)
	$(shell rm -rf dump.vcd)
	$(shell rm -rf ./obj_dir)

gtkwave:
	@$(GTKWAVE) $(GTKWAVE_INPUT)

test:
	#this is a test
