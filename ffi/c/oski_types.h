#ifndef OSKI_TYPES_H
#define OSKI_TYPES_H

#ifdef _WIN32
#  ifdef OSKI_BINDINGS_EXPORTS // This macro should be defined ONLY when building your shared library
#    define OSKI_BINDINGS_API __declspec(dllexport)
#  else // This is used when linking against your already compiled shared library
#    define OSKI_BINDINGS_API __declspec(dllimport)
#  endif
#else // For GCC/Clang on Linux/macOS
#  define OSKI_BINDINGS_API __attribute__((visibility("default")))
#endif

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

// for SkV3 binding to C++ structure
typedef struct {
  float x;
  float y;
  float z;
} oski_v3_t;

// for SkV4 binding to C++ structure
typedef struct {
  float x;
  float y;
  float z;
  float w;
} oski_v4_t;

typedef struct oski_svgdom_t oski_svgdom_t;
typedef uint32_t oski_typeface_id;

OSKI_PLUS_PLUS_END_GUARD

#endif