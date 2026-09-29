// libskia stub: DT_NEEDED placeholder for the Nougat camera blobs.
//
// There is no shared libskia since Android P (skia is linked into libhwui),
// but libcam.camadapter.so still has DT_NEEDED libskia.so, and a missing
// library fails the whole camera HAL load. It imports no Sk* symbols, so an
// empty library is enough. libaal.so and libvtmal.so really call Skia and are
// not covered by this stub.
extern "C" void __m6_libskia_stub_marker(void) {}
