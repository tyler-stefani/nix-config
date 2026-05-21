# The Prop Lab

Configurations for servers and workstations, with dotfiles managed through home-manager.

## Layout

This repository uses the [dendritic pattern](https://www.youtube.com/watch?v=-TRbzkw6Hjs) and takes inspiration from [den](https://github.com/denful/den). It uses an abstraction framework in ./lab which streamlines definitions of hosts and homes. (nearly) All nix files are modules which either populate a flake output or a lab option.

## Entities

Entities are top level configurations for hosts or homes which are output by the base project flake. Currently supported entities are:

- Nixos hosts -> lab.entities.hosts -> flake.nixosConfigurations
- Macos hosts -> lab.entities.hosts -> flake.darwinConfigurations
- Home-manager users -> lab.entities.homes -> flake.homeConfigurations

## Modules

Modules add new options and configurations to existing module systems. Examples include:

- Nixos modules -> flake.nixosModules
- Macos modules -> flake.darwinModules
- Home-manager modules -> flake.homeModules
- Flake-parts modules -> flake.flakeModules

## Traits

Traits represent a single aspect of a host or user configuration. They're simple modules that don't expose any options, just import them directly into a host/user config. This is different from capital-M Modules, which are always imported but get enabled and configured through options. Traits are not exposed as outputs in the base flake, only composed together into entities.
