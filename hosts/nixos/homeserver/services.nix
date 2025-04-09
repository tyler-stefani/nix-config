{ self, ... }:
{
  services = {
    tailscale.enable = true;

    piholeOCI = {
      enable = true;
      dataDir = "/home/tyler/apps";
      ip = "192.168.0.200";
    };
    nginxOCI = {
      enable = true;
      dataDir = "/home/tyler/apps";
    };

    portainerOCI = {
      enable = true;
      dataDir = "/home/tyler/apps";
    };

    grafana = {
      enable = true;
      settings.server = {
        domain = "monitoring.peebo.world";
        http_addr = "0.0.0.0";
      };
    };

    syncthing = {
      enable = true;
      openDefaultPorts = true;
      openGuiPort = true;
      user = "tyler";
      dataDir = "/home/tyler";
      configDir = "/home/tyler/.config/syncthing";
      settings = {
        gui = {
          user = "tyler";
          password = builtins.readFile "${self}/secrets/sync/password";
        };
        folders.notes.path = "/home/tyler/shared/safe/data/notes";
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 3000 ];
}
