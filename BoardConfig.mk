#
# Copyright (C) 2019 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

LOCAL_PATH := device/samsung/gtactive2lte

# Samsung Galaxy Tab Active2 LTE (SM-T395), Exynos 7870
TARGET_OTA_ASSERT_DEVICE := gtactive2lte,gtactive2ltexx
TARGET_SCREEN_DENSITY := 213

# Audio: open-source HAL (hardware/audio-hal-samsung-hardware) driving the
# tablet's TFA9890 speaker amp (stock /vendor/etc/Tfa9890.cnt)
TARGET_AUDIOHAL_VARIANT := samsung-exynos7870
TARGET_SECRIL_VARIANT := samsung-exynos7870
BOARD_USE_SPKAMP := true
TARGET_BOARD_TFA_MODEL := 9890

# Bluetooth: QCA9377 "ROME" (stock vendor.qcom.bluetooth.soc=rome)
BOARD_HAVE_BLUETOOTH := true
BOARD_HAVE_BLUETOOTH_QCOM := true
BOARD_HAS_QCA_BT_ROME := true
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := $(LOCAL_PATH)/bluetooth

# Wi-Fi: QCA9377 SDIO, qcacld driver
BOARD_HAS_QCOM_WLAN := true
BOARD_WLAN_DEVICE := qcwcn
BOARD_HOSTAPD_DRIVER := NL80211
BOARD_HOSTAPD_PRIVATE_LIB := //hardware/qcom-caf/wlan/qcwcn:lib_driver_cmd_$(BOARD_WLAN_DEVICE)
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := //hardware/qcom-caf/wlan/qcwcn:lib_driver_cmd_$(BOARD_WLAN_DEVICE)
WIFI_DRIVER_FW_PATH_AP := "ap"
WIFI_DRIVER_FW_PATH_STA := "sta"
WIFI_DRIVER_FW_PATH_P2P := "p2p"
WPA_SUPPLICANT_VERSION := VER_0_8_X
WIFI_AVOID_IFACE_RESET_MAC_CHANGE := true

# Camera: S5K4H5YC rear, S5K5E3 front (stock setfile_4h5yc / setfile_5e3)
BOARD_BACK_CAMERA_ROTATION := 90
BOARD_FRONT_CAMERA_ROTATION := 270
BOARD_BACK_CAMERA_SENSOR := SENSOR_NAME_S5K4H5YC
BOARD_FRONT_CAMERA_SENSOR := SENSOR_NAME_S5K5E3
BOARD_SECURE_CAMERA_SENSOR := SENSOR_NAME_NOTHING
BOARD_SECURE_CAMERA_ROTATION := 0
BOARD_SECURE_CAMERA_SUPPORT := false
BOARD_CAMERA_DUAL_SUPPORT := false
BOARD_CAMERA2_API_SUPPORT := true
BOARD_CAMERA_SAMSUNG_TN_FEATURE := true
BOARD_CAMERA_HAL3_FEATURE := true

# USB
$(call soong_config_set,samsungUsbGadgetVars,gadget_name,13600000.dwc3)

# Graphics: the stock Mali gralloc only provides mapper 2.x; let libui use it
# (Android 17 otherwise requires gralloc 4+).
$(call soong_config_set_bool,libui,legacy_gralloc,true)

# The stock libion is a stub that always fails; the Exynos camera and JPEG
# HALs need the legacy /dev/ion implementation
$(call soong_config_set_bool,libion,legacy_impl,true)

# 32-bit userspace on an arm64 kernel: the HWC must use the kernel's 64-bit
# dma_addr_t in decon_win_config, or S3CFB_WIN_CONFIG's ioctl number (which
# encodes the struct size) doesn't match and the HWC aborts.
BOARD_USES_DECON_64BIT_ADDRESS := true

# VINTF
DEVICE_MANIFEST_FILE := $(LOCAL_PATH)/configs/manifest.xml
BUILD_BROKEN_VINTF_PRODUCT_COPY_FILES := true
BUILD_BROKEN_CLANG_PROPERTY := true
BUILD_BROKEN_CLANG_CFLAGS := true
BUILD_BROKEN_CLANG_ASFLAGS := true

# Include path
TARGET_SPECIFIC_HEADER_PATH := $(LOCAL_PATH)/include

BOARD_SUPPORTS_SOUND_TRIGGER := true

