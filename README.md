# nix-config ![CI](https://github.com/lovesegfault/nix-config/workflows/CI/badge.svg)

This repository holds both my NixOS configuration. It is fully reproducible
(through [niv]) and position-independent, meaning there is no moving around of
`configuration.nix` (see [switch]).

For the configurations' entry points see the individual [systems], as well as
[default.nix]. For adding users or overlays see [users](#users),
[overlays](#overlays), respectively.

## structure
```
.
├── core         # Base-line configurations applicable to all machines
├── default.nix  # Attr set of all machines, with groups based on architecture
├── dev          # Developer tooling configuration
├── hardware     # Hardware-specific configuration
├── hostnames    # List of hostnames to use
├── misc         # Assorted configuration modules
├── nix          # Nix sources (nixpkgs and home-manager)
├── overlays     # Nixpkgs overlays
├── secrets      # Secrets (API keys, etc)
├── sway         # Sway configuration for the desktop
├── systems      # Machine (host) definition that actually gets built
└── users        # Per-user configurations
```

## usage
### set up
FIXME
### everyday
#### syncing sources
`$ niv update`
#### testing configs
`$ nix-build -A $machine`
#### switching configs
[`$ ./switch`][switch]

## users
FIXME

## overlays
FIXME

## issues
* my wallpapers are maintained ad-hoc
* no ssh configuration (`.ssh/config`)
* zsh plugins must be manually updated


[niv]: https://github.com/nmattia/niv
[switch]: https://github.com/lovesegfault/nix-config/blob/master/switch
[systems]: https://github.com/lovesegfault/nix-config/blob/master/systems
[default.nix]: https://github.com/lovesegfault/nix-config/blob/master/default.nix
