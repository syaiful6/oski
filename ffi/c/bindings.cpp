#include "bindings.h"

#include "include/core/SkM44.h"
#include "include/core/SkTypeface.h"
#include "oski_types.h"

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

bool oski_m44_invert(sk_matrix44_t* matrix) {
  return SkM44().invert(reinterpret_cast<SkM44*>(matrix));
}

oski_typeface_id oski_typeface_get_unique_id(const sk_typeface_t* typeface) {
  return reinterpret_cast<const SkTypeface*>(typeface)->uniqueID();
}

bool oski_typeface_equal(const sk_typeface_t* typeface, const sk_typeface_t* typeface2) {
  return SkTypeface::Equal(reinterpret_cast<const SkTypeface*>(typeface),
                           reinterpret_cast<const SkTypeface*>(typeface2));
}
