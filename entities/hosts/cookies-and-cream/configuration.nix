{
  pkgs,
  traits,
  ...
}:
{
  imports = with traits; [ ./hardware-configuration.nix ];

  boot.loader.grub.enable = true;

  networking = {
    hostName = "cookies-and-cream";
    useDHCP = true;
    firewall.enable = true;
  };

  environment.systemPackages = with pkgs; [
    git
  ];

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
