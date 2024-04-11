# nix-config [![built with nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org) [![ci](https://github.com/lovesegfault/nix-config/actions/workflows/ci.yaml/badge.svg)](https://github.com/lovesegfault/nix-config/actions/workflows/ci.yaml)

This repository holds my NixOS configuration. It is fully reproducible, flakes
based, and position-independent, meaning there is no moving around of
`configuration.nix`.

Hostnames are picked from my [hostname list][hostnames].

## Structure

```
.
├── darwin-configurations    # Configurations for nix-darwin hosts
├── darwin-modules           # Modules for nix-darwin hosts
├── flake-modules            # Modules for flake-parts
├── home-configurations      # Configurations for home-manager hosts
├── home-modules             # Modules for home-manager hosts
├── nixos-configurations     # Configurations for NixOS hosts
├── nixos-modules            # Modules for NixOS hosts
└── shared-modules           # Modules shared between NixOS and nix-darwin
```

## Usage

### Deploying

#### NixOS

```console
$ sudo nixos-rebuild -L --refresh --flake github:lovesegfault/nix-config#myHost switch |& nom
```

#### Darwin

For macOS hosts using `nix-darwin`:

```console
$ darwin-rebuild -L --refresh --flake github:lovesegfault/nix-config#myHost switch |& nom
```

#### Home Manager

For non-NixOS hosts (i.e. home-manager-only systems):

```console
$ home-manager -L --refresh --flake github:lovesegfault/nix-config#myHost switch |& nom
```

### Adding overlays

Overlays should be added as individual nix files to `./flake-modules/overlays` with format

```nix
final: prev: {
    hello = (prev.hello.overrideAttrs (oldAttrs: { doCheck = false; }));
}
```

For more examples see [./flake-modules/overlays][overlays].

[hostnames]: https://gist.github.com/2a059213162c190f125c16a8d4463043
[overlays]: https://github.com/lovesegfault/nix-config/blob/master/flake-modules/overlays
