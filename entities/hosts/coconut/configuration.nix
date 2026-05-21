{
  pkgs,
  traits,
  ...
}:
{
  imports = with traits; [ ./hardware-configuration.nix ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_6_1;

  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  programs.ssh.startAgent = true;

  networking = {
    hostName = "coconut";
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [ 3000 ];
    oci.networks = {
      bridge = {
        enable = true;
        name = "private";
      };
    };
  };

  virtualisation.docker-swarm.enable-manager = true;

  fileSystems."/home" = {
    fsType = "mergerfs";
    device = "/mnt/merge/*";
    depends = [
      "/mnt/merge/01"
      "/mnt/merge/01"
    ];
    options = [
      "allow_other"
      "use_ino"
      "cache.files=partial"
      "dropcacheonclose=true"
      "category.create=mfs"
    ];
    noCheck = true;
  };

  programs.fuse.userAllowOther = true;

  environment.systemPackages = with pkgs; [
    git
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
