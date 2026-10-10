# Low memory optimization
# PRODUCT_PROPERTY_OVERRIDES += \
#    ro.config.low_ram=true

# Audio
PRODUCT_PROPERTY_OVERRIDES += \
    af.fast_track_multiplier=1 \
    audio_hal.force_voice_config=wide

#(OSS audio hal only) use it when faceing call
# echo with your device to avoid quit mics on other devices
# TODO: move that thing to device speciffic props
#PRODUCT_PROPERTY_OVERRIDES += \
#    audio_hal.disable_two_mic=true

# Bluetooth
PRODUCT_PROPERTY_OVERRIDES += \
    ro.bt.bdaddr_path=/efs/bluetooth/bt_addr

# Charger
PRODUCT_PRODUCT_PROPERTIES += \
    ro.charger.enable_suspend=true

# Dalvik/Art
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.dex2oat-filter=speed \
    dalvik.vm.image-dex2oat-filter=speed \
    ro.sys.fw.dex2oat_thread_count=8 \
    dalvik.vm.boot-dex2oat-threads=8 \
    dalvik.vm.dex2oat-threads=8 \
    dalvik.vm.heapstartsize=8m \
    dalvik.vm.heapgrowthlimit=192m \
    dalvik.vm.heapsize=512m \
    dalvik.vm.heaptargetutilization=0.75 \
    dalvik.vm.heapminfree=512k \
    dalvik.vm.heapmaxfree=8m

# Do not update the recovery image
PRODUCT_PROPERTY_OVERRIDES += \
    persist.vendor.recovery_update=false

# FIFO UI scheduling
PRODUCT_PROPERTY_OVERRIDES += \
    sys.use_fifo_ui=1

# Graphics
PRODUCT_PROPERTY_OVERRIDES += \
    ro.opengles.version=196610 \
    ro.hardware.egl=mali \
    debug.hwc.skip_dma_types=0,2 \
    debug.renderengine.backend=gles
    
# HWUI
PRODUCT_PROPERTY_OVERRIDES += \
    debug.hwui.skia_atrace_enabled=false \
    debug.hwui.use_buffer_age=false

# SurfaceFlinger
PRODUCT_PROPERTY_OVERRIDES += \
    ro.surface_flinger.max_frame_buffer_acquired_buffers=3

# Nfc
PRODUCT_PROPERTY_OVERRIDES += \
    ro.nfc.port=I2C \
    ro.nfc.sec_hal=true

# Radio
PRODUCT_PROPERTY_OVERRIDES += \
    persist.radio.sib16_support=0 \
    ro.ril.hsxpa=1 \
    ro.ril.gprsclass=10 \
    ro.ril.telephony.mqanelements=6 \
    ro.telephony.default_network=9 \
    ro.telephony.get_imsi_from_sim=true \
    ro.ril.force_eri_from_xml=true \
    persist.radio.add_power_save=1 \
    persist.radio.apm_sim_not_pwdn=1 \
    ro.smps.enable=true \
    telephony.lteOnCdmaDevice=0 \

#Treble
PRODUCT_PROPERTY_OVERRIDES += \
    persist.media.treble_omx=true

# sdcardfs
PRODUCT_PROPERTY_OVERRIDES += \
    ro.sys.sdcardfs=true

# LiveDisplay
PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.sf.color_mode=0

# mediacodec cameraserver race workaround
PRODUCT_PROPERTY_OVERRIDES += \
    debug.fdsan=warn_once

# Bpf: 3.18 kernel with eBPF backported, reporting 4.9 in uname.
# Opts in to NetBpfLoad/netd's legacy-kernel path (as on dandelion).
PRODUCT_SYSTEM_PROPERTIES += \
	ro.bpf.allow_legacy_kernel=true

# Bluetooth: QCA9377 ROME on UART (as stock); without it libbt-vendor
# assumes an SMD (Pronto) SoC and waits for /dev/smd3
PRODUCT_VENDOR_PROPERTIES += \
    vendor.qcom.bluetooth.soc=rome

# The ROME firmware advertises Google LE vendor capabilities but answers the
# APCF (LE_ADV_FILTER, 0xfd57) command with a bogus opcode, which aborts the
# Bluetooth stack; don't use the vendor LE extensions.
PRODUCT_VENDOR_PROPERTIES += \
    bluetooth.core.le.vendor_capabilities.enabled=false

# Advertise as a tablet (major Computer, minor Tablet) so phones show it as a
# device instead of an unknown Bluetooth thing; Android leaves it empty.
PRODUCT_VENDOR_PROPERTIES += \
    bluetooth.device.class_of_device=90,1,28

# Android 13+ only starts the profiles listed here; without them the stack
# runs GATT alone and phones see a bare BLE device. No HFP/MAP/SAP: the
# tablet has no voice or SMS.
PRODUCT_VENDOR_PROPERTIES += \
    bluetooth.profile.a2dp.source.enabled=true \
    bluetooth.profile.avrcp.target.enabled=true \
    bluetooth.profile.bas.client.enabled=true \
    bluetooth.profile.gatt.enabled=true \
    bluetooth.profile.hid.device.enabled=true \
    bluetooth.profile.hid.host.enabled=true \
    bluetooth.profile.opp.enabled=true \
    bluetooth.profile.pan.nap.enabled=true \
    bluetooth.profile.pan.panu.enabled=true \
    bluetooth.profile.pbap.server.enabled=true

# Display: the panel is mounted upside down (stock ro.sf.hwrotation=180)
PRODUCT_VENDOR_PROPERTIES += \
    ro.surface_flinger.primary_display_orientation=ORIENTATION_180

# Wifi
PRODUCT_PROPERTY_OVERRIDES += \
    wifi.interface=wlan0 \
    wifi.direct.interface=p2p-dev-wlan0 \
    net.tethering.noprovisioning=true

# Blur
PRODUCT_PROPERTY_OVERRIDES += \
   ro.surface_flinger.supports_background_blur=1 \
   persist.sys.sf.disable_blurs=0 \
   ro.sf.blurs_are_expensive=0
