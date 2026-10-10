#!/usr/bin/env python3
#
# Copyright (C) 2026 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#
# Boot image v0 with a separate DT image, as Samsung's Exynos sboot expects:
# the header_version slot holds the dt.img size and dt.img follows the
# (empty) second stage. AOSP mkbootimg dropped --dt, so pack it here.
# Appends the SEANDROIDENFORCE trailer the stock images carry.

import argparse
import hashlib
import struct

BOOT_MAGIC = b'ANDROID!'


def parse_int(x):
    return int(x, 0)


def os_version_field(version, patch_level):
    a, b, c = (int(v) for v in (version.split('.') + ['0', '0'])[:3])
    y, m = (int(v) for v in patch_level.split('-')[:2])
    return (a << 25) | (b << 18) | (c << 11) | ((y - 2000) << 4) | m


def pad(data, page):
    return data + b'\0' * ((page - len(data) % page) % page)


def main():
    p = argparse.ArgumentParser()
    p.add_argument('--kernel', required=True)
    p.add_argument('--ramdisk', required=True)
    p.add_argument('--dt', required=True)
    p.add_argument('--cmdline', default='')
    p.add_argument('--board', default='')
    p.add_argument('--base', type=parse_int, default=0x10000000)
    p.add_argument('--kernel_offset', type=parse_int, default=0x00008000)
    p.add_argument('--ramdisk_offset', type=parse_int, default=0x01000000)
    p.add_argument('--second_offset', type=parse_int, default=0x00f00000)
    p.add_argument('--tags_offset', type=parse_int, default=0x00000100)
    p.add_argument('--pagesize', type=parse_int, default=2048)
    p.add_argument('--os_version', default='0.0.0')
    p.add_argument('--os_patch_level', default='2000-01-01')
    p.add_argument('-o', '--output', required=True)
    a = p.parse_args()

    kernel = open(a.kernel, 'rb').read()
    ramdisk = open(a.ramdisk, 'rb').read()
    dt = open(a.dt, 'rb').read()
    cmdline = a.cmdline.encode()
    if len(cmdline) > 512 + 1024 - 2:
        raise SystemExit('cmdline too long')

    sha = hashlib.sha1()
    for blob in (kernel, ramdisk, b'', dt):
        sha.update(blob)
        sha.update(struct.pack('<I', len(blob)))

    header = struct.pack(
        '<8s10I16s512s32s1024s',
        BOOT_MAGIC,
        len(kernel), a.base + a.kernel_offset,
        len(ramdisk), a.base + a.ramdisk_offset,
        0, a.base + a.second_offset,
        a.base + a.tags_offset,
        a.pagesize,
        len(dt),
        os_version_field(a.os_version, a.os_patch_level),
        a.board.encode(),
        cmdline[:512],
        sha.digest(),
        cmdline[512:])

    with open(a.output, 'wb') as f:
        for blob in (header, kernel, ramdisk, dt):
            f.write(pad(blob, a.pagesize))
        f.write(b'SEANDROIDENFORCE')


if __name__ == '__main__':
    main()
