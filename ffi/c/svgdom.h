#ifndef OSKI_SVGDOM_H
#define OSKI_SVGDOM_H

#include "oski_types.h"

OSKI_PLUS_PLUS_BEGIN_GUARD

void oski_svgdom_render(oski_svgdom_t* svgdom, sk_canvas_t* canvas);
void oski_svgdom_set_container_size(oski_svgdom_t* svgdom, float width, float height);
float oski_svgdom_get_container_width(oski_svgdom_t* svgdom);
float oski_svgdom_get_container_height(oski_svgdom_t* svgdom);
oski_svgdom_t* oski_svgdom_create_from_stream(sk_stream_t* stream);
void oski_svgdom_ref(const oski_svgdom_t* svg);
void oski_svgdom_unref(const oski_svgdom_t* svg);

OSKI_PLUS_PLUS_END_GUARD

#endif
