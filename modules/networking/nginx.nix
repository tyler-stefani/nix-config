{ lib, config, ... }:
with lib;
let
  cfg = config.nginx;
in
{
  options = {
    nginx = {
      enable = mkEnableOption "an Nginx reverse proxy service";
      dataDir = mkOption {
        type = types.str;
      };
    };
  };

  config.networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  config.virtualisation.oci-containers.containers = {
    proxy = {
      image = "docker.io/jc21/nginx-proxy-manager:latest";
      ports = [
        "80:80"
        "443:443"
      ];
      volumes = [
        "${cfg.dataDir}/nginx/data:/data"
        "${cfg.dataDir}/nginx/letsencrypt:/etc/letsencrypt"
      ];
      networks =
        [
        ]
        ++ (lists.optionals config.containerNetworks.bridge.enable [
          config.containerNetworks.bridge.name
        ]);
    };
  };
}
