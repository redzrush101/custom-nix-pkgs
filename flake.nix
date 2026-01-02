{
  description = "Custom Nix packages for iloader and iflow-cli";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    shuvcode.url = "github:Latitudes-Dev/shuvcode";
  };

  outputs = { self, nixpkgs, flake-utils, shuvcode }:
    flake-utils.lib.eachSystem [ "x86_64-linux" "aarch64-linux" ] (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
          packages = {
          iloader = pkgs.callPackage ./pkgs/iloader/default.nix { };
          iflow-cli = pkgs.callPackage ./pkgs/iflow-cli/default.nix { };
          mtkclient = pkgs.callPackage ./pkgs/mtkclient/default.nix { };
          shuvcode = shuvcode.packages.${system}.default;
          shuvcode-desktop = pkgs.callPackage ./pkgs/shuvcode-desktop/default.nix {
            opencode = self.packages.${system}.shuvcode;
            iconSrc = "${shuvcode}/packages/desktop/src-tauri/icons/prod/icon.png";
          };
        };

          apps = {
          iloader = flake-utils.lib.mkApp { drv = self.packages.${system}.iloader; };
          iflow = flake-utils.lib.mkApp { drv = self.packages.${system}.iflow-cli; };
          mtk = flake-utils.lib.mkApp { drv = self.packages.${system}.mtkclient; };
          shuvcode = flake-utils.lib.mkApp { drv = self.packages.${system}.shuvcode; };
        };

        formatter = pkgs.nixpkgs-fmt;
      }
    );
}
