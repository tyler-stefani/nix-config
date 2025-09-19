{ mounts, ... }:
{
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    openGuiPort = true;
    user = "tyler";
    dataDir = "/home/tyler";
    configDir = "/home/tyler/.config/syncthing";
    settings = {
      gui = {
        user = "tyler";
        password = builtins.readFile ./secrets/password;
      };
      folders.notes.path = "${mounts.data}/notes";
    };
  };
}
