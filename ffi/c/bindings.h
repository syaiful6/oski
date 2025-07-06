#ifndef OSKI_BINDINGS_H
#define OSKI_BINDINGS_H

#include "oski_types.h"

OSKI_PLUS_PLUS_BEGIN_GUARD
// Color
OSKI_BINDINGS_API sk_color_t oski_color_hsv_to_color(unsigned int alpha, const float hsv[3]);
OSKI_BINDINGS_API void oski_color_rgb_to_hsv(unsigned int red, unsigned int green,
                                             unsigned int blue, float hsv[3]);
// M44 operation helper
OSKI_BINDINGS_API void oski_m44_concat(const sk_matrix44_t* a, const sk_matrix44_t* b,
                                       sk_matrix44_t* result);
OSKI_BINDINGS_API bool oski_m44_invert(const sk_matrix44_t* src, sk_matrix44_t* dst);

OSKI_BINDINGS_API oski_typeface_id oski_typeface_get_unique_id(const sk_typeface_t* typeface);
OSKI_BINDINGS_API bool oski_typeface_equal(const sk_typeface_t* typeface,
                                           const sk_typeface_t* typeface2);

OSKI_PLUS_PLUS_END_GUARD
#endif
