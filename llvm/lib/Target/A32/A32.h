//===-- A32.h - Top-level interface for A32 -----------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file contains the entry points for global functions defined in the LLVM
// A32 back-end.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_A32_RISCV_H
#define LLVM_LIB_TARGET_A32_RISCV_H

#include "MCTargetDesc/A32MCTargetDesc.h"
#include "llvm/Target/TargetMachine.h"
#include "llvm/CodeGen/MachineFunctionPass.h"

namespace llvm {
class A32TargetMachine;
class MCInst;
class MachineInstr;

void LowerA32MachineInstrToMCInst(const MachineInstr *MI, MCInst &OutMI);

FunctionPass *createA32ISelDag(A32TargetMachine &TM);
}

#endif
