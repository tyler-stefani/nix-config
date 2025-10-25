{ pkgs, traits, ... }:

{
  imports = with traits; [
    ./hardware-configuration.nix

    base
    mesh-vpn
    metrics
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_6_1;

  networking.hostName = "bubblegum";
  networking.networkmanager.enable = true;

  users.users.tyler = {
    isNormalUser = true;
    description = "tyler";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    homeMode = "711";
    shell = pkgs.fish;
  };

  nix.settings = {
    experimental-features = "nix-command flakes pipe-operators";
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
  ];
  system.stateVersion = "25.05";
}
