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
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      flakeDir = ./.;
      homeModules = [
        ./users/tyler
        ./modules/home-manager
        nixvim.homeModules.nixvim
        stylix.homeModules.stylix
      ];
    in
    {
      nixosConfigurations = {
        homeserver = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit self;
          };
          modules = [
            ./hosts/nixos/homeserver/configuration.nix
            ./modules/nixos
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = {
                inherit flakeDir;
              };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.tyler = {
                imports = homeModules;
              };
            }
          ];
        };
      };

      homeConfigurations = {
        tyler = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit flakeDir;
          };
          modules = homeModules;
        };
      };

      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-tree;
    };
}
