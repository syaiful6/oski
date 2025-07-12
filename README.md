# Oski

This is still WIP.

OCaml bindings to the Skia. Skia is a complete 2D graphic library for drawing Text, Geometries, and Images.

We use [Mono Skia](https://github.com/mono/skia) to create this binding, as they provides C API we need.

**Oski** use [Ctypes](https://github.com/yallop/ocaml-ctypes#readme) to minimize the amount of C code in this repo, and [vendors](vendor/skia) skia to avoid versioning issues.

## External Mono Skia

You can tell oski to use prebuilt **Mono Skia binaries**. Set this environment variables during the build:

```bash
export USE_PREBUILT_SKIA="true"
export SKIA_PREBUILT_URL="file://$PWD/_prebuild/macos-arm64-text-laout.tar.gz"
```

The `SKIA_PREBUILD_URL` accept `file://`, `http://` and `https://`.
