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
  CommentString = "#";
  AllowAdditionalComments = true;
  AlignmentIsInBytes = true;
  SupportsDebugInformation = false;
  ExceptionsType = ExceptionHandling::DwarfCFI;
  AllowAtAtStartOfIdentifier = false;
  AllowDollarAtStartOfIdentifier = false;
  AllowHashAtStartOfIdentifier = false;
  AllowQuestionAtStartOfIdentifier = false;
  //Data8bitsDirective = "\t.d8\t";
  //Data16bitsDirective = "\t.d16\t";
  //Data32bitsDirective = "\t.d32\t";
  //Data64bitsDirective = "\t.d64\t";
  //AsciiDirective = "\t.ascii\t";
  //AscizDirective = "\t.asciiz\t";
  //ByteListDirective = "\t.d8\t";
  DollarIsPC = true;
  DotIsPC = false;
  StarIsPC = false;
  //GlobalDirective = "\t.global\t";
  HasDotTypeDotSizeDirective = true;
  HasFourStringsDotFile = false;
  HasSingleParameterDotFile = true;
  HasFunctionAlignment = true;
  HasIdentDirective = false;
  IsLittleEndian = true;
  LabelSuffix = ":";
  MaxInstLength = 4;
  MinInstAlignment = 4;
  StackGrowsUp = false;
  SupportsSignedData = true;
  //ZeroDirective = "\t.zero\t";
  ZeroDirectiveSupportsNonZeroValue = false;
}
