#include "bindings.h"

#include "include/core/SkTypeface.h"

oski_typeface_id oski_typeface_get_unique_id(const sk_typeface_t *typeface) {
  return reinterpret_cast<const SkTypeface *>(typeface)->uniqueID();
}

bool oski_typeface_equal(const sk_typeface_t *typeface, const sk_typeface_t *typeface2) {
  return SkTypeface::Equal(reinterpret_cast<const SkTypeface *>(typeface),
                           reinterpret_cast<const SkTypeface *>(typeface2));
}
