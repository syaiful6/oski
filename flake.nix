{
  description = "Oski - Nix Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-25.11";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.flake = false;
  };

  outputs =
    {
      self,
      nixpkgs,
      treefmt-nix,
    }:
    let
      allSystems = nixpkgs.lib.systems.flakeExposed;
      withPkgs =
        pkgsCallback:
        nixpkgs.lib.genAttrs allSystems (
          system:
          let
            pkgs = import nixpkgs {
              inherit system;
              overlays = [
                (import ./nix/overlays)
                (_final: _prev: {
                  treefmt-nix = import treefmt-nix;
                })
                (import ./nix/overlays/development.nix)
              ];
            };
          in
          pkgsCallback { inherit pkgs system; }
        );

    in
    {
      packages = withPkgs (
        { pkgs, system }:
        {
          default = self.packages.${system}.oski;
          inherit (pkgs.ocamlPackages)
            oski
            ;
        }
      );

      devShells = withPkgs (
        { pkgs, ... }:
        {
          default = pkgs.oski.dev-shell;
        }
      );

      overlays.default = import ./nix/overlays;

      formatter = withPkgs ({ pkgs, ... }: pkgs.oski.treefmt);

      checks = withPkgs (
        { pkgs, ... }:
        {
          formatting = pkgs.oski.checks.formatting;
        }
      );
    };
}
