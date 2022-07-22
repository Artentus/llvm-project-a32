//===-- A32BaseInfo.h - Top level definitions for A32 MC ----*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file contains small standalone enum definitions for the A32 target
// useful for the compiler back-end and the MC libraries.
//
//===----------------------------------------------------------------------===//
#ifndef LLVM_LIB_TARGET_A32_MCTARGETDESC_A32BASEINFO_H
#define LLVM_LIB_TARGET_A32_MCTARGETDESC_A32BASEINFO_H

#include "MCTargetDesc/A32MCTargetDesc.h"

namespace llvm {

// A32II - This namespace holds all of the target specific flags that
// instruction info tracks. All definitions must match A32InstrFormats.td.
namespace A32II {
enum {
  InstFormatPseudo = 0,
  InstFormatRegReg = 1,
  InstFormatRegImm = 2,
  InstFormatUI     = 3,
  InstFormatBranch = 4,
  InstFormatOther  = 5,

  InstFormatMask = 15
};
} // namespace A32II

} // namespace llvm

#endif
