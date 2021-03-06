; RUN: llc < %s -mtriple=i386-apple-darwin | FileCheck %s

; CodeGen should align the top of the loop, which differs from the loop
; header in this case.

; CHECK: jmp LBB0_2
; CHECK: .p2align
; CHECK: LBB0_1:

@A = common global [100 x i32] zeroinitializer, align 32		; <ptr> [#uses=1]

define ptr @test(ptr %Q, ptr %L) nounwind {
entry:
	%tmp = tail call i32 (...) @foo() nounwind		; <i32> [#uses=2]
	%tmp1 = inttoptr i32 %tmp to ptr		; <ptr> [#uses=1]
	br label %bb1

bb:		; preds = %bb1, %bb1
	%indvar.next = add i32 %P.0.rec, 1		; <i32> [#uses=1]
	br label %bb1

bb1:		; preds = %bb, %entry
	%P.0.rec = phi i32 [ 0, %entry ], [ %indvar.next, %bb ]		; <i32> [#uses=2]
	%P.0 = getelementptr i8, ptr %tmp1, i32 %P.0.rec		; <ptr> [#uses=3]
	%tmp2 = load i8, ptr %P.0, align 1		; <i8> [#uses=1]
	switch i8 %tmp2, label %bb4 [
		i8 12, label %bb
		i8 42, label %bb
	]

bb4:		; preds = %bb1
	%tmp3 = ptrtoint ptr %P.0 to i32		; <i32> [#uses=1]
	%tmp4 = sub i32 %tmp3, %tmp		; <i32> [#uses=1]
	%tmp5 = getelementptr [100 x i32], ptr @A, i32 0, i32 %tmp4		; <ptr> [#uses=1]
	store i32 4, ptr %tmp5, align 4
	ret ptr %P.0
}

declare i32 @foo(...)
