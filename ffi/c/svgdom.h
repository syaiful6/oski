#ifndef OSKI_SVGDOM_H
#define OSKI_SVGDOM_H
#include "oski_types.h"

OSKI_PLUS_PLUS_BEGIN_GUARD

OSKI_BINDINGS_API void oski_svgdom_render(oski_svgdom_t* svgdom, sk_canvas_t* canvas);
OSKI_BINDINGS_API void oski_svgdom_set_container_size(oski_svgdom_t* svgdom, float width, float height);
OSKI_BINDINGS_API float oski_svgdom_get_container_width(oski_svgdom_t* svgdom);
OSKI_BINDINGS_API float oski_svgdom_get_container_height(oski_svgdom_t* svgdom);
OSKI_BINDINGS_API oski_svgdom_t* oski_svgdom_create_from_stream(sk_stream_t* stream);
OSKI_BINDINGS_API void oski_svgdom_ref(const oski_svgdom_t* svg);
OSKI_BINDINGS_API void oski_svgdom_unref(const oski_svgdom_t* svg);

OSKI_PLUS_PLUS_END_GUARD
#endif