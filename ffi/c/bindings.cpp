#include "bindings.h"

#include <cstring>
#include <vector>

#include "include/c/sk_graphite.h"
#include "include/c/sk_image.h"
#include "include/core/SkColor.h"
#include "include/core/SkFontMgr.h"
#include "include/core/SkFontStyle.h"
#include "include/core/SkM44.h"
#include "include/core/SkPaint.h"
#include "include/core/SkPath.h"
#include "include/core/SkPathBuilder.h"
#include "include/core/SkPathEffect.h"
#include "include/core/SkStream.h"
#include "include/core/SkStrokeRec.h"
#include "include/core/SkTypeface.h"
#include "oski_types.h"

sk_color_t oski_color_hsv_to_color(unsigned int alpha, const float hsv[3]) {
  return SkHSVToColor(alpha, hsv);
}

void oski_color_rgb_to_hsv(unsigned int red, unsigned int green, unsigned int blue, float hsv[3]) {
  SkRGBToHSV(red, green, blue, hsv);
}

static inline SkM44 &AsSkM44(sk_matrix44_t *m) {
  return reinterpret_cast<SkM44 &>(*m);
}

static inline const SkM44 &AsConstSkM44(const sk_matrix44_t *m) {
  return reinterpret_cast<const SkM44 &>(*m);
}

void oski_m44_concat(const sk_matrix44_t *a, const sk_matrix44_t *b, sk_matrix44_t *result) {
  const SkM44 &ma = AsConstSkM44(a);
  const SkM44 &mb = AsConstSkM44(b);
  SkM44 &mresult = AsSkM44(result);
  mresult.setConcat(ma, mb);
}

bool oski_m44_invert(const sk_matrix44_t *src, sk_matrix44_t *dst) {
  const SkM44 &mSrc = AsConstSkM44(src);
  SkM44 &mDst = AsSkM44(dst);

  return mSrc.invert(&mDst);
}

void oski_matrix_set_rsxform(sk_matrix_t *matrix, const sk_rsxform_t *rsxform) {
  SkMatrix &mMatrix = reinterpret_cast<SkMatrix &>(*matrix);
  mMatrix.setRSXform(reinterpret_cast<const SkRSXform &>(*rsxform));
}

oski_typeface_id oski_typeface_get_unique_id(const sk_typeface_t *typeface) {
  return reinterpret_cast<const SkTypeface *>(typeface)->uniqueID();
}

bool oski_typeface_equal(const sk_typeface_t *typeface, const sk_typeface_t *typeface2) {
  return SkTypeface::Equal(reinterpret_cast<const SkTypeface *>(typeface),
                           reinterpret_cast<const SkTypeface *>(typeface2));
}

sk_stream_asset_t *oski_typeface_open_existing_stream(const sk_typeface_t *typeface,
                                                      int *ttcIndex) {
  return reinterpret_cast<sk_stream_asset_t *>(
      reinterpret_cast<const SkTypeface *>(typeface)->openExistingStream(ttcIndex).release());
}

sk_fontstyle_t *oski_fontstyle_create_empty() {
  return reinterpret_cast<sk_fontstyle_t *>(new SkFontStyle());
}

sk_fontstyleset_t *oski_fontstyleset_create_empty() {
  return reinterpret_cast<sk_fontstyleset_t *>(SkFontStyleSet::CreateEmpty().release());
}

bool oski_path_is_equal(const sk_path_t *path, const sk_path_t *other) {
  const SkPath *lhs = reinterpret_cast<const SkPath *>(path);
  const SkPath *rhs = reinterpret_cast<const SkPath *>(other);

  return *lhs == *rhs;
}

