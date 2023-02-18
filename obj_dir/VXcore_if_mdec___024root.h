// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See VXcore_if_mdec.h for the primary calling header

#ifndef VERILATED_VXCORE_IF_MDEC___024ROOT_H_
#define VERILATED_VXCORE_IF_MDEC___024ROOT_H_  // guard

#include "verilated.h"

class VXcore_if_mdec__Syms;

class VXcore_if_mdec___024root final : public VerilatedModule {
  public:

    // DESIGN SPECIFIC STATE
    VL_IN8(i_pc_instr_vld,0,0);
    VL_OUT8(o_mdec_b,0,0);
    VL_OUT8(o_mdec_jal,0,0);
    VL_OUT8(o_mdec_jalr,0,0);
    VL_OUT8(o_mdec_instr_vld,0,0);
    CData/*0:0*/ __VactContinue;
    VL_IN(i_pref_instr,31,0);
    VL_OUT(o_mdec_b_ofs,31,0);
    VL_OUT(o_mdec_jal_ofs,31,0);
    VL_OUT(o_mdec_jalr_ofs,31,0);
    IData/*31:0*/ __VstlIterCount;
    IData/*31:0*/ __VicoIterCount;
    IData/*31:0*/ __VactIterCount;
    VlTriggerVec<1> __VstlTriggered;
    VlTriggerVec<1> __VicoTriggered;
    VlTriggerVec<0> __VactTriggered;
    VlTriggerVec<0> __VnbaTriggered;

    // INTERNAL VARIABLES
    VXcore_if_mdec__Syms* const vlSymsp;

    // CONSTRUCTORS
    VXcore_if_mdec___024root(VXcore_if_mdec__Syms* symsp, const char* name);
    ~VXcore_if_mdec___024root();
    VL_UNCOPYABLE(VXcore_if_mdec___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
} VL_ATTR_ALIGNED(VL_CACHE_LINE_BYTES);


#endif  // guard
