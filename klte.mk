#
# Copyright (C) 2014 The CyanogenMod Project
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

$(call inherit-product, $(SRC_TARGET_DIR)/product/languages_full.mk)

# Get non-open-source specific aspects
$(call inherit-product-if-exists, vendor/samsung/klte-common/klte-common-vendor.mk)

# Overlays
DEVICE_PACKAGE_OVERLAYS += $(LOCAL_PATH)/overlay

# System properties
-include $(LOCAL_PATH)/system_prop.mk

# Device uses high-density artwork where available
PRODUCT_AAPT_CONFIG := normal hdpi xhdpi xxhdpi
PRODUCT_AAPT_PREF_CONFIG := xxhdpi

# Boot animation
TARGET_SCREEN_HEIGHT := 1920
TARGET_SCREEN_WIDTH := 1080

$(call inherit-product, frameworks/native/build/phone-xxhdpi-2048-dalvik-heap.mk)

$(call inherit-product-if-exists, frameworks/native/build/phone-xxhdpi-2048-hwui-memory.mk)

# Permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.nfc.xml:system/etc/permissions/android.hardware.nfc.xml \
    frameworks/native/data/etc/android.hardware.nfc.hce.xml:system/etc/permissions/android.hardware.nfc.hce.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepcounter.xml:system/etc/permissions/android.hardware.sensor.stepcounter.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepdetector.xml:system/etc/permissions/android.hardware.sensor.stepdetector.xml \
    frameworks/native/data/etc/android.hardware.telephony.cdma.xml:system/etc/permissions/android.hardware.telephony.cdma.xml \
    frameworks/native/data/etc/android.hardware.telephony.gsm.xml:system/etc/permissions/android.hardware.telephony.gsm.xml \
    frameworks/native/data/etc/com.android.nfc_extras.xml:system/etc/permissions/com.android.nfc_extras.xml \
    frameworks/native/data/etc/com.nxp.mifare.xml:system/etc/permissions/com.nxp.mifare.xml \
    frameworks/native/data/etc/handheld_core_hardware.xml:system/etc/permissions/handheld_core_hardware.xml

# Audio
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/audio/audio_effects.conf:system/vendor/etc/audio_effects.conf \
    $(LOCAL_PATH)/audio/audio_platform_info.xml:system/etc/audio_platform_info.xml \
    $(LOCAL_PATH)/audio/audio_policy.conf:system/etc/audio_policy.conf \
    $(LOCAL_PATH)/audio/mixer_paths.xml:system/etc/mixer_paths.xml

# GPS
PRODUCT_PACKAGES += \
    gps.msm8974

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/flp.conf:/system/etc/flp.conf \
    $(LOCAL_PATH)/configs/gps.conf:/system/etc/gps.conf \
    $(LOCAL_PATH)/configs/sap.conf:/system/etc/sap.conf

# Keylayouts
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/keylayout/gpio-keys.kl:system/usr/keylayout/gpio-keys.kl \
    $(LOCAL_PATH)/keylayout/sec_touchkey.kl:system/usr/keylayout/sec_touchkey.kl

# Lights
PRODUCT_PACKAGES += \
    lights.msm8974

# Media
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/media_profiles.xml:system/etc/media_profiles.xml

# NFC
PRODUCT_PACKAGES += \
    com.android.nfc_extras \
    NfcNci \
    nfc_nci.msm8974 \
    Tag

# F2FS System Tools
PRODUCT_PACKAGES += \
    mkfs.f2fs \
    fsck.f2fs \
    fibmap.f2fs

# Filesystem management tools
PRODUCT_PACKAGES += \
    setup_fs \
    e2fsck

# Ramdisk
PRODUCT_PACKAGES += \
    fstab.qcom \
    init.crda.sh \
    init.qcom.rc \
    init.qcom.usb.rc \
    init.sec.boot.sh \
    ueventd.qcom.rc

PRODUCT_COPY_FILES := \
    device/samsung/klte-common/fstab/fstab.qcom.all-EXT4:system/extras/fstab/fstab.qcom.all-EXT4 \
    device/samsung/klte-common/fstab/fstab.qcom.all-F2FS:system/extras/fstab/fstab.qcom.all-F2FS \
    device/samsung/klte-common/fstab/fstab.qcom.data-F2FS:system/extras/fstab/fstab.qcom.data-F2FS \
    device/samsung/klte-common/tools/repack-and-flash.sh:system/extras/tools/repack-and-flash.sh \
    device/samsung/klte-common/tools/format-system.sh:system/extras/tools/format-system.sh \
    device/samsung/klte-common/tools/kernel/repackimg.sh:system/extras/tools/kernel/repackimg.sh \
    device/samsung/klte-common/tools/kernel/unpackimg.sh:system/extras/tools/kernel/unpackimg.sh \
    device/samsung/klte-common/tools/kernel/cleanup.sh:system/extras//tools/kernel/cleanup.sh \
    device/samsung/klte-common/tools/kernel/authors.txt:system/extras/tools/kernel/authors.txt \
    device/samsung/klte-common/tools/kernel/bin/aik:system/extras/tools/kernel/bin/aik \
    device/samsung/klte-common/tools/kernel/bin/busybox:system/extras/tools/kernel/bin/busybox \
    device/samsung/klte-common/tools/kernel/bin/file:system/extras/tools/kernel/bin/file \
    device/samsung/klte-common/tools/kernel/bin/lz4:system/extras/tools/kernel/bin/lz4 \
    device/samsung/klte-common/tools/kernel/bin/magic:system/extras/tools/kernel/bin/magic \
    device/samsung/klte-common/tools/kernel/bin/mkbootfs:system/extras/tools/kernel/bin/mkbootfs \
    device/samsung/klte-common/tools/kernel/bin/mkbootimg:system/extras/tools/kernel/bin/mkbootimg \
    device/samsung/klte-common/tools/kernel/bin/unpackbootimg:system/extras/tools/kernel/bin/unpackbootimg \
    device/samsung/klte-common/tools/kernel/bin/xz:system/extras/tools/kernel/bin/xz

# Thermal
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/thermal-engine-8974.conf:system/etc/thermal-engine-8974.conf

# Note3 Advanced Settings
PRODUCT_PACKAGES += \
    GalaxyNote3Settings

# Torch
PRODUCT_PACKAGES += \
    Torch

# Wifi
PRODUCT_PACKAGES += \
    libnetcmdiface \
    macloader

PRODUCT_COPY_FILES += \
   $(LOCAL_PATH)/configs/wpa_supplicant_overlay.conf:system/etc/wifi/wpa_supplicant_overlay.conf \
   $(LOCAL_PATH)/configs/p2p_supplicant_overlay.conf:system/etc/wifi/p2p_supplicant_overlay.conf

# common msm8974
$(call inherit-product, device/samsung/msm8974-common/msm8974.mk)
