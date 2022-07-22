//===-- A32AsmBackend.cpp - A32 Assembler Backend ---------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "A32AsmBackend.h"
#include "llvm/ADT/APInt.h"
#include "llvm/MC/MCAsmInfo.h"
#include "llvm/MC/MCAsmLayout.h"
#include "llvm/MC/MCAssembler.h"
#include "llvm/MC/MCContext.h"
#include "llvm/MC/MCDirectives.h"
#include "llvm/MC/MCELFObjectWriter.h"
#include "llvm/MC/MCExpr.h"
#include "llvm/MC/MCObjectWriter.h"
#include "llvm/MC/MCSymbol.h"
#include "llvm/MC/MCValue.h"
#include "llvm/Support/Endian.h"
#include "llvm/Support/EndianStream.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/LEB128.h"
#include "llvm/Support/raw_ostream.h"

using namespace llvm;

bool A32AsmBackend::writeNopData(raw_ostream &OS, uint64_t Count,
                                 const MCSubtargetInfo *STI) const {
  if ((Count % 4) != 0)
    return false;

  for (uint64_t i = 0; i < Count; i++)
    OS.write(0);

  return true;
}

const MCFixupKindInfo &A32AsmBackend::getFixupKindInfo(MCFixupKind Kind) const {
  const static MCFixupKindInfo Infos[A32::NumTargetFixupKinds] = {
    // This table *must* be in the order that the fixup_* kinds are defined in
    // A32FixupKinds.h.
    
    // name                     offset bits flags
    { "fixup_a32_branch",      0,    32,  MCFixupKindInfo::FKF_IsPCRel },
    { "fixup_a32_lo12",       17,    15,  0 },
    { "fixup_a32_lo12_pcrel", 17,    15,  MCFixupKindInfo::FKF_IsPCRel },
    { "fixup_a32_hi20",        0,    32,  0 },
    { "fixup_a32_hi20_pcrel",  0,    32,  MCFixupKindInfo::FKF_IsPCRel },
    { "fixup_a32_lo15",       17,    15,  0 },
  };

  if (Kind < FirstTargetFixupKind)
    return MCAsmBackend::getFixupKindInfo(Kind);

  assert(unsigned(Kind - FirstTargetFixupKind) < getNumFixupKinds() && "Invalid kind!");
  return Infos[Kind - FirstTargetFixupKind];
}

static uint64_t adjustFixupValue(const MCFixup &Fixup, uint64_t Value, MCContext &Ctx) {
  unsigned Kind = Fixup.getKind();
  switch (Kind) {
  default:
    llvm_unreachable("Unknown fixup kind!");
  case FK_Data_1:
  case FK_Data_2:
  case FK_Data_4:
  case FK_Data_8:
    return Value;
  case A32::fixup_a32_branch: {
    if (!isInt<22>(Value))
      Ctx.reportError(Fixup.getLoc(), "address out of range");
    if (Value & 0x3)
      Ctx.reportError(Fixup.getLoc(), "address must be 4-byte aligned");

    return ((Value & 0x20'0000) << 10) | ((Value & 0x3FFC) << 17) | ((Value & 0x1F'C000) >> 2);
  }
  case A32::fixup_a32_lo12:
  case A32::fixup_a32_lo12_pcrel:
    return Value & 0xFFF;
  case A32::fixup_a32_hi20:
  case A32::fixup_a32_hi20_pcrel:
    return (Value & 0x8000'0000) | ((Value & 0x3000) << 17) | ((Value & 0x7FFF'C000) >> 2);
  case A32::fixup_a32_lo15: {
    if (Value & ~0x7FFF)
      Ctx.reportError(Fixup.getLoc(), "value out of range");

    return Value & 0x7FFF;
  }
  }
}

void A32AsmBackend::applyFixup(const MCAssembler &Asm, const MCFixup &Fixup,
                                 const MCValue &Target,
                                 MutableArrayRef<char> Data, uint64_t Value,
                                 bool IsResolved,
                                 const MCSubtargetInfo *STI) const {
  MCContext &Ctx = Asm.getContext();
  MCFixupKindInfo Info = getFixupKindInfo(Fixup.getKind());
  if (!Value)
    return; // Doesn't change encoding.
  // Apply any target-specific value adjustments.
  Value = adjustFixupValue(Fixup, Value, Ctx);

  // Shift the value into position.
  Value <<= Info.TargetOffset;

  unsigned Offset = Fixup.getOffset();

#ifndef NDEBUG
  unsigned NumBytes = (Info.TargetSize + 7) / 8;
  assert(Offset + NumBytes <= Data.size() && "Invalid fixup offset!");
#endif

  // For each byte of the fragment that the fixup touches, mask in the
  // bits from the fixup value.
  for (unsigned i = 0; i != 4; ++i) {
    Data[Offset + i] |= uint8_t((Value >> (i * 8)) & 0xff);
  }
}

std::unique_ptr<MCObjectTargetWriter>
A32AsmBackend::createObjectTargetWriter() const {
  return createA32ELFObjectWriter(OSABI, Is64Bit);
}

MCAsmBackend *llvm::createA32AsmBackend(const Target &T,
                                          const MCSubtargetInfo &STI,
                                          const MCRegisterInfo &MRI,
                                          const MCTargetOptions &Options) {
  const Triple &TT = STI.getTargetTriple();
  uint8_t OSABI = MCELFObjectTargetWriter::getOSABI(TT.getOS());
  return new A32AsmBackend(STI, OSABI, TT.isArch64Bit(), Options);
}
