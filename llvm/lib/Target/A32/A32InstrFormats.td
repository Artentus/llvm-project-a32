//===-- A32InstrFormats.td - A32 Instruction Formats ---*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

// Format specifies the encoding used by the instruction. This is used by
// A32MCCodeEmitter to determine which form of fixup to use. These
// definitions must be kept in-sync with A32BaseInfo.h.
class InstFormat<bits<4> val> {
  bits<4> Value = val;
}

def InstFormatPseudo : InstFormat<0>;
def InstFormatRegReg : InstFormat<1>;
def InstFormatRegImm : InstFormat<2>;
def InstFormatUI     : InstFormat<3>;
def InstFormatBranch : InstFormat<4>;
def InstFormatOther  : InstFormat<5>;

class A32OpcodeGroup<bits<3> val> {
  bits<3> Value = val;
}

def GRP_MISC    : A32OpcodeGroup<0b000>;
def GRP_ALU_REG : A32OpcodeGroup<0b001>;
def GRP_ALU_IMM : A32OpcodeGroup<0b010>;
def GRP_LD_ST   : A32OpcodeGroup<0b011>;
def GRP_JMP_UI  : A32OpcodeGroup<0b100>;
def GRP_BRA     : A32OpcodeGroup<0b101>;
def GRP_MOV_REG : A32OpcodeGroup<0b110>;
def GRP_MOV_IMM : A32OpcodeGroup<0b111>;

class A32MiscOp<bits<2> val> {
  bits<2> Value = val;
}

def MOP_NOP  : A32MiscOp<0b00>;
def MOP_BRK  : A32MiscOp<0b01>;
def MOP_HLT  : A32MiscOp<0b10>;
def MOP_ERR  : A32MiscOp<0b11>;

class A32SysOp<bit val> {
  bit Value = val;
}

def SOP_SYS  : A32SysOp<0>;
def SOP_CLRK : A32SysOp<1>;

class A32AluOp<bits<4> val> {
    bits<4> Value = val;
}

def AOP_ADD    : A32AluOp<0b0000>;
def AOP_ADDC   : A32AluOp<0b0001>;
def AOP_SUB    : A32AluOp<0b0010>;
def AOP_SUBB   : A32AluOp<0b0011>;
def AOP_AND    : A32AluOp<0b0100>;
def AOP_OR     : A32AluOp<0b0101>;
def AOP_XOR    : A32AluOp<0b0110>;
def AOP_SHL    : A32AluOp<0b0111>;
def AOP_LSR    : A32AluOp<0b1000>;
def AOP_ASR    : A32AluOp<0b1001>;
def AOP_MUL    : A32AluOp<0b1010>;
def AOP_MULHUU : A32AluOp<0b1011>;
def AOP_MULHSS : A32AluOp<0b1100>;
def AOP_MULHSU : A32AluOp<0b1101>;
def AOP_CSUB   : A32AluOp<0b1110>;
def AOP_SLC    : A32AluOp<0b1111>;

class A32LoadStoreOp<bits<2> val> {
    bits<2> Value = val;
}

def LSOP_32 : A32LoadStoreOp<0b00>;
def LSOP_8  : A32LoadStoreOp<0b01>;
def LSOP_16 : A32LoadStoreOp<0b10>;
def LSOP_IO : A32LoadStoreOp<0b11>;

class A32UiOp<bit val> {
    bit Value = val;
}

def UIOP_LD    : A32UiOp<0>;
def UIOP_ADDPC : A32UiOp<1>;

class A32Condition<bits<4> val> {
    bits<4> Value = val;
}

