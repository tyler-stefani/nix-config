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
      nixpkgs,
      home-manager,
      nixvim,
      stylix,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      traits = {
        all = {
          base = ./traits/all/base;
          ide = ./traits/all/ide;
        };
        nixos = {
          backup = ./traits/nixos/backup;
          base = ./traits/nixos/base;
          blog = ./traits/nixos/blog;
          containers = ./traits/nixos/containers;
          dns = ./traits/nixos/dns;
          feed = ./traits/nixos/feed;
          keep = ./traits/nixos/keep;
          media = ./traits/nixos/media;
          mesh-vpn = ./traits/nixos/mesh-vpn;
          minecraft = ./traits/nixos/minecraft;
          monitoring = ./traits/nixos/monitoring;
          photos = ./traits/nixos/photos;
          proxy = ./traits/nixos/proxy;
          sync = ./traits/nixos/sync;
        };
      };
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

      homeConfigurations = {
        tyler = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit traits;
          };
          modules = homeModules;
        };
      };

      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-tree;
    };
}
