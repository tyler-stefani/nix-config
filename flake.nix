{
  description = "tyler's nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager?ref=master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
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
      nixpkgs,
      home-manager,
      flake-parts,
      nixvim,
      stylix,
      ...
    }@inputs:
    let
      walk = import ./lib/walk.nix nixpkgs.lib;
      traits = walk ./traits;
      homeModules = [
        ./users/tyler
        ./modules/home-manager
        nixvim.homeModules.nixvim
        stylix.homeModules.stylix
      ];
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        home-manager.flakeModules.home-manager

        ./home/modules
        ./home/users/tyler
      ];

      systems = [
        "x86_64-linux"
        "x86_64-darwin"
      ];

      perSystem =
        { pkgs, ... }:
        {
          formatter = pkgs.nixfmt-tree;
        };

      flake =
        { ... }:
        {
          nixosConfigurations = {
            homeserver = nixpkgs.lib.nixosSystem {
              system = "x86_64-linux";
              specialArgs = {
                inherit traits;
              };
              modules = [
                ./hosts/nixos/homeserver/configuration.nix
                ./modules/nixos
                home-manager.nixosModules.home-manager
                {
                  home-manager.extraSpecialArgs = {
                    inherit traits;
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
        };
    };
}