sk_path_t *oski_path_make_from(const sk_point_t *pts, int point_count, const uint8_t *verbs,
                               int verb_count, const float *weights, int weight_count,
                               sk_path_filltype_t fill_type, bool is_volatile) {
  return reinterpret_cast<sk_path_t *>(new SkPath(SkPath::Raw(
      SkSpan(reinterpret_cast<const SkPoint *>(pts), static_cast<size_t>(point_count)),
      SkSpan(reinterpret_cast<const SkPathVerb *>(verbs), static_cast<size_t>(verb_count)),
      SkSpan(weights, static_cast<size_t>(weight_count)), static_cast<SkPathFillType>(fill_type),
      is_volatile)));
}

bool oski_path_effect_need_ctm(const sk_path_effect_t *pe) {
  return reinterpret_cast<const SkPathEffect *>(pe)->needsCTM();
}

oski_strokerec_t *oski_strokerec_make_fill_or_hairline(bool is_hairline) {
  return reinterpret_cast<oski_strokerec_t *>(new SkStrokeRec(
      is_hairline ? SkStrokeRec::kHairline_InitStyle : SkStrokeRec::kFill_InitStyle));
}

oski_strokerec_t *oski_strokerec_make_from_paint(const sk_paint_t *paint, sk_paint_style_t style,
                                                 float res_scale) {
  return reinterpret_cast<oski_strokerec_t *>(new SkStrokeRec(
      *reinterpret_cast<const SkPaint *>(paint), static_cast<SkPaint::Style>(style), res_scale));
}

void oski_strokerec_delete(oski_strokerec_t *rec) {
  delete reinterpret_cast<SkStrokeRec *>(rec);
}

bool oski_path_effect_filter_path(const sk_path_effect_t *effect, sk_pathbuilder_t *dst,
                                  const sk_path_t *src, oski_strokerec_t *rec,
                                  const sk_rect_t *cull_rect, const sk_matrix_t *ctm) {
  const SkPathEffect *pe = reinterpret_cast<const SkPathEffect *>(effect);
  SkPathBuilder *builder = reinterpret_cast<SkPathBuilder *>(dst);
  const SkPath *path = reinterpret_cast<const SkPath *>(src);
  SkStrokeRec *stroke_rec = reinterpret_cast<SkStrokeRec *>(rec);
  if(ctm != nullptr) {
    return pe->filterPath(builder, *path, stroke_rec, reinterpret_cast<const SkRect *>(cull_rect),
                          *reinterpret_cast<const SkMatrix *>(ctm));
  }
  return pe->filterPath(builder, *path, stroke_rec);
}

// Vulkan bootstrap -- see the comment above the declarations in bindings.h.

#if defined(IS_LINUX)

#include <vector>

#include "include/third_party/vulkan/vulkan/vulkan.h"

struct oski_vk_device_t {
  VkInstance instance = VK_NULL_HANDLE;
  VkPhysicalDevice physical_device = VK_NULL_HANDLE;
  VkDevice device = VK_NULL_HANDLE;
  VkQueue queue = VK_NULL_HANDLE;
  uint32_t queue_family_index = 0;
  uint32_t api_version = VK_API_VERSION_1_1;
};

namespace {
sk_graphite_vk_func_ptr oski_vk_get_proc(void *, const char *name, vk_instance_t *instance,
                                         vk_device_t *device) {
  if(device != nullptr) {
    return reinterpret_cast<sk_graphite_vk_func_ptr>(
        vkGetDeviceProcAddr(reinterpret_cast<VkDevice>(device), name));
  }
  return reinterpret_cast<sk_graphite_vk_func_ptr>(
      vkGetInstanceProcAddr(reinterpret_cast<VkInstance>(instance), name));
}
}  // namespace

