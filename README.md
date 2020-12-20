# nix-config ![CI](https://github.com/lovesegfault/nix-config/workflows/CI/badge.svg)

This repository holds my NixOS configuration. It is fully reproducible, flakes
based, and position-independent, meaning there is no moving around of
`configuration.nix`.

Deployment is done using [deploy-rs], see [usage](#usage).

For the configurations' entry points see the individual [hosts], as well as
[flake.nix]. For adding overlays see [overlays](#overlays).

Hostnames are picked from my [hostname list](hostnames)

## structure

```
.
├── core         # Baseline configurations applicable to all machines
├── dev          # Developer tooling configuration
├── hardware     # Hardware-specific configuration
├── hostnames    # List of hostnames to use
├── overlays     # Nixpkgs overlays
├── keys         # PGP keys for SOPS
├── sway         # Sway configuration for the desktop
├── hosts        # Machine definitions
└── users        # Per-user configurations
```

## usage

### deploying
To deply all hosts:
```
    nix run .#
```
To deply a specific host:
```
    nix run .#myHost
```

### adding overlays

Overlays should be added as individual nix files to ./overlays with format

```nix
self: super: {
    hello = (super.hello.overrideAttrs (oldAttrs: { doCheck = false; }));
}
```

For more examples see ./overlays.

## issues

* my wallpapers are maintained ad-hoc
* zsh plugins must be manually updated

[deploy-rs]: https://github.com/serokell/deploy-rs
[hosts]: https://github.com/lovesegfault/nix-config/blob/master/hosts
[flake.nix]: https://github.com/lovesegfault/nix-config/blob/master/flake.nix
[hostnames]: https://gist.github.com/2a059213162c190f125c16a8d4463043
