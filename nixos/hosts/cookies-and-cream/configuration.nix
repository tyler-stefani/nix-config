{
  pkgs,
  traits,
  ...
}:
{
  imports = with traits; [
    ./hardware-configuration.nix

    is.nixos
    is.container-host
    is.public-facing
    is.ssh-server

    hosts.mesh-vpn
  ];

  boot.loader.grub.enable = true;

  networking = {
    hostName = "cookies-and-cream";
    useDHCP = true;
    firewall.enable = true;
  };

  _module.args = {
    mounts = {
      config = "/home/tyler/apps";
    };
  };

  environment.systemPackages = with pkgs; [
    git
  ];

  users.users.tyler = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  disko.devices = {
    disk = {
      vda = {
        type = "disk";
        device = "/dev/vda";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              size = "1M";
              type = "EF02";
            };
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
    };
  };

  system.stateVersion = "24.11";
}
