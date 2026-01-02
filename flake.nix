{
  description = "Custom Nix packages for iloader and iflow-cli";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachSystem [ "x86_64-linux" "aarch64-linux" ] (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages = {
          iloader = pkgs.callPackage ./pkgs/iloader/default.nix { };
          iflow-cli = pkgs.callPackage ./pkgs/iflow-cli/default.nix { };
          mtkclient = pkgs.callPackage ./pkgs/mtkclient/default.nix { };

        };

        apps = {
          iloader = flake-utils.lib.mkApp { drv = self.packages.${system}.iloader; };
          iflow = flake-utils.lib.mkApp { drv = self.packages.${system}.iflow-cli; };
          mtk = flake-utils.lib.mkApp { drv = self.packages.${system}.mtkclient; };

        };

        formatter = pkgs.nixpkgs-fmt;
      }
    );
}
