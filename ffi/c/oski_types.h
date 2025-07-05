#ifndef OSKI_TYPES_H
#define OSKI_TYPES_H

#ifdef __cplusplus
#define OSKI_PLUS_PLUS_BEGIN_GUARD extern "C" {
#define OSKI_PLUS_PLUS_END_GUARD }
#else
#include <stdbool.h>
#define OSKI_PLUS_PLUS_BEGIN_GUARD
#define OSKI_PLUS_PLUS_END_GUARD
#endif

OSKI_PLUS_PLUS_BEGIN_GUARD

#include "include/c/sk_types.h"

typedef struct oski_svgdom_t oski_svgdom_t;
typedef uint32_t oski_typeface_id;

OSKI_PLUS_PLUS_END_GUARD

#endif