# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

**Oski** is an OCaml binding to the [Skia](https://skia.org) 2D graphics library. It targets Mono Skia's C API (not Google's upstream Skia directly) and uses [ctypes](https://github.com/yallop/ocaml-ctypes) with the `Cstubs` codegen approach to minimize handwritten C glue code.

## Development Environment

The project uses Nix flakes. Enter the dev shell before building:

```bash
nix develop
```

The dev shell provides clang 18, ninja, gn, ocaml-lsp, ocamlformat, and all other build dependencies.

## Common Commands

```bash
# Build everything (compiles Skia from source on first run — takes a while)
dune build

# Run all tests
dune test

# Run a single test executable
dune exec test/main.exe

# Format OCaml code
ocamlformat --inplace <file>.ml

# Format C/C++ code
clang-format -i ffi/c/*.{c,cpp,h}
```

### Skia Build Options

By default, Skia is compiled from source via `vendor/scripts/compile-skia.sh` using gn + ninja. To use prebuilt binaries instead:

```bash
export USE_PREBUILT_SKIA=true
export SKIA_PREBUILT_URL="file://$PWD/_prebuild/linux-x64.tar.gz"
dune build
```

Optional Skia features (off by default):

```bash
export SKIA_ENABLE_SVG=true        # adds libsvg, libskresources
export SKIA_ENABLE_SHAPING=true    # adds libskshaper, libskunicode, libskparagraph
```

## Architecture

The codebase is layered; each layer depends only on those below it:

```
lib/            ← High-level OCaml API (oski package, exposed via oski.mli)
ffi/lib/        ← Generated FFI glue (oski.ffi) — do not edit g.ml/m.ml directly
ffi/stubgen/    ← Executable that drives Cstubs codegen
ffi/bindings/   ← Foreign function declarations (oski.bindings)
types/          ← C type definitions using ctypes TYPE functor (oski.types)
ffi/c/          ← Handwritten C/C++ helpers where Skia's C API needs adaptation
vendor/         ← Vendored Skia source (git submodule) + build scripts
config/         ← dune-configurator: detects OS, emits C/C++ flags as .sexp/.txt
```

### How the FFI Pipeline Works

1. **`types/bindings/oski_bindings_types.ml`** — declares Skia C structs and enums using the `Ctypes.TYPE` functor. The `skia_c_enum` helper maps OCaml polymorphic variants to Skia's `ENUM_VALUE_SK_TYPENAME` naming convention.

2. **`ffi/bindings/oski_bindings.ml`** — declares foreign functions using the `Ctypes.FOREIGN` functor. All `sk_*` symbols come from Mono Skia's C headers; `oski_*` symbols are custom helpers in `ffi/c/`.

3. **`ffi/stubgen/ffi_stubgen.ml`** — runs `Cstubs.write_ml` / `Cstubs.write_c` to auto-generate `ffi/lib/g.ml` (OCaml bindings) and `ffi/lib/oski_stubs.c` (C trampolines).

4. **`ffi/c/bindings.{h,cpp}`** — custom C++ wrappers for things that can't be expressed directly (e.g. `oski_path_make_from`, `oski_m44_concat`). Only add helpers here when the Mono Skia C API is missing or awkward.

5. **`lib/`** — wraps the raw FFI in idiomatic OCaml. Types like `Rect.t`, `Color.t`, `Path.t` are pure OCaml records/abstracts with `to_native`/`of_native` converters that cross the FFI boundary.

### Adding New Bindings

1. If a helper C function is needed: add declaration to `ffi/c/bindings.h` and implementation to `ffi/c/bindings.cpp`.
2. Add struct/enum types to `types/bindings/oski_bindings_types.ml`.
3. Declare foreign functions in `ffi/bindings/oski_bindings.ml` inside `module M (F : Ctypes.FOREIGN)`.
4. Add the high-level OCaml API in a new or existing file under `lib/`, and expose it in `lib/oski.mli`.
5. `ppx_optcomp` is used in `ffi/bindings/` for conditional compilation based on `config/config.h` flags (e.g. `[%%if defined ENABLE_SVG]`).

### Platform Detection

`config/discover.ml` (dune-configurator) runs at build time to detect the OS, writes `config.h` (for ppx_optcomp), and emits flag files (`c_flags.txt`, `cxx_flags.txt`, `c_library_flags.txt`, etc.) consumed by dune rules in `ffi/c/dune` and `ffi/lib/dune`.

## Testing

Tests use **alcotest** in `test/`. `test_oski.ml` tests the high-level `Oski` API; `test_ffi.ml` tests lower-level FFI behaviour. `test/main.ml` registers both suites.