def CON_FALSE : A32Condition<0b0000>;
def CON_C     : A32Condition<0b0001>;
def CON_Z     : A32Condition<0b0010>;
def CON_S     : A32Condition<0b0011>;
def CON_O     : A32Condition<0b0100>;
def CON_NC    : A32Condition<0b0101>;
def CON_NZ    : A32Condition<0b0110>;
def CON_NS    : A32Condition<0b0111>;
def CON_NO    : A32Condition<0b1000>;
def CON_U_LE  : A32Condition<0b1001>;
def CON_U_G   : A32Condition<0b1010>;
def CON_S_L   : A32Condition<0b1011>;
def CON_S_GE  : A32Condition<0b1100>;
def CON_S_LE  : A32Condition<0b1101>;
def CON_S_G   : A32Condition<0b1110>;
def CON_TRUE  : A32Condition<0b1111>;

class A32Inst<A32OpcodeGroup grp, dag outs, dag ins, string asmstr, list<dag> pattern, InstFormat format> : Instruction {
  let Namespace = "A32";
  let Size = 4;

  field bits<32> Inst;
  let Inst{2-0} = grp.Value;

  field bits<32> SoftFail = 0;

  dag OutOperandList = outs;
  dag InOperandList = ins;
  let AsmString = asmstr;
  let Pattern = pattern;
  let TSFlags{3-0} = format.Value;
}

// Pseudo instructions
class A32Pseudo<A32OpcodeGroup grp, dag outs, dag ins, list<dag> pattern>
    : A32Inst<grp, outs, ins, "", pattern, InstFormatPseudo> {
  let isPseudo = 1;
  let isCodeGenOnly = 1;
}

let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in
class A32InstMisc<A32MiscOp op, dag outs, dag ins, string asmstr>
    : A32Inst<GRP_MISC, outs, ins, asmstr, [], InstFormatOther> {
  let Inst{4-3} = op.Value;
  let Inst{5} = 0;
  let Inst{6} = 0;
  let Inst{31-7} = 0;
}

let hasSideEffects = 1, mayLoad = 0, mayStore = 0 in
class A32InstSys<A32SysOp op, dag outs, dag ins, string asmstr>
    : A32Inst<GRP_MISC, outs, ins, asmstr, [], InstFormatOther> {
  let Inst{3} = op.Value;
  let Inst{5-4} = 0;
  let Inst{6} = 1;
  let Inst{31-7} = 0;
}

let hasSideEffects = 1, mayLoad = 0, mayStore = 0, isAsCheapAsAMove = 1 in
class A32InstAluReg<A32AluOp op, bit comm, dag outs, dag ins, string asmstr>
    : A32Inst<GRP_ALU_REG, outs, ins, asmstr, [], InstFormatRegReg> {
  bits<5> rd;
  bits<5> rsl;
  bits<5> rsr;
  
  let Inst{6-3} = op.Value;
  let Inst{11-7} = rd;
  let Inst{16-12} = rsl;
  let Inst{21-17} = rsr;
  let Inst{31-22} = 0;

  let isCommutable = comm;
}

let hasSideEffects = 1, mayLoad = 0, mayStore = 0, isAsCheapAsAMove = 1 in
class A32InstAluImm<A32AluOp op, dag outs, dag ins, string asmstr>
    : A32Inst<GRP_ALU_IMM, outs, ins, asmstr, [], InstFormatRegImm> {
  bits<5> rd;
  bits<5> rsl;
  bits<15> imm15sr;
  
  let Inst{6-3} = op.Value;
  let Inst{11-7} = rd;
  let Inst{16-12} = rsl;
  let Inst{31-17} = imm15sr;
}

let hasSideEffects = 0, mayLoad = 1, mayStore = 0 in
class A32InstLoad<A32LoadStoreOp op, bit sigext, dag outs, dag ins, string asmstr>
    : A32Inst<GRP_LD_ST, outs, ins, asmstr, [], InstFormatRegImm> {
  bits<5> rd;
  bits<5> rs;
  bits<15> imm15o;
  
  let Inst{4-3} = op.Value;
  let Inst{5} = sigext;
  let Inst{6} = 0;
  let Inst{11-7} = rd;
  let Inst{16-12} = rs;
  let Inst{31-17} = imm15o;
}

