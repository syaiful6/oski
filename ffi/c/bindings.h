#ifndef OSKI_BINDINGS_H
#define OSKI_BINDINGS_H

#include "oski_types.h"

OSKI_PLUS_PLUS_BEGIN_GUARD
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

OSKI_BINDINGS_API bool oski_path_effect_filter_path(sk_path_effect_t *dst,
                                                    const sk_path_effect_t *src,
                                                    const sk_rect_t *cull_rect);

OSKI_PLUS_PLUS_END_GUARD
#endif
