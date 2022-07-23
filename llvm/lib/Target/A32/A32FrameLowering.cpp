//===-- A32FrameLowering.cpp - A32 Frame Information ------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file contains the A32 implementation of TargetFrameLowering class.
//
//===----------------------------------------------------------------------===//

#include "A32FrameLowering.h"
#include "A32Subtarget.h"
#include "llvm/CodeGen/MachineFrameInfo.h"
#include "llvm/CodeGen/MachineFunction.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"

using namespace llvm;

bool A32FrameLowering::hasFP(const MachineFunction &MF) const { return true; }

void A32FrameLowering::emitPrologue(MachineFunction &MF, MachineBasicBlock &MBB) const {}

void A32FrameLowering::emitEpilogue(MachineFunction &MF, MachineBasicBlock &MBB) const {}
