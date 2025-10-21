{ ... }:
{
  flake.homeTraits.git =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        git-crypt
        lazygit
      ];

      programs.git = {
        enable = true;
        signing.format = null;
        settings = {
          user = {
            name = "tyler";
            email = "tylerjstefani@gmail.com";
          };
          init = {
            defaultBranch = "main";
          };
          push = {
            autoSetupRemote = "true";
          };
        };
      };
    };
}
