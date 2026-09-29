// Echo-reference and AudioSystem stubs for the Nougat audio.primary HAL.
//
// create/release_echo_reference were removed from libaudioutils. They serve
// voice-call echo cancellation only; returning -ENOSYS makes the HAL take its
// no-EC path (a null reference with a success return would crash on first
// use).
#include <errno.h>
#include <stdint.h>

extern "C" {

struct echo_reference_itfe;

int create_echo_reference(int /*rdFormat*/, uint32_t /*rdChannelCount*/,
                          uint32_t /*rdSamplingRate*/, int /*wrFormat*/,
                          uint32_t /*wrChannelCount*/,
                          uint32_t /*wrSamplingRate*/,
                          struct echo_reference_itfe** reference) {
    if (reference) *reference = 0;
    return -ENOSYS;
}

void release_echo_reference(struct echo_reference_itfe* /*reference*/) {
}

}  // extern "C"

// android::AudioSystem::getDeviceConnectionState(audio_devices_t, const char*)
// The HAL calls it from adev_open(). In the audio HAL service the call goes
// through /dev/vndbinder, where the audio policy service is never published,
// and AudioFlinger only publishes after the HAL is loaded: both would wait on
// each other forever. Report "unavailable"; the policy manager pushes the real
// connection state via set_parameters once the module is loaded. This library
// precedes libaudioclient in DT_NEEDED, so this definition wins the lookup.
extern "C" int _ZN7android11AudioSystem24getDeviceConnectionStateEjPKc(
        unsigned int /*device*/, const char* /*device_address*/) {
    return 0;  // AUDIO_POLICY_DEVICE_STATE_UNAVAILABLE
}

// AudioSystem::getParameters / setParameters (audio_io_handle_t, String8)
// libaudio_param_parser calls getParameters() from adev_open() and hits the
// same deadlock. getParameters returns an empty String8 (custom XML is then
// treated as disabled and NVRAM parameters are used); setParameters reports
// success. String8 is returned by value (sret); a one-pointer struct with a
// user-provided destructor is returned the same way, and the empty string is
// built by the real String8::String8().
namespace { struct M95String8Ret { void* p; ~M95String8Ret() {} }; }
extern "C" void _ZN7android7String8C1Ev(void* self);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wreturn-type-c-linkage"
extern "C" M95String8Ret _ZN7android11AudioSystem13getParametersEiRKNS_7String8E(
        int /*ioHandle*/, const void* /*keys*/) {
    M95String8Ret r;
    _ZN7android7String8C1Ev(&r);
    return r;
}
#pragma clang diagnostic pop
extern "C" int _ZN7android11AudioSystem13setParametersEiRKNS_7String8E(
        int /*ioHandle*/, const void* /*keyValuePairs*/) {
    return 0;  // NO_ERROR
}
