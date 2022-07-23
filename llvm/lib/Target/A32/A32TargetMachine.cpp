//===-- A32TargetMachine.cpp - Define TargetMachine for A32 -----------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// Implements the info about A32 target spec.
//
//===----------------------------------------------------------------------===//

#include "A32TargetMachine.h"
#include "TargetInfo/A32TargetInfo.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/CodeGen/Passes.h"
#include "llvm/CodeGen/TargetLoweringObjectFileImpl.h"
#include "llvm/CodeGen/TargetPassConfig.h"
#include "llvm/IR/LegacyPassManager.h"
#include "llvm/MC/TargetRegistry.h"
#include "llvm/Support/FormattedStream.h"
#include "llvm/Target/TargetOptions.h"
using namespace llvm;

extern "C" LLVM_EXTERNAL_VISIBILITY void LLVMInitializeA32Target() {
  RegisterTargetMachine<A32TargetMachine> X(getTheA32Target());
}

static StringRef computeDataLayout(const Triple &TT) {
  return "e-m:e-p:32:32-i64:64-n32-S128";
}

static Reloc::Model getEffectiveRelocModel(const Triple &TT,
                                           Optional<Reloc::Model> RM) {
  return RM.value_or(Reloc::Static);
}

A32TargetMachine::A32TargetMachine(const Target &T, const Triple &TT,
                                       StringRef CPU, StringRef FS,
                                       const TargetOptions &Options,
                                       Optional<Reloc::Model> RM,
                                       Optional<CodeModel::Model> CM,
                                       CodeGenOpt::Level OL, bool JIT)
    : LLVMTargetMachine(T, computeDataLayout(TT), TT, CPU, FS, Options,
                        getEffectiveRelocModel(TT, RM),
                        getEffectiveCodeModel(CM, CodeModel::Small), OL),
      TLOF(std::make_unique<TargetLoweringObjectFileELF>()),
      Subtarget(TT, CPU, CPU, FS, *this) {
  initAsmInfo();
}

namespace {
class A32PassConfig : public TargetPassConfig {
public:
  A32PassConfig(A32TargetMachine &TM, PassManagerBase &PM)
      : TargetPassConfig(TM, PM) {}

  A32TargetMachine &getA32TargetMachine() const {
    return getTM<A32TargetMachine>();
  }

  bool addInstSelector() override;
};
}

bool A32PassConfig::addInstSelector() {
  addPass(createA32ISelDag(getA32TargetMachine()));

  return false;
}

TargetPassConfig *A32TargetMachine::createPassConfig(PassManagerBase &PM) {
  return new A32PassConfig(*this, PM);
}
