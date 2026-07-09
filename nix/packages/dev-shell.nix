{
  lib,
  stdenv,
  mkShell,
  treefmt,
  pkgs,
  ocamlPackages,
}:

let
  llvmPkgs = pkgs.llvmPackages_18;
in
mkShell {
  inputsFrom = with ocamlPackages; [
    oski
  ];
  SKIA_NINJA_COMMAND = "${pkgs.ninja}/bin/ninja";
  SKIA_GN_COMMAND = "${pkgs.gn}/bin/gn";

  LIBCLANG_PATH = "${llvmPkgs.libclang}/lib/libclang.so";

  shellHook = ''
    export CC="${llvmPkgs.clang}/bin/clang"
    export CXX="${llvmPkgs.clang}/bin/clang++"
    export LIBCLANG_PATH="${llvmPkgs.libclang}/lib"
  '';

  buildInputs =
    (with ocamlPackages; [
      ocaml-lsp
      ocamlformat
    ])
    ++
    (with pkgs;
    [
      llvmPkgs.clang
      ninja
      gn
      git
      fontconfig
      libiconv
      python3
      llvmPkgs.libcxx
      pkg-config
    ])
    ++ lib.optionals stdenv.isLinux [
      pkgs.vulkan-headers
      pkgs.vulkan-loader
      pkgs.libGL
    ];
}
