{ pkgs, ... }:
{
  users.users.tyler = {
    isNormalUser = true;
    description = "tyler";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    packages = [ ];
    shell = pkgs.fish;
  };
}
