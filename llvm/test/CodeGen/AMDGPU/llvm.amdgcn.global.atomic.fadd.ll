; RUN: llc < %s -mtriple=amdgcn -mcpu=gfx908 -verify-machineinstrs -amdgpu-atomic-optimizer-strategy=DPP | FileCheck %s -check-prefix=GCN
; RUN: llc < %s -mtriple=amdgcn -mcpu=gfx90a -verify-machineinstrs -amdgpu-atomic-optimizer-strategy=DPP | FileCheck %s -check-prefix=GCN

declare float @llvm.amdgcn.global.atomic.fadd.f32.p1.f32(ptr addrspace(1), float)
declare <2 x half> @llvm.amdgcn.global.atomic.fadd.v2f16.p1.v2f16(ptr addrspace(1), <2 x half>)
declare float @llvm.amdgcn.flat.atomic.fadd.f32.p0.f32(ptr, float)

; GCN-LABEL: {{^}}global_atomic_add_f32:
; GCN: global_atomic_add_f32 v{{[0-9]+}}, v{{[0-9]+}}, s{{\[[0-9]+:[0-9]+\]}}
define amdgpu_kernel void @global_atomic_add_f32(ptr addrspace(1) %ptr, float %data) {
main_body:
  %ret = call float @llvm.amdgcn.global.atomic.fadd.f32.p1.f32(ptr addrspace(1) %ptr, float %data)
  ret void
}

; GCN-LABEL: {{^}}global_atomic_add_f32_off4:
; GCN: global_atomic_add_f32 v{{[0-9]+}}, v{{[0-9]+}}, s{{\[[0-9]+:[0-9]+\]}} offset:4
define amdgpu_kernel void @global_atomic_add_f32_off4(ptr addrspace(1) %ptr, float %data) {
main_body:
  %p = getelementptr float, ptr addrspace(1) %ptr, i64 1
  %ret = call float @llvm.amdgcn.global.atomic.fadd.f32.p1.f32(ptr addrspace(1) %p, float %data)
  ret void
}

; GCN-LABEL: {{^}}global_atomic_add_f32_offneg4:
; GCN: global_atomic_add_f32 v{{[0-9]+}}, v{{[0-9]+}}, s{{\[[0-9]+:[0-9]+\]}} offset:-4
define amdgpu_kernel void @global_atomic_add_f32_offneg4(ptr addrspace(1) %ptr, float %data) {
main_body:
  %p = getelementptr float, ptr addrspace(1) %ptr, i64 -1
  %ret = call float @llvm.amdgcn.global.atomic.fadd.f32.p1.f32(ptr addrspace(1) %p, float %data)
  ret void
}

; GCN-LABEL: {{^}}global_atomic_pk_add_v2f16:
; GCN: global_atomic_pk_add_f16 v{{[0-9]+}}, v{{[0-9]+}}, s{{\[[0-9]+:[0-9]+\]$}}
define amdgpu_kernel void @global_atomic_pk_add_v2f16(ptr addrspace(1) %ptr, <2 x half> %data) {
main_body:
  %ret = call <2 x half> @llvm.amdgcn.global.atomic.fadd.v2f16.p1.v2f16(ptr addrspace(1) %ptr, <2 x half> %data)
  ret void
}

; GCN-LABEL: {{^}}global_atomic_pk_add_v2f16_off4:
; GCN: global_atomic_pk_add_f16 v{{[0-9]+}}, v{{[0-9]+}}, s{{\[[0-9]+:[0-9]+\]}} offset:4
define amdgpu_kernel void @global_atomic_pk_add_v2f16_off4(ptr addrspace(1) %ptr, <2 x half> %data) {
main_body:
  %p = getelementptr <2 x half>, ptr addrspace(1) %ptr, i64 1
  %ret = call <2 x half> @llvm.amdgcn.global.atomic.fadd.v2f16.p1.v2f16(ptr addrspace(1) %p, <2 x half> %data)
  ret void
}

; GCN-LABEL: {{^}}global_atomic_pk_add_v2f16_offneg4:
; GCN: global_atomic_pk_add_f16 v{{[0-9]+}}, v{{[0-9]+}}, s{{\[[0-9]+:[0-9]+\]}} offset:-4{{$}}
define amdgpu_kernel void @global_atomic_pk_add_v2f16_offneg4(ptr addrspace(1) %ptr, <2 x half> %data) {
main_body:
  %p = getelementptr <2 x half>, ptr addrspace(1) %ptr, i64 -1
  %ret = call <2 x half> @llvm.amdgcn.global.atomic.fadd.v2f16.p1.v2f16(ptr addrspace(1) %p, <2 x half> %data)
  ret void
}

; Make sure this artificially selects with an incorrect subtarget, but
; the feature set.
; GCN-LABEL: {{^}}global_atomic_fadd_f32_wrong_subtarget:
; GCN: global_atomic_add_f32 v{{[0-9]+}}, v{{[0-9]+}}, s{{\[[0-9]+:[0-9]+\]$}}
define amdgpu_kernel void @global_atomic_fadd_f32_wrong_subtarget(ptr addrspace(1) %ptr, float %data) #0 {
  %ret = call float @llvm.amdgcn.global.atomic.fadd.f32.p1.f32(ptr addrspace(1) %ptr, float %data)
  ret void
}

; GCN-LABEL: {{^}}flat_atomic_fadd_f32_wrong_subtarget:
; GCN: flat_atomic_add_f32 v{{\[[0-9]+:[0-9]+\]}}, v{{[0-9]+}}
define amdgpu_kernel void @flat_atomic_fadd_f32_wrong_subtarget(ptr %ptr, float %data) #1 {
  %ret = call float @llvm.amdgcn.flat.atomic.fadd.f32.p0.f32(ptr %ptr, float %data)
  ret void
}

attributes #0 = { "target-cpu"="gfx803" "target-features"="+atomic-fadd-no-rtn-insts"}
attributes #1 = { "target-cpu"="gfx803" "target-features"="+flat-atomic-fadd-f32-inst"}
