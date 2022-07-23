//===-- A32Subtarget.cpp - A32 Subtarget Information ------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file implements the A32 specific subclass of TargetSubtargetInfo.
//
//===----------------------------------------------------------------------===//

#include "A32Subtarget.h"
#include "A32.h"
#include "A32FrameLowering.h"

using namespace llvm;

#define DEBUG_TYPE "a32-subtarget"

#define GET_SUBTARGETINFO_TARGET_DESC
#define GET_SUBTARGETINFO_CTOR
#include "A32GenSubtargetInfo.inc"

void A32Subtarget::anchor() {}

A32Subtarget &A32Subtarget::initializeSubtargetDependencies(StringRef CPU, StringRef TuneCPU, StringRef FS) {
  // Determine default and user-specified characteristics
  StringRef CPUName = CPU;
  if (CPUName.empty())
    CPUName = "generic-a32";
  ParseSubtargetFeatures(CPUName, TuneCPU, FS);
  return *this;
}

A32Subtarget::A32Subtarget(const Triple &TT, StringRef CPU, StringRef TuneCPU,
                               StringRef FS, const TargetMachine &TM)
    : A32GenSubtargetInfo(TT, CPU, TuneCPU, FS),
      FrameLowering(initializeSubtargetDependencies(CPU, TuneCPU, FS)),
      InstrInfo(), RegInfo(getHwMode()), TLInfo(TM, *this) {}
