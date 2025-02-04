{
  description = "tyler's nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixvim,
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
            props = builtins.fromTOML (builtins.readFile "${self}/hosts/homeserver/props.toml");
          in
          nixpkgs.lib.nixosSystem {
            system = system;
            specialArgs = { inherit inputs outputs props; };
            modules = [
              ./hosts/homeserver/configuration.nix
              ./modules
              nixvim.nixosModules.nixvim
            ];
          };
      };

      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-rfc-style;
    };
}
