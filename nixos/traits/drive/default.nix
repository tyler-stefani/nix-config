{ ... }:
{

  flake.nixosTraits.hosts.drive =
    { config, mounts, ... }:
    let
      configDir = "${mounts.config}/opencloud/config";
      appsDir = "${mounts.config}/opencloud/apps";
      dataDir = "${mounts.config}/opencloud/data";
      userDataDir = "${mounts.data}/drive/users";
      projectDataDir = "${mounts.data}/drive/projects";
    in
    {
      sops.envs.drive = {
        sopsFile = ./secrets/.env;
      };
      virtualisation.docker-compose.drive = {
        file = ./docker-compose.yaml;
        env = {
          OC_DOCKER_IMAGE = "opencloudeu/opencloud-rolling";
          OC_DOCKER_TAG = "latest";
          CONFIG_DIR = configDir;
          APPS_DIR = appsDir;
          DATA_DIR = dataDir;
          USER_DATA_DIR = userDataDir;
          PROJECT_DATA_DIR = projectDataDir;
        };
        envPath = config.sops.envs.drive.path;
      };
      services.restic.stack-backup.drive = {
        paths = [
          configDir
          appsDir
          dataDir
          userDataDir
          projectDataDir
        ];
      };
    };
}
