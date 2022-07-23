//===-- A32InstrInfo.cpp - A32 Instruction Information ------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file contains the A32 implementation of the TargetInstrInfo class.
//
//===----------------------------------------------------------------------===//

#include "A32InstrInfo.h"
#include "A32.h"
#include "A32Subtarget.h"
#include "A32TargetMachine.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/CodeGen/MachineFunctionPass.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"
#include "llvm/Support/ErrorHandling.h"

#define GET_INSTRINFO_CTOR_DTOR
#include "A32GenInstrInfo.inc"

using namespace llvm;

A32InstrInfo::A32InstrInfo() : A32GenInstrInfo() {}
