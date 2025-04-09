{
  description = "tyler's nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixvim,
      stylix,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations = {
        homeserver =
          let
            inherit (self) outputs;
          in
          nixpkgs.lib.nixosSystem {
            system = system;
            specialArgs = {
              inherit
                self
                inputs
                outputs
                ;
            };
            modules = [
              ./hosts/nixos/homeserver/configuration.nix
              ./modules
              nixvim.nixosModules.nixvim
              stylix.nixosModules.stylix
            ];
          };
      };

      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-rfc-style;
    };
}
