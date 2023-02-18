// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Model implementation (design independent parts)

#include "VXcore_if_mdec.h"
#include "VXcore_if_mdec__Syms.h"
#include "verilated_vcd_c.h"

//============================================================
// Constructors

VXcore_if_mdec::VXcore_if_mdec(VerilatedContext* _vcontextp__, const char* _vcname__)
    : VerilatedModel{*_vcontextp__}
    , vlSymsp{new VXcore_if_mdec__Syms(contextp(), _vcname__, this)}
    , i_pc_instr_vld{vlSymsp->TOP.i_pc_instr_vld}
    , o_mdec_b{vlSymsp->TOP.o_mdec_b}
    , o_mdec_jal{vlSymsp->TOP.o_mdec_jal}
    , o_mdec_jalr{vlSymsp->TOP.o_mdec_jalr}
    , o_mdec_instr_vld{vlSymsp->TOP.o_mdec_instr_vld}
    , i_pref_instr{vlSymsp->TOP.i_pref_instr}
    , o_mdec_b_ofs{vlSymsp->TOP.o_mdec_b_ofs}
    , o_mdec_jal_ofs{vlSymsp->TOP.o_mdec_jal_ofs}
    , o_mdec_jalr_ofs{vlSymsp->TOP.o_mdec_jalr_ofs}
    , rootp{&(vlSymsp->TOP)}
{
    // Register model with the context
    contextp()->addModel(this);
}

VXcore_if_mdec::VXcore_if_mdec(const char* _vcname__)
    : VXcore_if_mdec(Verilated::threadContextp(), _vcname__)
{
}

//============================================================
// Destructor

VXcore_if_mdec::~VXcore_if_mdec() {
    delete vlSymsp;
}

//============================================================
// Evaluation function

#ifdef VL_DEBUG
void VXcore_if_mdec___024root___eval_debug_assertions(VXcore_if_mdec___024root* vlSelf);
#endif  // VL_DEBUG
void VXcore_if_mdec___024root___eval_static(VXcore_if_mdec___024root* vlSelf);
void VXcore_if_mdec___024root___eval_initial(VXcore_if_mdec___024root* vlSelf);
void VXcore_if_mdec___024root___eval_settle(VXcore_if_mdec___024root* vlSelf);
void VXcore_if_mdec___024root___eval(VXcore_if_mdec___024root* vlSelf);

void VXcore_if_mdec::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate VXcore_if_mdec::eval_step\n"); );
#ifdef VL_DEBUG
    // Debug assertions
    VXcore_if_mdec___024root___eval_debug_assertions(&(vlSymsp->TOP));
#endif  // VL_DEBUG
    vlSymsp->__Vm_activity = true;
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) {
        vlSymsp->__Vm_didInit = true;
        VL_DEBUG_IF(VL_DBG_MSGF("+ Initial\n"););
        VXcore_if_mdec___024root___eval_static(&(vlSymsp->TOP));
        VXcore_if_mdec___024root___eval_initial(&(vlSymsp->TOP));
        VXcore_if_mdec___024root___eval_settle(&(vlSymsp->TOP));
    }
    // MTask 0 start
    VL_DEBUG_IF(VL_DBG_MSGF("MTask0 starting\n"););
    Verilated::mtaskId(0);
    VL_DEBUG_IF(VL_DBG_MSGF("+ Eval\n"););
    VXcore_if_mdec___024root___eval(&(vlSymsp->TOP));
    // Evaluate cleanup
    Verilated::endOfThreadMTask(vlSymsp->__Vm_evalMsgQp);
    Verilated::endOfEval(vlSymsp->__Vm_evalMsgQp);
}

//============================================================
// Events and timing
bool VXcore_if_mdec::eventsPending() { return false; }

uint64_t VXcore_if_mdec::nextTimeSlot() {
    VL_FATAL_MT(__FILE__, __LINE__, "", "%Error: No delays in the design");
    return 0;
}

//============================================================
// Utilities

const char* VXcore_if_mdec::name() const {
    return vlSymsp->name();
}

//============================================================
// Invoke final blocks

void VXcore_if_mdec___024root___eval_final(VXcore_if_mdec___024root* vlSelf);

VL_ATTR_COLD void VXcore_if_mdec::final() {
    VXcore_if_mdec___024root___eval_final(&(vlSymsp->TOP));
}

//============================================================
// Implementations of abstract methods from VerilatedModel

const char* VXcore_if_mdec::hierName() const { return vlSymsp->name(); }
const char* VXcore_if_mdec::modelName() const { return "VXcore_if_mdec"; }
unsigned VXcore_if_mdec::threads() const { return 1; }
std::unique_ptr<VerilatedTraceConfig> VXcore_if_mdec::traceConfig() const {
    return std::unique_ptr<VerilatedTraceConfig>{new VerilatedTraceConfig{false, false, false}};
};

//============================================================
// Trace configuration

void VXcore_if_mdec___024root__trace_init_top(VXcore_if_mdec___024root* vlSelf, VerilatedVcd* tracep);

VL_ATTR_COLD static void trace_init(void* voidSelf, VerilatedVcd* tracep, uint32_t code) {
    // Callback from tracep->open()
    VXcore_if_mdec___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<VXcore_if_mdec___024root*>(voidSelf);
    VXcore_if_mdec__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    if (!vlSymsp->_vm_contextp__->calcUnusedSigs()) {
        VL_FATAL_MT(__FILE__, __LINE__, __FILE__,
            "Turning on wave traces requires Verilated::traceEverOn(true) call before time 0.");
    }
    vlSymsp->__Vm_baseCode = code;
    tracep->scopeEscape(' ');
    tracep->pushNamePrefix(std::string{vlSymsp->name()} + ' ');
    VXcore_if_mdec___024root__trace_init_top(vlSelf, tracep);
    tracep->popNamePrefix();
    tracep->scopeEscape('.');
}

VL_ATTR_COLD void VXcore_if_mdec___024root__trace_register(VXcore_if_mdec___024root* vlSelf, VerilatedVcd* tracep);

VL_ATTR_COLD void VXcore_if_mdec::trace(VerilatedVcdC* tfp, int levels, int options) {
    if (tfp->isOpen()) {
        vl_fatal(__FILE__, __LINE__, __FILE__,"'VXcore_if_mdec::trace()' shall not be called after 'VerilatedVcdC::open()'.");
    }
    if (false && levels && options) {}  // Prevent unused
    tfp->spTrace()->addModel(this);
    tfp->spTrace()->addInitCb(&trace_init, &(vlSymsp->TOP));
    VXcore_if_mdec___024root__trace_register(&(vlSymsp->TOP), tfp->spTrace());
}
