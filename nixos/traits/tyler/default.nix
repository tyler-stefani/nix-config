{ ... }:
{
  flake.nixosTraits.has.user-tyler =
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
        homeMode = "711";
        packages = [ ];
        shell = pkgs.fish;
      };
    };
}
