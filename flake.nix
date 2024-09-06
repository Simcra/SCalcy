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
          formatter = pkgs.nixpkgs-fmt;
          devShells.default = pkgs.mkShell {
            buildInputs = scalcyPkg.buildInputs;
            nativeBuildInputs = scalcyPkg.nativeBuildInputs;
          };

          checks.default = scalcyPkg;
          apps.default = {
            type = "app";
            program = "${scalcyBin}/bin/scalcy";
          };
          packages.default = scalcyPkg;
        };
    };
}
