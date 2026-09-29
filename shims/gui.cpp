// Nougat-to-current BufferQueue::createBufferQueue forwarder.
//
// The Nougat hwcomposer blob imports:
//   BufferQueue::createBufferQueue(sp<IGBP>*, sp<IGBC>*, sp<IGraphicBufferAlloc> const&)
// while libgui only has:
//   BufferQueue::createBufferQueue(sp<IGBP>*, sp<IGBC>*, bool consumerIsSurfaceFlinger=false)
//
// This module links nothing: both mangled names are declared manually and the
// platform symbol resolves at runtime from libgui.
namespace android {
template <typename T>
class sp;
class IGraphicBufferProducer;
class IGraphicBufferConsumer;
}  // namespace android

extern "C" {

// Platform implementation (libgui, resolved at runtime).
void _ZN7android11BufferQueue17createBufferQueueEPNS_2spINS_22IGraphicBufferProducerEEEPNS1_INS_22IGraphicBufferConsumerEEEb(
        android::sp<android::IGraphicBufferProducer>*,
        android::sp<android::IGraphicBufferConsumer>*, bool);

// Nougat entry point the blob links against; the allocator argument is
// dropped (libgui allocates internally).
void _ZN7android11BufferQueue17createBufferQueueEPNS_2spINS_22IGraphicBufferProducerEEEPNS1_INS_22IGraphicBufferConsumerEEERKNS1_INS_19IGraphicBufferAllocEEE(
        android::sp<android::IGraphicBufferProducer>* outProducer,
        android::sp<android::IGraphicBufferConsumer>* outConsumer) {
    _ZN7android11BufferQueue17createBufferQueueEPNS_2spINS_22IGraphicBufferProducerEEEPNS1_INS_22IGraphicBufferConsumerEEEb(
            outProducer, outConsumer, false);
}

}  // extern "C"

// ---- Camera closure ---------------------------------------------------------
// libmtkcam_imgbuf.so imports the Nougat 7-arg GraphicBuffer ctor,
// libeffecthal.base the Nougat GraphicBuffer(ANativeWindowBuffer*, bool) ctor
// plus the Nougat BufferItemConsumer ctor (uint32_t usage) and
// BufferItemConsumer::setName. libui still exports the 8-arg (layerCount) ctor
// and the HandleWrapMethod ctor; libgui exports BufferItemConsumer(uint64_t
// usage) and ConsumerBase::setName. Caveat: the blob allocates the Nougat-sized
// object and the platform ctor initialises the current layout.
#include <stdint.h>

namespace android {
class GraphicBuffer;
class BufferItemConsumer;
class ConsumerBase;
class String8;
struct native_handle;
}  // namespace android

// system/window.h ANativeWindowBuffer, R layout (handle offset identical to N:
// 96/60 bytes on 64/32-bit; N's reserved[2] became layerCount + reserved[1]).
struct m95_native_base {
    int magic; int version; void* reserved[4];
    void (*incRef)(struct m95_native_base*); void (*decRef)(struct m95_native_base*);
};
struct m95_anwb {
    struct m95_native_base common;
    int width; int height; int stride; int format; int usage_deprecated;
    uintptr_t layerCount; void* reserved[1];
    const android::native_handle* handle;
    uint64_t usage; void* reserved_proc[8];
};

