{ pkgs, traits, ... }:

{
  imports = with traits; [
    ./hardware-configuration.nix

    base
    containers
    dns
    mesh-vpn
    metrics
    search
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

  _module.args = {
    mounts.config = "/home/tyler/apps";
    ips.dns = "192.168.0.201";
  };

  nix.settings = {
    experimental-features = "nix-command flakes pipe-operators";
  };

  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
  ];
  system.stateVersion = "25.05";
}
