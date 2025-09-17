{ ... }:
{
  time.timeZone = "America/Chicago";

  nix.settings = {
    experimental-features = "nix-command flakes pipe-operators";
  };

  nixpkgs.config.allowUnfree = true;

  programs.fish.enable = true;
}
