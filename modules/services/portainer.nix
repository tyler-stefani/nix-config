{ lib, config, ... }:
with lib;
let
  cfg = config.services.portainerOCI;
in
{

  options.services.portainerOCI = {
    enable = mkEnableOption "a container manager";
    dataDir = mkOption {
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers = {
      containers = {
        containers = {
          image = "portainer/portainer-ce:latest";
          volumes = [
            "${cfg.dataDir}/portainer/data:/data"
            "/var/run/docker.sock:/var/run/docker.sock"
          ];
          networks =
            [ ]
            ++ (lists.optionals config.networking.oci.networks.bridge.enable [
              config.networking.oci.networks.bridge.name
            ]);
        };
      };
    };
  };
}
