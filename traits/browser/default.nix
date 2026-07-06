{ ... }:
{
  lab.traits.has.browser.home =
    { config, ... }:
    {
      programs.firefox = {
        enable = true;
        configPath = "${config.xdg.configHome}/mozilla/firefox";
        profiles.default = {
          isDefault = true;
          search = {
            force = true;
            default = "ddg";
          };
          settings = {
            "sidebar.revamp" = true;
            "sidebar.verticalTabs" = true;
            "browser.newtabpage.activity-stream.feeds.topsites" = false;
            "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
            "browser.newtabpage.activity-stream.showSponsored" = false;
            "browser.newtabpage.activity-stream.feeds.snippets" = false;
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
