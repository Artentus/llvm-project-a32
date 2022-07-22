//===-- A32MCExpr.cpp - A32 specific MC expression classes ------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file contains the implementation of the assembly expression modifiers
// accepted by the A32 architecture (e.g. ":lo12:", ":gottprel_g1:", ...).
//
//===----------------------------------------------------------------------===//

#include "A32MCExpr.h"
#include "llvm/BinaryFormat/ELF.h"
#include "llvm/MC/MCAsmLayout.h"
#include "llvm/MC/MCAssembler.h"
#include "llvm/MC/MCContext.h"
#include "llvm/MC/MCStreamer.h"
#include "llvm/MC/MCSymbolELF.h"
#include "llvm/MC/MCValue.h"
#include "llvm/Support/Casting.h"
#include "llvm/Support/ErrorHandling.h"

using namespace llvm;

#define DEBUG_TYPE "a32mcexpr"

const A32MCExpr *A32MCExpr::create(const MCExpr *Expr, VariantKind Kind,
                                       MCContext &Ctx) {
  return new (Ctx) A32MCExpr(Expr, Kind);
}

void A32MCExpr::printImpl(raw_ostream &OS, const MCAsmInfo *MAI) const {
  bool HasVariant = getKind() != VK_A32_None;

  if (HasVariant)
    OS << '%' << getVariantKindName(getKind()) << '(';
  Expr->print(OS, MAI);
  if (HasVariant)
    OS << ')';
}

bool A32MCExpr::evaluateAsRelocatableImpl(MCValue &Res,
                                            const MCAsmLayout *Layout,
                                            const MCFixup *Fixup) const {
  return getSubExpr()->evaluateAsRelocatable(Res, Layout, Fixup);
}

void A32MCExpr::visitUsedExpr(MCStreamer &Streamer) const {
  Streamer.visitUsedExpr(*getSubExpr());
}

A32MCExpr::VariantKind A32MCExpr::getVariantKindForName(StringRef name) {
  return StringSwitch<A32MCExpr::VariantKind>(name)
      .Case("lo", VK_A32_LO12)
      .Case("pclo", VK_A32_LO12_PCREL)
      .Case("hi", VK_A32_HI20)
      .Case("pchi", VK_A32_HI20_PCREL)
      .Default(VK_A32_Invalid);
}

StringRef A32MCExpr::getVariantKindName(VariantKind Kind) {
  switch (Kind) {
  case VK_A32_Invalid:
  case VK_A32_None:
    llvm_unreachable("Invalid ELF symbol kind");
  case VK_A32_LO12:
    return "lo";
  case VK_A32_LO12_PCREL:
    return "pclo";
  case VK_A32_HI20:
    return "hi";
  case VK_A32_HI20_PCREL:
    return "pchi";
  }
  llvm_unreachable("Invalid ELF symbol kind");
}

bool A32MCExpr::evaluateAsConstant(int64_t &Res) const {
  MCValue Value;

  if (Kind == VK_A32_LO12_PCREL || Kind == VK_A32_HI20_PCREL)
    return false;

  if (!getSubExpr()->evaluateAsRelocatable(Value, nullptr, nullptr))
    return false;

  if (!Value.isAbsolute())
    return false;

  Res = evaluateAsInt64(Value.getConstant());
  return true;
}

int64_t A32MCExpr::evaluateAsInt64(int64_t Value) const {
  switch (Kind) {
  default:
    llvm_unreachable("Invalid kind");
  case VK_A32_LO12:
    return Value & 0xFFF;
  case VK_A32_HI20:
    return Value & 0xFFFFF000;
  }
}
