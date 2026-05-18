{
  description = "tyler's nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
    extras = {
      url = "git+ssh://git@github.com/tyler-stefani/nix-extras";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager?ref=release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim?ref=nixos-25.11";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };
    stylix = {
      url = "github:danth/stylix?ref=release-25.11";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      extras,
      home-manager,
      flake-parts,
      import-tree,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./lab

        (import-tree ./flake/modules)
        home-manager.flakeModules.home-manager

        (import-tree ./nixos/modules)
        (import-tree ./traits)
        # TODO: structure so that import-tree can be used
        ./entities/hosts/bloob
        ./entities/hosts/bubblegum
        ./entities/hosts/coconut
        ./entities/hosts/cookies-and-cream

        (import-tree ./home/modules)
        ./entities/homes/tyler
      ];

      lab.traits = extras.nixosTraits;

      systems = [
        "x86_64-linux"
        "x86_64-darwin"
      ];

      perSystem =
        { pkgs, ... }:
        {
          formatter = pkgs.nixfmt-tree;
        };
    };
}
