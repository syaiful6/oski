#include "bindings.h"

#include "include/core/SkColor.h"
#include "include/core/SkM44.h"
#include "include/core/SkTypeface.h"
#include "oski_types.h"

sk_color_t oski_color_hsv_to_color(unsigned int alpha, const float hsv[3]) {
  return SkHSVToColor(alpha, hsv);
}

void oski_color_rgb_to_hsv(unsigned int red, unsigned int green, unsigned int blue, float hsv[3]) {
  SkRGBToHSV(red, green, blue, hsv);
}

static inline SkM44& AsSkM44(sk_matrix44_t* m) {
  return reinterpret_cast<SkM44&>(*m);
}

static inline const SkM44& AsConstSkM44(const sk_matrix44_t* m) {
  return reinterpret_cast<const SkM44&>(*m);
}

void oski_m44_concat(const sk_matrix44_t* a, const sk_matrix44_t* b, sk_matrix44_t* result) {
  const SkM44& ma = AsConstSkM44(a);
  const SkM44& mb = AsConstSkM44(b);
  SkM44& mresult = AsSkM44(result);
  mresult.setConcat(ma, mb);
}

bool oski_m44_invert(const sk_matrix44_t* src, sk_matrix44_t* dst) {
  const SkM44& mSrc = AsConstSkM44(src);
  SkM44& mDst = AsSkM44(dst);

  return mSrc.invert(&mDst);
}

void oski_matrix_set_rsxform(sk_matrix_t* matrix, const sk_rsxform_t* rsxform) {
  SkMatrix& mMatrix = reinterpret_cast<SkMatrix&>(*matrix);
  mMatrix.setRSXform(reinterpret_cast<const SkRSXform&>(*rsxform));
}

oski_typeface_id oski_typeface_get_unique_id(const sk_typeface_t* typeface) {
  return reinterpret_cast<const SkTypeface*>(typeface)->uniqueID();
}

bool oski_typeface_equal(const sk_typeface_t* typeface, const sk_typeface_t* typeface2) {
  return SkTypeface::Equal(reinterpret_cast<const SkTypeface*>(typeface),
                           reinterpret_cast<const SkTypeface*>(typeface2));
}
