//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// UNSUPPORTED: no-threads

// <thread>

// void this_thread::yield();

#include <thread>
#include <cassert>

#include "test_macros.h"

int main(int, char**)
{
    std::this_thread::yield();

  return 0;
}
