{ lib, stdenv, ocamlPackages, nix-filter, doCheck ? true, pkgs }:

with ocamlPackages;

let
  genSrc = { dirs, files }:
    with nix-filter; filter {
      root = ./..;
      include = [ "dune-project" ] ++ files ++ (builtins.map inDirectory dirs);
    };

  builOskia = args: buildDunePackage ({
    version = "0.0.1";
    doCheck = doCheck;
    duneVersion = "3";
    nativeBuildInputs = with pkgs; [
      clang
      fontconfig
      libiconv
      python
    ] ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk_framework; [
      AppKit
      ApplicationServices
      CoreVideo
      fixDarwinDylibNames
      OpenGL
      Security
    ]);
  });
in

rec {
  oskia = buildOskia {
    pname = "oskia";
    src = genSrc {
      dirs = ["config" "lib" "types" "ffi" "vendor"];
      files = ["oskia.opam"]
    }
    propagatedBuildInputs = [
      ctypes
    ]
  }
}
