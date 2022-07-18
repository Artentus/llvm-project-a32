//===-- A32RegisterInfo.td - A32 Register defs --------*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
//  Declarations that describe the A32 register file
//===----------------------------------------------------------------------===//

let Namespace = "A32" in {
  class A32Reg<bits<5> Enc, string n, list<string> alt = []> : Register<n> {
    let HWEncoding{4-0} = Enc;
    let AltNames = alt;
  }

  def ABIRegAltName : RegAltNameIndex;
} // Namespace = "A32"

let RegAltNameIndices = [ABIRegAltName] in {
  def R0  : A32Reg<0,  "r0",  ["zero"]>, DwarfRegNum<[0]>;
  def R1  : A32Reg<1,  "r1",  ["ra"]>,   DwarfRegNum<[1]>;
  def R2  : A32Reg<2,  "r2",  ["sp"]>,   DwarfRegNum<[2]>;
  def R3  : A32Reg<3,  "r3",  ["a0"]>,   DwarfRegNum<[3]>;
  def R4  : A32Reg<4,  "r4",  ["a1"]>,   DwarfRegNum<[4]>;
  def R5  : A32Reg<5,  "r5",  ["a2"]>,   DwarfRegNum<[5]>;
  def R6  : A32Reg<6,  "r6",  ["a3"]>,   DwarfRegNum<[6]>;
  def R7  : A32Reg<7,  "r7",  ["a4"]>,   DwarfRegNum<[7]>;
  def R8  : A32Reg<8,  "r8",  ["a5"]>,   DwarfRegNum<[8]>;
  def R9  : A32Reg<9,  "r9",  ["a6"]>,   DwarfRegNum<[9]>;
  def R10 : A32Reg<10, "r10", ["a7"]>,   DwarfRegNum<[10]>;
  def R11 : A32Reg<11, "r11", ["t0"]>,   DwarfRegNum<[11]>;
  def R12 : A32Reg<12, "r12", ["t1"]>,   DwarfRegNum<[12]>;
  def R13 : A32Reg<13, "r13", ["t2"]>,   DwarfRegNum<[13]>;
  def R14 : A32Reg<14, "r14", ["t3"]>,   DwarfRegNum<[14]>;
  def R15 : A32Reg<15, "r15", ["t4"]>,   DwarfRegNum<[15]>;
  def R16 : A32Reg<16, "r16", ["t5"]>,   DwarfRegNum<[16]>;
  def R17 : A32Reg<17, "r17", ["t6"]>,   DwarfRegNum<[17]>;
  def R18 : A32Reg<18, "r18", ["t7"]>,   DwarfRegNum<[18]>;
  def R19 : A32Reg<19, "r19", ["s0"]>,   DwarfRegNum<[19]>;
  def R20 : A32Reg<20, "r20", ["s1"]>,   DwarfRegNum<[20]>;
  def R21 : A32Reg<21, "r21", ["s2"]>,   DwarfRegNum<[21]>;
  def R22 : A32Reg<22, "r22", ["s3"]>,   DwarfRegNum<[22]>;
  def R23 : A32Reg<23, "r23", ["s4"]>,   DwarfRegNum<[23]>;
  def R24 : A32Reg<24, "r24", ["s5"]>,   DwarfRegNum<[24]>;
  def R25 : A32Reg<25, "r25", ["s6"]>,   DwarfRegNum<[25]>;
  def R26 : A32Reg<26, "r26", ["s7"]>,   DwarfRegNum<[26]>;
  def R27 : A32Reg<27, "r27", ["s8"]>,   DwarfRegNum<[27]>;
  def R28 : A32Reg<28, "r28", ["s9"]>,   DwarfRegNum<[28]>;
  def R29 : A32Reg<29, "r29", ["s10"]>,  DwarfRegNum<[29]>;
  def R30 : A32Reg<30, "r30", ["s11"]>,  DwarfRegNum<[30]>;
  def R31 : A32Reg<31, "r31", ["s12"]>,  DwarfRegNum<[31]>;
}

// The order of registers represents the preferred allocation sequence.
// Registers are listed in the order caller-save, callee-save, specials.
def GPR : RegisterClass<"A32", [i32], 32,
  (add
    (sequence "R%u", 3, 10),  // a0-a7
    (sequence "R%u", 11, 18), // t0-t7
    (sequence "R%u", 19, 31), // s0-s12
    (sequence "R%u", 0, 2)    // zero, ra, sp
  )>;

def GPRZ : RegisterClass<"A32", [i32], 32, (add R0)>;
def GPRSP : RegisterClass<"A32", [i32], 32, (add R2)>;
def GPRNoZ : RegisterClass<"A32", [i32], 32, (sub GPR, R0)>;
def GPRNoZSP : RegisterClass<"A32", [i32], 32, (sub GPR, R0, R2)>;

// For indirect tail calls, we can't use callee-saved registers, as they are
// restored to the saved value before the tail call, which would clobber a call
// address.
def GPRTail : RegisterClass<"A32", [i32], 32,
  (add
    (sequence "R%u", 3, 10), // a0-a7
    (sequence "R%u", 11, 18) // t0-t7
  )>;
