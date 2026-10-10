#!/bin/bash
#
# Flash an Android 17 build onto the SM-T395 from TWRP (adb root shell).
#
#   flash.sh <out/target/product/gtactive2lte>
#
# Layout (stock PIT): BOOT <- boot.img, SYSTEM <- system.img,
# CACHE <- vendor.img, HIDDEN formatted as /cache, USERDATA formatted.
# RECOVERY is left alone (TWRP).
set -euo pipefail

out=$(realpath "$1")
blk=/dev/block/platform/13540000.dwmmc0/by-name
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

[ "$(adb get-state)" = recovery ] || { echo "tablet not in recovery"; exit 1; }

# Unsparse if needed; dd needs raw images
raw() {
    if file -b "$1" | grep -q "Android sparse"; then
        simg2img "$1" "$work/$(basename "$1").raw"
        echo "$work/$(basename "$1").raw"
    else
        echo "$1"
    fi
}

write() {   # write <image> <partition>
    local img size want got
    img=$(raw "$1")
    size=$(stat -c %s "$img")
    want=$(sha256sum "$img" | cut -d' ' -f1)
    echo ">> $2 <- $(basename "$1") ($size bytes)"
    adb shell "dd of=$blk/$2 bs=1048576" < "$img"
    adb shell sync
    # toybox head fails on multi-GB reads; dd handles them
    if (( size % 4096 == 0 )); then
        got=$(adb shell "dd if=$blk/$2 bs=4096 count=$((size / 4096)) 2>/dev/null | sha256sum" | cut -d' ' -f1)
    else
        got=$(adb shell "head -c $size $blk/$2 | sha256sum" | cut -d' ' -f1)
    fi
    [ "$want" = "$got" ] || { echo "!! $2 verify failed ($got != $want)"; exit 1; }
    echo "   verified"
}

for f in boot.img system.img vendor.img; do
    [ -f "$out/$f" ] || { echo "missing $out/$f"; exit 1; }
done

adb shell 'umount /system /vendor /cache /data /system_root 2>/dev/null; true'
write "$out/boot.img" BOOT
write "$out/system.img" SYSTEM
write "$out/vendor.img" CACHE

echo ">> formatting HIDDEN (/cache) and USERDATA (/data)"
adb shell "mke2fs -t ext4 -F $blk/HIDDEN"
# leave the last 16 KB (fstab length=-16384)
blocks=$(( $(adb shell "blockdev --getsize64 $blk/USERDATA" | tr -d '\r') / 4096 - 4 ))
# TWRP's mke2fs enables quota+project on large filesystems; 3.18 refuses
# to mount those read-write
adb shell "mke2fs -t ext4 -F -b 4096 -O ^quota,^project $blk/USERDATA $blocks"
echo "done; reboot with: adb reboot"
