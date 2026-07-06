{ ... }:
{
  lab.traits.hosts.home-automation.nixos =
    { config, mounts, ... }:
    let
      configDir = "${mounts.config}/home-assistant";
      matterDataDir = "${mounts.config}/home-assistant-matter";
    in
    {
      virtualisation.docker-compose.home-automation = {
        file = ./docker-compose.yaml;
        env = {
          CONFIG_DIR = configDir;
          MATTER_DATA_DIR = matterDataDir;
          TZ = "America/Chicago";
        };
      };
      networking.firewall.allowedTCPPorts = [
        8123
        5580
      ];
      services.restic.serviceBackups.home-automation = {
        serviceName = config.virtualisation.docker-compose.home-automation.serviceName;
        paths = [
          configDir
          matterDataDir
        ];
      };
    };
}
