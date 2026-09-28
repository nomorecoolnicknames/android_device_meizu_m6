LOCAL_PATH := device/meizu/meizu_m6
TARGET_MEIZU_MT675X_DEVICE := meizu_m6

# Inherit from the proprietary version
-include vendor/meizu/meizu_m6/BoardConfigVendor.mk

include device/meizu/m3_meizu_m6-common/BoardConfigCommon.mk

# MediaTek's Oreo libril wrapper needs the MediaTek telephony/ril.h extensions
# before the AOSP hardware/ril include directory is searched.
TARGET_SPECIFIC_HEADER_PATH := vendor/mediatek/include $(COMMON_PATH)/include


# system.prop
TARGET_SYSTEM_PROP := $(LOCAL_PATH)/system.prop

# Radio
ADD_RADIO_FILES := true
TARGET_RELEASETOOLS_EXTENSIONS := $(LOCAL_PATH)
# The MediaTek Oreo HIDL RIL wrapper is used with the stock modem blobs.
BOARD_PROVIDES_RILD := true
BOARD_PROVIDES_LIBRIL := true

# Bluetooth
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := $(LOCAL_PATH)/bluetooth

# Device identity
TARGET_OTA_ASSERT_DEVICE := meizu_m6
BOARD_NAME := meizu_m6
TARGET_SYSTEM_PROP := device/meizu/meizu_m6/system.prop
# There is no gatekeeper HAL service; use gatekeeperd's software fallback
# instead of blocking forever on HIDL.
BOARD_USE_SOFT_GATEKEEPER := true
# 64-bit-only app runtime: keep the 32-bit native build for stock vendor
# daemons and HAL wrappers, but do not publish 32-bit app ABIs or start
# zygote_secondary, because app_process32 aborts and takes zygote64 down.
M6_PURE_ARM64 ?= true
ifeq ($(M6_PURE_ARM64),true)
TARGET_CPU_ABI_LIST_64_BIT := $(TARGET_CPU_ABI)
TARGET_CPU_ABI_LIST_32_BIT :=
TARGET_CPU_ABI_LIST := $(TARGET_CPU_ABI_LIST_64_BIT)
TARGET_SUPPORTS_32_BIT_APPS := false
TARGET_SUPPORTS_64_BIT_APPS := true
else
TARGET_SUPPORTS_32_BIT_APPS := true
TARGET_SUPPORTS_64_BIT_APPS := true
endif
# The stock audio.primary is unstable in the 64-bit HIDL service path; keep
# the audio HAL service 32-bit.
AUDIOSERVER_MULTILIB := 32
# cameraserver is 32-bit-only here, so CameraService is published from the
# 64-bit mediaserver instead.
TARGET_HAS_LEGACY_CAMERA_HAL1 := true
# Stock camera blobs reference legacy graphics symbols, and the stock vendor
# ICU must coexist with system libraries that need ICU 58 symbols.
TARGET_LD_SHIM_LIBS += \
    /system/vendor/lib/libmpe.sensorlistener.so|/system/vendor/lib/libmtkshim_sensor.so \
    /system/vendor/lib/hw/hwcomposer.mt6755.so|/system/vendor/lib/libmtkshim_gui.so \
    /system/vendor/lib64/hw/hwcomposer.mt6755.so|/system/vendor/lib64/libmtkshim_gui.so \
    /system/lib/libandroid_runtime.so|/system/lib/libicuuc.so \
    /system/lib/libmedia.so|/system/lib/libicuuc.so \
    /system/lib/libmedia.so|/system/lib/libicui18n.so \
    /system/lib/libsqlite.so|/system/lib/libicuuc.so \
    /system/lib/libsqlite.so|/system/lib/libicui18n.so \
    /system/vendor/lib/libicui18n.so|/system/vendor/lib/libicuuc.so \
    /system/vendor/lib/libxml2.so|/system/vendor/lib/libicuuc.so \
    /system/vendor/lib/libcam_utils.so|/system/vendor/lib/libmtkshim_gui.so \
    /system/vendor/lib/libcam.device1.so|/system/vendor/lib/libmtkshim_gui.so \
    /system/vendor/lib/libcam_platform.so|/system/vendor/lib/libmtkshim_gui.so \
    /system/vendor/lib/libcam.camadapter.so|/system/vendor/lib/libmtkshim_gui.so \
    /system/vendor/lib/hw/camera.mt6750.so|/system/vendor/lib/libmtkshim_gui.so \
    /system/vendor/lib/libcam.client.so|/system/vendor/lib/libmtkshim_gui.so \
    /system/vendor/lib/libcam.camnode.so|/system/vendor/lib/libmtkshim_gui.so \
    /system/vendor/lib/libeffecthal.base.so|/system/vendor/lib/libmtkshim_gui.so \
    /system/vendor/lib/libjni_lomoeffect.so|/system/vendor/lib/libmtkshim_gui.so \
    /system/vendor/lib/libvfb_render.so|/system/vendor/lib/libmtkshim_gui.so \
    /system/vendor/lib/libMtkOmxVenc.so|/system/vendor/lib/libmtkshim_gui.so \
    /system/vendor/lib/libmtk_mmutils.so|/system/vendor/lib/libmtkshim_gui.so \
    /system/vendor/lib/libshowlogo.so|/system/vendor/lib/libmtkshim_gui.so \
    /system/vendor/lib/libgui_ext.so|/system/vendor/lib/libmtkshim_gui.so \
    /system/vendor/lib/libui_ext.so|/system/vendor/lib/libmtkshim_gui.so \
    /system/vendor/lib64/libcam_utils.so|/system/vendor/lib64/libmtkshim_gui.so \
    /system/vendor/lib64/libcam.device1.so|/system/vendor/lib64/libmtkshim_gui.so \
    /system/vendor/lib64/libcam_platform.so|/system/vendor/lib64/libmtkshim_gui.so \
    /system/vendor/lib64/libcam.camadapter.so|/system/vendor/lib64/libmtkshim_gui.so \
    /system/vendor/lib64/hw/camera.mt6750.so|/system/vendor/lib64/libmtkshim_gui.so \
    /system/vendor/lib64/libcam.client.so|/system/vendor/lib64/libmtkshim_gui.so \
    /system/vendor/lib64/libcam.camnode.so|/system/vendor/lib64/libmtkshim_gui.so \
    /system/vendor/lib64/libeffecthal.base.so|/system/vendor/lib64/libmtkshim_gui.so \
    /system/vendor/lib64/libjni_lomoeffect.so|/system/vendor/lib64/libmtkshim_gui.so \
    /system/vendor/lib64/libvfb_render.so|/system/vendor/lib64/libmtkshim_gui.so \
    /system/vendor/lib64/libmtk_mmutils.so|/system/vendor/lib64/libmtkshim_gui.so \
    /system/vendor/lib64/libgui_ext.so|/system/vendor/lib64/libmtkshim_gui.so \
    /system/vendor/lib64/libui_ext.so|/system/vendor/lib64/libmtkshim_gui.so \
    /system/lib64/libandroid_runtime.so|/system/lib64/libicuuc.so \
    /system/lib64/libmedia.so|/system/lib64/libicuuc.so \
    /system/lib64/libmedia.so|/system/lib64/libicui18n.so \
    /system/lib64/libsqlite.so|/system/lib64/libicuuc.so \
    /system/lib64/libsqlite.so|/system/lib64/libicui18n.so \
    /system/vendor/lib64/libicui18n.so|/system/vendor/lib64/libicuuc.so \
    /system/vendor/lib64/libxml2.so|/system/vendor/lib64/libicuuc.so
