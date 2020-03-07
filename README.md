# nix-config ![CI](https://github.com/lovesegfault/nix-config/workflows/CI/badge.svg)

This repository holds both my NixOS configuration. It is fully reproducible
(through [niv]) and position-independent, meaning there is no moving around of
`configuration.nix` (see [sync]).

(`system/`) as well as my Home
Manager configuration (`home/`), both work together to generate fully
configured, consistent, systems to my liking.

## structure
```
combo/            # Meta-configurations (e.g. core, desktop, development)
hardware/         # Hardware-specific configuration (e.g. kernel modules, peripherals)
machines/         # Configuration for actual hosts (selectively imports combos)
modules/          # Composable modules (e.g. bumblebee, sudo, sway, xserver)
pkgs/             # Personal packages (e.g. kernel patches)
secrets/          # Secrets (API keys)
misc/
├── config.nix    # Example NixOS user configuration (FIXME: NUKE)
├── home/         # Deprecated home-manager files (FIXME: NUKE)
└── hostnames     # List of hostnames to use
```

## usage
### set up
### everyday


## issues
* my wallpapers are maintained ad-hoc
* no ssh configuration (`.ssh/config`)
* zsh plugins must be manually updated


[niv]: https://github.com/nmattia/niv
[sync]: https://github.com/lovesegfault/nix-config/blob/master/sync
