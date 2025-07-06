#include "include/c/gr_context.h"
#include "include/c/sk_canvas.h"
#include "include/c/sk_paint.h"
#include "include/c/sk_patheffect.h"
#include "include/c/sk_shader.h"
#include "include/c/sk_types.h"
#include "oski_types.h"

void oski_stub_sk_canvas_draw_rect_ltwh(sk_canvas_t* canvas, float left, float top, float width,
                                        float height, sk_paint_t* paint);

sk_shader_t* oski_stub_linear_gradient2(sk_point_t* startPosition, sk_point_t* stopPosition,
                                        sk_color_t startColor, sk_color_t stopColor,
                                        sk_shader_tilemode_t tileMode);

sk_shader_t* oski_stub_linear_gradient(sk_point_t* startPosition, sk_point_t* stopPosition,
                                       sk_color_t* colors, float* positions, int count,
                                       sk_shader_tilemode_t tileMode);

void oski_stub_paint_set_alpha(sk_paint_t* pPaint, double alpha);

void oski_stub_matrix_set_translate(sk_matrix_t* matrix, double translateX, double translateY);
void oski_stub_matrix_set_scale(sk_matrix_t* matrix, double scaleX, double scaleY, double pivotX,
                                double pivotY);

void oski_stub_rect_set(sk_rect_t* pRect, double left, double top, double right, double bottom);
