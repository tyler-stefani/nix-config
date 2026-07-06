{ ... }:
{
  disko.devices = {
    disk = {
      sda = {
        type = "disk";
        device = "/dev/sda";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            swap = {
              size = "16G";
              content = {
                type = "swap";
                randomEncryption = false;
              };
            };
            root = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
                subvolumes = {
                  "@".mountpoint = "/";
                  "@nix" = {
                    mountpoint = "/nix";
                    mountOptions = [ "noatime" ];
                  };
                  "@docker" = {
                    mountpoint = "/var/docker";
                    mountOptions = [ "noatime" ];
                  };
                  "@home".mountpoint = "/home";
                  "@data".mountpoint = "/home/tyler/data";
                  "@config".mountpoint = "/home/tyler/config";
                  "@media".mountpoint = "/home/tyler/media";
                };
              };
            };
          };
        };
      };
    };
  };
}
