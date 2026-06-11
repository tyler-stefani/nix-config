{ ... }:
{
  lab.traits.has.git-work.home =
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
            email = "tyler.stefani@topbloc.com";
          };
          init = {
            defaultBranch = "main";
          };
          push = {
            autoSetupRemote = "true";
          };
        };
      };

      stylix.targets = {
        lazygit.enable = true;
      };
    };
}
