#ifndef OSKI_BINDINGS_H
#define OSKI_BINDINGS_H

#include "oski_types.h"

OSKI_PLUS_PLUS_BEGIN_GUARD

oski_typeface_id oski_typeface_get_unique_id(const sk_typeface_t* typeface);
bool oski_typeface_equal(const sk_typeface_t* typeface, const sk_typeface_t* typeface2);

OSKI_PLUS_PLUS_END_GUARD

#endif