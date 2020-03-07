# nix-config ![CI](https://github.com/lovesegfault/nix-config/workflows/CI/badge.svg)

This repository holds both my NixOS configuration. It is fully reproducible
(through [niv]) and position-independent, meaning there is no moving around of
`configuration.nix` (see [switch]).

For the configurations' entry points see the individual [systems], as well as
[default.nix]. For adding users or overlays see [users](#users),
[overlays](#overlays), respectively.

## structure
```
combo/            # Meta-configurations (e.g. core, desktop, development)
hardware/         # Hardware-specific configuration (e.g. kernel modules, peripherals)
misc/
├── config.nix    # Example NixOS user configuration (FIXME: NUKE)
├── home/         # Deprecated home-manager files (FIXME: NUKE)
└── hostnames     # List of hostnames to use
modules/          # Composable modules (e.g. bumblebee, sudo, sway, xserver)
pkgs/             # Personal packages (e.g. kernel patches)
secrets/          # Secrets (API keys)
systems/          # Configuration for actual hosts (selectively imports combos)
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
