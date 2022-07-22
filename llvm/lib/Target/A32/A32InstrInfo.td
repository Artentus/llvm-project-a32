//===-- A32InstrInfo.td - Target Description for A32 ---*- tablegen -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file describes the A32 instructions in TableGen format.
//
//===----------------------------------------------------------------------===//

include "A32InstrFormats.td"

//===----------------------------------------------------------------------===//
// Operand and SDNode transformation definitions.
//===----------------------------------------------------------------------===//

class ImmAsmOperand<int width> : AsmOperandClass {
  let Name = "Imm" # width;
  let RenderMethod = "addImmOperands";
  let DiagnosticType = !strconcat("Invalid", Name);
}

class UIAsmOperand<int width> : AsmOperandClass {
  let Name = "UI" # width;
  let RenderMethod = "addImmOperands";
  let DiagnosticType = !strconcat("Invalid", Name);
}

def imm15 : Operand<i32> {
  let ParserMatchClass = ImmAsmOperand<15>;
  let EncoderMethod = "getImmOpValue";
  let DecoderMethod = "decodeImmOperand<15>";
  let MCOperandPredicate = [{
    int64_t Imm;
    if (MCOp.evaluateAsConstantImm(Imm))
      return isInt<15>(Imm);
    return MCOp.isBareSymbolRef();
  }];
  //let OperandType = "OPERAND_IMM15";
  //let OperandNamespace = "A32Op";
}

// A 22-bit signed immediate where the two least significant bits are zero.
def imm22 : Operand<i32> {
  let ParserMatchClass = ImmAsmOperand<22>;
  let EncoderMethod = "getImmOpValue";
  let DecoderMethod = "decodeImmOperand<22>";
  let PrintMethod = "printPcRelOperand";
  let MCOperandPredicate = [{
    int64_t Imm;
    if (MCOp.evaluateAsConstantImm(Imm))
      return isShiftedInt<20, 2>(Imm);
    return MCOp.isBareSymbolRef();
  }];
  let OperandType = "OPERAND_PCREL";
}

def ui20 : Operand<i32> {
  let ParserMatchClass = UIAsmOperand<20>;
  let EncoderMethod = "getImmOpValue";
  let DecoderMethod = "decodeImmOperand<32>";
  let MCOperandPredicate = [{
    int64_t Imm;
    if (MCOp.evaluateAsConstantImm(Imm))
      return isShiftedInt<20, 12>(Imm);
    return MCOp.isBareSymbolRef();
  }];
  //let OperandType = "OPERAND_UI20";
  //let OperandNamespace = "A32Op";
}

//===----------------------------------------------------------------------===//
// Instructions
//===----------------------------------------------------------------------===//

def NOP : A32InstMisc<MOP_NOP, (outs), (ins), "nop">;
def BRK : A32InstMisc<MOP_BRK, (outs), (ins), "brk">;
def HLT : A32InstMisc<MOP_HLT, (outs), (ins), "hlt">;
def ERR : A32InstMisc<MOP_ERR, (outs), (ins), "err">;

def SYS  : A32InstSys<SOP_SYS,  (outs), (ins), "sys" >;
def CLRK : A32InstSys<SOP_CLRK, (outs), (ins), "clrk">;

