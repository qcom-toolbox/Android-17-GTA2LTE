#!/bin/bash
#
# Apply this device's patches to the rest of the source tree.
#
#   tools/apply-patches.sh [android root]
#
# patches/<path>/NNNN-*.patch is applied with `git am` in <android root>/<path>.
set -eu

dev=$(cd "$(dirname "$0")/.." && pwd)
root=$(realpath "${1:-$dev/../../..}")

cd "$dev/patches"
for dir in $(find . -name '*.patch' -printf '%h\n' | sort -u); do
    echo ">> ${dir#./}"
    git -C "$root/$dir" am -3 --keep-cr "$dev/patches/$dir"/*.patch
done
