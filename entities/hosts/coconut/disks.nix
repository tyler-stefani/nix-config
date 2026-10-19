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
                  "@data" = {
                    mountpoint = "/mnt/merge/01/data";
                    mountOptions = [ "noatime" ];
                  };
                  "@config" = {
                    mountpoint = "/mnt/merge/01/config";
                    mountOptions = [ "noatime" ];
                  };
                  "@media" = {
                    mountpoint = "/mnt/merge/01/media";
                    mountOptions = [ "noatime" ];
                  };
                };
              };
            };
          };
        };
      };
      ssd01 = {
        type = "disk";
        device = "/dev/sdc";
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
                  "@home" = {
                    mountpoint = "/mnt/merge/02";
                    mountOptions = [ "noatime" ];
                  };
                  "@data" = {
                    mountpoint = "/mnt/merge/02/data";
                    mountOptions = [ "noatime" ];
                  };
                  "@config" = {
                    mountpoint = "/mnt/merge/02/config";
                    mountOptions = [ "noatime" ];
                  };
                  "@media" = {
                    mountpoint = "/mnt/merge/02/media";
                    mountOptions = [ "noatime" ];
                  };
                };
              };
            };
          };
        };
      };
      hdd01 = {
        type = "disk";
        device = "/dev/sdb";
        content = {
          type = "gpt";
          partitions = {
            data = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
                subvolumes = {
                  "@home" = {
                    mountpoint = "/mnt/merge/03";
                    mountOptions = [ "noatime" ];
                  };
                  "@data" = {
                    mountpoint = "/mnt/merge/03/data";
                    mountOptions = [ "noatime" ];
                  };
                  "@config" = {
                    mountpoint = "/mnt/merge/03/config";
                    mountOptions = [ "noatime" ];
                  };
                  "@media" = {
                    mountpoint = "/mnt/merge/03/media";
                    mountOptions = [ "noatime" ];
                  };
                };
              };
            };
          };
        };
      };
      hdd02 = {
        type = "disk";
        device = "/dev/sda";
        content = {
          type = "gpt";
          partitions.data = {
            size = "100%";
            content = {
              type = "btrfs";
              extraArgs = [ "-f" ];
              mountpoint = "/mnt/parity";
              mountOptions = [
                "nodatacow"
                "noatime"
              ];
            };
          };
        };
      };
    };
  };
}
