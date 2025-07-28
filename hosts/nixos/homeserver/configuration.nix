{ self, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./users.nix

    (self + /traits/all/base.nix)
    (self + /traits/nixos/backup.nix)
    (self + /traits/nixos/base.nix)
    (self + /traits/nixos/containers.nix)
    (self + /traits/nixos/dns.nix)
    (self + /traits/nixos/feed.nix)
    (self + /traits/nixos/ide.nix)
    (self + /traits/nixos/mesh-vpn.nix)
    (self + /traits/nixos/monitoring.nix)
    (self + /traits/nixos/proxy.nix)
    (self + /traits/nixos/sync.nix)
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

  environment.systemPackages = with pkgs; [
    git
    git-crypt
    lazygit
    chezmoi
    eza
    bat
    zoxide
    starship
    mergerfs
    mergerfs-tools
  ];

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
    targets = {
      fish.enable = true;
      nixvim.enable = true;
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
