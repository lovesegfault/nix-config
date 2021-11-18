# nix-config [![built with nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org) [![ci](https://github.com/lovesegfault/nix-config/actions/workflows/ci.yaml/badge.svg)](https://github.com/lovesegfault/nix-config/actions/workflows/ci.yaml)

This repository holds my NixOS configuration. It is fully reproducible, flakes
based, and position-independent, meaning there is no moving around of
`configuration.nix`.

Deployment is done using [deploy-rs], see [usage](#usage).

For the configurations' entry points see the individual [hosts], as well as
[flake.nix]. For adding overlays see [overlays](#overlays).

Hostnames are picked from my [hostname list][hostnames]

## structure

```
.
├── core         # Baseline configurations applicable to all machines
├── dev          # Developer tooling configuration
├── graphical    # Sway/i3 configuration for the desktop
├── hardware     # Hardware-specific configuration
├── hosts        # Machine definitions
├── nix          # Nix build support files (overlays, deployment code, ci generators)
└── users        # Per-user configurations
```

## usage

### deploying
To deploy all hosts:

```console
$ deploy
```

To deploy a specific host:

```console
$ deploy .#myHost
```

### adding overlays

Overlays should be added as individual nix files to ./nix/overlays with format

```nix
final: prev: {
    hello = (prev.hello.overrideAttrs (oldAttrs: { doCheck = false; }));
}
```

For more examples see [./nix/overlays][overlays].

## issues

* my wallpapers are maintained ad-hoc
* zsh plugins must be manually updated

[deploy-rs]: https://github.com/serokell/deploy-rs
[hosts]: https://github.com/lovesegfault/nix-config/blob/master/hosts
[flake.nix]: https://github.com/lovesegfault/nix-config/blob/master/flake.nix
[hostnames]: https://gist.github.com/2a059213162c190f125c16a8d4463043
[overlays]: https://github.com/lovesegfault/nix-config/blob/master/nix/overlays