# AUDIO hal
BOARD_USE_ALP_AUDIO := false
BOARD_USE_SEIREN_AUDIO := false
BOARD_USE_COMMON_AUDIOHAL := true
BOARD_USE_SIPC_RIL := true
BOARD_USE_OFFLOAD_AUDIO := false
BOARD_USE_OFFLOAD_EFFECT := false
BOARD_USE_VNDSECRIL := true
BOARD_USE_SOUNDTRIGGER_HAL_EXYNOS := false

# misc
BUILD_BROKEN_DUP_RULES := true
# FaceUnlock only ships 64-bit libs; this is a 32-bit-only target
BUILD_BROKEN_MISSING_REQUIRED_MODULES := true
BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true
# Network Routing
TARGET_IGNORES_FTP_PPTP_CONNTRACK_FAILURE := true

# Firmware
TARGET_NO_BOOTLOADER := true
TARGET_NO_RADIOIMAGE := true

# Platform
BOARD_VENDOR := samsung
TARGET_BOOTLOADER_BOARD_NAME := exynos7870
TARGET_BOARD_PLATFORM := universal7870
TARGET_SOC := exynos7870
include hardware/samsung_slsi-linaro/config/BoardConfig7870.mk

# Architecture
# 32-bit userspace on the 64-bit kernel, like stock: the blobs come from the
# tablet's own firmware, which has no 64-bit libraries (Mali included).
TARGET_ARCH := arm
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := armeabi-v7a
TARGET_CPU_ABI2 := armeabi
TARGET_CPU_VARIANT := cortex-a53
TARGET_CPU_VARIANT_RUNTIME := cortex-a53
TARGET_CPU_ABI_LIST := armeabi-v7a,armeabi
TARGET_CPU_ABI_LIST_32_BIT := armeabi-v7a,armeabi

# Binder
TARGET_BOARD_SUFFIX := _32
BUILD_BROKEN_DUP_RULES := true
BUILD_BROKEN_USES_BUILD_COPY_HEADERS := true

# Boot image: v0 header with a separate Samsung DTBH dt.img, which AOSP
# mkbootimg can no longer write (see mkbootimg.mk, tools/mkbootimg_samsung.py).
BOARD_CUSTOM_BOOTIMG := true
BOARD_CUSTOM_BOOTIMG_MK := $(LOCAL_PATH)/mkbootimg.mk
BOARD_KERNEL_BASE := 0x10000000
BOARD_KERNEL_PAGESIZE := 2048
BOARD_KERNEL_IMAGE_NAME := Image
# Board name of the stock boot image
BOARD_NAME := SRPQE17A011RU
# Wi-Fi/BT firmware moves from /system/etc/firmware to /vendor/etc/firmware;
# the kernel's built-in search path only covers /etc/firmware.
BOARD_KERNEL_CMDLINE := firmware_class.path=/vendor/etc/firmware
BOARD_KERNEL_CMDLINE += androidboot.boot_devices=13540000.dwmmc0
# Bring-up only: the vendor policy is still incomplete
BOARD_KERNEL_CMDLINE += androidboot.selinux=permissive

# Kernel
# Built from kernel/samsung/exynos7870 (branch gtactive2lte) with GCC 4.9 by
# tools/build-kernel.sh, which this tree doesn't have; the source is still
# used for the userspace kernel headers.
TARGET_KERNEL_ARCH := arm64
TARGET_KERNEL_HEADER_ARCH := arm64
TARGET_LINUX_KERNEL_VERSION := 3.18
TARGET_KERNEL_SOURCE := kernel/samsung/exynos7870
TARGET_KERNEL_CONFIG := exynos7870-gtactive2lte_defconfig
TARGET_PREBUILT_KERNEL := $(LOCAL_PATH)/prebuilt/Image
TARGET_FORCE_PREBUILT_KERNEL := true
BOARD_PREBUILT_DT_IMAGE := $(LOCAL_PATH)/prebuilt/dt.img

# HIDL
DEVICE_MATRIX_FILE := $(LOCAL_PATH)/configs/compatibility_matrix.xml
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE := \
    $(LOCAL_PATH)/configs/device_framework_compatibility_matrix.xml
PRODUCT_ENFORCE_VINTF_MANIFEST_OVERRIDE := true

# Use these flags if the board has a ext4 partition larger than 2gb
BOARD_HAS_LARGE_FILESYSTEM := true
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true
TARGET_FS_CONFIG_GEN := $(LOCAL_PATH)/config.fs

