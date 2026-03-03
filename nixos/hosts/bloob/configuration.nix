{ traits, pkgs, ... }:
{
  imports = with traits; [
    is.nixos
  ];

  wsl.enable = true;
  wsl.defaultUser = "tyler";

  networking.hostName = "bloob";

  environment.systemPackages = with pkgs; [
    wget
  ];

  programs.nix-ld.enable = true;

  users.users.tyler.shell = pkgs.fish;

  system.stateVersion = "25.05";
}
