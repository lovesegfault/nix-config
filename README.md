# nix-config [![built with nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org) [![ci](https://github.com/lovesegfault/nix-config/actions/workflows/ci.yaml/badge.svg)](https://github.com/lovesegfault/nix-config/actions/workflows/ci.yaml)

This repository holds my NixOS configuration. It is fully reproducible, flakes
based, and uses the [nixos-unified] framework for consistent configuration
across NixOS, nix-darwin, and home-manager.

For the configurations' entry points see the individual [configurations], as
well as [flake.nix]. For adding overlays see [overlays](#adding-overlays).

Hostnames are picked from my [hostname list][hostnames].

## Structure

```
.
├── configurations/          # Host-specific configurations
│   ├── nixos/              # NixOS hosts
│   ├── darwin/             # nix-darwin hosts
│   └── home/               # Standalone home-manager hosts
├── modules/                 # Reusable modules
│   ├── nixos/              # NixOS-only modules
│   ├── darwin/             # Darwin-only modules
│   ├── home/               # Shared home-manager modules
│   ├── shared/             # Shared NixOS+Darwin modules
│   └── flake-parts/        # Flake-level configuration
├── overlays/               # Nixpkgs overlays
├── lib/                    # Library functions and data
└── packages/               # Custom packages
```

## Usage

### Deploying

#### NixOS

To activate the current host:

```console
$ nix run .#activate
```

To activate a specific host:

```console
$ nix run .#activate <hostname>
```

Or using the traditional method:

```console
$ sudo nixos-rebuild --flake .#<hostname> switch
```

#### Darwin

For macOS hosts using nix-darwin:

```console
$ nix run .#activate
```

Or:

```console
$ darwin-rebuild --flake .#poincare switch
```

#### Home Manager

For standalone home-manager hosts:

```console
$ nix run .#activate
```

Or:

```console
$ home-manager --flake .#<hostname> switch
```

### Adding overlays

Overlays should be added as individual nix files to `./overlays/` with format:

```nix
final: prev: {
  hello = prev.hello.overrideAttrs (oldAttrs: { doCheck = false; });
}
```

For more examples see [overlays].

### Module conventions

- **nixosModules.\*** - NixOS-only modules from `modules/nixos/`
- **darwinModules.\*** - Darwin-only modules from `modules/darwin/`
- **homeModules.\*** - Shared home-manager modules from `modules/home/`

Modules are imported via flake outputs:

```nix
{ flake, ... }:
let
  inherit (flake) inputs self;
in
{
  imports = [
    self.nixosModules.default
    self.nixosModules.hardware-thinkpad-z13
  ];
}
```

[nixos-unified]: https://github.com/srid/nixos-unified
[configurations]: https://github.com/lovesegfault/nix-config/tree/master/configurations
[flake.nix]: https://github.com/lovesegfault/nix-config/blob/master/flake.nix
[hostnames]: https://gist.github.com/2a059213162c190f125c16a8d4463043
[overlays]: https://github.com/lovesegfault/nix-config/tree/master/overlays
