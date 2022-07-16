//===-- A32MCAsmInfo.cpp - A32 Asm properties -------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file contains the declarations of the A32MCAsmInfo properties.
//
//===----------------------------------------------------------------------===//

#include "A32MCAsmInfo.h"
#include "llvm/ADT/Triple.h"
#include "llvm/BinaryFormat/Dwarf.h"
#include "llvm/MC/MCStreamer.h"
using namespace llvm;

void A32MCAsmInfo::anchor() {}

A32MCAsmInfo::A32MCAsmInfo(const Triple &TT) {
  CodePointerSize = CalleeSaveStackSlotSize = 4;
  CommentString = "//";
  AlignmentIsInBytes = true;
  SupportsDebugInformation = false;
  ExceptionsType = ExceptionHandling::DwarfCFI;
  Data8bitsDirective = "#d8 ";
  Data16bitsDirective = "#d16 ";
  Data32bitsDirective = "#d32 ";
  Data64bitsDirective = "#d64 ";
}
