{ ... }:
{
  flake.nixosTraits.has.desktop-environment =
    { nixpkgs-unstable, ... }:
    {
      nixpkgs.overlays = [
        (final: prev: {
          cosmic-comp = nixpkgs-unstable.cosmic-comp;
          cosmic-settings = nixpkgs-unstable.cosmic-settings;
          cosmic-files = nixpkgs-unstable.cosmic-files;
          cosmic-edit = nixpkgs-unstable.cosmic-edit;
          cosmic-term = nixpkgs-unstable.cosmic-term;
          cosmic-launcher = nixpkgs-unstable.cosmic-launcher;
          # cosmic-applets = nixpkgs-unstable.cosmic-applets;
          cosmic-panel = nixpkgs-unstable.cosmic-panel;
          cosmic-session = nixpkgs-unstable.cosmic-session;
          cosmic-greeter = nixpkgs-unstable.cosmic-greeter;
          cosmic-icons = nixpkgs-unstable.cosmic-icons;
          cosmic-wallpapers = nixpkgs-unstable.cosmic-wallpapers;
          cosmic-store = nixpkgs-unstable.cosmic-store;
          cosmic-screenshot = nixpkgs-unstable.cosmic-screenshot;
          cosmic-notifications = nixpkgs-unstable.cosmic-notifications;
          cosmic-workspaces-epoch = nixpkgs-unstable.cosmic-workspaces-epoch;
          cosmic-initial-setup = nixpkgs-unstable.cosmic-initial-setup;
          cosmic-bg = nixpkgs-unstable.cosmic-bg;
          cosmic-osd = nixpkgs-unstable.cosmic-osd;
          cosmic-player = nixpkgs-unstable.cosmic-player;
          cosmic-idle = nixpkgs-unstable.cosmic-idle;
          cosmic-applibrary = nixpkgs-unstable.cosmic-applibrary;
          xdg-desktop-portal-cosmic = nixpkgs-unstable.xdg-desktop-portal-cosmic;
        })
      ];

      services.displayManager.cosmic-greeter.enable = true;
      services.desktopManager.cosmic.enable = true;
    };
}
