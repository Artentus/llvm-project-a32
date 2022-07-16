//===-- A32MCTargetDesc.cpp - A32 Target Descriptions -----------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
///
/// This file provides A32-specific target descriptions.
///
//===----------------------------------------------------------------------===//

#include "A32MCTargetDesc.h"
#include "A32MCAsmInfo.h"
#include "TargetInfo/A32TargetInfo.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/MC/MCAsmBackend.h"
#include "llvm/MC/MCAsmInfo.h"
#include "llvm/MC/MCCodeEmitter.h"
#include "llvm/MC/MCInstrAnalysis.h"
#include "llvm/MC/MCInstrInfo.h"
#include "llvm/MC/MCObjectFileInfo.h"
#include "llvm/MC/MCObjectWriter.h"
#include "llvm/MC/MCRegisterInfo.h"
#include "llvm/MC/MCStreamer.h"
#include "llvm/MC/MCSubtargetInfo.h"
#include "llvm/MC/TargetRegistry.h"
#include "llvm/Support/ErrorHandling.h"

#define GET_INSTRINFO_MC_DESC
#define ENABLE_INSTR_PREDICATE_VERIFIER
#include "A32GenInstrInfo.inc"

#define GET_REGINFO_MC_DESC
#include "A32GenRegisterInfo.inc"

#define GET_SUBTARGETINFO_MC_DESC
#include "A32GenSubtargetInfo.inc"

using namespace llvm;

static MCInstrInfo *createA32MCInstrInfo() {
  MCInstrInfo *X = new MCInstrInfo();
  InitA32MCInstrInfo(X);
  return X;
}

static MCRegisterInfo *createA32MCRegisterInfo(const Triple &TT) {
  MCRegisterInfo *X = new MCRegisterInfo();
  InitA32MCRegisterInfo(X, A32::R1);
  return X;
}

static MCAsmInfo *createA32MCAsmInfo(
  const MCRegisterInfo &MRI,
  const Triple &TT,
  const MCTargetOptions &Options
) {
  MCAsmInfo *MAI = new A32MCAsmInfo(TT);

  MCRegister SP = MRI.getDwarfRegNum(A32::R2, true);
  MCCFIInstruction Inst = MCCFIInstruction::cfiDefCfa(nullptr, SP, 0);
  MAI->addInitialFrameState(Inst);

  return MAI;
}

static MCSubtargetInfo *createA32MCSubtargetInfo(
  const Triple &TT,
  StringRef CPU,
  StringRef FS
) {
  if (CPU.empty() || CPU == "generic")
    CPU = "generic-a32";

  return createA32MCSubtargetInfoImpl(TT, CPU, /*TuneCPU*/ CPU, FS);
}

extern "C" LLVM_EXTERNAL_VISIBILITY void LLVMInitializeA32TargetMC() {
  for (Target *T : {&getTheA32Target()}) {
    TargetRegistry::RegisterMCAsmInfo(*T, createA32MCAsmInfo);
    TargetRegistry::RegisterMCInstrInfo(*T, createA32MCInstrInfo);
    TargetRegistry::RegisterMCRegInfo(*T, createA32MCRegisterInfo);
    TargetRegistry::RegisterMCAsmBackend(*T, createA32AsmBackend);
    TargetRegistry::RegisterMCCodeEmitter(*T, createA32MCCodeEmitter);
    TargetRegistry::RegisterMCSubtargetInfo(*T, createA32MCSubtargetInfo);
  }
}
