//===-- A32TargetInfo.cpp - A32 Target Implementation -----------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "TargetInfo/A32TargetInfo.h"
#include "llvm/MC/TargetRegistry.h"
using namespace llvm;

Target &llvm::getTheA32Target() {
  static Target TheA32Target;
  return TheA32Target;
}

extern "C" LLVM_EXTERNAL_VISIBILITY void LLVMInitializeA32TargetInfo() {
  RegisterTarget<Triple::a32> X(getTheA32Target(), "a32", "A32", "A32");
}
