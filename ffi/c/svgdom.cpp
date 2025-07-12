#include "svgdom.h"
#ifdef ENABLE_SVG
#include "include/core/SkCanvas.h"
#include "include/core/SkRefCnt.h"
#include "include/core/SkSize.h"
#include "include/core/SkStream.h"
#include "modules/svg/include/SkSVGDOM.h"

void oski_svgdom_render(oski_svgdom_t *svgdom, sk_canvas_t *canvas) {
  reinterpret_cast<SkSVGDOM *>(svgdom)->render(reinterpret_cast<SkCanvas *>(canvas));
}

void oski_svgdom_set_container_size(oski_svgdom_t *svgdom, float width, float height) {
  reinterpret_cast<SkSVGDOM *>(svgdom)->setContainerSize(SkSize::Make(width, height));
}

float oski_svgdom_get_container_width(oski_svgdom_t *svgdom) {
  return reinterpret_cast<SkSVGDOM *>(svgdom)->containerSize().width();
}

float oski_svgdom_get_container_height(oski_svgdom_t *svgdom) {
  return reinterpret_cast<SkSVGDOM *>(svgdom)->containerSize().height();
}

oski_svgdom_t *oski_svgdom_create_from_stream(sk_stream_t *stream) {
  return reinterpret_cast<oski_svgdom_t *>(
      SkSVGDOM::MakeFromStream(*reinterpret_cast<SkStream *>(stream)).release());
}

void oski_svgdom_ref(const oski_svgdom_t *svg) {
  SkSafeRef(reinterpret_cast<const SkSVGDOM *>(svg));
}

void oski_svgdom_unref(const oski_svgdom_t *svg) {
  SkSafeUnref(reinterpret_cast<const SkSVGDOM *>(svg));
}
#endif
