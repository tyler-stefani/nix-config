{ ... }:
{
  time.timeZone = "America/Chicago";

  nix.settings = {
    experimental-features = "nix-command flakes";
  };

  nixpkgs.config.allowUnfree = true;

  programs.fish.enable = true;
}
