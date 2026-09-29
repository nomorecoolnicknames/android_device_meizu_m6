# Copyright (C) 2026 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#
# BoardConfig.mk - Meizu M6 (meizu_m6 / M711), MediaTek MT6750

# Nougat blobs are installed with PRODUCT_COPY_FILES (vendor-blobs.mk).
# Android 11+ rejects ELF files in PRODUCT_COPY_FILES; this flag lifts that
# check. Nothing validates the blobs' DT_NEEDED entries at build time.
BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true

# A blob and an AOSP module at the same /vendor path (e.g.
# hw/fingerprint.default.so) warn instead of erroring.
BUILD_BROKEN_DUP_RULES := true

DEVICE_PATH := device/meizu/meizu_m6

# Architecture
# MT6750: eight Cortex-A53 cores (ARMv8.0, no LSE).
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := cortex-a53

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := cortex-a53

TARGET_USES_64_BIT_BINDER := true

# Platform
#
# TARGET_BOARD_PLATFORM is mt6750 (ro.board.platform=mt6750); it selects hw
# modules named *.mt6750.so. ro.hardware stays mt6755 (see the cmdline below),
# which is what the kernel publishes and what names init.mt6755.rc,
# ueventd.mt6755.rc and fstab.mt6755: MediaTek ships an MT6755 BSP for this
# MT6750-branded part.
# The GPU is assumed to be the MT6755 Mali-T860MP2; it only feeds
# ro.hardware.egl fallbacks.
TARGET_BOARD_PLATFORM := mt6750
TARGET_BOOTLOADER_BOARD_NAME := mt6750
TARGET_BOARD_PLATFORM_GPU := mali-t860mp2

TARGET_NO_BOOTLOADER := true
TARGET_NO_RADIOIMAGE := true

BOARD_NAME := meizu_m6
# meizu_M6 is the factory ro.product.device.
TARGET_OTA_ASSERT_DEVICE := meizu_m6,meizu_M6,M711,m711

# Display
# 720x1280. Both ili9881c and ili9881p panel drivers are built; the
# bootloader selects the panel.
TARGET_SCREEN_WIDTH := 720
TARGET_SCREEN_HEIGHT := 1280
TARGET_RECOVERY_PIXEL_FORMAT := BGRA_8888

# Partitions
# A-only. Userdata size depends on the storage variant.
BOARD_FLASH_BLOCK_SIZE := 131072

BOARD_BOOTIMAGE_PARTITION_SIZE := 16777216
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 33554432
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 2684354560
BOARD_CACHEIMAGE_PARTITION_SIZE := 452984832
BOARD_USERDATAIMAGE_PARTITION_SIZE := 11683216896

# The stock custom partition is mmcblk0p3 (512 MiB); this product uses it for /vendor.
# Preserve its contents before installing a vendor image.
BOARD_VENDORIMAGE_PARTITION_SIZE := 536870912
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4

TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true
BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := ext4

# No A/B, no virtual A/B, no dynamic partitions, no super image.
# PRODUCT_USE_DYNAMIC_PARTITIONS must not be assigned here: it is a product
# variable marked read-only before BoardConfig.mk is read.
AB_OTA_UPDATER := false
BOARD_USES_RECOVERY_AS_BOOT := false
BOARD_BUILD_SYSTEM_ROOT_IMAGE := false

# Treble / VNDK
#
# Stock is not Treble (Android 7.0, ro.product.first_api_level=24); Treble is
# enabled with PRODUCT_FULL_TREBLE_OVERRIDE (lineage_meizu_m6.mk) and a real
# /vendor image. Vendor processes no longer see /system/lib*, so blobs that
# need system-only libraries get a vendor copy or a shim (Android.bp).
TARGET_COPY_OUT_VENDOR := vendor
BOARD_VNDK_VERSION := current
BOARD_PROPERTY_OVERRIDES_SPLIT_ENABLED := true

# Vendor-owned properties (hw module suffixes, RIL, legacy-kernel VINTF flag).
TARGET_VENDOR_PROP += $(DEVICE_PATH)/vendor.prop

