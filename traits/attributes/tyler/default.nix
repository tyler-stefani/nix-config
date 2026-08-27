{ ... }:
{
  lab.traits.attributes.user-tyler.nixos =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    {
      sops.secrets."tyler/hashpass" = {
        sopsFile = ./secrets/hashpass.yaml;
        key = "hashpass";
      };

      users.users.tyler = {
        isNormalUser = true;
        description = "tyler";
        extraGroups = [
          "networkmanager"
          "wheel"
          "docker"
        ];
        homeMode = "711";
        hashedPasswordFile = config.sops.secrets."tyler/hashpass".path;
        packages = [ ];
        shell = pkgs.fish;
        openssh.authorizedKeys.keys = lib.mkIf config.services.openssh.enable [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK5w7m9bwtX1tMoxmOKfDRPUeN4scTtpnBTNHdkI8Wgt tyler"
        ];
      };
    };
}
