# Meizu M6 (meizu_m6)

Device tree for the Meizu M6 for LineageOS 16.0.

## Specifications

| | |
| --- | --- |
| SoC | MediaTek MT6750 |
| Display | 720 x 1280 |
| Kernel | Linux 3.18 (prebuilt, optional source build) |

## Status

An earlier build of this branch booted; the current state is not verified on
hardware.

- Display, HWC and ADB: working on an earlier build
- Wi-Fi: scanning works on an earlier build; association unverified
- Bluetooth: enables on an earlier build; pairing and audio unverified
- SIM, LTE and calls: not working (no service on an earlier build)
- Camera: provider crashed on an earlier build; later fixes untested
- Fingerprint: daemon started on an earlier build; enrollment and unlock unverified
- Audio and sensors: untested
- GPS: location fix unverified

## Building

Sync the LineageOS 16.0 source (JDK 8) and place this tree at
`device/meizu/meizu_m6`. Required external inputs:

- common tree at `device/meizu/m3_meizu_m6-common`;
- matching `vendor/mediatek` sources, including the MediaTek telephony headers;
- vendor tree at `vendor/meizu/meizu_m6`;
- kernel source at `kernel/meizu/meizu_m6/kernel-3.18`;
- prebuilt kernel at `device/meizu/meizu_m6/prebuilt-kernel/Image.gz-dtb`.

```sh
source build/envsetup.sh
breakfast meizu_m6
brunch meizu_m6
```

To build the kernel from source, set `M6_KERNEL_FROM_SOURCE=true` and
`M6_KERNEL_CROSS_COMPILE_PREFIX` to an absolute AArch64 GCC 4.9 prefix.
