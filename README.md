# Android 17 for the Galaxy Tab Active2 LTE (SM-T395)

Device tree for an Evolution X (Android 17, LineageOS based) build of the
Samsung Galaxy Tab Active2 LTE, `gtactive2lte`, Exynos 7870, 32-bit userspace.

The recovery used to flash it lives in its own repo:
[TWRP_GTA2LTE](https://github.com/qcom-toolbox/TWRP_GTA2LTE/tree/android17-layout), branch `android17-layout`.

## Status

| Works | Notes |
| --- | --- |
| Boot, display, rotation | Panel is mounted upside down (`ORIENTATION_180`) |
| Touch, S Pen | Survive screen off/on |
| LTE data | Single SIM, community RIL blobs; no voice/SMS |
| Wi-Fi | QCA9377, AIDL HAL |
| Bluetooth | A2DP, AVRCP, HID, PAN, OPP, PBAP |
| GPS | AOSP GNSS 1.0 HAL over the stock `gpsd` |
| Camera | Front and back |
| Hardware keys | Recents key mapped to `RECENT_APPS` |
| Speaker | TFA9890 amplifier |

## Installing

Download `boot.img`, `system.img.xz` and `vendor.img.xz` from the
[latest release](https://github.com/qcom-toolbox/ROM_GTA2LTE/releases/latest),
check them against `SHA256SUMS`, and unpack the two `.xz` files
(`xz -d`) into one directory. Boot
[TWRP](https://github.com/qcom-toolbox/TWRP_GTA2LTE/tree/android17-layout) (the `android17-layout` branch), then:

    tools/flash.sh <that directory>

**This wipes the tablet.** Back up first, and keep the stock firmware
around so you can go back with Odin.

## Known limitations

- No voice calls or SMS, only mobile data.
- The build is `userdebug` signed with the public test keys.
- No `adb root` (`ro.debuggable=0`).

## Partition layout

The stock PIT is kept. The bootloader passes its own cmdline (SELinux is
enforcing).

| Partition | Holds |
| --- | --- |
| BOOT | `boot.img` |
| SYSTEM | `system.img` |
| CACHE | `vendor.img` |
| HIDDEN | `/cache` |
| USERDATA | `/data` (ext4 without `quota`/`project`; the 3.18 kernel can't mount those read-write) |

## Building

1. Sync Evolution X and put this repo at `device/samsung/gtactive2lte`, along
   with the `samsungexynos7870` common repos (kernel, `hardware/samsung_slsi-linaro`,
   `vendor/samsung/universal7870-common`).
2. Apply the patches to the rest of the tree:

       device/samsung/gtactive2lte/tools/apply-patches.sh

   | Tree | Why |
   | --- | --- |
   | `kernel/samsung/exynos7870` | Defconfig, SELinux netlink xperms, uname override for bpfloader, compat bpf syscall, bpffs `renameat2`, touch/S Pen across blank, no RT group scheduling |
   | `hardware/samsung_slsi-linaro/exynos` | Sensor infos for the S5K4H5YC and S5K5E3 cameras |
   | `hardware/samsung_slsi-linaro/graphics` | Build fix |
   | `system/core` | No cgroup v2; reboot to recovery without a misc partition |
   | `frameworks/base` | Don't abort without per-app process groups |
   | `build/make` | `TARGET_HEALTH_SKIP_BPF_FILTER` |
   | `vendor/lineage` | Build manifest fallback |

3. Extract the proprietary files from the tablet (stock T395XXSDCUI7) into
   `vendor/samsung/gtactive2lte`:

       ./extract-files.py <path to stock dump>

4. Build the kernel, then the images:

       tools/build-kernel.sh <kernel dir> <aarch64-linux-android-4.9 bin dir>
       lunch lineage_gtactive2lte-<release>-userdebug
       m bootimage systemimage vendorimage

## Flashing

Boot TWRP, then:

    tools/flash.sh out/target/product/gtactive2lte

This writes and verifies boot, system and vendor. **It also formats /cache
and /data.**

## Credits

- [samsungexynos7870](https://github.com/samsungexynos7870): the
  universal7870-common and a3y17lte trees this is based on, the kernel with
  backported eBPF, and the `hardware/samsung_slsi-linaro` repos
- [LineageOS](https://github.com/LineageOS) and
  [Evolution X](https://github.com/Evolution-X)
- Pierre-Hugues Husson (phh) for the cgroup v2 `system/core` patch
- The Android Open Source Project
- NXP for the TFA98xx amplifier code

## License

Apache License 2.0, see [LICENSE](LICENSE). The kernel and the kernel
patches are GPL-2.0. [NOTICE](NOTICE) lists the exceptions and where the
prebuilt kernel's source is.

This software comes with no warranty. Flashing it may brick your device or
void its warranty. Samsung and Galaxy are trademarks of Samsung Electronics;
this project is not affiliated with Samsung.