let hasSideEffects = 0, mayLoad = 0, mayStore = 1 in
class A32InstStore<A32LoadStoreOp op, dag outs, dag ins, string asmstr>
    : A32Inst<GRP_LD_ST, outs, ins, asmstr, [], InstFormatRegImm> {
  bits<5> rd;
  bits<5> rs;
  bits<15> imm15o;
  
  let Inst{4-3} = op.Value;
  let Inst{5} = 0;
  let Inst{6} = 1;
  let Inst{11-7} = rd;
  let Inst{16-12} = rs;
  let Inst{31-17} = imm15o;
}

let hasSideEffects = 0, mayLoad = 0, mayStore = 0, isCall = 1 in
class A32InstJump<bit indirect, dag outs, dag ins, string asmstr>
    : A32Inst<GRP_JMP_UI, outs, ins, asmstr, [], InstFormatRegImm> {
  bits<5> rs;
  bits<15> imm15o;
  
  let Inst{3} = indirect;
  let Inst{6-4} = 0;
  let Inst{11-7} = 0;
  let Inst{16-12} = rs;
  let Inst{31-17} = imm15o;
}

let hasSideEffects = 0, mayLoad = 0, mayStore = 0, isAsCheapAsAMove = 1 in
class A32InstLink<dag outs, dag ins, string asmstr>
    : A32Inst<GRP_JMP_UI, outs, ins, asmstr, [], InstFormatRegImm> {
  bits<5> rd;
  bits<15> imm15o;
  
  let Inst{6-3} = 0b0100;
  let Inst{11-7} = rd;
  let Inst{16-12} = 0;
  let Inst{31-17} = imm15o;
}

let hasSideEffects = 0, mayLoad = 0, mayStore = 0, isAsCheapAsAMove = 1 in
class A32InstUi<A32UiOp op, dag outs, dag ins, string asmstr>
    : A32Inst<GRP_JMP_UI, outs, ins, asmstr, [], InstFormatUI> {
  bits<5> rd;
  bits<32> ui20;
  
  let Inst{3} = op.Value;
  let Inst{6-4} = 0b100;
  let Inst{11-7} = rd;
  let Inst{28-12} = ui20{30-14};
  let Inst{30-29} = ui20{13-12};
  let Inst{31} = ui20{31};
}

let hasSideEffects = 0, mayLoad = 0, mayStore = 0, isBranch = 1, isTerminator = 1 in
class A32InstBranch<A32Condition cond, dag outs, dag ins, string asmstr>
    : A32Inst<GRP_BRA, outs, ins, asmstr, [], InstFormatBranch> {
  bits<22> imm22;
  
  let Inst{6-3} = cond.Value;
  let Inst{11-7} = 0;
  let Inst{18-12} = imm22{20-14};
  let Inst{30-19} = imm22{13-2};
  let Inst{31} = imm22{21};
}

let hasSideEffects = 0, mayLoad = 0, mayStore = 0, isAsCheapAsAMove = 1 in
class A32InstMoveReg<A32Condition cond, dag outs, dag ins, string asmstr>
    : A32Inst<GRP_MOV_REG, outs, ins, asmstr, [], InstFormatRegReg> {
  bits<5> rd;
  bits<5> rsl;
  bits<5> rsr;
  
  let Inst{6-3} = cond.Value;
  let Inst{11-7} = rd;
  let Inst{16-12} = rsl;
  let Inst{21-17} = rsr;
  let Inst{31-22} = 0;
}

let hasSideEffects = 0, mayLoad = 0, mayStore = 0, isAsCheapAsAMove = 1 in
class A32InstMoveImm<A32Condition cond, dag outs, dag ins, string asmstr>
    : A32Inst<GRP_MOV_IMM, outs, ins, asmstr, [], InstFormatRegImm> {
  bits<5> rd;
  bits<5> rsl;
  bits<15> imm15sr;
  
  let Inst{6-3} = cond.Value;
  let Inst{11-7} = rd;
  let Inst{16-12} = rsl;
  let Inst{31-17} = imm15sr;
}
