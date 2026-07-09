{
  buildDunePackage,
  lib,
  pkg-config,
  alcotest,
  ctypes,
  dune-configurator,
  ppx_optcomp,
  doCheck ? true,
}:

buildDunePackage {
  pname = "oski";
  version = "0.1.0";

  src =
    let
      fs = lib.fileset;
    in
    fs.toSource {
      root = ../..;
      fileset = fs.unions [
        ../../oski.opam
        ../../dune-project
        ../../config
        ../../lib
        ../../types
        ../../ffi
        ../../vendor
      ];
    };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ dune-configurator ];

  propagatedBuildInputs = [
    ctypes
    ppx_optcomp
  ];

  inherit doCheck;

  checkInputs = [ alcotest ];
}