oski_vk_device_t *oski_vk_device_make(void) {
  auto *dev = new oski_vk_device_t();

  VkApplicationInfo app_info{};
  app_info.sType = VK_STRUCTURE_TYPE_APPLICATION_INFO;
  app_info.pApplicationName = "oski";
  app_info.apiVersion = dev->api_version;

  VkInstanceCreateInfo instance_info{};
  instance_info.sType = VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO;
  instance_info.pApplicationInfo = &app_info;

  if(vkCreateInstance(&instance_info, nullptr, &dev->instance) != VK_SUCCESS) {
    delete dev;
    return nullptr;
  }

  uint32_t device_count = 0;
  vkEnumeratePhysicalDevices(dev->instance, &device_count, nullptr);
  if(device_count == 0) {
    vkDestroyInstance(dev->instance, nullptr);
    delete dev;
    return nullptr;
  }
  std::vector<VkPhysicalDevice> devices(device_count);
  vkEnumeratePhysicalDevices(dev->instance, &device_count, devices.data());

  // Prefer a discrete GPU; otherwise fall back to whatever was reported first
  // (commonly a software rasterizer like llvmpipe, or an integrated GPU).
  dev->physical_device = devices[0];
  for(const auto &candidate : devices) {
    VkPhysicalDeviceProperties props;
    vkGetPhysicalDeviceProperties(candidate, &props);
    if(props.deviceType == VK_PHYSICAL_DEVICE_TYPE_DISCRETE_GPU) {
      dev->physical_device = candidate;
      break;
    }
  }

  uint32_t queue_family_count = 0;
  vkGetPhysicalDeviceQueueFamilyProperties(dev->physical_device, &queue_family_count, nullptr);
  std::vector<VkQueueFamilyProperties> queue_families(queue_family_count);
  vkGetPhysicalDeviceQueueFamilyProperties(dev->physical_device, &queue_family_count,
                                           queue_families.data());

  bool found_queue = false;
  for(uint32_t i = 0; i < queue_family_count; i++) {
    if(queue_families[i].queueFlags & VK_QUEUE_GRAPHICS_BIT) {
      dev->queue_family_index = i;
      found_queue = true;
      break;
    }
  }
  if(!found_queue) {
    vkDestroyInstance(dev->instance, nullptr);
    delete dev;
    return nullptr;
  }

  float queue_priority = 1.0f;
  VkDeviceQueueCreateInfo queue_info{};
  queue_info.sType = VK_STRUCTURE_TYPE_DEVICE_QUEUE_CREATE_INFO;
  queue_info.queueFamilyIndex = dev->queue_family_index;
  queue_info.queueCount = 1;
  queue_info.pQueuePriorities = &queue_priority;

  VkDeviceCreateInfo device_info{};
  device_info.sType = VK_STRUCTURE_TYPE_DEVICE_CREATE_INFO;
  device_info.queueCreateInfoCount = 1;
  device_info.pQueueCreateInfos = &queue_info;

  if(vkCreateDevice(dev->physical_device, &device_info, nullptr, &dev->device) != VK_SUCCESS) {
    vkDestroyInstance(dev->instance, nullptr);
    delete dev;
    return nullptr;
  }

  vkGetDeviceQueue(dev->device, dev->queue_family_index, 0, &dev->queue);
  return dev;
}

void oski_vk_device_delete(oski_vk_device_t *dev) {
  if(!dev) return;
  if(dev->device != VK_NULL_HANDLE) {
    vkDeviceWaitIdle(dev->device);
    vkDestroyDevice(dev->device, nullptr);
  }
  if(dev->instance != VK_NULL_HANDLE) {
    vkDestroyInstance(dev->instance, nullptr);
  }
  delete dev;
}

vk_instance_t *oski_vk_device_get_instance(const oski_vk_device_t *dev) {
  return reinterpret_cast<vk_instance_t *>(dev->instance);
}
vk_physical_device_t *oski_vk_device_get_physical_device(const oski_vk_device_t *dev) {
  return reinterpret_cast<vk_physical_device_t *>(dev->physical_device);
}
vk_device_t *oski_vk_device_get_device(const oski_vk_device_t *dev) {
  return reinterpret_cast<vk_device_t *>(dev->device);
}
vk_queue_t *oski_vk_device_get_queue(const oski_vk_device_t *dev) {
  return reinterpret_cast<vk_queue_t *>(dev->queue);
}
uint32_t oski_vk_device_get_queue_family_index(const oski_vk_device_t *dev) {
  return dev->queue_family_index;
}
uint32_t oski_vk_device_get_api_version(const oski_vk_device_t *dev) {
  return dev->api_version;
}