def ADD    : A32InstAluReg<AOP_ADD   , 1, (outs GPR:$rd), (ins GPR:$rsl, GPR:$rsr), "add    $rd, $rsl, $rsr">;
def ADDC   : A32InstAluReg<AOP_ADDC  , 0, (outs GPR:$rd), (ins GPR:$rsl, GPR:$rsr), "addc   $rd, $rsl, $rsr">;
def SUB    : A32InstAluReg<AOP_SUB   , 0, (outs GPR:$rd), (ins GPR:$rsl, GPR:$rsr), "sub    $rd, $rsl, $rsr">;
def SUBB   : A32InstAluReg<AOP_SUBB  , 0, (outs GPR:$rd), (ins GPR:$rsl, GPR:$rsr), "subb   $rd, $rsl, $rsr">;
def AND    : A32InstAluReg<AOP_AND   , 1, (outs GPR:$rd), (ins GPR:$rsl, GPR:$rsr), "and    $rd, $rsl, $rsr">;
def OR     : A32InstAluReg<AOP_OR    , 1, (outs GPR:$rd), (ins GPR:$rsl, GPR:$rsr), "or     $rd, $rsl, $rsr">;
def XOR    : A32InstAluReg<AOP_XOR   , 1, (outs GPR:$rd), (ins GPR:$rsl, GPR:$rsr), "xor    $rd, $rsl, $rsr">;
def SHL    : A32InstAluReg<AOP_SHL   , 0, (outs GPR:$rd), (ins GPR:$rsl, GPR:$rsr), "shl    $rd, $rsl, $rsr">;
def LSR    : A32InstAluReg<AOP_LSR   , 0, (outs GPR:$rd), (ins GPR:$rsl, GPR:$rsr), "lsr    $rd, $rsl, $rsr">;
def ASR    : A32InstAluReg<AOP_ASR   , 0, (outs GPR:$rd), (ins GPR:$rsl, GPR:$rsr), "asr    $rd, $rsl, $rsr">;
def MUL    : A32InstAluReg<AOP_MUL   , 1, (outs GPR:$rd), (ins GPR:$rsl, GPR:$rsr), "mul    $rd, $rsl, $rsr">;
def MULHUU : A32InstAluReg<AOP_MULHUU, 0, (outs GPR:$rd), (ins GPR:$rsl, GPR:$rsr), "mulhuu $rd, $rsl, $rsr">;
def MULHSS : A32InstAluReg<AOP_MULHSS, 0, (outs GPR:$rd), (ins GPR:$rsl, GPR:$rsr), "mulhss $rd, $rsl, $rsr">;
def MULHSU : A32InstAluReg<AOP_MULHSU, 0, (outs GPR:$rd), (ins GPR:$rsl, GPR:$rsr), "mulhsu $rd, $rsl, $rsr">;
def CSUB   : A32InstAluReg<AOP_CSUB  , 0, (outs GPR:$rd), (ins GPR:$rsl, GPR:$rsr), "csub   $rd, $rsl, $rsr">;
def SLC    : A32InstAluReg<AOP_SLC   , 0, (outs GPR:$rd), (ins GPR:$rsl),           "slc    $rd, $rsl"      >;

def IADD    : A32InstAluImm<AOP_ADD   , (outs GPR:$rd), (ins GPR:$rsl, imm15:$imm15sr), "add    $rd, $rsl, $imm15sr">;
def IADDC   : A32InstAluImm<AOP_ADDC  , (outs GPR:$rd), (ins GPR:$rsl, imm15:$imm15sr), "addc   $rd, $rsl, $imm15sr">;
def ISUB    : A32InstAluImm<AOP_SUB   , (outs GPR:$rd), (ins GPR:$rsl, imm15:$imm15sr), "sub    $rd, $rsl, $imm15sr">;
def ISUBB   : A32InstAluImm<AOP_SUBB  , (outs GPR:$rd), (ins GPR:$rsl, imm15:$imm15sr), "subb   $rd, $rsl, $imm15sr">;
def IAND    : A32InstAluImm<AOP_AND   , (outs GPR:$rd), (ins GPR:$rsl, imm15:$imm15sr), "and    $rd, $rsl, $imm15sr">;
def IOR     : A32InstAluImm<AOP_OR    , (outs GPR:$rd), (ins GPR:$rsl, imm15:$imm15sr), "or     $rd, $rsl, $imm15sr">;
def IXOR    : A32InstAluImm<AOP_XOR   , (outs GPR:$rd), (ins GPR:$rsl, imm15:$imm15sr), "xor    $rd, $rsl, $imm15sr">;
def ISHL    : A32InstAluImm<AOP_SHL   , (outs GPR:$rd), (ins GPR:$rsl, imm15:$imm15sr), "shl    $rd, $rsl, $imm15sr">;
def ILSR    : A32InstAluImm<AOP_LSR   , (outs GPR:$rd), (ins GPR:$rsl, imm15:$imm15sr), "lsr    $rd, $rsl, $imm15sr">;
def IASR    : A32InstAluImm<AOP_ASR   , (outs GPR:$rd), (ins GPR:$rsl, imm15:$imm15sr), "asr    $rd, $rsl, $imm15sr">;
def IMUL    : A32InstAluImm<AOP_MUL   , (outs GPR:$rd), (ins GPR:$rsl, imm15:$imm15sr), "mul    $rd, $rsl, $imm15sr">;
def IMULHUU : A32InstAluImm<AOP_MULHUU, (outs GPR:$rd), (ins GPR:$rsl, imm15:$imm15sr), "mulhuu $rd, $rsl, $imm15sr">;
def IMULHSS : A32InstAluImm<AOP_MULHSS, (outs GPR:$rd), (ins GPR:$rsl, imm15:$imm15sr), "mulhss $rd, $rsl, $imm15sr">;
def IMULHSU : A32InstAluImm<AOP_MULHSU, (outs GPR:$rd), (ins GPR:$rsl, imm15:$imm15sr), "mulhsu $rd, $rsl, $imm15sr">;
def ICSUB   : A32InstAluImm<AOP_CSUB  , (outs GPR:$rd), (ins GPR:$rsl, imm15:$imm15sr), "csub   $rd, $rsl, $imm15sr">;

