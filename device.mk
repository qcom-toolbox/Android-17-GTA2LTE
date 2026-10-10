#
# Copyright (C) 2019-2023 The LineageOS Project
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

# Samsung Galaxy Tab Active2 LTE (SM-T395). Forked from the samsungexynos7870
# community universal7870-common tree (lineage-22.2) and the a3y17lte device
# (same QCA9377 Wi-Fi/BT); all proprietary files come from the tablet's own
# stock firmware (T395XXSDCUI7), see extract-files.sh.

# Shipped with Android 7.1 (stock ro.product.first_api_level=25)
PRODUCT_SHIPPING_API_LEVEL := 25

# Screen: 8" 800x1280 WXGA, mounted upside down (stock ro.sf.hwrotation=180)
TARGET_SCREEN_HEIGHT := 1280
TARGET_SCREEN_WIDTH := 800
PRODUCT_CHARACTERISTICS := tablet
PRODUCT_AAPT_CONFIG := normal large
PRODUCT_AAPT_PREF_CONFIG := tvdpi
PRODUCT_AAPT_PREBUILT_DPI := hdpi mdpi

# Audio: open-source HAL with the TFA9890 amplifier
TARGET_DEVICE_HAS_TFA_SEC_AUDIO_HAL := false
TARGET_DEVICE_HAS_SEC_AUDIO_HAL := false
TARGET_DEVICE_HAS_OSS_AUDIO_HAL := true
TARGET_DEVICE_HAS_TFA_AMP := true
TARGET_DEVICE_TFA_MODEL := 9890
TARGET_DEVICE_HAS_SEC_RIL := true
TARGET_DEVICE_HAS_SEC_GNSS := true

# First stage mount: /system and /vendor (CACHE) from the ramdisk fstab
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/etc/fstab.samsungexynos7870:$(TARGET_COPY_OUT_RAMDISK)/fstab.samsungexynos7870

# Bluetooth / Wi-Fi (QCA9377)
# wpa_supplicant/hostapd reach the driver lib by its full name (BoardConfig.mk)
PRODUCT_SOONG_NAMESPACES += \
    hardware/qcom-caf/wlan \
    hardware/qcom-caf/wlan/qcwcn

PRODUCT_PACKAGES += \
    android.hardware.bluetooth@1.0-impl \
    android.hardware.bluetooth@1.0-service \
    android.hardware.bluetooth@1.0.vendor \
    android.hardware.bluetooth.audio-impl \
    audio.bluetooth.default \
    libbt-vendor \
    wcnss_filter \
    init.qca9377_bt.rc \
    init.wifi_device.rc \
    mobicore.rc

PRODUCT_PACKAGES += \
    android.hardware.wifi-service-legacy \
    hostapd \
    libcld80211 \
    libwifi-hal \
    libwpa_client \
    wificond \
    wpa_supplicant \
    wpa_supplicant.conf

# NFC (Samsung S3NRN81)
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.nfc.hce.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.hce.xml \
    frameworks/native/data/etc/android.hardware.nfc.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.xml

PRODUCT_PACKAGES += \
    libnfc-nci \
    libnfc_nci_jni \
    Tag \
    com.android.nfc_extras \
    android.hardware.nfc@1.2.vendor \
    android.hardware.nfc@1.2-service.samsung

# Tablet
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/tablet_core_hardware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/tablet_core_hardware.xml
     
# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH) \
    hardware/lineage/interfaces/power-libperfmgr \
    hardware/google/pixel/power-libperfmgr \
    hardware/google/interfaces \
    hardware/google/pixel \
    hardware/samsung \
    hardware/ril \
    hardware/lineage/compat \
    vendor/samsung/gtactive2lte

# Product Characteristics

# Boot animation
TARGET_BOOTANIMATION_PRELOAD := true
TARGET_BOOTANIMATION_TEXTURE_CACHE := true

# APEX
OVERRIDE_PRODUCT_COMPRESSED_APEX := false

# Speed profile services and wifi-service to reduce RAM and storage.
PRODUCT_DEXPREOPT_SPEED_APPS += SystemUI  # For AOSP
PRODUCT_SYSTEM_SERVER_COMPILER_FILTER := speed-profile
PRODUCT_ALWAYS_PREOPT_EXTRACTED_APK := true

