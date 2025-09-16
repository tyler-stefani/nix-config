{ flakePath, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./users.nix

    (flakePath + /traits/all/base.nix)
    (flakePath + /traits/nixos/backup.nix)
    (flakePath + /traits/nixos/base.nix)
    (flakePath + /traits/nixos/blog.nix)
    (flakePath + /traits/nixos/containers.nix)
    (flakePath + /traits/nixos/dns.nix)
    (flakePath + /traits/nixos/feed.nix)
    (flakePath + /traits/nixos/keep.nix)
    (flakePath + /traits/nixos/media.nix)
    (flakePath + /traits/nixos/mesh-vpn.nix)
    (flakePath + /traits/nixos/minecraft.nix)
    (flakePath + /traits/nixos/monitoring.nix)
    (flakePath + /traits/nixos/photos.nix)
    (flakePath + /traits/nixos/proxy.nix)
    (flakePath + /traits/nixos/sync.nix)
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_6_1;

  hostConfig = {
    hostName = "homeserver";
    directories = {
      personalData = "/home/tyler/shared/safe/data";
      appData = "/home/tyler/shared/safe/apps";
    };
  };

  nix.package = pkgs.lixPackageSets.stable.lix;

  networking = {
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [ 3000 ];
    oci.networks = {
      bridge = {
        enable = true;
        name = "private";
      };
      ipvlan = {
        enable = true;
      };
    };
  };

  fileSystems."/home" = {
    fsType = "fuse.mergerfs";
    device = "/mnt/merge/*";
    options = [
      "allow_other"
      "use_ino"
      "cache.files=partial"
      "dropcacheonclose=true"
      "category.create=mfs"
    ];
  };

  programs.fuse.userAllowOther = true;

  environment.systemPackages = with pkgs; [
    git
    git-crypt
    lazygit
    mergerfs
    mergerfs-tools
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
