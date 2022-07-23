; RUN: llc -mtriple=a32 -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=A32

; Register-register instructions

define i32 @add(i32 %a, i32 %b) nounwind {
; A32-LABEL: add:
; A32:       # %bb.0:
; A32-NEXT:    add a0, a0, a1
; A32-NEXT:    jmp ra, 0
  %1 = add i32 %a, %b
  ret i32 %1
}

define i32 @sub(i32 %a, i32 %b) nounwind {
; A32-LABEL: sub:
; A32:       # %bb.0:
; A32-NEXT:    sub a0, a0, a1
; A32-NEXT:    jmp ra, 0
  %1 = sub i32 %a, %b
  ret i32 %1
}

define i32 @and(i32 %a, i32 %b) nounwind {
; A32-LABEL: and:
; A32:       # %bb.0:
; A32-NEXT:    and a0, a0, a1
; A32-NEXT:    jmp ra, 0
  %1 = and i32 %a, %b
  ret i32 %1
}

define i32 @or(i32 %a, i32 %b) nounwind {
; A32-LABEL: or:
; A32:       # %bb.0:
; A32-NEXT:    or a0, a0, a1
; A32-NEXT:    jmp ra, 0
  %1 = or i32 %a, %b
  ret i32 %1
}

define i32 @xor(i32 %a, i32 %b) nounwind {
; A32-LABEL: xor:
; A32:       # %bb.0:
; A32-NEXT:    xor a0, a0, a1
; A32-NEXT:    jmp ra, 0
  %1 = xor i32 %a, %b
  ret i32 %1
}

define i32 @shl(i32 %a, i32 %b) nounwind {
; A32-LABEL: shl:
; A32:       # %bb.0:
; A32-NEXT:    shl a0, a0, a1
; A32-NEXT:    jmp ra, 0
  %1 = shl i32 %a, %b
  ret i32 %1
}

define i32 @lsr(i32 %a, i32 %b) nounwind {
; A32-LABEL: lsr:
; A32:       # %bb.0:
; A32-NEXT:    lsr a0, a0, a1
; A32-NEXT:    jmp ra, 0
  %1 = lshr i32 %a, %b
  ret i32 %1
}

define i32 @asr(i32 %a, i32 %b) nounwind {
; A32-LABEL: asr:
; A32:       # %bb.0:
; A32-NEXT:    asr a0, a0, a1
; A32-NEXT:    jmp ra, 0
  %1 = ashr i32 %a, %b
  ret i32 %1
}

define i32 @mul(i32 %a, i32 %b) nounwind {
; A32-LABEL: mul:
; A32:       # %bb.0:
; A32-NEXT:    mul a0, a0, a1
; A32-NEXT:    jmp ra, 0
  %1 = mul i32 %a, %b
  ret i32 %1
}

; Register-immediate instructions

define i32 @iadd(i32 %a) nounwind {
; A32-LABEL: iadd:
; A32:       # %bb.0:
; A32-NEXT:    add a0, a0, 1
; A32-NEXT:    jmp ra, 0
  %1 = add i32 %a, 1
  ret i32 %1
}

define i32 @isub(i32 %a) nounwind {
; A32-LABEL: isub:
; A32:       # %bb.0:
; A32-NEXT:    add a0, a0, -2
; A32-NEXT:    jmp ra, 0
  %1 = sub i32 %a, 2
  ret i32 %1
}

define i32 @iand(i32 %a) nounwind {
; A32-LABEL: iand:
; A32:       # %bb.0:
; A32-NEXT:    and a0, a0, 3
; A32-NEXT:    jmp ra, 0
  %1 = and i32 %a, 3
  ret i32 %1
}

define i32 @ior(i32 %a) nounwind {
; A32-LABEL: ior:
; A32:       # %bb.0:
; A32-NEXT:    or a0, a0, 4
; A32-NEXT:    jmp ra, 0
  %1 = or i32 %a, 4
  ret i32 %1
}

define i32 @ixor(i32 %a) nounwind {
; A32-LABEL: ixor:
; A32:       # %bb.0:
; A32-NEXT:    xor a0, a0, 5
; A32-NEXT:    jmp ra, 0
  %1 = xor i32 %a, 5
  ret i32 %1
}

define i32 @ishl(i32 %a) nounwind {
; A32-LABEL: ishl:
; A32:       # %bb.0:
; A32-NEXT:    shl a0, a0, 6
; A32-NEXT:    jmp ra, 0
  %1 = shl i32 %a, 6
  ret i32 %1
}

define i32 @ilsr(i32 %a) nounwind {
; A32-LABEL: ilsr:
; A32:       # %bb.0:
; A32-NEXT:    lsr a0, a0, 7
; A32-NEXT:    jmp ra, 0
  %1 = lshr i32 %a, 7
  ret i32 %1
}

define i32 @iasr(i32 %a) nounwind {
; A32-LABEL: iasr:
; A32:       # %bb.0:
; A32-NEXT:    asr a0, a0, 8
; A32-NEXT:    jmp ra, 0
  %1 = ashr i32 %a, 8
  ret i32 %1
}

define i32 @imul(i32 %a) nounwind {
; A32-LABEL: imul:
; A32:       # %bb.0:
; A32-NEXT:    mul a0, a0, 9
; A32-NEXT:    jmp ra, 0
  %1 = mul i32 %a, 9
  ret i32 %1
}
