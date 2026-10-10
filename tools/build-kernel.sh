#!/bin/bash
#
# Rebuild prebuilt/Image and prebuilt/dt.img from kernel/samsung/exynos7870
# (branch gtactive2lte). The Android 17 tree has no GCC, and this 3.18
# kernel needs it, so the kernel is built here and committed as a prebuilt.
#
#   tools/build-kernel.sh <android tree> <aarch64-linux-android-4.9 bin dir>
#
set -e
top=$(realpath "$1")
cross=$(realpath "$2")/aarch64-linux-android-
here=$(dirname "$(realpath "$0")")/..
src=$top/kernel/samsung/exynos7870
out=$top/out/kernel-gtactive2lte

make -C "$src" O="$out" ARCH=arm64 CROSS_COMPILE="$cross" exynos7870-gtactive2lte_defconfig
make -C "$src" O="$out" ARCH=arm64 CROSS_COMPILE="$cross" -j"$(nproc)" Image
# rev00/02/03/04 dts, in the order of the stock DTBH table
revs="00 02 03 04"
for r in $revs; do
    make -C "$src" O="$out" ARCH=arm64 CROSS_COMPILE="$cross" exynos7870-gtactive2lte_eur_open_$r.dtb
done
cp "$out/arch/arm64/boot/Image" "$here/prebuilt/Image"
python3 "$here/tools/mkdtbh.py" -o "$here/prebuilt/dt.img" \
    $(for r in $revs; do echo "$out/arch/arm64/boot/dts/exynos7870-gtactive2lte_eur_open_$r.dtb"; done)
