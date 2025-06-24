module Configurator = Configurator.V1

let get_env name =
  try Sys.getenv name with
  | Not_found -> failwith ("Error: Undefined environment variable: " ^ name)

let find_xcode_sysroot sdk =
  let ic =
    Unix.open_process_in (Format.sprintf "xcrun --sdk %s --show-sdk-path" sdk)
  in
  Fun.protect ~finally:(fun () -> close_in ic) (fun () -> input_line ic)

type os =
  | Android
  | IOS
  | Linux
  | Mac
  | Windows

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

(* Common include flags for Skia *)
let skia_include_flags =
  [ "-I" ^ get_env "SKIA_INCLUDE_PATH"
  ; "-I" ^ get_env "SKIA_PREFIX_PATH" ^ "/modules"
  ]

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
      ; "-lfreetype"
      ; "-lpng"
      ; "-ljpeg"
      ; "-lz"
      ; "-lGLESv2"
      ; "-llog"
      ; "-landroid"
      ; "-L" ^ get_env "SKIA_LIB_PATH"
      ]
  | IOS ->
    []
    @ [ "-lskia"
      ; "-lfreetype"
      ; "-lpng"
      ; "-ljpeg"
      ; "-lz"
      ; "-framework"
      ; "CoreFoundation"
      ; "-framework"
      ; "CoreGraphics"
      ; "-framework"
      ; "CoreText"
      ; "-framework"
      ; "Metal"
      ; "-framework"
      ; "UIKit"
      ; "-L" ^ get_env "SKIA_LIB_PATH"
      ]
  | Mac ->
    []
    @ [ "-lskia"
      ; "-lfreetype"
      ; "-lpng"
      ; "-ljpeg"
      ; "-lz"
      ; "-framework"
      ; "CoreFoundation"
      ; "-framework"
      ; "CoreGraphics"
      ; "-framework"
      ; "CoreText"
      ; "-framework"
      ; "OpenGL"
      ; (* or Metal *)
        "-framework"
      ; "Cocoa"
      ; "-L" ^ get_env "SKIA_LIB_PATH"
      ]
  | Linux ->
    []
    @ [ "-lskia"
      ; "-lfreetype"
      ; "-lpng"
      ; "-ljpeg"
      ; "-lz"
      ; "-lfontconfig"
      ; "-lGL"
      ; "-L" ^ get_env "SKIA_LIB_PATH"
      ]
  | Windows ->
    []
    @ [ "-lskia"
      ; "-lopengl32"
      ; "-lgdi32"
      ; "-luser32"
      ; "-lkernel32"
      ; "-L" ^ get_env "SKIA_LIB_PATH"
      ]

(* Combined flags for OCaml (with ccopt/cclib) *)
let flags os =
  (cflags os |> List.map (fun s -> ccopt s) |> List.flatten)
  @ (c_library_flags os |> List.map (fun s -> cclib s) |> List.flatten)
;;

Configurator.main ~name:"skia" (fun conf ->
  let os = get_os conf in
  Configurator.Flags.write_sexp "flags.sexp" (flags os);
  Configurator.Flags.write_lines "c_flags.txt" (cflags os);
  Configurator.Flags.write_sexp "c_flags.sexp" (cflags os);
  Configurator.Flags.write_sexp "c_library_flags.sexp" (c_library_flags os);
  Configurator.Flags.write_lines "c_library_flags.txt" (c_library_flags os);
  Configurator.Flags.write_sexp
    "cclib_c_library_flags.sexp"
    (c_library_flags os |> List.map (fun s -> [ "-cclib"; s ]) |> List.flatten))
