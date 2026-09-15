#ifndef OSKI_BINDINGS_H
#define OSKI_BINDINGS_H

#include "oski_types.h"

OSKI_PLUS_PLUS_BEGIN_GUARD

#include "include/c/sk_graphite_vulkan.h"
// Color
OSKI_BINDINGS_API sk_color_t oski_color_hsv_to_color(unsigned int alpha, const float hsv[3]);
OSKI_BINDINGS_API void oski_color_rgb_to_hsv(unsigned int red, unsigned int green,
                                             unsigned int blue, float hsv[3]);
// Matrix
OSKI_BINDINGS_API void oski_matrix_set_rsxform(sk_matrix_t *matrix, const sk_rsxform_t *rsxform);
// M44 operation helper
OSKI_BINDINGS_API void oski_m44_concat(const sk_matrix44_t *a, const sk_matrix44_t *b,
                                       sk_matrix44_t *result);
OSKI_BINDINGS_API bool oski_m44_invert(const sk_matrix44_t *src, sk_matrix44_t *dst);

// typeface
OSKI_BINDINGS_API oski_typeface_id oski_typeface_get_unique_id(const sk_typeface_t *typeface);
OSKI_BINDINGS_API bool oski_typeface_equal(const sk_typeface_t *typeface,
                                           const sk_typeface_t *typeface2);
OSKI_BINDINGS_API sk_stream_asset_t *oski_typeface_open_existing_stream(
    const sk_typeface_t *typeface, int *ttcIndex);
// font style
OSKI_BINDINGS_API sk_fontstyle_t *oski_fontstyle_create_empty();
// Font manager
OSKI_BINDINGS_API sk_fontstyleset_t *oski_fontstyleset_create_empty();

// Path
OSKI_BINDINGS_API bool oski_path_is_equal(const sk_path_t *path, const sk_path_t *other);

OSKI_BINDINGS_API sk_path_t *oski_path_make_from(const sk_point_t pts[], int point_count,
                                                 const uint8_t verbs[], int verb_count,
                                                 const float weights[], int weight_count,
                                                 sk_path_filltype_t fill_type, bool is_volatile);

OSKI_BINDINGS_API bool oski_path_effect_need_ctm(const sk_path_effect_t *pe);

// Stroke rec: wraps SkStrokeRec, needed by oski_path_effect_filter_path.
OSKI_BINDINGS_API oski_strokerec_t *oski_strokerec_make_fill_or_hairline(bool is_hairline);
OSKI_BINDINGS_API oski_strokerec_t *oski_strokerec_make_from_paint(const sk_paint_t *paint,
                                                                   sk_paint_style_t style,
                                                                   float res_scale);
OSKI_BINDINGS_API void oski_strokerec_delete(oski_strokerec_t *rec);

// [oski_path_effect_filter_path effect dst src rec cull_rect ctm] applies
// [effect] to [src], writing the result into the path builder [dst]. [ctm]
// may be NULL, in which case [cull_rect] is ignored too (mirrors
// SkPathEffect::filterPath's two overloads).
OSKI_BINDINGS_API bool oski_path_effect_filter_path(const sk_path_effect_t *effect,
                                                    sk_pathbuilder_t *dst, const sk_path_t *src,
                                                    oski_strokerec_t *rec,
                                                    const sk_rect_t *cull_rect,
                                                    const sk_matrix_t *ctm);

// Vulkan bootstrap: creates a minimal headless VkInstance + VkDevice + a
// single graphics queue, suitable for feeding into Graphite's Vulkan
// backend (sk_graphite_context_make_vulkan). This is NOT meant to replace
// an application's own Vulkan/window-surface setup -- it exists to get the
// Graphite+Vulkan pipeline working end to end without one (e.g. an
// offscreen render target). Only implemented on Linux for now; other
// platforms get stubs that always return NULL/0.
typedef struct oski_vk_device_t oski_vk_device_t;

// Returns NULL on failure (no Vulkan loader, no suitable GPU/queue, etc).
OSKI_BINDINGS_API oski_vk_device_t *oski_vk_device_make(void);
OSKI_BINDINGS_API void oski_vk_device_delete(oski_vk_device_t *dev);

OSKI_BINDINGS_API vk_instance_t *oski_vk_device_get_instance(const oski_vk_device_t *dev);
OSKI_BINDINGS_API vk_physical_device_t *oski_vk_device_get_physical_device(
    const oski_vk_device_t *dev);
OSKI_BINDINGS_API vk_device_t *oski_vk_device_get_device(const oski_vk_device_t *dev);
OSKI_BINDINGS_API vk_queue_t *oski_vk_device_get_queue(const oski_vk_device_t *dev);
OSKI_BINDINGS_API uint32_t oski_vk_device_get_queue_family_index(const oski_vk_device_t *dev);
OSKI_BINDINGS_API uint32_t oski_vk_device_get_api_version(const oski_vk_device_t *dev);

// A sk_graphite_vk_get_proc-compatible function pointer (userData is
// ignored). Pass the result directly as
// sk_graphite_vk_backend_context_init_t::fGetProc.
OSKI_BINDINGS_API sk_graphite_vk_get_proc oski_vk_get_proc_fn(void);

// Synchronous Graphite pixel readback. sk_graphite_context_async_rescale_and_read_pixels_surface
// is inherently async (its result is only valid for the duration of the
// callback), which doesn't map onto a plain OCaml value; this pumps
// sk_graphite_context_check_async_work_completion internally, copies plane 0
// out of the callback's result before it's invalidated, and returns it
// synchronously. Returns NULL on failure, or if the read hasn't completed
// after [max_iterations] pumps.
OSKI_BINDINGS_API oski_graphite_read_pixels_result_t *oski_graphite_context_read_pixels_sync(
    sk_graphite_context_t *context, const sk_surface_t *surface, const sk_imageinfo_t *dst_info,
    const sk_irect_t *src_rect, sk_image_rescale_gamma_t gamma, sk_image_rescale_mode_t mode,
    int32_t max_iterations);

OSKI_BINDINGS_API size_t
oski_graphite_read_pixels_result_get_row_bytes(const oski_graphite_read_pixels_result_t *result);
OSKI_BINDINGS_API const void *oski_graphite_read_pixels_result_get_data(
    const oski_graphite_read_pixels_result_t *result);
OSKI_BINDINGS_API void oski_graphite_read_pixels_result_delete(
    oski_graphite_read_pixels_result_t *result);

OSKI_PLUS_PLUS_END_GUARD
#endif
