{
  lib,
  stdenv,
  ocamlPackages,
  packages,
  pkgs,
  llvmPkgs,
}:

with ocamlPackages;

pkgs.mkShell {
  inputsFrom = with packages; [ oskia ];
  SKIA_NINJA_COMMAND = "${pkgs.ninja}/bin/ninja";
  SKIA_GN_COMMAND = "${pkgs.gn}/bin/gn";

  LIBCLANG_PATH = "${llvmPkgs.libclang}/lib/libclang.so";

  shellHook = ''
    export CC="${llvmPkgs.clang}/bin/clang"
    export CXX="${llvmPkgs.clang}/bin/clang++"
    export LIBCLANG_PATH="${llvmPkgs.libclang}/lib"
  '';

  buildInputs =
    with pkgs;
    [
      ocaml
      dune
      dune-configurator
      ocaml-lsp
      ocamlformat
      utop
      llvmPkgs.clang
      ninja
      gn
      fontconfig
      libiconv
      python3
      llvmPkgs.libcxx
      pkg-config
    ]
    ++ lib.optionals stdenv.isLinux [
      pkgs.vulkan-headers
      pkgs.vulkan-loader
    ];
}