# Kernel
# The prebuilt kernel is the default. M6_KERNEL_FROM_SOURCE=true builds
# kernel/meizu/meizu_m6/kernel-3.18 with meizu_m6_defconfig and GCC 4.9
# (M6_KERNEL_CROSS_COMPILE_PREFIX) instead.
TARGET_NO_KERNEL := false

M6_KERNEL_FROM_SOURCE ?= false

ifeq ($(M6_KERNEL_FROM_SOURCE),true)
# In-tree source build (ARCH=arm64, GCC 4.9, Image.gz-dtb)
TARGET_KERNEL_SOURCE := kernel/meizu/meizu_m6/kernel-3.18
TARGET_KERNEL_CONFIG := meizu_m6_defconfig
TARGET_KERNEL_ARCH := arm64
ifeq ($(strip $(M6_KERNEL_CROSS_COMPILE_PREFIX)),)
$(error Set M6_KERNEL_CROSS_COMPILE_PREFIX to the absolute AArch64 GCC 4.9 prefix for M6_KERNEL_FROM_SOURCE=true)
endif
ifeq ($(filter /%,$(strip $(M6_KERNEL_CROSS_COMPILE_PREFIX))),)
$(error M6_KERNEL_CROSS_COMPILE_PREFIX must be an absolute AArch64 GCC 4.9 prefix)
endif
TARGET_KERNEL_CROSS_COMPILE_PREFIX := $(strip $(M6_KERNEL_CROSS_COMPILE_PREFIX))
BOARD_KERNEL_IMAGE_NAME := Image.gz-dtb
# Clear the prebuilt variables so kernel.mk takes the full kernel build path.
TARGET_PREBUILT_KERNEL :=
M6_DISPLAY_KERNEL_PREBUILT :=
else
# Prebuilt kernel (default). It includes the TPS65132 bias regulator
# (GPIO24/27) and the ILI9881C panel driver.
# The panel is not mounted rotated: CONFIG_MTK_LCM_PHYSICAL_ROTATION_HW must
# stay unset, it is a real 180-degree flip in the display path and turns the
# UI upside down. The LK boot logo stays inverted; boot_logo_updater
# replaces it.
TARGET_KERNEL_SOURCE := kernel/meizu/meizu_m6/kernel-3.18
TARGET_KERNEL_CONFIG :=
M6_DISPLAY_KERNEL_PREBUILT := device/meizu/meizu_m6/prebuilt-kernel/Image.gz-dtb
TARGET_PREBUILT_KERNEL := $(M6_DISPLAY_KERNEL_PREBUILT)
BOARD_KERNEL_IMAGE_NAME := kernel
PRODUCT_COPY_FILES += \
    $(M6_DISPLAY_KERNEL_PREBUILT):kernel
endif


# Wi-Fi
# libwifi_hal only writes /dev/wmtWifi when WIFI_DRIVER_STATE_CTRL_PARAM is
# defined; without it wlan0 never appears.
WIFI_DRIVER_STATE_CTRL_PARAM := /dev/wmtWifi
WIFI_DRIVER_STATE_ON := 1
WIFI_DRIVER_STATE_OFF := 0
WIFI_DRIVER_OPERSTATE_PATH := /sys/class/net/wlan0/operstate
WIFI_DRIVER_STATE_CTRL_RETRIES := 8
WIFI_DRIVER_STATE_CTRL_RETRY_DELAY_US := 1000000
