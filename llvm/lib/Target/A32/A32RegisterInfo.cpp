//===-- A32RegisterInfo.cpp - A32 Register Information ------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file contains the A32 implementation of the TargetRegisterInfo class.
//
//===----------------------------------------------------------------------===//

#include "A32RegisterInfo.h"
#include "A32.h"
#include "A32Subtarget.h"
#include "llvm/CodeGen/MachineFrameInfo.h"
#include "llvm/CodeGen/MachineFunction.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/RegisterScavenging.h"
#include "llvm/CodeGen/TargetFrameLowering.h"
#include "llvm/CodeGen/TargetInstrInfo.h"
#include "llvm/Support/ErrorHandling.h"

#define GET_REGINFO_TARGET_DESC
#include "A32GenRegisterInfo.inc"

using namespace llvm;

A32RegisterInfo::A32RegisterInfo(unsigned HwMode)
    : A32GenRegisterInfo(A32::R1, /*DwarfFlavour*/0, /*EHFlavor*/0, /*PC*/0, HwMode) {}

const MCPhysReg *
A32RegisterInfo::getCalleeSavedRegs(const MachineFunction *MF) const {
  return CSR_SaveList;
}

BitVector A32RegisterInfo::getReservedRegs(const MachineFunction &MF) const {
  BitVector Reserved(getNumRegs());

  // Use markSuperRegs to ensure any register aliases are also reserved
  markSuperRegs(Reserved, A32::R0); // zero
  markSuperRegs(Reserved, A32::R1); // ra
  markSuperRegs(Reserved, A32::R2); // sp
  markSuperRegs(Reserved, A32::R19); // fp
  assert(checkAllSuperRegsMarked(Reserved));
  return Reserved;
}

void A32RegisterInfo::eliminateFrameIndex(MachineBasicBlock::iterator II,
                                            int SPAdj, unsigned FIOperandNum,
                                            RegScavenger *RS) const {
  report_fatal_error("Subroutines not supported yet");
}

Register A32RegisterInfo::getFrameRegister(const MachineFunction &MF) const {
  return A32::R19;
}
