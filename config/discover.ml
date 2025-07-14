type os =
  | Android
  | IOS
  | Linux
  | Mac
  | Windows

type feature =
  | Text_shaping
  | SVG

module Configurator = Configurator.V1

let str_true x = x = "1" || x = "yes" || x = "true" || x = "on"

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

let ccopt s = [ "-ccopt"; s ]
let cclib s = [ "-cclib"; s ]

(* Paths relative to _build/default *)
let skia_base_path vendor = Format.sprintf "%s/artifacts" vendor
let skia_source_path vendor = Format.sprintf "%s/skia" vendor
let skia_lib_path vendor = skia_base_path vendor
let skia_include_flags vendor = [ "-I" ^ skia_source_path vendor ]

(* C flags for compilation (plain strings for clang) *)
let cflags vendor = function
  | Android -> [] @ skia_include_flags vendor @ [ "-fPIC" ]
  | IOS ->
    let sdk_path = find_xcode_sysroot "iphoneos" in
    [] @ [ "-isysroot"; sdk_path ] @ skia_include_flags vendor
  | Mac ->
    let sdk_path = find_xcode_sysroot "macosx" in
    [] @ [ "-isysroot"; sdk_path ] @ skia_include_flags vendor
  | Linux -> [] @ skia_include_flags vendor @ [ "-fPIC" ]
  | Windows -> [] @ skia_include_flags vendor

let cxxflags vendor os =
  match os with
  | Android | Linux ->
    [] @ skia_include_flags vendor @ [ "-fPIC"; "-std=c++17" ]
  | IOS ->
    let sdk_path = find_xcode_sysroot "iphoneos" in
    []
    @ [ "-isysroot"; sdk_path ]
    @ skia_include_flags vendor
    @ [ "-std=c++17" ]
  | Mac ->
    let sdk_path = find_xcode_sysroot "macosx" in
    []
    @ [ "-isysroot"; sdk_path ]
    @ skia_include_flags vendor
    @ [ "-std=c++17" ]
  | Windows -> [] @ skia_include_flags vendor @ [ "/std:c++17" ]

let get_feature_flags () =
  []
  @ (match Sys.getenv_opt "SKIA_ENABLE_SHAPING" with
    | Some flag when str_true flag -> [ Text_shaping ]
    | _ -> [])
  @
  match Sys.getenv_opt "SKIA_ENABLE_SVG" with
  | Some flag when str_true flag -> [ SVG ]
  | _ -> []

let get_config_header conf os features =
  let open Configurator.C_define in
  let includes value = Value.Switch (List.exists (( = ) value) features) in
  let os_str =
    match os with
    | Android -> "android"
    | IOS -> "ios"
    | Linux -> "linux"
    | Mac -> "mac"
    | Windows -> "windows"
  in
  let is_os os_b = Value.Switch (os = os_b) in
  gen_header_file
    conf
    [ "PLATFORM_NAME", Value.String os_str
    ; "ENABLE_TEXT_SHAPING", includes Text_shaping
    ; "ENABLE_SVG", includes SVG
    ; "IS_OS", is_os IOS
    ; "IS_MACOS", is_os Mac
    ; "IS_ANDROID", is_os Android
    ; "IS_LINUX", is_os Linux
    ; "IS_WINDOWS", is_os Windows
    ]

let skia_lib_flags () =
  let base_libs = [ "-lskia" ] in
  let text_shaping_libs =
    match Sys.getenv_opt "SKIA_ENABLE_SHAPING" with
    | Some flag when str_true flag ->
      [ "-lskshaper"; "-lskunicode"; "-lskparagraph" ]
    | _ -> []
  in
  let svg_libs =
    match Sys.getenv_opt "SKIA_ENABLE_SVG" with
    | Some flag when str_true flag -> [ "-lsvg"; "-lskresources" ]
    | _ -> []
  in
  (*TODO: remove duplicate libs *)
  base_libs @ text_shaping_libs @ svg_libs

