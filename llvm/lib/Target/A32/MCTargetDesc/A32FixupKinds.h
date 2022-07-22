//===-- A32FixupKinds.h - A32 Specific Fixup Entries --------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_A32_MCTARGETDESC_A32FIXUPKINDS_H
#define LLVM_LIB_TARGET_A32_MCTARGETDESC_A32FIXUPKINDS_H

#include "llvm/MC/MCFixup.h"

#undef A32

namespace llvm {
namespace A32 {
enum Fixups {
  // 22-bit fixup for symbol references in the branch instructions
  fixup_a32_branch = FirstTargetFixupKind,

  // 12-bit fixup for symbol references in instructions with lower immediate
  fixup_a32_lo12,
  // 12-bit fixup for pc-relative symbol references in instructions with lower immediate
  fixup_a32_lo12_pcrel,

  // 20-bit fixup for symbol references in instructions with upper immediate
  fixup_a32_hi20,
  // 20-bit fixup for pc-relative symbol references in instructions with upper immediate
  fixup_a32_hi20_pcrel,

  // 15-bit fixup for symbol references in instructions with lower immediate
  fixup_a32_lo15,

  // Used as a sentinel, must be the last
  fixup_a32_invalid,
  NumTargetFixupKinds = fixup_a32_invalid - FirstTargetFixupKind
};
} // end namespace A32
} // end namespace llvm

#endif
