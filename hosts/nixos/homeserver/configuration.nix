{
  traits,
  pkgs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./users.nix

    traits.all.base

    traits.nixos.backup
    traits.nixos.base
    traits.nixos.blog
    traits.nixos.containers
    traits.nixos.dns
    traits.nixos.feed
    traits.nixos.keep
    traits.nixos.media
    traits.nixos.mesh-vpn
    traits.nixos.minecraft
    traits.nixos.monitoring
    traits.nixos.photos
    traits.nixos.proxy
    traits.nixos.sync
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_6_1;

  _module.args.mounts = {
    data = "/home/tyler/shared/safe/data";
    config = "/home/tyler/apps";
    media = "/home/tyler/shared/media";
  };

  networking = {
    hostName = "homeserver";
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
