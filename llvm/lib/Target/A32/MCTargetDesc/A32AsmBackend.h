//===-- A32AsmBackend.h - A32 Assembler Backend -----------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_A32_MCTARGETDESC_A32ASMBACKEND_H
#define LLVM_LIB_TARGET_A32_MCTARGETDESC_A32ASMBACKEND_H

#include "MCTargetDesc/A32MCTargetDesc.h"
#include "llvm/MC/MCAsmBackend.h"
#include "llvm/MC/MCFixupKindInfo.h"
#include "llvm/MC/MCSubtargetInfo.h"

namespace llvm {
class MCAssembler;
class MCObjectTargetWriter;
class raw_ostream;

class A32AsmBackend : public MCAsmBackend {
  const MCSubtargetInfo &STI;
  uint8_t OSABI;
  bool Is64Bit;
  bool ForceRelocs = false;
  const MCTargetOptions &TargetOptions;

public:
  A32AsmBackend(const MCSubtargetInfo &STI, uint8_t OSABI, bool Is64Bit, const MCTargetOptions &Options)
      : MCAsmBackend(support::little), STI(STI), OSABI(OSABI), Is64Bit(Is64Bit), TargetOptions(Options) {}
  ~A32AsmBackend() override = default;

  void applyFixup(const MCAssembler &Asm, const MCFixup &Fixup,
                  const MCValue &Target, MutableArrayRef<char> Data,
                  uint64_t Value, bool IsResolved,
                  const MCSubtargetInfo *STI) const override;

  std::unique_ptr<MCObjectTargetWriter>
  createObjectTargetWriter() const override;

  bool fixupNeedsRelaxation(const MCFixup &Fixup, uint64_t Value,
                            const MCRelaxableFragment *DF,
                            const MCAsmLayout &Layout) const override {
    return false;
  }

  unsigned getNumFixupKinds() const override {
    return 1;
  }

  bool mayNeedRelaxation(const MCInst &Inst,
                         const MCSubtargetInfo &STI) const override {
    return false;
  }
  
  void relaxInstruction(MCInst &Inst,
                        const MCSubtargetInfo &STI) const override {
    report_fatal_error("A32AsmBackend::relaxInstruction() unimplemented");
  }

  bool writeNopData(raw_ostream &OS, uint64_t Count,
                    const MCSubtargetInfo *STI) const override;
};
}

#endif
