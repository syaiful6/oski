final: prev:
let
  ocamlOverlay = final': prev': {
    oski = final'.callPackage ../packages/oski.nix {
      inherit (final.oski) doCheck;
    };
  };
in
{
  ocaml-ng.ocamlPackages_4_14 = prev.ocaml-ng.ocamlPackages_4_14.overrideScope ocamlOverlay;
  ocaml-ng.ocamlPackages_5_2 = prev.ocaml-ng.ocamlPackages_5_2.overrideScope ocamlOverlay;
  ocaml-ng.ocamlPackages_5_3 = prev.ocaml-ng.ocamlPackages_5_3.overrideScope ocamlOverlay;
  ocaml-ng.ocamlPackages_5_4 = prev.ocaml-ng.ocamlPackages_5_4.overrideScope ocamlOverlay;
  ocaml-ng.ocamlPackages = prev.ocaml-ng.ocamlPackages.overrideScope ocamlOverlay;

  oski = final.lib.makeScope final.newScope (self: {
    doCheck = true;
  });
}
