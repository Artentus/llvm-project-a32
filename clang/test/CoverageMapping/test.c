// RUN: %clang_cc1 -mllvm -emptyline-comment-coverage=false -fprofile-instrument=clang -fcoverage-mapping -dump-coverage-mapping -emit-llvm-only -main-file-name test.c %s | FileCheck %s

void bar(void);
static void static_func(void);

                                 // CHECK: main
int main(void) {                 // CHECK-NEXT: File 0, [[@LINE]]:16 -> [[@LINE+8]]:2 = #0
                                 // CHECK-NEXT: File 0, [[@LINE+2]]:18 -> [[@LINE+2]]:24 = (#0 + #1)
                                 // CHECK-NEXT: Branch,File 0, [[@LINE+1]]:18 -> [[@LINE+1]]:24 = #1, #0
  for(int i = 0; i < 10; ++i) {  // CHECK-NEXT: File 0, [[@LINE]]:26 -> [[@LINE]]:29 = #1
    bar();                       // CHECK: File 0, [[@LINE-1]]:31 -> [[@LINE+1]]:4 = #1
  }
  static_func();
  return 0;
}

                                 // CHECK-NEXT: foo
void foo(void) {                 // CHECK-NEXT: File 0, [[@LINE]]:16 -> [[@LINE+5]]:2 = #0
                                 // CHECK-NEXT: File 0, [[@LINE+1]]:6 -> [[@LINE+1]]:7 = #0
  if(1) {                        // CHECK: File 0, [[@LINE]]:9 -> [[@LINE+2]]:4 = #1
    int i = 0;
  }
}

                                 // CHECK-NEXT: bar
void bar(void) {                 // CHECK-NEXT: File 0, [[@LINE]]:16 -> [[@LINE+1]]:2 = #0
}

                                 // CHECK-NEXT: static_func
void static_func(void) { }       // CHECK: File 0, [[@LINE]]:24 -> [[@LINE]]:27 = #0

                                 // CHECK-NEXT: func
static void func(void) { }       // CHECK: File 0, [[@LINE]]:24 -> [[@LINE]]:27 = 0
