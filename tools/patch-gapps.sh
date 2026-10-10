#!/bin/bash
#
# Make a MindTheGapps-style zip installable from this tablet's TWRP:
#  - TWRP's fstab lists the mount point first, so the installer can't find
#    SYSTEM: fall back to it by name
#  - TWRP runs an arm64 kernel under a 32-bit ROM: if the installer compares
#    `uname -m` with the package arch, skip that check
#
#   tools/patch-gapps.sh <gapps zip>
#
# Writes <name>-gtactive2lte.zip next to the input.
set -euo pipefail
in=$(realpath "$1")
out=${in%.zip}-gtactive2lte.zip
bin=META-INF/com/google/android/update-binary
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

cp "$in" "$out"
cd "$work"
unzip -q "$in" "$bin"
sed -i 's|^CPU_ARCH=$(uname -m)$|CPU_ARCH=$GAPPS_ARCH|' "$bin"
sed -i 's|^SYSTEM_BLOCK=$(find_block "system")$|&\n[ -z "$SYSTEM_BLOCK" ] \&\& SYSTEM_BLOCK=$(ls /dev/block/platform/*/by-name/SYSTEM \| head -n1)|' "$bin"
grep -q 'by-name/SYSTEM' "$bin" ||
    { echo "unexpected update-binary, not patched" >&2; rm -f "$out"; exit 1; }
zip -q "$out" "$bin"
echo "$out"
