{
  description = "pds - personal dev shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, nixvim, ... }:
    {
      packages = nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ] (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          pds = import ./default.nix { inherit pkgs nixvim; };
        }
      );
    };
}