def LD    : A32InstLoad<LSOP_32, 0, (outs GPR:$rd), (ins GPR:$rs, imm15:$imm15o), "ld    $rd, [$rs, $imm15o]">;
def LD8   : A32InstLoad<LSOP_8 , 0, (outs GPR:$rd), (ins GPR:$rs, imm15:$imm15o), "ld8   $rd, [$rs, $imm15o]">;
def LD8S  : A32InstLoad<LSOP_8 , 1, (outs GPR:$rd), (ins GPR:$rs, imm15:$imm15o), "ld8s  $rd, [$rs, $imm15o]">;
def LD16  : A32InstLoad<LSOP_16, 0, (outs GPR:$rd), (ins GPR:$rs, imm15:$imm15o), "ld16  $rd, [$rs, $imm15o]">;
def LD16S : A32InstLoad<LSOP_16, 1, (outs GPR:$rd), (ins GPR:$rs, imm15:$imm15o), "ld16s $rd, [$rs, $imm15o]">;
def IN    : A32InstLoad<LSOP_IO, 0, (outs GPR:$rd), (ins GPR:$rs, imm15:$imm15o), "in    $rd, [$rs, $imm15o]">;

def ST   : A32InstStore<LSOP_32, (outs), (ins GPR:$rd, GPR:$rs, imm15:$imm15o), "st   [$rd, $imm15o], $rs">;
def ST8  : A32InstStore<LSOP_8 , (outs), (ins GPR:$rd, GPR:$rs, imm15:$imm15o), "st8  [$rd, $imm15o], $rs">;
def ST16 : A32InstStore<LSOP_16, (outs), (ins GPR:$rd, GPR:$rs, imm15:$imm15o), "st16 [$rd, $imm15o], $rs">;
def OUT  : A32InstStore<LSOP_IO, (outs), (ins GPR:$rd, GPR:$rs, imm15:$imm15o), "out  [$rd, $imm15o], $rs">;

def JMP     : A32InstJump<0, (outs), (ins GPR:$rs, imm15:$imm15o), "jmp $rs, $imm15o"  >;
def JMP_IND : A32InstJump<1, (outs), (ins GPR:$rs, imm15:$imm15o), "jmp [$rs, $imm15o]">;

def LINK : A32InstLink<(outs GPR:$rd), (ins imm15:$imm15o), "link $rd, $imm15o">;

def LDUI    : A32InstUi<UIOP_LD,    (outs GPR:$rd), (ins ui20:$ui20), "ldui    $rd, $ui20">;
def ADDPCUI : A32InstUi<UIOP_ADDPC, (outs GPR:$rd), (ins ui20:$ui20), "addpcui $rd, $ui20">;

def BR_C    : A32InstBranch<CON_C   , (outs), (ins imm22:$imm22), "br.c    $imm22">;
def BR_Z    : A32InstBranch<CON_Z   , (outs), (ins imm22:$imm22), "br.z    $imm22">;
def BR_S    : A32InstBranch<CON_S   , (outs), (ins imm22:$imm22), "br.s    $imm22">;
def BR_O    : A32InstBranch<CON_O   , (outs), (ins imm22:$imm22), "br.o    $imm22">;
def BR_NC   : A32InstBranch<CON_NC  , (outs), (ins imm22:$imm22), "br.nc   $imm22">;
def BR_NZ   : A32InstBranch<CON_NZ  , (outs), (ins imm22:$imm22), "br.nz   $imm22">;
def BR_NS   : A32InstBranch<CON_NS  , (outs), (ins imm22:$imm22), "br.ns   $imm22">;
def BR_NO   : A32InstBranch<CON_NO  , (outs), (ins imm22:$imm22), "br.no   $imm22">;
def BR_U_LE : A32InstBranch<CON_U_LE, (outs), (ins imm22:$imm22), "br.u.le $imm22">;
def BR_U_G  : A32InstBranch<CON_U_G , (outs), (ins imm22:$imm22), "br.u.g  $imm22">;
def BR_S_L  : A32InstBranch<CON_S_L , (outs), (ins imm22:$imm22), "br.s.l  $imm22">;
def BR_S_GE : A32InstBranch<CON_S_GE, (outs), (ins imm22:$imm22), "br.s.ge $imm22">;
def BR_S_LE : A32InstBranch<CON_S_LE, (outs), (ins imm22:$imm22), "br.s.le $imm22">;
def BR_S_G  : A32InstBranch<CON_S_G , (outs), (ins imm22:$imm22), "br.s.g  $imm22">;

