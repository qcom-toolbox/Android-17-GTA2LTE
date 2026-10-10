#
# Copyright (C) 2026 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#
# Boot image for Samsung Exynos sboot: v0 header carrying a separate DTBH
# dt.img, plus the SEANDROIDENFORCE trailer (tools/mkbootimg_samsung.py).

MKBOOTIMG_SAMSUNG := $(TARGET_DEVICE_DIR)/tools/mkbootimg_samsung.py

$(INSTALLED_BOOTIMAGE_TARGET): $(MKBOOTIMG_SAMSUNG) $(INSTALLED_KERNEL_TARGET) \
		$(INSTALLED_RAMDISK_TARGET) $(BOARD_PREBUILT_DT_IMAGE)
	$(call pretty,"Target boot image: $@")
	$(hide) python3 $(MKBOOTIMG_SAMSUNG) \
		--kernel $(INSTALLED_KERNEL_TARGET) \
		--ramdisk $(INSTALLED_RAMDISK_TARGET) \
		--dt $(BOARD_PREBUILT_DT_IMAGE) \
		--cmdline "$(strip $(BOARD_KERNEL_CMDLINE))" \
		--board $(BOARD_NAME) \
		--base $(BOARD_KERNEL_BASE) \
		--pagesize $(BOARD_KERNEL_PAGESIZE) \
		--os_version $(PLATFORM_VERSION_LAST_STABLE) \
		--os_patch_level $(PLATFORM_SECURITY_PATCH) \
		--output $@
	$(hide) $(call assert-max-image-size,$@,$(BOARD_BOOTIMAGE_PARTITION_SIZE),raw)
	@echo "Made boot image: $@"
