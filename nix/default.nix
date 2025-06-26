{
  lib,
  stdenv,
  ocamlPackages,
  nix-filter,
  doCheck ? true,
  pkgs,
  llvmPkgs,
}:

with ocamlPackages;

let
  genSrc =
    { dirs, files }:
    with nix-filter;
    filter {
      root = ./..;
      include = [ "dune-project" ] ++ files ++ (builtins.map inDirectory dirs);
    };

  buildOskia =
    args:
    buildDunePackage (
      {
        version = "0.0.1";
        doCheck = doCheck;
        duneVersion = "3";
        nativeBuildInputs =
          with pkgs;
          [
            llvmPkgs.clang
            llvmPkgs.libcxx
            fontconfig
            libiconv
            ninja
            gn
            python3
            pkg-config
          ]
          ++ lib.optionals stdenv.isLinux [
            pkgs.vulkan-headers
            pkgs.vulkan-loader
          ];

        buildInputs = lib.optionals (stdenv.isLinux || stdenv.isDarwin) [
          pkgs.icu
        ];
      }
      // args
    );
in

rec {
  oskia = buildOskia {
    pname = "oskia";
    src = genSrc {
      dirs = [
        "config"
        "lib"
        "types"
        "ffi"
        "vendor"
      ];
      files = [ "oskia.opam" ];
    };
    propagatedBuildInputs = [
      ctypes
      dune
      dune-configurator
    ];
  };
}
