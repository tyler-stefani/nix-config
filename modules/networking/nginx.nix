{ lib, config, ... }:
with lib;
let
  cfg = config.services.nginxOCI;
in
{
  options.services.nginxOCI = {
    enable = mkEnableOption "an Nginx reverse proxy service";
    dataDir = mkOption {
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [
      80
      443
    ];
    virtualisation.oci-containers.containers = {
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
          ++ (lists.optionals config.networking.oci.networks.bridge.enable [
            config.networking.oci.networks.bridge.name
          ]);
      };
    };
  };
}