(* Library flags for linking (plain strings for clang) *)
let c_library_flags prefix = function
  | Android ->
    []
    @ skia_lib_flags ()
    @ [ "-lGLESv2"; "-llog"; "-landroid"; "-L" ^ skia_lib_path prefix ]
  | IOS ->
    []
    @ skia_lib_flags ()
    @ [ "-framework"
      ; "CoreFoundation"
      ; "-framework"
      ; "CoreGraphics"
      ; "-framework"
      ; "CoreText"
      ; "-framework"
      ; "Metal"
      ; "-framework"
      ; "MetalKit"
      ; "-L" ^ skia_lib_path prefix
      ]
  | Mac ->
    []
    @ skia_lib_flags ()
    @ [ "-framework"
      ; "ApplicationServices"
      ; "-framework"
      ; "Metal"
      ; "-framework"
      ; "MetalKit"
      ; "-framework"
      ; "Foundation"
      ; "-framework"
      ; "OpenGL"
      ; "-L" ^ skia_lib_path prefix
      ]
  | Linux ->
    []
    @ skia_lib_flags ()
    @ [ "-lfontconfig"; "-lGL"; "-L" ^ skia_lib_path prefix ]
  | Windows ->
    []
    @ skia_lib_flags ()
    @ [ "-lopengl32"
      ; "-lgdi32"
      ; "-luser32"
      ; "-lkernel32"
      ; "-L" ^ skia_lib_path prefix
      ]

let cxx_library_flags vendor os =
  match os with
  | IOS | Mac -> [] @ c_library_flags vendor os @ [ "-lc++"; "-lc++abi" ]
  | Linux | Android -> [] @ c_library_flags vendor os @ [ "-static-libstdc++" ]
  | _ -> c_library_flags vendor os (* Adjust for Windows/IOS if needed *)

(* Combined flags for OCaml (with ccopt/cclib) *)
let flags prefix os =
  (cflags prefix os |> List.map (fun s -> ccopt s) |> List.flatten)
  @ (cxx_library_flags prefix os |> List.map (fun s -> cclib s) |> List.flatten)

let () =
  let vendor = ref "" in
  let args = Arg.[ "-vendor", Set_string vendor, "vendor" ] in

  Configurator.main ~args ~name:"skia" (fun conf ->
    let os = get_os conf in
    let feature_flags = get_feature_flags () in
    (* Write feature config for ppx_optcomp *)
    get_config_header conf os feature_flags ~fname:"config.h";

    Configurator.Flags.write_sexp "flags.sexp" (flags !vendor os);
    Configurator.Flags.write_lines "c_flags.txt" (cflags !vendor os);
    Configurator.Flags.write_sexp "c_flags.sexp" (cflags !vendor os);
    Configurator.Flags.write_sexp
      "c_library_flags.sexp"
      (c_library_flags !vendor os);
    Configurator.Flags.write_lines
      "c_library_flags.txt"
      (c_library_flags !vendor os);
    Configurator.Flags.write_sexp
      "cclib_c_library_flags.sexp"
      (c_library_flags !vendor os
      |> List.map (fun s -> [ "-cclib"; s ])
      |> List.flatten);

    Configurator.Flags.write_lines "cxx_flags.txt" (cxxflags !vendor os);
    Configurator.Flags.write_sexp "cxx_flags.sexp" (cxxflags !vendor os);
    Configurator.Flags.write_lines
      "cxx_library_flags.txt"
      (cxx_library_flags !vendor os);
    Configurator.Flags.write_sexp
      "cxx_library_flags.sexp"
      (cxx_library_flags !vendor os);
    Configurator.Flags.write_sexp
      "cclib_cxx_library_flags.sexp"
      (cxx_library_flags !vendor os
      |> List.map (fun s -> [ "-cclib"; s ])
      |> List.flatten))
