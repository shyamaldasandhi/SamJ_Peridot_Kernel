#!/usr/bin/env bash

# ─── CONFIG ─────────────────────────────────────────────────────────────────────

export PATH="$HOME/tc/clang/bin:$PATH"
export LD_LIBRARY_PATH="$HOME/tc/clang/lib64:$LD_LIBRARY_PATH"

OUT_DIR="out"
DEFCONFIG="peridot_defconfig"
KCFLAGS_OPTIMIZATION="-O3"
JOBS=$(nproc)

ARGS=(
    ARCH=arm64
    O="$OUT_DIR"
    CC="ccache clang"
    LD=ld.lld
    CLANG_TRIPLE=aarch64-linux-gnu-
    CROSS_COMPILE=aarch64-linux-gnu-
    CROSS_COMPILE_COMPAT=arm-linux-gnueabi-
    -j"$JOBS"
)

# ─── BUILD ──────────────────────────────────────────────────────────────────────

make "${ARGS[@]}" "$DEFCONFIG"
make -C "$OUT_DIR" "${ARGS[@]}" HOSTCC="ccache gcc" HOSTCXX="ccache g++" olddefconfig
make "${ARGS[@]}" KCFLAGS="$KCFLAGS_OPTIMIZATION" Image.gz