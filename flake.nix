{
  description = "Scalcy is a simple calculator built using Slint UI with the Rust programming language";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    { nixpkgs, flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = nixpkgs.lib.systems.flakeExposed;
      perSystem =
        { pkgs, ... }:
        let
          scalcyPkg = pkgs.callPackage ./default.nix { };
          scalcyBin = nixpkgs.lib.getBin scalcyPkg;
        in
        {
          packages = rec {
            scalcy = scalcyPkg;
            default = scalcy;
          };
          checks = {
            default = scalcyPkg;
          };
          apps = rec {
            scalcy = {
              type = "app";
              program = "${scalcyBin}/bin/scalcy";
            };
            default = scalcy;
          };

          formatter = pkgs.nixpkgs-fmt;

          devShells = rec {
            scalcy = pkgs.mkShell {
              buildInputs = scalcyPkg.buildInputs;
              nativeBuildInputs = scalcyPkg.nativeBuildInputs;
            };
            default = scalcy;
          };
        };
    };
}
