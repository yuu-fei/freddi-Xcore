// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table implementation internals

#include "VXcore_if_mdec__Syms.h"
#include "VXcore_if_mdec.h"
#include "VXcore_if_mdec___024root.h"

// FUNCTIONS
VXcore_if_mdec__Syms::~VXcore_if_mdec__Syms()
{
}

VXcore_if_mdec__Syms::VXcore_if_mdec__Syms(VerilatedContext* contextp, const char* namep, VXcore_if_mdec* modelp)
    : VerilatedSyms{contextp}
    // Setup internal state of the Syms class
    , __Vm_modelp{modelp}
    // Setup module instances
    , TOP{this, namep}
{
    // Configure time unit / time precision
    _vm_contextp__->timeunit(-9);
    _vm_contextp__->timeprecision(-12);
    // Setup each module's pointers to their submodules
    // Setup each module's pointer back to symbol table (for public functions)
    TOP.__Vconfigure(true);
}