PRODUCT_ENFORCE_RRO_TARGETS := \
    framework-res

# Permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.audio.low_latency.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.low_latency.xml \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth_le.xml \
    frameworks/native/data/etc/android.hardware.camera.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.xml \
    frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.flash-autofocus.xml \
    frameworks/native/data/etc/android.hardware.camera.front.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.front.xml \
    frameworks/native/data/etc/android.hardware.camera.full.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.full.xml \
    frameworks/native/data/etc/android.hardware.camera.raw.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.raw.xml \
    frameworks/native/data/etc/android.hardware.ethernet.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.ethernet.xml \
    frameworks/native/data/etc/android.hardware.fingerprint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.fingerprint.xml \
    frameworks/native/data/etc/android.hardware.location.gps.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.location.gps.xml \
    frameworks/native/data/etc/android.hardware.opengles.aep.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.opengles.aep.xml \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.compass.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepcounter.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepcounter.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepdetector.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepdetector.xml \
    frameworks/native/data/etc/android.hardware.telephony.cdma.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.cdma.xml \
    frameworks/native/data/etc/android.hardware.telephony.gsm.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.gsm.xml \
    frameworks/native/data/etc/android.hardware.telephony.ims.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.ims.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.host.xml \
    frameworks/native/data/etc/android.hardware.vulkan.compute-0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.compute-0.xml \
    frameworks/native/data/etc/android.hardware.vulkan.level-0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.level-0.xml \
    frameworks/native/data/etc/android.hardware.vulkan.version-1_1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.version-1_1.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/android.hardware.wifi.passpoint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.passpoint.xml \
    frameworks/native/data/etc/android.software.midi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.midi.xml \
    frameworks/native/data/etc/android.software.print.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.print.xml \
    frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.sip.voip.xml \
    frameworks/native/data/etc/android.software.sip.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.sip.xml \
    frameworks/native/data/etc/com.android.nfc_extras.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.android.nfc_extras.xml \
    frameworks/native/data/etc/com.nxp.mifare.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.nxp.mifare.xml \
    frameworks/native/data/etc/android.hardware.vulkan.compute-0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.compute.xml \
    $(LOCAL_PATH)/configs/permissions/com.samsung.permission.SSENSOR.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.samsung.permission.SSENSOR.xml

# Audio common
PRODUCT_PACKAGES += \
    android.hardware.audio.service \
    android.hardware.audio@7.0-impl \
    android.hardware.audio.effect@7.0-impl \
    audio.usb.default \
    audio.r_submix.default \
    libtinycompress


ifeq ($(TARGET_DEVICE_HAS_TFA_SEC_AUDIO_HAL),true)
#PRODUCT_PACKAGES += \
#    libaudioroute_sec_helper
else ifeq ($(TARGET_DEVICE_HAS_SEC_AUDIO_HAL),true)
#PRODUCT_PACKAGES += \
#    libaudioroute_sec_helper    
else
ifeq ($(TARGET_DEVICE_HAS_OSS_AUDIO_HAL),true)
PRODUCT_PACKAGES += \
    audio.primary.exynos7870
ifeq ($(TARGET_DEVICE_HAS_TFA_AMP),true)
PRODUCT_PACKAGES += \
    audio_amplifier.exynos7870
endif
endif
endif


# Audio configuration
ifeq ($(TARGET_DEVICE_HAS_OSS_AUDIO_HAL),true)
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/audio/audio_policy_configuration_oss.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml \
    $(LOCAL_PATH)/configs/audio/mixer_paths.xml:$(TARGET_COPY_OUT_VENDOR)/etc/mixer_paths.xml
else
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/audio/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml
endif

#ifeq ($(TARGET_DEVICE_HAS_OSS_AUDIO_HAL),true)
#PRODUCT_PACKAGES += \
#    audio.primary.exynos7870_32
#
## Audio configuration OSS
#PRODUCT_COPY_FILES += \
#    $(LOCAL_PATH)/configs/audio/oss/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml \
#    $(LOCAL_PATH)/configs/audio/oss/audio_effects.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_effects.xml \
#    $(LOCAL_PATH)/configs/audio/oss/mixer_gains.xml:$(TARGET_COPY_OUT_VENDOR)/etc/mixer_gains.xml
#
#else
## Audio configuration for prebuilt samsung stock audio
#PRODUCT_COPY_FILES += \
#    $(LOCAL_PATH)/configs/audio/prebuilt/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml \
#    $(LOCAL_PATH)/configs/audio/prebuilt/audio_effects.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_effects.xml
#endif
#
#ifeq ($(TARGET_DEVICE_HAS_TFA_AMP),true)
#PRODUCT_PACKAGES += \
#    audio_amplifier.exynos7870_32
#endif

