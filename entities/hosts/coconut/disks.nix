{ ... }:
{
  flake.diskoConfigurations.coconut.disko.devices = {
    disk = {
      nvme0n1 = {
        type = "disk";
        device = "/dev/nvme0n1";
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
                  "@fast".mountpoint = "/home/tyler/fast";
                  "@home".mountpoint = "/mnt/merge/01";
                  "@data".mountpoint = "/mnt/merge/01/data";
                  "@config".mountpoint = "/mnt/merge/01/config";
                  "@media".mountpoint = "/mnt/merge/01/media";
                };
              };
            };
          };
        };
      };
      sda = {
        type = "disk";
        device = "/dev/sda";
        content = {
          type = "gpt";
          partitions = {
            swap = {
              size = "16G";
              content = {
                type = "swap";
                randomEncryption = false;
              };
            };
            data = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
                subvolumes = {
                  "@home".mountpoint = "/mnt/merge/02";
                  "@data".mountpoint = "/mnt/merge/02/data";
                  "@config".mountpoint = "/mnt/merge/02/config";
                  "@media".mountpoint = "/mnt/merge/02/media";
                };
              };
            };
          };
        };
      };
    };
  };
}
