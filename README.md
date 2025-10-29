# The Propagation Lab 🖥️ 🪴

Configurations for servers and workstations, with dotfiles managed through home-manager.

## Layout

This repository fully embraces flake-parts, every nix file represents a flake-parts module. Any nix file can be imported directly in the top-level `mkFlake` output and will populate the corresponding flake output.
Extra flake modules are used to add traits outputs for each module system (nixos, home-manager, darwin).

The directory layout maps nicely to which flake output each nix file contains:

```
nix-config
├── flake
│   └── modules -> flake.flakeModules
├── home
│   ├── modules -> flake.homeModules
│   ├── traits -> flake.homeTraits
│   └── users -> flake.homeConfigurations
└── nixos
    ├── hosts -> flake.nixosConfigurations
    ├── modules -> flake.nixosModules
    └── traits -> flake.nixosTraits
```

## Traits

Traits represent a single aspect of a host or user configuration. They're simple modules that don't expose any options, just import them directly into a host/user config (or into another trait). This is different from capital-M Modules, which are always imported but get enabled and configured through options.

## Extra Arguments

Some traits need extra arguments to be passed to them through `_module.args` in the top-level host.

### Mounts

These are paths to directories on the host that live outside the nix store. Mounts are used basically anywhere a trait needs to keep state that nix doesn't manage directly.

### IPs

These refer to the IP address for the host itself, plus any other IPs where the host will make services available on the network.
