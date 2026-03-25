{ ... }:
{
  flake.homeTraits.user-headless =
    { pkgs, traits, ... }:
    {
      imports = with traits; [
        editor
        git
        prompt
        shell
        styling
      ];

      home = {
        username = "tyler";
        homeDirectory = if pkgs.stdenv.isDarwin then "/Users/tyler" else "/home/tyler";
      };

      nixpkgs.config.allowUnfree = true;

      programs.nix-index-database.comma.enable = true;

      home.stateVersion = "24.11";
    };
}
