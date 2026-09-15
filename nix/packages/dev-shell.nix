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
  ''
  + lib.optionalString stdenv.isLinux ''
    # The nix-provided vulkan-loader doesn't search /usr/share/vulkan/icd.d,
    # and even if it did, a system Mesa ICD's "library_path" is a bare
    # filename resolved via the system's own ld.so search path, which a
    # nix-sandboxed process doesn't have. Point the loader at nixpkgs' own
    # Mesa ICDs instead, whose driver .so is referenced by an absolute nix
    # store path.
    export VK_ICD_FILENAMES="$(echo ${pkgs.mesa}/share/vulkan/icd.d/*.json | tr ' ' ':')"
    export VK_DRIVER_FILES="$VK_ICD_FILENAMES"
  '';

  buildInputs =
    (with ocamlPackages; [
      ocaml-lsp
      ocamlformat
    ])
    ++ (with pkgs; [
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
      pkgs.vulkan-tools
      pkgs.mesa
      pkgs.libGL
    ];
}
