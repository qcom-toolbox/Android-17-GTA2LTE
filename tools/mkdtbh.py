#!/usr/bin/env python3
#
# Copyright (C) 2026 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#
# Pack DTBs into the Samsung Exynos "DTBH" dt.img the bootloader picks from
# by hw_rev. Table values come from the stock SM-T395 dt.img: one fixed
# 0x1f000 slot per board revision.

import argparse
import struct

CHIP, PLATFORM, SUBTYPE = 7870, 20646, 561349850
REVS = [(0, 1), (2, 2), (3, 3), (4, 255)]   # rev00, rev02, rev03, rev06+
SLOT, PAGE, SPACE = 126976, 2048, 32


def main():
    p = argparse.ArgumentParser()
    p.add_argument('-o', '--output', required=True)
    p.add_argument('dtbs', nargs=len(REVS))
    a = p.parse_args()

    head = struct.pack('<4sII', b'DTBH', 2, len(REVS))
    body = b''
    for i, (dtb, (rev, rev_end)) in enumerate(zip(a.dtbs, REVS)):
        data = open(dtb, 'rb').read()
        if len(data) > SLOT:
            raise SystemExit(f'{dtb}: {len(data)} bytes, slot is {SLOT}')
        head += struct.pack('<8I', CHIP, PLATFORM, SUBTYPE, rev, rev_end,
                            PAGE + i * SLOT, SLOT, SPACE)
        body += data + b'\0' * (SLOT - len(data))
    with open(a.output, 'wb') as f:
        f.write(head + b'\0' * (PAGE - len(head)) + body)


if __name__ == '__main__':
    main()