# Audio Permissions common
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/audio/audio_effects.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_effects.xml \
    frameworks/av/services/audiopolicy/config/a2dp_in_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/a2dp_in_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/bluetooth_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml \
    frameworks/av/services/audiopolicy/config/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml \
    frameworks/av/services/audiopolicy/config/bluetooth_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/usb_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/usb_audio_policy_configuration.xml

# Sound trigger
PRODUCT_PACKAGES += \
    android.hardware.soundtrigger@2.2-impl

# Camera
PRODUCT_PACKAGES += \
    android.hardware.camera.common@1.0-helper \
    android.hardware.camera.provider@2.4-impl \
    android.hardware.camera.provider@2.4-service \
    libion_exynos \
    libstagefright_shim \
    camera.exynos7870 \
    camera.vendor.exynos7870 \
    libexynoscamera \
    libexynoscamera3 \
    libcamera_metadata_helper \
    libcsc \
    libhwjpeg \
    libacryl \
    libGrallocWrapper \
    Camera2

PRODUCT_PACKAGES += \
    libexpat.vendor

PRODUCT_PACKAGES += \
    libssl \
    libssl.vendor

# MobiCore setup
PRODUCT_PACKAGES += \
	libMcClient \
	libMcRegistry \
	mcDriverDaemon

# Camera configurations
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/camera/external_camera_config.xml:$(TARGET_COPY_OUT_VENDOR)/etc/external_camera_config.xml

# Cas
PRODUCT_PACKAGES += \
    android.hardware.cas@1.2-service \
    android.hardware.cas@1.2 \
    android.hardware.cas@1.1
    
# OMX
PRODUCT_PACKAGES += \
    libstagefrighthw \
    libstagefright_softomx.vendor \
    libstagefright_softomx_plugin.vendor \
    libExynosOMX_Core \
    libExynosOMX_Resourcemanager \
    libOMX.Exynos.AVC.Decoder \
    libOMX.Exynos.AVC.Encoder \
    libOMX.Exynos.AVC.WFD.Encoder \
    libOMX.Exynos.HEVC.Decoder \
    libOMX.Exynos.HEVC.Encoder \
    libOMX.Exynos.HEVC.WFD.Encoder \
    libOMX.Exynos.MPEG4.Decoder \
    libOMX.Exynos.MPEG4.Encoder \
    libOMX.Exynos.VP8.Decoder \
    libOMX.Exynos.VP8.Encoder \
    libOMX.Exynos.VP9.Decoder \
    libOMX.Exynos.VP9.Encoder \
    libOMX.Exynos.WMV.Decoder

# SoundPicker
PRODUCT_PACKAGES += \
    SoundPicker

# Display
PRODUCT_PACKAGES += \
    android.hardware.graphics.allocator@2.0-impl \
    android.hardware.graphics.allocator@2.0-service  \
    android.hardware.graphics.composer@2.2-service  \
    android.hardware.graphics.mapper@2.0-impl-2.1 \
    android.hardware.renderscript@1.0-impl \
    gralloc.exynos7870 \
    hwcomposer.exynos7870 \
    libhwc2on1adapter \
    libhwc2onfbadapter \
    libtinyxml \
    libion

# Memtrack
PRODUCT_PACKAGES += \
    android.hardware.memtrack-service.samsung-mali

# VNDK
PRODUCT_PACKAGES += \
    libprotobuf-cpp-lite-v29 \
    libprotobuf-cpp-full-v29

# DRM - AIDL for Android 15
PRODUCT_PACKAGES += \
    android.hardware.drm-service.clearkey

# The Widevine HAL itself is a prebuilt blob and is linked against
# the vendor variants of drm@1.0/1.1/1.2, but on A15 only 1.4 vendor is kept
# for compatibility (like universal9611-common). Init rc files for widevine
# are now handled by AIDL.
PRODUCT_PACKAGES += \
    android.hardware.drm@1.4.vendor