# Kernel
# Boot addresses: kernel 0x40080000, ramdisk 0x45000000, tags 0x44000000.
BOARD_KERNEL_BASE := 0x40078000
BOARD_KERNEL_PAGESIZE := 2048
BOARD_KERNEL_OFFSET := 0x00008000
BOARD_RAMDISK_OFFSET := 0x04f88000
BOARD_SECOND_OFFSET := 0x00f00000
BOARD_TAGS_OFFSET := 0x03f88000
BOARD_MKBOOTIMG_ARGS := --board 1552631950 --ramdisk_offset $(BOARD_RAMDISK_OFFSET) --second_offset $(BOARD_SECOND_OFFSET) --tags_offset $(BOARD_TAGS_OFFSET)

# Legacy MTK boot header: no header_version, no dtb in bootimg, no dtbo.
BOARD_BOOT_HEADER_VERSION := 0
BOARD_INCLUDE_DTB_IN_BOOTIMG :=
BOARD_INCLUDE_RECOVERY_DTBO :=

# binder.devices provides binder, hwbinder and vndbinder on the 3.18 kernel.
BOARD_KERNEL_CMDLINE := bootopt=64S3,32N2,64N2 androidboot.hardware=mt6755 androidboot.selinux=permissive binder.devices=binder,hwbinder,vndbinder androidboot.usb.config=adb buildvariant=userdebug

# A prebuilt 3.18 kernel is used; the kernel source is still required for
# UAPI header generation.
TARGET_NO_KERNEL := false
TARGET_KERNEL_ARCH := arm64
TARGET_KERNEL_HEADER_ARCH := arm64
# TARGET_FORCE_PREBUILT_KERNEL keeps the prebuilt image while the source tree
# provides headers_install for the generated_kernel_includes genrule; without
# it a present source and config trigger a full kernel build.
TARGET_KERNEL_SOURCE := kernel/meizu/meizu_m6
TARGET_KERNEL_CONFIG := meizu_m6_a13_defconfig
TARGET_FORCE_PREBUILT_KERNEL := true
TARGET_KERNEL_VERSION := 3.18
TARGET_PREBUILT_KERNEL := $(DEVICE_PATH)/prebuilt/Image.gz-dtb
BOARD_KERNEL_IMAGE_NAME := kernel

# Recovery
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/rootdir/etc/fstab.mt6755
BOARD_SUPPRESS_SECURE_ERASE := true
BOARD_CHARGER_SHOW_PERCENTAGE := true

# Wi-Fi
# MediaTek WMT / conn_soc combo chip. WIFI_DRIVER_STATE_CTRL_PARAM is required:
# without it libwifi_hal never writes /dev/wmtWifi, so wlan0 never appears.
BOARD_WLAN_DEVICE := MediaTek
WPA_SUPPLICANT_VERSION := VER_0_8_X
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_mt66xx
BOARD_HOSTAPD_DRIVER := NL80211
BOARD_HOSTAPD_PRIVATE_LIB := lib_driver_cmd_mt66xx
WIFI_DRIVER_STATE_CTRL_PARAM := /dev/wmtWifi
WIFI_DRIVER_STATE_ON := 1
WIFI_DRIVER_STATE_OFF := 0
WIFI_DRIVER_OPERSTATE_PATH := /sys/class/net/wlan0/operstate
WIFI_DRIVER_STATE_CTRL_RETRIES := 8
WIFI_DRIVER_STATE_CTRL_RETRY_DELAY_US := 1000000

# Bluetooth
BOARD_HAVE_BLUETOOTH := true
BOARD_HAVE_BLUETOOTH_MTK := true

# SELinux
# Oreo-era MediaTek vendor rules violate the platform neverallows.
SELINUX_IGNORE_NEVERALLOWS := true
BOARD_VENDOR_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/vendor

# Mount points for /protect_f, /protect_s and /nvdata. The root is read-only
# after switch_root, so init cannot create them; without them there is no
# NVRAM and no IMEI/modem.
BOARD_ROOT_EXTRA_FOLDERS := nvdata protect_f protect_s

# Not Qualcomm: QTI paths in SurfaceFlinger cause a black-screen deadlock.
BOARD_USES_QCOM_HARDWARE := false
TARGET_USES_QCOM_BSP := false

# Properties
TARGET_SYSTEM_PROP := $(DEVICE_PATH)/system.prop