let isBranch = 0, isTerminator = 0, isCall = 1 in
def JR : A32InstBranch<CON_TRUE, (outs), (ins imm22:$imm22), "jr $imm22">;

def MV_C    : A32InstMoveReg<CON_C   , (outs GPR:$rd), (ins GPR:$rsl, GPR:$rsr), "mv.c    $rd, $rsl, $rsr">;
def MV_Z    : A32InstMoveReg<CON_Z   , (outs GPR:$rd), (ins GPR:$rsl, GPR:$rsr), "mv.z    $rd, $rsl, $rsr">;
def MV_S    : A32InstMoveReg<CON_S   , (outs GPR:$rd), (ins GPR:$rsl, GPR:$rsr), "mv.s    $rd, $rsl, $rsr">;
def MV_O    : A32InstMoveReg<CON_O   , (outs GPR:$rd), (ins GPR:$rsl, GPR:$rsr), "mv.o    $rd, $rsl, $rsr">;
def MV_NC   : A32InstMoveReg<CON_NC  , (outs GPR:$rd), (ins GPR:$rsl, GPR:$rsr), "mv.nc   $rd, $rsl, $rsr">;
def MV_NZ   : A32InstMoveReg<CON_NZ  , (outs GPR:$rd), (ins GPR:$rsl, GPR:$rsr), "mv.nz   $rd, $rsl, $rsr">;
def MV_NS   : A32InstMoveReg<CON_NS  , (outs GPR:$rd), (ins GPR:$rsl, GPR:$rsr), "mv.ns   $rd, $rsl, $rsr">;
def MV_NO   : A32InstMoveReg<CON_NO  , (outs GPR:$rd), (ins GPR:$rsl, GPR:$rsr), "mv.no   $rd, $rsl, $rsr">;
def MV_U_LE : A32InstMoveReg<CON_U_LE, (outs GPR:$rd), (ins GPR:$rsl, GPR:$rsr), "mv.u.le $rd, $rsl, $rsr">;
def MV_U_G  : A32InstMoveReg<CON_U_G , (outs GPR:$rd), (ins GPR:$rsl, GPR:$rsr), "mv.u.g  $rd, $rsl, $rsr">;
def MV_S_L  : A32InstMoveReg<CON_S_L , (outs GPR:$rd), (ins GPR:$rsl, GPR:$rsr), "mv.s.l  $rd, $rsl, $rsr">;
def MV_S_GE : A32InstMoveReg<CON_S_GE, (outs GPR:$rd), (ins GPR:$rsl, GPR:$rsr), "mv.s.ge $rd, $rsl, $rsr">;
def MV_S_LE : A32InstMoveReg<CON_S_LE, (outs GPR:$rd), (ins GPR:$rsl, GPR:$rsr), "mv.s.le $rd, $rsl, $rsr">;
def MV_S_G  : A32InstMoveReg<CON_S_G , (outs GPR:$rd), (ins GPR:$rsl, GPR:$rsr), "mv.s.g  $rd, $rsl, $rsr">;

let isMoveReg = 1 in
def MOV : A32InstMoveReg<CON_TRUE, (outs GPR:$rd), (ins GPR:$rsl, GPR:$rsr), "mov $rd, $rsl, $rsr">;

