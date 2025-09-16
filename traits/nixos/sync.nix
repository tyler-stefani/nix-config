{ flakePath, ... }:
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
        password = builtins.readFile (flakePath + /secrets/sync/password);
      };
      folders.notes.path = "/home/tyler/shared/safe/data/notes";
    };
  };
}
