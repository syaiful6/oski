type os =
  | Android
  | IOS
  | Linux
  | Mac
  | Windows

type arch =
  | X64
  | Arm64

let quote s = Format.sprintf "\"%s\"" s

module Target = struct
  type t =
    { arch : arch
    ; os : os
    }

  let of_os_arch os arch = { arch; os }

  let target_args t =
    let os =
      match t.os with
      | Linux -> "linux"
      | Mac -> "mac"
      | Windows -> "win"
      | Android -> "android"
      | IOS -> "ios"
    in
    let cpu = match t.arch with Arm64 -> "arm64" | X64 -> "x64" in
    [ "target_os", quote os; "target_cpu", quote cpu ]
end

module GnArgs = struct
  type t =
    { target : Target.t
    ; mutable args : (string * string) list
    ; mutable cflags : string list
    ; mutable ldflags : string list
    }

  let enable_if b = if b then "true" else "false"

  let enable_with_env name =
    let env = Sys.getenv_opt name in
    enable_if
      (Option.fold ~none:false ~some:(fun x -> x == "yes" || x == "1") env)

  let of_target target = { target; args = []; cflags = []; ldflags = [] }

  let arg ~name value t =
    t.args <- List.cons (name, value) t.args;
    t

  let cflag flag t =
    t.cflags <- List.cons flag t.cflags;
    t

  let ldflag flag t =
    t.ldflags <- List.cons flag t.ldflags;
    t

  let extra_compiler_flags xs = xs |> List.map quote |> String.concat ","

  let to_gn_args t =
    let target_args = Target.target_args t.target in
    let cflags =
      [ "extra_cflags", Format.sprintf "[%s]" (extra_compiler_flags t.cflags) ]
    in
    let ldflags =
      [ "extra_ldflags", Format.sprintf "[%s]" (extra_compiler_flags t.ldflags)
      ]
    in
    target_args @ t.args @ cflags @ ldflags

  let setup_args t =
    ( t
    |> arg ~name:"is_official_build" "true"
    |> arg ~name:"is_debug" "false"
    |> arg ~name:"is_component_build" "false"
    |> arg ~name:"skia_enable_tools" "false"
    |> arg ~name:"skia_enable_svg" "true"
    |> arg ~name:"skia_use_piex" "true"
    |> arg ~name:"skia_use_sfntly" "false"
    |> arg ~name:"skia_use_system_expat" "false"
    |> arg ~name:"skia_use_system_libjpeg_turbo" "false"
    |> arg ~name:"skia_use_system_libpng" "false"
    |> arg ~name:"skia_use_system_libwebp" "false"
    |> arg ~name:"skia_use_system_zlib" "false"
    |> arg ~name:"skia_enable_skottie" "true"
    |> arg ~name:"skia_enable_pdf" "true"
    (* Text layout / sharping *)
    |> fun t ->
      match Sys.getenv_opt "SKIA_ENABLE_TEXT_LAYOUT" with
      | Some x when x = "1" || x = "yes" ->
        t
        |> arg ~name:"skia_enable_skshaper" "true"
        |> arg ~name:"skia_use_icu" "true"
        (* Mono uncomment icu deps, so we need to fallback to system icu *)
        |> arg ~name:"skia_use_system_icu" "true"
        |> arg ~name:"skia_use_harfbuzz" "true"
        |> arg ~name:"skia_pdf_subset_harfbuzz" "true"
        |> arg ~name:"skia_use_system_harfbuzz" "false"
        |> arg ~name:"skia_enable_skparagraph" "true"
      | _ ->
        t
        |> arg ~name:"skia_use_icu" "false"
        |> arg ~name:"skia_use_harfbuzz" "false" )
    |> fun t ->
    match t.target.os with
    | Linux ->
      t
      |> arg ~name:"cc" (quote "clang")
      |> arg ~name:"cxx" (quote "clang++")
      |> arg ~name:"skia_enable_ganesh" (enable_with_env "SUPPORT_GPU")
      |> arg ~name:"skia_use_vulkan" (enable_with_env "SUPPORT_VULKAN")
      |> cflag "-DSKIA_C_DLL"
      |> cflag "-DHAVE_SYSCALL_GETRANDOM"
      |> ldflag "-static-libstdc++"
      |> ldflag "-static-libgcc"
    | Mac ->
      t
      |> arg ~name:"skia_use_metal" "true"
      |> cflag "-DSKIA_C_DLL"
      |> cflag "-DHAVE_ARC4RANDOM_BUF"
      |> cflag "-stdlib=libc++"
      |> ldflag "-stdlib=libc++"
    | Windows ->
      t
      |> arg ~name:"cc" (quote "clang")
      |> arg ~name:"cxx" (quote "clang++")
      |> arg ~name:"skia_enable_fontmgr_win_gdi" "false"
      |> arg ~name:"skia_use_dng_sdk" "false"
      |> arg ~name:"skia_use_vulkan" (enable_with_env "SUPPORT_VULKAN")
      |> arg ~name:"skia_use_direct3d" (enable_with_env "SUPPORT_DIRECT3D")
      |> cflag "-DSKIA_C_DLL"
      |> cflag "/MT" (* /Mtd to enable debug *)
      |> cflag "/EHsc"
      |> cflag "/Z7"
      |> cflag "-D_HAS_AUTO_PTR_ETC=1"
      |> ldflag "/DEBUG:FULL"
      |> ldflag "/DEBUGTYPE:CV,FIXUP"
    | Android ->
      t
      |> arg ~name:"skia_enable_ganesh" "true"
      |> cflag "-DSKIA_C_DLL"
      |> ldflag "-static-libstdc++"
    | IOS ->
      t
      |> arg ~name:"skia_use_metal" "true"
      |> cflag "-DSKIA_C_DLL"
      |> cflag "-DHAVE_ARC4RANDOM_BUF"
