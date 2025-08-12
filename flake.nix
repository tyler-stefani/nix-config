{
  description = "tyler's nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager?ref=master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
      home-manager,
      nixvim,
      stylix,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
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
              ./modules/nixos
            ];
          };
      };

      homeConfigurations = {
        tyler = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit self;
          };
          modules = [
            ./users/tyler
            ./modules/home-manager
            nixvim.homeModules.nixvim
            stylix.homeModules.stylix
          ];
        };
      };

      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-tree;
    };
}
