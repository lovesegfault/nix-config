# CI workflow definition using actions.nix
{
  inputs,
  self,
  lib,
  ...
}:
let
  # Platform mappings: Nix system -> GitHub runner
  platforms = {
    x86_64-linux = {
      os = "ubuntu-24.04";
      arch = "X64";
    };
    aarch64-linux = {
      os = "ubuntu-22.04-arm";
      arch = "ARM64";
    };
    aarch64-darwin = {
      os = "macos-15";
      arch = "ARM64";
      equivalentLinux = "aarch64-linux";
    };
  };

  # Helper to get system from a configuration
  getSystem = cfg: cfg.pkgs.stdenv.hostPlatform.system;

  # Build matrix entry from configuration (autodiscovery)
  # Returns data in the exact shape needed for GitHub Actions matrix
  mkHostInfo =
    type: name: cfg:
    let
      platform = getSystem cfg;
      platformInfo = platforms.${platform} or null;
    in
    lib.optionalAttrs (platformInfo != null) (
      {
        inherit name;
        hostPlatform = platform;
        runsOn = platformInfo.os;
        attr =
          if type == "nixos" then
            "nixosConfigurations.${name}.config.system.build.toplevel"
          else if type == "darwin" then
            "darwinConfigurations.${name}.config.system.build.toplevel"
          else
            "homeConfigurations.${name}.activationPackage";
      }
      // lib.optionalAttrs (type == "darwin") {
        equivalentLinuxRunner = platforms.${platformInfo.equivalentLinux}.os;
        linuxBuilderAttr = "darwinConfigurations.${name}.config.nix.linux-builder.package.nixosConfig.system.build.toplevel";
      }
    );

  # Autodiscover all hosts and filter out unsupported platforms
  nixosHosts = lib.filter (h: h != { }) (
    lib.mapAttrsToList (mkHostInfo "nixos") (self.nixosConfigurations or { })
  );
  darwinHosts = lib.filter (h: h != { }) (
    lib.mapAttrsToList (mkHostInfo "darwin") (self.darwinConfigurations or { })
  );
  homeHosts = lib.filter (h: h != { }) (
    lib.mapAttrsToList (mkHostInfo "home") (self.homeConfigurations or { })
  );

  # Hosts built directly on their platform (no linux-builder needed)
  # This includes: NixOS hosts, home-manager hosts (both Linux and darwin)
  directBuildHosts = nixosHosts ++ homeHosts;

  # nix-darwin configurations need linux-builder for cross-compilation
  darwinConfigs = darwinHosts;

  # Common Nix configuration
  nixConf = ''
    accept-flake-config = true
    always-allow-substitutes = true
    builders-use-substitutes = true
    max-jobs = auto
  '';

  # nix-fast-build arguments
  nfbArgs = "--no-nom --skip-cached --retries=3 --option accept-flake-config true";

  # Reusable step definitions
  steps = {
    checkout = {
      uses = "actions/checkout@v4";
    };

    nixInstaller = {
      uses = "DeterminateSystems/nix-installer-action@v16";
      "with".extra-conf = nixConf;
    };

    nixCache = {
      uses = "actions/cache@v4";
      "with" = {
        path = "~/.cache/nix";
        key = "nix-eval-\${{ runner.os }}-\${{ runner.arch }}-\${{ needs.setup.outputs.flake-lock-hash }}";
        restore-keys = "nix-eval-\${{ runner.os }}-\${{ runner.arch }}-";
      };
    };

    cachix = {
      uses = "cachix/cachix-action@v15";
      "with" = {
        name = "nix-config";
        authToken = "\${{ secrets.CACHIX_AUTH_TOKEN }}";
        extraPullNames = "nix-community";
      };
    };
  };

  # Common setup steps for build jobs
  setupSteps = [
    steps.checkout
    steps.nixInstaller
    steps.nixCache
    steps.cachix
  ];

  # Platforms to run flake check/show on
  checkPlatforms = [
    {
      os = "ubuntu-24.04";
      platform = "x86_64-linux";
    }
    {
      os = "macos-15";
      platform = "aarch64-darwin";
    }
  ];

  flakeRef = "github:\${{ github.repository }}/\${{ github.sha }}";
