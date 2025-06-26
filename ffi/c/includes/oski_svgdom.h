#ifndef oski_svgdom_c_DEFINED
#define oski_svgdom_c_DEFINED

#include "oski_types.h"
SK_C_PLUS_PLUS_BEGIN_GUARD

SK_C_API void oski_svgdom_render(oski_svgdom_t *svgdom, sk_canvas_t *canvas);
SK_C_API void oski_svgdom_set_container_size(oski_svgdom_t *svgdom, float width, float height);
SK_C_API float oski_svgdom_get_container_width(oski_svgdom_t *svgdom);
SK_C_API float oski_svgdom_get_container_height(oski_svgdom_t *svgdom);
SK_C_API oski_svgdom_t* oski_svgdom_create_from_stream(sk_stream_t *stream);
SK_C_API void oski_svgdom_ref(const oski_svgdom_t *svg);
SK_C_API void oski_svgdom_unref(const oski_svgdom_t *svg);

SK_C_PLUS_PLUS_END_GUARD
#endif