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

    hosts.mesh-vpn
  ];

  boot.loader.grub.enable = true;

  networking = {
    hostName = "cookies-and-cream";
    useDHCP = true;
    firewall.enable = true;
    firewall.allowedTCPPorts = [ 22 ];
  };

  _module.args = {
    mounts = {
      config = "/home/tyler/apps";
    };
  };

  environment.systemPackages = with pkgs; [
    git
  ];

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = false;
    };
  };

  users.users.tyler = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [ ];
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
