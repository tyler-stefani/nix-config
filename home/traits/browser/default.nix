{ ... }:
{
  flake.homeTraits.browser =
    { ... }:
    {
      programs.firefox = {
        enable = true;
        profiles.default = {
          isDefault = true;
          search = {
            force = true;
            default = "DuckDuckGo";
          };
          settings = {
            "sidebar.revamp" = true;
            "sidebar.verticalTabs" = true;
          };
        };
      };

      stylix.targets = {
        firefox = {
          enable = true;
          profileNames = [ "default" ];
        };
      };
    };
}