end

module Configurator = Configurator.V1

let find_xcode_sysroot sdk =
  let ic =
    Unix.open_process_in (Format.sprintf "xcrun --sdk %s --show-sdk-path" sdk)
  in
  Fun.protect ~finally:(fun () -> close_in ic) (fun () -> input_line ic)

let detect_system_header =
  {|
  #if __APPLE__
    #include <TargetConditionals.h>
    #if TARGET_OS_IPHONE
      #define PLATFORM_NAME "ios"
    #else
      #define PLATFORM_NAME "mac"
    #endif
  #elif __linux__
    #if __ANDROID__
      #define PLATFORM_NAME "android"
    #else
      #define PLATFORM_NAME "linux"
    #endif
  #elif WIN32
    #define PLATFORM_NAME "windows"
  #endif
|}

let get_os t =
  let header =
    let file = Filename.temp_file "discover" "os.h" in
    let fd = open_out file in
    output_string fd detect_system_header;
    close_out fd;
    file
  in
  let platform =
    Configurator.C_define.import
      t
      ~includes:[ header ]
      [ "PLATFORM_NAME", String ]
  in
  match platform with
  | [ (_, String "android") ] -> Android
  | [ (_, String "ios") ] -> IOS
  | [ (_, String "linux") ] -> Linux
  | [ (_, String "mac") ] -> Mac
  | [ (_, String "windows") ] -> Windows
  | _ -> failwith "Unknown operating system"

let get_arch () =
  let ic = Unix.open_process_in "uname -m" in
  let arch =
    Fun.protect ~finally:(fun () -> close_in ic) (fun () -> input_line ic)
  in
  match arch with
  | "x86_64" -> X64
  | "arm64" | "aarch64" -> Arm64
  | _ -> failwith "Unsupported architecture"

let ccopt s = [ "-ccopt"; s ]
let cclib s = [ "-cclib"; s ]