# Init scripts for the prebuilt Widevine 1.2 service and for the Samsung
# key provisioning HAL (vendor.wvkprov_server_hal).
PRODUCT_PACKAGES += \
    android.hardware.drm@1.2-service.widevine.rc \
    vendor.samsung.hardware.security.widevine.keyprovisioning@1.0-service.rc

# WideVine DRM setup
PRODUCT_PROPERTY_OVERRIDES += \
     drm.service.enabled = true


# OMX
PRODUCT_PACKAGES += \
    android.hardware.media.omx@1.0-service \
    libstagefright_omx

# FastCharge

# Touch features

# FlipFlap
PRODUCT_PACKAGES += \
    FlipFlap

# Gatekeeper
# The hardware (TEE) gatekeeper requires a provisioned Root Encryption Key
# (tlApiDeriveKeyWithREK), which is only established by RootPA against the
# OEM/Trustonic Service Enabler and is therefore unavailable on custom
# builds. Since the keymaster is already the software implementation, use
# the software gatekeeper so lock screen credentials can be enrolled.
PRODUCT_PACKAGES += \
    android.hardware.gatekeeper@1.0-service.software

# Power - AIDL libperfmgr for Android 15 (pixel variant, samsung-libperfmgr removed in LOS 21+)
# RIL: data-only LTE with the newer Samsung RIL (radio HIDL 1.4) from the
# universal7870 common vendor tree; the tablet's own Android 9 RIL is 1.2.
PRODUCT_SOONG_NAMESPACES += \
    vendor/samsung/universal7870-common/radio

PRODUCT_PACKAGES += \
    libfloatingfeature \
    libril-samsung \
    libsec-ril \
    libsecnativefeature \
    vendor.samsung.hardware.radio@2.0_vendor \
    vendor.samsung.hardware.radio.bridge@2.0_vendor \
    vendor.samsung.hardware.radio.channel@2.0_vendor

# Wi-Fi: supplicant overlays (as on the A3); p2p_disabled=1 keeps P2P off
# wlan0 so the AIDL supplicant registers it as a STA interface
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/wifi/p2p_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/p2p_supplicant_overlay.conf \
    $(LOCAL_PATH)/configs/wifi/wpa_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wpa_supplicant_overlay.conf

# GPS: AOSP GNSS 1.0 HAL over the stock gps.default.so, plus a shim for the
# stock gpsd
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/etc/init.gps.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.gps.rc

PRODUCT_PACKAGES += \
    android.hardware.gnss@1.0-impl \
    android.hardware.gnss@1.0-service \
    libshim_gpsd

PRODUCT_PACKAGES += \
    android.hardware.power-service.lineage-libperfmgr

# Same SoC nodes as the A3 (checked on the tablet); without it HintManager
# init fails and the HAL aborts, leaving PowerManagerService waiting forever.
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/power/powerhint.json:$(TARGET_COPY_OUT_VENDOR)/etc/powerhint.json

# Configstore
PRODUCT_PACKAGES += \
    vndservicemanager

# Health - AIDL for Android 15
PRODUCT_PACKAGES += \
    android.hardware.health-service.samsung \
    android.hardware.health-service.samsung-recovery

# HIDL
PRODUCT_PACKAGES += \
    android.hidl.base@1.0 \
    libhidltransport \
    libhidltransport.vendor \
    libhwbinder \
    libhwbinder.vendor

# Keylayout
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/keylayout/gpio-keys.kl:$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/gpio-keys.kl \
    $(LOCAL_PATH)/configs/keylayout/gpio_keys.kl:$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/gpio_keys.kl \
    $(LOCAL_PATH)/configs/keylayout/sec_touchkey.kl:$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/sec_touchkey.kl \
    $(LOCAL_PATH)/configs/keylayout/sec_touchscreen.kl:$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/sec_touchscreen.kl

# Keymaster
PRODUCT_PACKAGES += \
    android.hardware.keymaster@4.1-service

# Lights
PRODUCT_PACKAGES += \
    android.hardware.light-service.samsung

# VNDK

# LiveDisplay

# OpenMAX IL configuration files
PRODUCT_COPY_FILES += \
    frameworks/av/media/libstagefright/data/media_codecs_google_video_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_video_le.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_audio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_audio.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_telephony.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_telephony.xml \
    $(LOCAL_PATH)/configs/media/media_codecs.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs.xml \
    $(LOCAL_PATH)/configs/media/media_codecs_performance.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_performance.xml \
    $(LOCAL_PATH)/configs/media/media_profiles_V1_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles_V1_0.xml

