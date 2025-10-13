{ ... }:
{
  flake.nixosTraits.base =
    { ... }:
    {
      time.timeZone = "America/Chicago";

      nix.settings = {
        experimental-features = "nix-command flakes pipe-operators";
      };

      nixpkgs.config.allowUnfree = true;

      programs.fish.enable = true;

      i18n = {
        defaultLocale = "en_US.UTF-8";

        extraLocaleSettings = {
          LC_ADDRESS = "en_US.UTF-8";
          LC_IDENTIFICATION = "en_US.UTF-8";
          LC_MEASUREMENT = "en_US.UTF-8";
          LC_MONETARY = "en_US.UTF-8";
          LC_NAME = "en_US.UTF-8";
          LC_NUMERIC = "en_US.UTF-8";
          LC_PAPER = "en_US.UTF-8";
          LC_TELEPHONE = "en_US.UTF-8";
          LC_TIME = "en_US.UTF-8";
        };
      };

      programs.nh = {
        enable = true;
        clean.enable = true;
        clean.extraArgs = "-K 7d -k 3";
        flake = "/home/tyler/shared/nix";
      };
    };
}
