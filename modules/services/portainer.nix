{ lib, config, ... }:
with lib;
{

  options = {
    portainer = {
      enable = mkEnableOption "a container manager";
      dataDir = mkOption {
        type = types.str;
      };
    };
  };

  config = mkIf config.portainer.enable {
    virtualisation.oci-containers = {
      containers = {
        containers = {
          image = "portainer/portainer-ce:latest";
          volumes = [
            "${config.portainer.dataDir}/portainer/data:/data"
            "/var/run/docker.sock:/var/run/docker.sock"
          ];
          networks =
            [ ]
            ++ (lists.optionals config.containerNetworks.bridge.enable [
              config.containerNetworks.bridge.name
            ]);
        };
      };
    };
  };
}