def IMV_C    : A32InstMoveImm<CON_C   , (outs GPR:$rd), (ins GPR:$rsl, imm15:$imm15sr), "mv.c    $rd, $rsl, $imm15sr">;
def IMV_Z    : A32InstMoveImm<CON_Z   , (outs GPR:$rd), (ins GPR:$rsl, imm15:$imm15sr), "mv.z    $rd, $rsl, $imm15sr">;
def IMV_S    : A32InstMoveImm<CON_S   , (outs GPR:$rd), (ins GPR:$rsl, imm15:$imm15sr), "mv.s    $rd, $rsl, $imm15sr">;
def IMV_O    : A32InstMoveImm<CON_O   , (outs GPR:$rd), (ins GPR:$rsl, imm15:$imm15sr), "mv.o    $rd, $rsl, $imm15sr">;
def IMV_NC   : A32InstMoveImm<CON_NC  , (outs GPR:$rd), (ins GPR:$rsl, imm15:$imm15sr), "mv.nc   $rd, $rsl, $imm15sr">;
def IMV_NZ   : A32InstMoveImm<CON_NZ  , (outs GPR:$rd), (ins GPR:$rsl, imm15:$imm15sr), "mv.nz   $rd, $rsl, $imm15sr">;
def IMV_NS   : A32InstMoveImm<CON_NS  , (outs GPR:$rd), (ins GPR:$rsl, imm15:$imm15sr), "mv.ns   $rd, $rsl, $imm15sr">;
def IMV_NO   : A32InstMoveImm<CON_NO  , (outs GPR:$rd), (ins GPR:$rsl, imm15:$imm15sr), "mv.no   $rd, $rsl, $imm15sr">;
def IMV_U_LE : A32InstMoveImm<CON_U_LE, (outs GPR:$rd), (ins GPR:$rsl, imm15:$imm15sr), "mv.u.le $rd, $rsl, $imm15sr">;
def IMV_U_G  : A32InstMoveImm<CON_U_G , (outs GPR:$rd), (ins GPR:$rsl, imm15:$imm15sr), "mv.u.g  $rd, $rsl, $imm15sr">;
def IMV_S_L  : A32InstMoveImm<CON_S_L , (outs GPR:$rd), (ins GPR:$rsl, imm15:$imm15sr), "mv.s.l  $rd, $rsl, $imm15sr">;
def IMV_S_GE : A32InstMoveImm<CON_S_GE, (outs GPR:$rd), (ins GPR:$rsl, imm15:$imm15sr), "mv.s.ge $rd, $rsl, $imm15sr">;
def IMV_S_LE : A32InstMoveImm<CON_S_LE, (outs GPR:$rd), (ins GPR:$rsl, imm15:$imm15sr), "mv.s.le $rd, $rsl, $imm15sr">;
def IMV_S_G  : A32InstMoveImm<CON_S_G , (outs GPR:$rd), (ins GPR:$rsl, imm15:$imm15sr), "mv.s.g  $rd, $rsl, $imm15sr">;

let isMoveImm = 1 in
def LDI : A32InstMoveImm<CON_TRUE, (outs GPR:$rd), (ins GPR:$rsl, imm15:$imm15sr), "ldi $rd, $rsl, $imm15sr">;

//===----------------------------------------------------------------------===//
// Assembler Pseudo Instructions
//===----------------------------------------------------------------------===//

def : InstAlias<"cmp  $rsl, $rsr",     (SUB  R0, GPR:$rsl, GPR:$rsr      )>;
def : InstAlias<"cmp  $rsl, $imm15sr", (ISUB R0, GPR:$rsl, imm15:$imm15sr)>;
def : InstAlias<"bit  $rsl, $rsr",     (AND  R0, GPR:$rsl, GPR:$rsr      )>;
def : InstAlias<"bit  $rsl, $imm15sr", (IAND R0, GPR:$rsl, imm15:$imm15sr)>;
def : InstAlias<"test $rs",            (OR   R0, GPR:$rs,  R0            )>;

def : InstAlias<"inc  $rd", (IADD  GPR:$rd, GPR:$rd, 1)>;
def : InstAlias<"incc $rd", (IADDC GPR:$rd, GPR:$rd, 0)>;
def : InstAlias<"dec  $rd", (ISUB  GPR:$rd, GPR:$rd, 1)>;
def : InstAlias<"decb $rd", (ISUBB GPR:$rd, GPR:$rd, 0)>;

def : InstAlias<"neg  $rd, $rs", (SUB  GPR:$rd, R0, GPR:$rs)>;
def : InstAlias<"negb $rd, $rs", (SUBB GPR:$rd, R0, GPR:$rs)>;
def : InstAlias<"not  $rd, $rs", (IXOR GPR:$rd, GPR:$rs, -1)>;

