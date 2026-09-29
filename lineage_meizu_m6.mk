# Copyright (C) 2026 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#
# lineage_meizu_m6.mk - Meizu M6 (meizu_m6 / M711), MediaTek MT6750

# Inherit from those products. Most specific first.
# core_64_bit must come first so core_minimal does not pin ro.zygote=zygote32.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit from the device configuration.
$(call inherit-product, device/meizu/meizu_m6/device.mk)

# Inherit some common Lineage stuff.
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

# Device identifier. This must come after all inclusions.
# Stock Flyme uses meizu_M6; the meizu_m6 name keeps existing OTA assertions.
PRODUCT_DEVICE := meizu_m6
PRODUCT_NAME := lineage_meizu_m6
PRODUCT_BRAND := Meizu
PRODUCT_MODEL := M6
PRODUCT_MANUFACTURER := Meizu

PRODUCT_GMS_CLIENTID_BASE := android-meizu

# The vendor ABI originates from Nougat (API 24).
PRODUCT_SHIPPING_API_LEVEL := 24

# Treble is forced on (see BoardConfig.mk). Linker namespaces, the sepolicy
# split and VINTF manifest enforcement follow the override.
PRODUCT_FULL_TREBLE_OVERRIDE := true

PRODUCT_CHARACTERISTICS := phone

# Boot animation
TARGET_BOOT_ANIMATION_RES := 720

# Build fingerprint from stock Flyme.
PRODUCT_BUILD_PROP_OVERRIDES += \
    TARGET_DEVICE=meizu_M6 \
    PRIVATE_BUILD_DESC="meizu_M6-user 7.0 NRD90M 1553585720 release-keys"

BUILD_FINGERPRINT := Meizu/meizu_M6/meizu_M6:7.0/NRD90M/1553585720:user/release-keys

# Dual SIM (DSDS). Set as a product property so the framework reads it from
# the product namespace.
PRODUCT_PROPERTY_OVERRIDES += \
    persist.radio.multisim.config=dsds \
    ro.telephony.default_network=10,10

# This product targets Android 11 (API 30).
ifneq ($(PLATFORM_SDK_VERSION),30)
$(error meizu_m6 lineage-18.1 requires PLATFORM_SDK_VERSION=30)
endif
