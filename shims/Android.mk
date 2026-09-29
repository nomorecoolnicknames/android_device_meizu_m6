# Device-local blob shims for the Meizu M6 (meizu_m6).
#
# The module cannot simply be named libskia: the name clashes with the static
# Soong module and would build all of external/skia. It stays device-local so
# a libskia.so does not apply to other devices.
# The symlink targets are spelled out per arch: inside PRIVATE_POST_INSTALL_CMD
# $@ does not expand to the installed module.

LOCAL_PATH := $(call my-dir)

# libskia.so — DT_NEEDED satisfier, exports nothing.
include $(CLEAR_VARS)
LOCAL_MODULE := libskia_m6_stub
LOCAL_SRC_FILES := skia.cpp
LOCAL_POST_INSTALL_CMD := mkdir -p $(TARGET_OUT_VENDOR)/lib $(TARGET_OUT_VENDOR)/lib64 \
    && ln -sf libskia_m6_stub.so $(TARGET_OUT_VENDOR)/lib/libskia.so \
    && ln -sf libskia_m6_stub.so $(TARGET_OUT_VENDOR)/lib64/libskia.so
LOCAL_MULTILIB := both
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_TAGS := optional
include $(BUILD_SHARED_LIBRARY)
