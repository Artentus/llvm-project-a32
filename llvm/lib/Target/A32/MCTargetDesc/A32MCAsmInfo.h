//===-- A32MCAsmInfo.h - A32 Asm Info ----------------------*- C++ -*--===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file contains the declaration of the A32MCAsmInfo class.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_A32_MCTARGETDESC_A32MCASMINFO_H
#define LLVM_LIB_TARGET_A32_MCTARGETDESC_A32MCASMINFO_H

#include "llvm/MC/MCAsmInfoELF.h"

namespace llvm {
class Triple;

class A32MCAsmInfo : public MCAsmInfoELF {
  void anchor() override;

public:
  explicit A32MCAsmInfo(const Triple &TargetTriple);
};

} // namespace llvm

#endif
