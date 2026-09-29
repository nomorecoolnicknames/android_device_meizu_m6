#
# device.mk - Meizu M6 (meizu_m6 / M711), MT6750
#
# Copyright (C) 2026 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

LOCAL_PATH := device/meizu/meizu_m6

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    device/meizu/meizu_m6

# Display
# 720x1280, density 320 (xhdpi).
PRODUCT_AAPT_CONFIG := normal
PRODUCT_AAPT_PREF_CONFIG := xhdpi

# Overlays
DEVICE_PACKAGE_OVERLAYS += $(LOCAL_PATH)/overlay

# Ramdisk / fstab
# First-stage init mounts the first_stage_mount entries and switches root to
# /system, so the fstab must also be in the boot ramdisk.
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/etc/fstab.mt6755:$(TARGET_COPY_OUT_RAMDISK)/fstab.mt6755 \
    $(LOCAL_PATH)/rootdir/etc/fstab.mt6755:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.mt6755

# Vendor init and ueventd. Only init.${ro.hardware}.rc (mt6755) is imported
# by init; the other hw/ files are imported from it. sensors.rc lives in
# etc/init so its `override` is parsed after the AOSP sensors service rc.
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/etc/ueventd.mt6755.rc:$(TARGET_COPY_OUT_VENDOR)/etc/ueventd.rc \
    $(LOCAL_PATH)/rootdir/etc/init/hw/init.mt6755.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.mt6755.rc \
    $(LOCAL_PATH)/rootdir/etc/init/hw/init.mt6755.usb.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.mt6755.usb.rc \
    $(LOCAL_PATH)/rootdir/etc/init/hw/init.meizu_m6.nvram.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.meizu_m6.nvram.rc \
    $(LOCAL_PATH)/rootdir/etc/init/hw/init.meizu_m6.modem.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.meizu_m6.modem.rc \
    $(LOCAL_PATH)/rootdir/etc/init/hw/init.meizu_m6.tee.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.meizu_m6.tee.rc \
    $(LOCAL_PATH)/rootdir/etc/init/hw/init.meizu_m6.connectivity.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.meizu_m6.connectivity.rc \
    $(LOCAL_PATH)/rootdir/etc/init/hw/init.meizu_m6.thermal.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.meizu_m6.thermal.rc \
    $(LOCAL_PATH)/rootdir/etc/init/init.meizu_m6.sensors.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.meizu_m6.sensors.rc

# VINTF
DEVICE_MANIFEST_FILE := $(LOCAL_PATH)/manifest.xml

# Wi-Fi
# wpa_supplicant.conf is not a module, so the device ships the file itself.
PRODUCT_PACKAGES += \
    libwpa_client \
    wpa_supplicant \
    hostapd

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/wifi/wpa_supplicant.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wpa_supplicant.conf \
    $(LOCAL_PATH)/wifi/p2p_supplicant.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/p2p_supplicant.conf

# wpa_supplicant service; nothing else in the image defines it.
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/etc/init/init.meizu_m6.wifi.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.meizu_m6.wifi.rc

# Health
PRODUCT_PACKAGES += \
    android.hardware.health@2.1-impl \
    android.hardware.health@2.1-service

# Permissions
# Camera and sensor features are not declared: the camera provider currently
# aborts and the sensors HAL is untested.
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth_le.xml \
    frameworks/native/data/etc/android.hardware.location.gps.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.location.gps.xml \
    frameworks/native/data/etc/android.hardware.opengles.aep.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.opengles.aep.xml \
    frameworks/native/data/etc/android.hardware.telephony.gsm.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.gsm.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.host.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/handheld_core_hardware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/handheld_core_hardware.xml

# Proprietary blobs
# Nougat HALs and firmware in /vendor. libcurl and the AOSP reference DRM
# plugins are excluded so they do not shadow source-built/VNDK libraries.
$(call inherit-product, $(LOCAL_PATH)/vendor-blobs.mk)

# Vendor-side libraries the blobs need and a vendor process cannot take from
# /system: libstdc++.vendor, a libgui forwarder (libgui is VNDK-private),
# libcamera_client_vendor, a Nougat-ABI libfs_mgr shim for libnvram and the
# vendor audio helper libraries. The libmeizu_m6shim_* modules provide Nougat
# ABI symbols; shims/wiring.txt lists which blob needs which shim.
PRODUCT_PACKAGES += \
    libmeizu_m6shim_netd_client \
    libmeizu_m6shim_ssl \
    libmeizu_m6shim_gui \
    libmeizu_m6shim_ui \
    libmeizu_m6shim_sf \
    libmeizu_m6shim_utils \
    libmeizu_m6shim_audioutils \
    libmeizu_m6shim_region \
    libmeizu_m6shim_net

PRODUCT_PACKAGES += \
    libstdc++.vendor \
    libgui_vendor \
    libgui_fwd_meizu_m6 \
    libcamera_client_vendor \
    libfs_mgr_shim_meizu_m6 \
    libtinycompress \
    libtinyxml \
    libalsautils

# HALs
# Passthrough services backed by the blob set. Every passthrough *-service
# needs its *-impl in /vendor/lib*/hw or it exits shortly after start.
# Power, IR, RenderScript, Bluetooth, Wi-Fi HAL and fingerprint HALs are not
# included yet.
PRODUCT_PACKAGES += \
    android.hardware.graphics.allocator@2.0-impl \
    android.hardware.graphics.allocator@2.0-service \
    android.hardware.graphics.composer@2.1-service \
    android.hardware.graphics.mapper@2.0-impl-2.1 \
    android.hardware.memtrack@1.0-impl \
    android.hardware.memtrack@1.0-service \
    android.hardware.light@2.0-impl \
    android.hardware.light@2.0-service \
    android.hardware.vibrator@1.0-impl \
    android.hardware.vibrator@1.0-service \
    vibrator.default \
    android.hardware.audio.service \
    android.hardware.audio@6.0-impl \
    android.hardware.audio.effect@6.0-impl \
    android.hardware.keymaster@3.0-impl \
    android.hardware.keymaster@3.0-service \
    android.hardware.gatekeeper@1.0-service.software \
    android.hardware.drm@1.4-service.clearkey \
    android.hardware.gnss@1.0-impl \
    android.hardware.gnss@1.0-service \
    android.hardware.camera.provider@2.4-impl \
    android.hardware.camera.provider@2.4-service \
    android.hardware.sensors@1.0-impl \
    android.hardware.sensors@1.0-service
