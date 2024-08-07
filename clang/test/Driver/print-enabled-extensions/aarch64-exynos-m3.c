// REQUIRES: aarch64-registered-target
// RUN: %clang --target=aarch64 --print-enabled-extensions -mcpu=exynos-m3 | FileCheck --strict-whitespace --implicit-check-not=FEAT_ %s

// CHECK: Extensions enabled for the given AArch64 target
// CHECK-EMPTY:
// CHECK-NEXT:     Architecture Feature(s)                                Description
// CHECK-NEXT:     FEAT_AES, FEAT_PMULL                                   Enable AES support
// CHECK-NEXT:     FEAT_AdvSIMD                                           Enable Advanced SIMD instructions
// CHECK-NEXT:     FEAT_CRC32                                             Enable ARMv8 CRC-32 checksum instructions
// CHECK-NEXT:     FEAT_FP                                                Enable ARMv8
// CHECK-NEXT:     FEAT_PMUv3                                             Enable Code Generation for ARMv8 PMUv3 Performance Monitors extension
// CHECK-NEXT:     FEAT_SHA1, FEAT_SHA256                                 Enable SHA1 and SHA256 support
