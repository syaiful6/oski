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

  buildOski =
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
            pkgs.mesa
            pkgs.libglvnd
          ];
      }
      // args
    );
in

rec {
  oski = buildOski {
    pname = "oski";
    src = genSrc {
      dirs = [
        "config"
        "lib"
        "types"
        "ffi"
        "vendor"
      ];
      files = [ "oski.opam" ];
    };
    propagatedBuildInputs = [
      ctypes
      dune
      dune-configurator
      ppx_optcomp
    ];
  };
}
