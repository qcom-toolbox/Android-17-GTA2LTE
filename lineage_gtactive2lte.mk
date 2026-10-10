#
# Copyright (C) 2026 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# The 3.18 eBPF backport's verifier rejects libhealthloop's uevent filter,
# which the vendor BPF loader treats as fatal; healthd runs without it.
TARGET_HEALTH_SKIP_BPF_FILTER := true

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/aosp_base.mk)

# Evolution X: vanilla, 32-bit userspace, Mali-T830.
# Must be set before common_full_tablet.mk: it evaluates these (?=, ifeq).
EVO_BUILD_TYPE := Unofficial
WITH_GMS := false
TARGET_SCREEN_WIDTH := 800
TARGET_SCREEN_HEIGHT := 1280
TARGET_SUPPORTS_QUICK_TAP := false
TARGET_SUPPORTS_GFU := false
TARGET_ENABLE_BLUR := false
# Report the real tablet, not Evolution's Pixel fingerprint spoof
TARGET_ENABLE_FP_OVERRIDE := false

# Lineage / Evolution X stuff
$(call inherit-product, vendor/lineage/config/common_full_tablet.mk)

# Skip Qualcomm SoC trees in soong analysis (saves RAM); keep the wlan
# trees, the QCA9377 Wi-Fi uses them
PRODUCT_SOURCE_ROOT_DIRS += \
    -device/qcom \
    -vendor/qcom \
    -hardware/qcom/sm7250 \
    -hardware/qcom/sm8150 \
    -hardware/qcom-caf/bootctrl \
    -hardware/qcom-caf/msm8953 \
    -hardware/qcom-caf/msm8996 \
    -hardware/qcom-caf/sdm660 \
    -hardware/qcom-caf/sm8150 \
    -hardware/qcom-caf/sm8250 \
    -hardware/qcom-caf/sm8350 \
    -hardware/qcom-caf/sm8450 \
    -hardware/qcom-caf/sm8450-6.6 \
    -hardware/qcom-caf/sm8550 \
    -hardware/qcom-caf/sm8650 \
    -hardware/qcom-caf/sm8750 \
    -hardware/qcom-caf/sm8850 \
    -hardware/qcom-caf/thermal \
    -hardware/qcom-caf/thermal-legacy-um

# Unused Exynos BSP modules that depend on interfaces Android 17 removed
PRODUCT_SOURCE_ROOT_DIRS += \
    -hardware/samsung_slsi-linaro/exynos/dumpstate


# Inherit from the device makefile
$(call inherit-product, $(LOCAL_PATH)/device.mk)

# Device identifier. This must come after all inclusions.
PRODUCT_NAME := lineage_gtactive2lte
PRODUCT_DEVICE := gtactive2lte
PRODUCT_BRAND := samsung
PRODUCT_MODEL := SM-T395
PRODUCT_MANUFACTURER := samsung

PRODUCT_BUILD_PROP_OVERRIDES += \
    SystemDevice=gtactive2lte \
    SystemName=gtactive2ltexx

PRODUCT_GMS_CLIENTID_BASE := android-samsung
