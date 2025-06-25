{ lib, stdenv, ocamlPackages, packages, pkgs }:

with ocamlPackages;

pkgs.mkShell {
  inputsFrom = with packages; [ oskia ];
  SKIA_NINJA_COMMAND = "${pkgs.ninja}/bin/ninja";
  SKIA_GN_COMMAND = "${pkgs.gn}/bin/gn";
  LIBCLANG_PATH = "${pkgs.llvmPackages.libclang}/lib/libclang.so";

  shellHook = ''
    export CC="${pkgs.clang}/bin/clang"
    export CXX="${pkgs.clang}/bin/clang++"
    export LIBCLANG_PATH="${pkgs.libclang.lib}/lib"
  '';

  buildInputs = [
    ocaml
    dune
    ocaml-lsp
    ocamlformat
    utop
  ];
}