in
{
  imports = [ inputs.actions-nix.flakeModules.default ];

  flake.actions-nix = {
    pre-commit.enable = true;

    defaultValues.jobs = {
      timeout-minutes = 60;
      runs-on = "ubuntu-24.04";
    };

    workflows.".github/workflows/ci.yaml" = {
      name = "ci";

      on = {
        push.branches = [
          "master"
          "try"
        ];
        pull_request = { };
      };

      permissions = { };

      env = {
        flake = flakeRef;
        nix-conf = nixConf;
        nix-fast-build-args = nfbArgs;
      };

      jobs = {
        # Setup job - gets flake.lock hash for caching
        setup = {
          runs-on = "ubuntu-24.04";
          outputs.flake-lock-hash = "\${{ steps.flake-lock-hash.outputs.hash }}";
          steps = [
            steps.checkout
            {
              id = "flake-lock-hash";
              run = ''echo "hash=''${{ hashFiles('flake.lock') }}" >> "$GITHUB_OUTPUT"'';
            }
          ];
        };

        # Flake check on all platforms
        flake-check = {
          name = "flake check (\${{ matrix.systems.platform }})";
          needs = [ "setup" ];
          strategy.matrix.systems = checkPlatforms;
          runs-on = "\${{ matrix.systems.os }}";
          steps = setupSteps ++ [
            {
              name = "nix flake check";
              run = "nix flake check '\${{ env.flake }}'";
            }
          ];
        };

        # Flake show on all platforms
        flake-show = {
          name = "flake show (\${{ matrix.systems.platform }})";
          needs = [ "setup" ];
          strategy.matrix.systems = checkPlatforms;
          runs-on = "\${{ matrix.systems.os }}";
          steps = setupSteps ++ [
            {
              name = "nix flake show";
              run = "nix flake show '\${{ env.flake }}'";
            }
          ];
        };

        # Build hosts directly (NixOS + home-manager on any platform)
        build = {
          name = "build \${{ matrix.attrs.name }} (\${{ matrix.attrs.hostPlatform }})";
          needs = [ "setup" ];
          strategy = {
            fail-fast = false;
            matrix.attrs = directBuildHosts;
          };
          runs-on = "\${{ matrix.attrs.runsOn }}";
          steps = setupSteps ++ [
            {
              name = "nix-fast-build";
              run = "nix run '\${{ env.flake }}#nix-fast-build' -- \${{ env.nix-fast-build-args }} --flake='\${{ env.flake }}#\${{ matrix.attrs.attr }}'";
            }
          ];
        };

        # Build linux-builder for nix-darwin hosts (cross-compile on Linux)
        build-linux-builder = {
          name = "build linux-builder for \${{ matrix.attrs.name }}";
          "if" = toString (lib.length darwinConfigs > 0);
          needs = [ "setup" ];
          strategy = {
            fail-fast = false;
            matrix.attrs = darwinConfigs;
          };
          runs-on = "\${{ matrix.attrs.equivalentLinuxRunner }}";
          steps = setupSteps ++ [
            {
              name = "nix-fast-build";
              run = "nix run '\${{ env.flake }}#nix-fast-build' -- \${{ env.nix-fast-build-args }} --flake='\${{ env.flake }}#\${{ matrix.attrs.linuxBuilderAttr }}'";
            }
          ];
        };

        # Build nix-darwin hosts (after linux-builder)
        build-darwin-host = {
          name = "build \${{ matrix.attrs.name }} (\${{ matrix.attrs.hostPlatform }})";
          "if" = toString (lib.length darwinConfigs > 0);
          needs = [
            "setup"
            "build-linux-builder"
          ];
          strategy = {
            fail-fast = false;
            matrix.attrs = darwinConfigs;
          };
          runs-on = "\${{ matrix.attrs.runsOn }}";
          steps = setupSteps ++ [
            {
              name = "nix-fast-build";
              run = "nix run '\${{ env.flake }}#nix-fast-build' -- \${{ env.nix-fast-build-args }} --flake='\${{ env.flake }}#\${{ matrix.attrs.attr }}'";
            }
          ];
        };

        # Final check job - aggregates all results
        check = {
          runs-on = "ubuntu-24.04";
          needs = [
            "flake-check"
            "flake-show"
            "build"
            "build-linux-builder"
            "build-darwin-host"
          ];
          "if" = "always()";
          steps = [
            {
              uses = "re-actors/alls-green@release/v1";
              "with" = {
                jobs = "\${{ toJSON(needs) }}";
                allowed-skips = "build-linux-builder, build-darwin-host";
              };
            }
          ];
        };
      };
    };
  };
}
