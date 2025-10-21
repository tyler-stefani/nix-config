{ traits, pkgs, ... }:
{
  imports = with traits; [
    base
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