# Partitions (sizes from the stock PIT, GTACTIVE2LTE_EUR_OPEN.pit)
# The tablet has no VENDOR partition and the PIT stays stock: /vendor lives
# on CACHE (200 MB) and /cache moves to HIDDEN (100 MB, Samsung preloads).
# product and system_ext are folded into the 3 GB SYSTEM partition.
BOARD_BOOTIMAGE_PARTITION_SIZE := 33554432
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 3221225472
BOARD_VENDORIMAGE_PARTITION_SIZE := 209715200
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_CACHEIMAGE_PARTITION_SIZE := 104857600
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_USERDATAIMAGE_PARTITION_SIZE := 11936989184
BOARD_FLASH_BLOCK_SIZE := 4096
BOARD_ROOT_EXTRA_FOLDERS := efs cpefs

# Vendor separation
TARGET_COPY_OUT_VENDOR := vendor
TARGET_COPY_OUT_PRODUCT := system/product
TARGET_COPY_OUT_SYSTEM_EXT := system/system_ext

# APEX
DEXPREOPT_GENERATE_APEX_IMAGE := true

# Audio
USE_XML_AUDIO_POLICY_CONF := 1
AUDIOSERVER_MULTILIB := 32
BOARD_SUPPORTS_SOUND_TRIGGER := true

# TFA98xx amplifier IC. Selects the source set built by hardware/amplifier
# (tfa9890/ or tfa9896/), the register map built into libtfa98xx_oss and the
# container file name (/vendor/etc/Tfa<TARGET_BOARD_TFA_MODEL>.cnt).
# Devices with a TFA9890 must override this to 9890.

# Backlight
BACKLIGHT_PATH := "/sys/class/backlight/panel/brightness"

# Camera
BOARD_USE_SAMSUNG_CAMERAFORMAT_NV21 := true
TARGET_USES_MEDIA_EXTENSIONS := true
USE_DEVICE_SPECIFIC_CAMERA := true

# DRM
TARGET_ENABLE_MEDIADRM_64 := true

# LIBHWJPEG
TARGET_USES_EXYNOS7870_LIBHWJPEG := true

# Libhwui
HWUI_COMPILE_FOR_PERF := true

#Offline charge
BOARD_CHARGING_MODE_BOOTING_LPM := "/sys/class/power_supply/battery/batt_lp_charging"
BOARD_CHARGER_SHOW_PERCENTAGE := true
CHARGING_ENABLED_PATH := "/sys/class/power_supply/battery/batt_lp_charging"

# Recovery
# Not built: sboot rejects ramdisks this large (a 14.7 MB one failed to boot);
# the tablet keeps the separate TWRP build (github qcom-toolbox TWRP_GTA2LTE).
TARGET_NO_RECOVERY := true
BOARD_USES_RECOVERY_AS_BOOT := false
AB_OTA_UPDATER := false
BOARD_HAS_DOWNLOAD_MODE := true

# RIL
BOARD_VENDOR := samsung
BOARD_MODEM_TYPE := tss310
BOARD_PROVIDES_LIBRIL := true
ENABLE_VENDOR_RIL_SERVICE := true
TARGET_USES_VND_SECRIL := true

# Security patch level
VENDOR_SECURITY_PATCH := 2020-12-05

# CURL
BOARD_USES_CURL := true

# Renderscript
OVERRIDE_RS_DRIVER := libRSDriverArm.so

# Seccomp
BOARD_SECCOMP_POLICY := $(LOCAL_PATH)/seccomp

# no need to set in for sepolicy_slsi_exynos7870
# BOARD_SEPOLICY_TEE_FLAVOR := mobicore
# only needed by livedisplay wich is labled inline
# include device/lineage/sepolicy/exynos/sepolicy.mk
include device/lineage/sepolicy/libperfmgr/sepolicy.mk
include device/samsung/gtactive2lte/sepolicy_slsi_exynos7870/sepolicy.mk
BOARD_SEPOLICY_DIRS += $(LOCAL_PATH)/sepolicy/vendor

# BOARD_SEPOLICY_VERS := $(PLATFORM_SDK_VERSION).0

# Treble
BOARD_PROPERTY_OVERRIDES_SPLIT_ENABLED := true
PRODUCT_FULL_TREBLE_OVERRIDE := true
PRODUCT_VENDOR_MOVE_ENABLED := true
BOARD_VNDK_VERSION := current
BOARD_USES_VENDORIMAGE := true

# Shim
TARGET_LD_SHIM_LIBS += \
    /system/bin/mediaserver|/system/lib/libstagefright_shim.so

# SELinux
# Bring-up: the kernel is built without SELINUX_ALWAYS_ENFORCE, so a
# userdebug build can boot permissive while the vendor policy is written.
SELINUX_IGNORE_NEVERALLOWS := true

# Wifi
BOARD_HAVE_SAMSUNG_WIFI := true
