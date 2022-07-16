//===-- A32ELFObjectWriter.cpp - A32 ELF Writer -----------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

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
  report_fatal_error("invalid fixup kind!");
}

std::unique_ptr<MCObjectTargetWriter>
llvm::createA32ELFObjectWriter(uint8_t OSABI, bool Is64Bit) {
  return std::make_unique<A32ELFObjectWriter>(OSABI, Is64Bit);
}
