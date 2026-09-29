# Meizu M6 (meizu_m6)

Device tree for the Meizu M6 for LineageOS 20.0.

## Specifications

| | |
| --- | --- |
| Model | M711 |
| SoC | MediaTek MT6750 |
| CPU | 8x ARM Cortex-A53 |
| Display | 720 x 1280 |
| Kernel | Linux 3.18 (prebuilt) |

## Status

- Treble product with a real /vendor partition; a complete ROM and hardware
  run for this branch are not verified yet.
- Boot, display and touch: untested
- Wi-Fi and Bluetooth: untested
- SIM, LTE and calls: untested
- Camera and audio: untested
- Sensors and fingerprint: untested
- GPS: location fix unverified
- SELinux: permissive

## Building

Sync the LineageOS 20.0 source and add the local manifest from
[android_local_manifests_meizu](https://github.com/nomorecoolnicknames/android_local_manifests_meizu)
(branch `lineage-20.0`); this tree goes to `device/meizu/meizu_m6`.
Required external inputs:

- matching legacy MediaTek framework/HAL adaptations for the platform;
- vendor blobs in `device/meizu/meizu_m6/proprietary/` (paths in
  `vendor-blobs.mk`);
- kernel source at `kernel/meizu/meizu_m6` (used for headers);
- prebuilt kernel at `device/meizu/meizu_m6/prebuilt/Image.gz-dtb`.

```sh
source build/envsetup.sh
breakfast meizu_m6
brunch meizu_m6
```