# Net
PRODUCT_PACKAGES += \
    android.system.net.netd@1.0 \
    libandroid_net \
    netutils-wrapper-1.0

# Offmode charger
PRODUCT_PACKAGES += \
    charger_res_images

# Overlays
DEVICE_PACKAGE_OVERLAYS += \
    $(LOCAL_PATH)/overlay

# public.libraries.txt
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/public.libraries.txt:$(TARGET_COPY_OUT_VENDOR)/etc/public.libraries.txt

# Radio
PRODUCT_PACKAGES += \
    android.hardware.radio@1.6.vendor \
    android.hardware.radio.config@1.2.vendor \
    android.hardware.radio.deprecated@1.0.vendor \
    cbd \
    libcutils_shim_vendor

PRODUCT_PACKAGES += \
    libprotobuf-cpp-full-vendorcompat \
    libprotobuf-cpp-lite-vendorcompat \
    libxml2 \
    libxml2.vendor


PRODUCT_PACKAGES += \
    libcrypto \
    libcrypto.vendor \
    libnetutils.vendor \
    librilutils \
    libsqlite.vendor

# Filesystem tools for resizing system partitions
PRODUCT_PACKAGES += \
    e2fsck_static

# Ramdisk
PRODUCT_PACKAGES += \
    fstab.samsungexynos7870 \
    init.baseband.rc \
    init.samsungexynos7870.rc \
    init.samsungexynos7870.usb.rc \
    init.wifi.rc \
    ueventd.samsungexynos7870.rc \
    init.vendor.rilchip.rc \
    init.vendor.rilcommon.rc

# Recorder
PRODUCT_PACKAGES += \
    Recorder

# SamsungDoze
PRODUCT_PACKAGES += \
    SamsungDoze

# Seccomp_policy
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/seccomp/mediacodec-seccomp.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediacodec.policy \
    $(LOCAL_PATH)/seccomp/mediaextractor-seccomp.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediaextractor.policy

# Sensors
PRODUCT_PACKAGES += \
    android.hardware.sensors@1.0-service.universal7870 \
    android.hardware.sensors@1.0-impl.universal7870 \
    libsensorndkbridge \
    libshim_sensorndkbridge

# Thermal
PRODUCT_PACKAGES += \
    thermal.exynos7870 \
    android.hardware.thermal@1.0-impl \
    android.hardware.thermal@1.0-service

# Touchscreen
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/idc/AVRCP.idc:$(TARGET_COPY_OUT_VENDOR)/usr/idc/AVRCP.idc \
    $(LOCAL_PATH)/configs/idc/qwerty.idc:$(TARGET_COPY_OUT_VENDOR)/usr/idc/qwerty.idc \
    $(LOCAL_PATH)/configs/idc/qwerty2.idc:$(TARGET_COPY_OUT_VENDOR)/usr/idc/qwerty2.idc

# Shims
PRODUCT_PACKAGES += \
    libexynoscamera_shim

# USB
PRODUCT_PACKAGES += \
    android.hardware.usb@1.3-service.basic

# Vibrator
PRODUCT_PACKAGES += \
    android.hardware.vibrator-service.samsung

# Vendor security patch level
PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.vendor_security_patch=2019-11-01

# GNSS
PRODUCT_PACKAGES += \
    android.frameworks.sensorservice@1.0.vendor \
    android.hardware.gnss@2.0.vendor

# VNDK
PRODUCT_PACKAGES += \
    libgui_vendor

# Wifi - macloader removed in LOS 22.2 (A15), no longer exists
# macloader was providing macloader binary from hardware/samsung/macloader
# which was removed upstream; MAC address handling now via init.

# WiFi Display
PRODUCT_PACKAGES += \
    libnl

# Properties
-include $(LOCAL_PATH)/vendor_prop.mk

# setup dalvik vm configs.
$(call inherit-product, frameworks/native/build/tablet-7in-xhdpi-2048-dalvik-heap.mk)

# call the proprietary setup
$(call inherit-product, vendor/samsung/gtactive2lte/gtactive2lte-vendor.mk)
