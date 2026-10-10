#!/usr/bin/env -S PYTHONPATH=../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#
# Every blob comes from the tablet's own stock firmware (SM-T395,
# T395XXSDCUI7, Android 9): pass the unpacked dump with as the source argument, with the system
# image at <dump>/system and its /vendor folder at <dump>/vendor.

from extract_utils.fixups_blob import (
    blob_fixup,
    blob_fixups_user_type,
)
from extract_utils.main import (
    ExtractUtils,
    ExtractUtilsModule,
)

blob_fixups: blob_fixups_user_type = {
    # The Android 9 copy links libandroid.so, which vendor code cannot load;
    # libsensorndkbridge + its shim provide the ASensor/ALooper calls it uses
    'vendor/lib/libsensorlistener.so': blob_fixup()
        .replace_needed('libandroid.so', 'libsensorndkbridge.so')
        .add_needed('libshim_sensorndkbridge.so'),
    # Stock rild against the newer Samsung libril (radio 1.4), which also
    # exports rilc_configure_thread_pool
    'vendor/bin/hw/rild': blob_fixup()
        .replace_needed('libril.so', 'libril-samsung.so'),
}

module = ExtractUtilsModule(
    'gtactive2lte',
    'samsung',
    # Android 9 blobs on Android 17: missing dependencies are tracked at
    # runtime during bring-up rather than failing the build.
    check_elf=False,
    blob_fixups=blob_fixups,
)

if __name__ == '__main__':
    utils = ExtractUtils.device(module)
    utils.run()