extern "C" {

// R: GraphicBuffer(w, h, format, layerCount, usage, stride, handle, keepOwnership)
void _ZN7android13GraphicBufferC1EjjijjjP13native_handleb(
        android::GraphicBuffer*, uint32_t, uint32_t, int, uint32_t, uint32_t,
        uint32_t, android::native_handle*, bool);

// N: GraphicBuffer(w, h, format, usage, stride, handle, keepOwnership)
void _ZN7android13GraphicBufferC1EjjijjP13native_handleb(
        android::GraphicBuffer* self, uint32_t w, uint32_t h, int format,
        uint32_t usage, uint32_t stride, android::native_handle* handle,
        bool keepOwnership) {
    _ZN7android13GraphicBufferC1EjjijjjP13native_handleb(
            self, w, h, format, 1u, usage, stride, handle, keepOwnership);
}

// R: GraphicBuffer(const native_handle_t*, HandleWrapMethod, w, h, format,
//                  layerCount, uint64_t usage, stride); uint64_t mangles as
//                  'm' (LP64) / 'y' (ILP32).
#ifdef __LP64__
void _ZN7android13GraphicBufferC1EPK13native_handleNS0_16HandleWrapMethodEjjijmj(
        android::GraphicBuffer*, const android::native_handle*, int, uint32_t,
        uint32_t, int, uint32_t, uint64_t, uint32_t);
#define M95_GB_WRAP _ZN7android13GraphicBufferC1EPK13native_handleNS0_16HandleWrapMethodEjjijmj
#else
void _ZN7android13GraphicBufferC1EPK13native_handleNS0_16HandleWrapMethodEjjijyj(
        android::GraphicBuffer*, const android::native_handle*, int, uint32_t,
        uint32_t, int, uint32_t, uint64_t, uint32_t);
#define M95_GB_WRAP _ZN7android13GraphicBufferC1EPK13native_handleNS0_16HandleWrapMethodEjjijyj
#endif

// N: GraphicBuffer(ANativeWindowBuffer* buffer, bool keepOwnership). N kept an
// sp<> on the source buffer when keepOwnership was set (handle stayed owned by
// the source); R's equivalent without a lifetime tie is CLONE_HANDLE (own an
// imported dup), WRAP_HANDLE otherwise. TAKE_HANDLE would double-free.
void _ZN7android13GraphicBufferC1EP19ANativeWindowBufferb(
        android::GraphicBuffer* self, struct m95_anwb* buffer, bool keepOwnership) {
    enum { WRAP_HANDLE = 0, CLONE_HANDLE = 1 };
    uint64_t usage = buffer->usage ? buffer->usage
                                   : (uint64_t)(uint32_t)buffer->usage_deprecated;
    M95_GB_WRAP(self, buffer->handle, keepOwnership ? CLONE_HANDLE : WRAP_HANDLE,
                (uint32_t)buffer->width, (uint32_t)buffer->height, buffer->format,
                1, usage, (uint32_t)buffer->stride);
}

// R: BufferItemConsumer(const sp<IGraphicBufferConsumer>&, uint64_t usage,
//                       int bufferCount, bool controlledByApp)
#ifdef __LP64__
void _ZN7android18BufferItemConsumerC1ERKNS_2spINS_22IGraphicBufferConsumerEEEmib(
        android::BufferItemConsumer*, const void*, uint64_t, int, bool);
#define M95_BIC_CTOR _ZN7android18BufferItemConsumerC1ERKNS_2spINS_22IGraphicBufferConsumerEEEmib
#else
void _ZN7android18BufferItemConsumerC1ERKNS_2spINS_22IGraphicBufferConsumerEEEyib(
        android::BufferItemConsumer*, const void*, uint64_t, int, bool);
#define M95_BIC_CTOR _ZN7android18BufferItemConsumerC1ERKNS_2spINS_22IGraphicBufferConsumerEEEyib
#endif

// N: BufferItemConsumer(const sp<IGraphicBufferConsumer>&, uint32_t usage, ...)
void _ZN7android18BufferItemConsumerC1ERKNS_2spINS_22IGraphicBufferConsumerEEEjib(
        android::BufferItemConsumer* self, const void* consumer, uint32_t usage,
        int bufferCount, bool controlledByApp) {
    M95_BIC_CTOR(self, consumer, (uint64_t)usage, bufferCount, controlledByApp);
}

// R keeps ConsumerBase::setName only; BufferItemConsumer derives from it
// (first, non-virtual base -> same pointer).
void _ZN7android12ConsumerBase7setNameERKNS_7String8E(
        android::ConsumerBase*, const android::String8&);
void _ZN7android18BufferItemConsumer7setNameERKNS_7String8E(
        android::BufferItemConsumer* self, const android::String8& name) {
    _ZN7android12ConsumerBase7setNameERKNS_7String8E(
            (android::ConsumerBase*)self, name);
}

}  // extern "C"

// ---- GLConsumer::getCurrentBuffer() (N: no args; R: int* outSlot) ----------
// libvfb_render.so (a camera HAL dependency) imports the Nougat signature;
// libgui only exports getCurrentBuffer(int*). sp<GraphicBuffer> is returned
// indirectly (sret), so both sides are declared as returning a struct with a
// user-provided destructor, which the ABI returns exactly like sp<>.
// Guaranteed copy elision (C++17) passes the callee's sret slot straight
// through, so no refcount is touched here.
namespace { struct M95SpRet { void* p; ~M95SpRet() {} }; }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wreturn-type-c-linkage"
extern "C" M95SpRet _ZNK7android10GLConsumer16getCurrentBufferEPi(const void* self, int* outSlot);
extern "C" M95SpRet _ZNK7android10GLConsumer16getCurrentBufferEv(const void* self) {
    return _ZNK7android10GLConsumer16getCurrentBufferEPi(self, nullptr);
}
#pragma clang diagnostic pop

// ---- Surface::Surface(const sp<IGraphicBufferProducer>&, bool) -------------
// The pre-S two-argument constructor, imported by libeffecthal.base.so.
// Without the symbol the whole camera HAL fails to load. It is not forwarded:
// the blob allocates the object itself with the Nougat size (3560 bytes on
// lib64), while a current Surface needs about 8 KiB, so constructing into that
// block would overrun the heap. Abort instead; only camera effect paths reach
// it.
#include <log/log.h>
extern "C" void _ZN7android7SurfaceC1ERKNS_2spINS_22IGraphicBufferProducerEEEb(
        void* /*self*/, const void* /*bufferProducer*/, bool /*controlledByApp*/) {
    LOG_ALWAYS_FATAL("m95: legacy Surface(sp<IGraphicBufferProducer>, bool) called "
                     "(camera effect HAL); the N-sized allocation cannot hold an A13 Surface");
}
