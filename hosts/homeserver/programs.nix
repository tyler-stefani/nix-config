{ ... }:
{
  programs = {
    fish.enable = true;

    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 3d --keep 3";
      flake = "/home/tyler/nix-config";
    };

    nixvim.enable = true;
  };
}
