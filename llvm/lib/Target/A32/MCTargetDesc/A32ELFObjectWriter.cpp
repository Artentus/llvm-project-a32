//===-- A32ELFObjectWriter.cpp - A32 ELF Writer -----------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "MCTargetDesc/A32FixupKinds.h"
#include "MCTargetDesc/A32MCTargetDesc.h"
#include "llvm/MC/MCContext.h"
#include "llvm/MC/MCELFObjectWriter.h"
#include "llvm/MC/MCFixup.h"
#include "llvm/MC/MCObjectWriter.h"
#include "llvm/Support/ErrorHandling.h"

using namespace llvm;

namespace {
class A32ELFObjectWriter : public MCELFObjectTargetWriter {
public:
  A32ELFObjectWriter(uint8_t OSABI, bool Is64Bit);

  ~A32ELFObjectWriter() override;

protected:
  unsigned getRelocType(MCContext &Ctx, const MCValue &Target,
                        const MCFixup &Fixup, bool IsPCRel) const override;
};
}

A32ELFObjectWriter::A32ELFObjectWriter(uint8_t OSABI, bool Is64Bit)
    : MCELFObjectTargetWriter(Is64Bit, OSABI, ELF::EM_A32,
                              /*HasRelocationAddend*/ true) {}

A32ELFObjectWriter::~A32ELFObjectWriter() = default;

unsigned A32ELFObjectWriter::getRelocType(MCContext &Ctx,
                                            const MCValue &Target,
                                            const MCFixup &Fixup,
                                            bool IsPCRel) const {
  // Determine the type of the relocation
  switch ((unsigned)Fixup.getKind()) {
  default:
    llvm_unreachable("invalid fixup kind!");
  case FK_Data_4:
    return ELF::R_A32_32;
  case FK_Data_8:
    return ELF::R_A32_64;
  case A32::fixup_a32_branch:
    return ELF::R_A32_BRANCH;
  case A32::fixup_a32_lo12:
    return ELF::R_A32_LO12;
  case A32::fixup_a32_lo12_pcrel:
    return ELF::R_A32_LO12_PCREL;
  case A32::fixup_a32_hi20:
    return ELF::R_A32_HI20;
  case A32::fixup_a32_hi20_pcrel:
    return ELF::R_A32_HI20_PCREL;
  case A32::fixup_a32_lo15:
    return ELF::R_A32_LO15;
  }
}

std::unique_ptr<MCObjectTargetWriter>
llvm::createA32ELFObjectWriter(uint8_t OSABI, bool Is64Bit) {
  return std::make_unique<A32ELFObjectWriter>(OSABI, Is64Bit);
}
