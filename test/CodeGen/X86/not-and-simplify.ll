; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=-bmi | FileCheck %s --check-prefix=ALL --check-prefix=NO_BMI
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+bmi | FileCheck %s --check-prefix=ALL --check-prefix=BMI

; Clear high bits via shift, set them with xor (not), then mask them off.

define i32 @shrink_xor_constant1(i32 %x) {
; ALL-LABEL: shrink_xor_constant1:
; ALL:       # %bb.0:
; ALL-NEXT:    movl %edi, %eax
; ALL-NEXT:    shrl $31, %eax
; ALL-NEXT:    xorl $1, %eax
; ALL-NEXT:    retq
  %sh = lshr i32 %x, 31
  %not = xor i32 %sh, -1
  %and = and i32 %not, 1
  ret i32 %and
}

define <4 x i32> @shrink_xor_constant1_splat(<4 x i32> %x) {
; ALL-LABEL: shrink_xor_constant1_splat:
; ALL:       # %bb.0:
; ALL-NEXT:    psrld $31, %xmm0
; ALL-NEXT:    pxor {{.*}}(%rip), %xmm0
; ALL-NEXT:    retq
  %sh = lshr <4 x i32> %x, <i32 31, i32 31, i32 31, i32 31>
  %not = xor <4 x i32> %sh, <i32 -1, i32 -1, i32 -1, i32 -1>
  %and = and <4 x i32> %not, <i32 1, i32 1, i32 1, i32 1>
  ret <4 x i32> %and
}

; Clear low bits via shift, set them with xor (not), then mask them off.

define i8 @shrink_xor_constant2(i8 %x) {
; ALL-LABEL: shrink_xor_constant2:
; ALL:       # %bb.0:
; ALL-NEXT:    movl %edi, %eax
; ALL-NEXT:    shlb $5, %al
; ALL-NEXT:    xorb $-32, %al
; ALL-NEXT:    # kill: def $al killed $al killed $eax
; ALL-NEXT:    retq
  %sh = shl i8 %x, 5
  %not = xor i8 %sh, -1
  %and = and i8 %not, 224 ; 0xE0
  ret i8 %and
}

define <16 x i8> @shrink_xor_constant2_splat(<16 x i8> %x) {
; ALL-LABEL: shrink_xor_constant2_splat:
; ALL:       # %bb.0:
; ALL-NEXT:    movaps {{.*#+}} xmm0 = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
; ALL-NEXT:    retq
  %sh = shl <16 x i8> %x, <i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5>
  %not = xor <16 x i8> %sh, <i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1>
  %and = and <16 x i8> %not, <i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1>
  ret <16 x i8> %and
}

