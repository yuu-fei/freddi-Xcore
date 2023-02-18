// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See VXcore_if_mdec.h for the primary calling header

#include "verilated.h"

#include "VXcore_if_mdec__Syms.h"
#include "VXcore_if_mdec___024root.h"

void VXcore_if_mdec___024root___ctor_var_reset(VXcore_if_mdec___024root* vlSelf);

VXcore_if_mdec___024root::VXcore_if_mdec___024root(VXcore_if_mdec__Syms* symsp, const char* name)
    : VerilatedModule{name}
    , vlSymsp{symsp}
 {
    // Reset structure values
    VXcore_if_mdec___024root___ctor_var_reset(this);
}

void VXcore_if_mdec___024root::__Vconfigure(bool first) {
    if (false && first) {}  // Prevent unused
}

VXcore_if_mdec___024root::~VXcore_if_mdec___024root() {
}