sk_graphite_vk_get_proc oski_vk_get_proc_fn(void) {
  return &oski_vk_get_proc;
}

#else  // !IS_LINUX

oski_vk_device_t *oski_vk_device_make(void) {
  return nullptr;
}
void oski_vk_device_delete(oski_vk_device_t *) {}
vk_instance_t *oski_vk_device_get_instance(const oski_vk_device_t *) {
  return nullptr;
}
vk_physical_device_t *oski_vk_device_get_physical_device(const oski_vk_device_t *) {
  return nullptr;
}
vk_device_t *oski_vk_device_get_device(const oski_vk_device_t *) {
  return nullptr;
}
vk_queue_t *oski_vk_device_get_queue(const oski_vk_device_t *) {
  return nullptr;
}
uint32_t oski_vk_device_get_queue_family_index(const oski_vk_device_t *) {
  return 0;
}
uint32_t oski_vk_device_get_api_version(const oski_vk_device_t *) {
  return 0;
}
sk_graphite_vk_get_proc oski_vk_get_proc_fn(void) {
  return nullptr;
}

#endif  // IS_LINUX

// Synchronous Graphite pixel readback -- see the comment above the
// declarations in bindings.h.

struct oski_graphite_read_pixels_result_t {
  std::vector<uint8_t> data;
  size_t row_bytes = 0;
};

namespace {
struct ReadPixelsBridge {
  oski_graphite_read_pixels_result_t *out = nullptr;
  bool done = false;
  bool failed = false;
  int32_t height = 0;
};

void oski_graphite_read_pixels_callback(void *ctx, const sk_image_async_read_result_t *result) {
  auto *bridge = reinterpret_cast<ReadPixelsBridge *>(ctx);
  bridge->done = true;
  if(result == nullptr) {
    bridge->failed = true;
    return;
  }
  size_t row_bytes = sk_image_async_read_result_get_row_bytes(result, 0);
  const void *data = sk_image_async_read_result_get_data(result, 0);
  auto *r = new oski_graphite_read_pixels_result_t();
  r->row_bytes = row_bytes;
  size_t total = row_bytes * static_cast<size_t>(bridge->height);
  r->data.resize(total);
  if(total > 0) {
    memcpy(r->data.data(), data, total);
  }
  bridge->out = r;
}
}  // namespace

oski_graphite_read_pixels_result_t *oski_graphite_context_read_pixels_sync(
    sk_graphite_context_t *context, const sk_surface_t *surface, const sk_imageinfo_t *dst_info,
    const sk_irect_t *src_rect, sk_image_rescale_gamma_t gamma, sk_image_rescale_mode_t mode,
    int32_t max_iterations) {
  ReadPixelsBridge bridge;
  bridge.height = dst_info->height;

  sk_graphite_context_async_rescale_and_read_pixels_surface(
      context, surface, dst_info, src_rect, gamma, mode, oski_graphite_read_pixels_callback,
      &bridge);

  // The read is only actually triggered by a submit (see the doc comment on
  // Context::asyncRescaleAndReadPixels in include/gpu/graphite/Context.h).
  sk_graphite_submit_info_t submit_info{};
  submit_info.fSync = true;
  sk_graphite_context_submit(context, &submit_info);

  for(int32_t i = 0; i < max_iterations && !bridge.done; i++) {
    sk_graphite_context_check_async_work_completion(context);
  }

  if(!bridge.done || bridge.failed) {
    return nullptr;
  }
  return bridge.out;
}

size_t oski_graphite_read_pixels_result_get_row_bytes(
    const oski_graphite_read_pixels_result_t *result) {
  return result->row_bytes;
}

const void *oski_graphite_read_pixels_result_get_data(
    const oski_graphite_read_pixels_result_t *result) {
  return result->data.data();
}

void oski_graphite_read_pixels_result_delete(oski_graphite_read_pixels_result_t *result) {
  delete result;
}
