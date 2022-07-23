//===-- A32InstrInfo.h - A32 Instruction Information --------*- C++ -*-===//
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

#ifndef LLVM_LIB_TARGET_A32_A32INSTRINFO_H
#define LLVM_LIB_TARGET_A32_A32INSTRINFO_H

#include "A32RegisterInfo.h"
#include "llvm/CodeGen/TargetInstrInfo.h"

#define GET_INSTRINFO_HEADER
#include "A32GenInstrInfo.inc"

namespace llvm {

class A32InstrInfo : public A32GenInstrInfo {

public:
  A32InstrInfo();
};
}

#endif
