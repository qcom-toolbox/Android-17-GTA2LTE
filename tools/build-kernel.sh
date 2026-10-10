#!/bin/bash
#
# Rebuild prebuilt/Image and prebuilt/dt.img. The kernel is
# samsungexynos7870/android_kernel_samsung_exynos7870 (lineage-22.2) with
# patches/kernel/samsung/exynos7870 applied; the Android 17 tree has no
# GCC 4.9 for it, so it is built here and committed as a prebuilt.
#
#   tools/build-kernel.sh <kernel git dir> <aarch64-linux-android-4.9 bin dir>
#
# The build runs in-tree in a temporary clone, so no absolute source paths or
# local user/host names end up in the image.
set -e
src=$(realpath "$1")
cross=$(realpath "$2")/aarch64-linux-android-
here=$(dirname "$(realpath "$0")")/..
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

git clone -q --shared "$src" "$work/k"
cd "$work/k"
export KBUILD_BUILD_USER=builder KBUILD_BUILD_HOST=gtactive2lte
make ARCH=arm64 CROSS_COMPILE="$cross" exynos7870-gtactive2lte_defconfig
make ARCH=arm64 CROSS_COMPILE="$cross" -j"$(nproc)" Image
# rev00/02/03/04 dts, in the order of the stock DTBH table
revs="00 02 03 04"
for r in $revs; do
    make ARCH=arm64 CROSS_COMPILE="$cross" exynos7870-gtactive2lte_eur_open_$r.dtb
done
cp arch/arm64/boot/Image "$here/prebuilt/Image"
python3 "$here/tools/mkdtbh.py" -o "$here/prebuilt/dt.img" \
    $(for r in $revs; do echo "arch/arm64/boot/dts/exynos7870-gtactive2lte_eur_open_$r.dtb"; done)