(* Paths relative to _build/default *)
let skia_base_path = "../../vendor/prefix"
let skia_include_path = skia_base_path ^ "/include"
let skia_lib_path = skia_base_path ^ "/lib"
let skia_include_flags = [ "-I" ^ skia_include_path ]

(* C flags for compilation (plain strings for clang) *)
let cflags = function
  | Android -> [] @ skia_include_flags @ [ "-fPIC" ]
  | IOS ->
    let sdk_path = find_xcode_sysroot "iphoneos" in
    [] @ [ "-isysroot"; sdk_path ] @ skia_include_flags
  | Mac ->
    let sdk_path = find_xcode_sysroot "macosx" in
    [] @ [ "-isysroot"; sdk_path ] @ skia_include_flags
  | Linux -> [] @ skia_include_flags @ [ "-fPIC" ]
  | Windows -> [] @ skia_include_flags

(* Library flags for linking (plain strings for clang) *)
let c_library_flags = function
  | Android ->
    []
    @ [ "-lskia"
      ; "-lsvg"
      ; "-lskottie"
      ; "-lGLESv2"
      ; "-llog"
      ; "-landroid"
      ; "-L" ^ skia_lib_path
      ]
  | IOS ->
    []
    @ [ "-lskia"
      ; "-lsvg"
      ; "-lskottie"
      ; "-framework"
      ; "CoreFoundation"
      ; "-framework"
      ; "CoreGraphics"
      ; "-framework"
      ; "CoreText"
      ; "-framework"
      ; "Metal"
      ; "-framework"
      ; "MetalKit"
      ; "-L" ^ skia_lib_path
      ]
  | Mac ->
    []
    @ [ "-lskia"
      ; "-lsvg"
      ; "-lskottie"
      ; "-framework"
      ; "ApplicationServices"
      ; "-framework"
      ; "Metal"
      ; "-framework"
      ; "MetalKit"
      ; "-framework"
      ; "Foundation"
      ; "-framework"
      ; "OpenGL"
      ; "-L" ^ skia_lib_path
      ]
  | Linux ->
    []
    @ [ "-lskia"
      ; "-lsvg"
      ; "-lskottie"
      ; "-lfontconfig"
      ; "-lGL"
      ; "-L" ^ skia_lib_path
      ]
  | Windows ->
    []
    @ [ "-lskia"
      ; "-lsvg"
      ; "-lskottie"
      ; "-lopengl32"
      ; "-lgdi32"
      ; "-luser32"
      ; "-lkernel32"
      ; "-L" ^ skia_lib_path
      ]

(* Combined flags for OCaml (with ccopt/cclib) *)
let flags os =
  (cflags os |> List.map (fun s -> ccopt s) |> List.flatten)
  @ (c_library_flags os |> List.map (fun s -> cclib s) |> List.flatten)
;;

Configurator.main ~name:"skia" (fun conf ->
  let os = get_os conf in
  let target = Target.of_os_arch os (get_arch ()) in
  let gn_args =
    GnArgs.of_target target
    |> GnArgs.setup_args
    |> GnArgs.to_gn_args
    |> List.map (fun (name, value) -> Format.sprintf "%s=%s" name value)
    |> String.concat " "
  in
  Configurator.Flags.write_sexp "flags.sexp" (flags os);
  Configurator.Flags.write_lines "c_flags.txt" (cflags os);
  Configurator.Flags.write_sexp "c_flags.sexp" (cflags os);
  Configurator.Flags.write_sexp "c_library_flags.sexp" (c_library_flags os);
  Configurator.Flags.write_lines "c_library_flags.txt" (c_library_flags os);
  Configurator.Flags.write_sexp
    "cclib_c_library_flags.sexp"
    (c_library_flags os |> List.map (fun s -> [ "-cclib"; s ]) |> List.flatten);
  Configurator.Flags.write_lines "gn_args.txt" [ gn_args ])