def : InstAlias<"ld    $rd, [$rs]", (LD    GPR:$rd, GPR:$rs, 0)>;
def : InstAlias<"ld8   $rd, [$rs]", (LD8   GPR:$rd, GPR:$rs, 0)>;
def : InstAlias<"ld8s  $rd, [$rs]", (LD8S  GPR:$rd, GPR:$rs, 0)>;
def : InstAlias<"ld16  $rd, [$rs]", (LD16  GPR:$rd, GPR:$rs, 0)>;
def : InstAlias<"ld16s $rd, [$rs]", (LD16S GPR:$rd, GPR:$rs, 0)>;
def : InstAlias<"in    $rd, [$rs]", (IN    GPR:$rd, GPR:$rs, 0)>;

def : InstAlias<"ld    $rd, [$imm15o]", (LD    GPR:$rd, R0, imm15:$imm15o)>;
def : InstAlias<"ld8   $rd, [$imm15o]", (LD8   GPR:$rd, R0, imm15:$imm15o)>;
def : InstAlias<"ld8s  $rd, [$imm15o]", (LD8S  GPR:$rd, R0, imm15:$imm15o)>;
def : InstAlias<"ld16  $rd, [$imm15o]", (LD16  GPR:$rd, R0, imm15:$imm15o)>;
def : InstAlias<"ld16s $rd, [$imm15o]", (LD16S GPR:$rd, R0, imm15:$imm15o)>;
def : InstAlias<"in    $rd, [$imm15o]", (IN    GPR:$rd, R0, imm15:$imm15o)>;

def : InstAlias<"st   [$rd], $rs", (ST   GPR:$rd, GPR:$rs, 0)>;
def : InstAlias<"st8  [$rd], $rs", (ST8  GPR:$rd, GPR:$rs, 0)>;
def : InstAlias<"st16 [$rd], $rs", (ST16 GPR:$rd, GPR:$rs, 0)>;
def : InstAlias<"out  [$rd], $rs", (OUT  GPR:$rd, GPR:$rs, 0)>;

def : InstAlias<"st   [$imm15o], $rs", (ST   R0, GPR:$rs, imm15:$imm15o)>;
def : InstAlias<"st8  [$imm15o], $rs", (ST8  R0, GPR:$rs, imm15:$imm15o)>;
def : InstAlias<"st16 [$imm15o], $rs", (ST16 R0, GPR:$rs, imm15:$imm15o)>;
def : InstAlias<"out  [$imm15o], $rs", (OUT  R0, GPR:$rs, imm15:$imm15o)>;

def : InstAlias<"jmp $rs"      , (JMP     GPR:$rs, 0)       >;
def : InstAlias<"jmp [$rs]"    , (JMP_IND GPR:$rs, 0)       >;
def : InstAlias<"jmp [$imm15o]", (JMP_IND R0, imm15:$imm15o)>;

def : InstAlias<"br.eq   $imm22", (BR_Z  imm22:$imm22)>;
def : InstAlias<"br.neq  $imm22", (BR_NZ imm22:$imm22)>;
def : InstAlias<"br.u.l  $imm22", (BR_NC imm22:$imm22)>;
def : InstAlias<"br.u.ge $imm22", (BR_C  imm22:$imm22)>;

def : InstAlias<"mv.eq   $rd, $rsl, $rsr", (MV_Z  GPR:$rd, GPR:$rsl, GPR:$rsr)>;
def : InstAlias<"mv.neq  $rd, $rsl, $rsr", (MV_NZ GPR:$rd, GPR:$rsl, GPR:$rsr)>;
def : InstAlias<"mv.u.l  $rd, $rsl, $rsr", (MV_NC GPR:$rd, GPR:$rsl, GPR:$rsr)>;
def : InstAlias<"mv.u.ge $rd, $rsl, $rsr", (MV_C  GPR:$rd, GPR:$rsl, GPR:$rsr)>;

def : InstAlias<"mv.eq   $rd, $rsl, $imm15sr", (IMV_Z  GPR:$rd, GPR:$rsl, imm15:$imm15sr)>;
def : InstAlias<"mv.neq  $rd, $rsl, $imm15sr", (IMV_NZ GPR:$rd, GPR:$rsl, imm15:$imm15sr)>;
def : InstAlias<"mv.u.l  $rd, $rsl, $imm15sr", (IMV_NC GPR:$rd, GPR:$rsl, imm15:$imm15sr)>;
def : InstAlias<"mv.u.ge $rd, $rsl, $imm15sr", (IMV_C  GPR:$rd, GPR:$rsl, imm15:$imm15sr)>;
