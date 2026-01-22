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
    x86_64-linux.os = "ubuntu-24.04";
    aarch64-linux.os = "ubuntu-22.04-arm";
    aarch64-darwin = {
      os = "macos-15";
      equivalentLinuxPlatform = "aarch64-linux";
    };
  };

  # Build matrix entry from configuration (autodiscovery)
  # Returns data in the exact shape needed for GitHub Actions matrix
  mkHostInfo =
    kind: name: cfg:
    let
      platform = cfg.pkgs.stdenv.hostPlatform.system;
      platformInfo = platforms.${platform} or null;
    in
    lib.optionalAttrs (platformInfo != null) (
      {
        inherit name;
        hostPlatform = platform;
        runsOn = platformInfo.os;
        attr =
          if kind == "nixos" then
            "nixosConfigurations.${name}.config.system.build.toplevel"
          else if kind == "darwin" then
            "darwinConfigurations.${name}.config.system.build.toplevel"
          else
            "homeConfigurations.${name}.activationPackage";
      }
      // lib.optionalAttrs (kind == "darwin") rec {
        inherit (platformInfo) equivalentLinuxPlatform;
        equivalentLinuxRunner = platforms.${equivalentLinuxPlatform}.os;
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

  # GitHub Actions references - all versions consolidated here for Renovate
  actions = {
    alls-green = "re-actors/alls-green@05ac9388f0aebcb5727afa17fcccfecd6f8ec5fe"; # v1.2.2
    automerge = "peter-evans/enable-pull-request-automerge@a660677d5469627102a1c1e11409dd063606628d"; # v3.0.0
    cache = "actions/cache@8b402f58fbc84540c8b491a91e594a4576fec3d7"; # v5.0.2
    cachix = "cachix/cachix-action@0fc020193b5a1fa3ac4575aa3a7d3aa6a35435ad"; # v16
    checkout = "actions/checkout@de0fac2e4500dabe0009e67214ff5f5447ce83dd"; # v6.0.2
    nix-installer = "DeterminateSystems/nix-installer-action@c5a866b6ab867e88becbed4467b93592bce69f8a"; # v21
  };

  # Reusable step definitions
  steps = {
    checkout = {
      uses = actions.checkout;
      "with".persist-credentials = false;
    };

    nixInstaller = {
      uses = actions.nix-installer;
      "with".extra-conf = ''
        accept-flake-config = true
        always-allow-substitutes = true
        builders-use-substitutes = true
        max-jobs = auto
      '';
    };

    nixCache = {
      uses = actions.cache;
      "with" = {
        path = "~/.cache/nix";
        key = "nix-eval-\${{ runner.os }}-\${{ runner.arch }}-\${{ hashFiles('flake.lock') }}";
        restore-keys = "nix-eval-\${{ runner.os }}-\${{ runner.arch }}-";
      };
    };

    cachix = {
      uses = actions.cachix;
      "with" = {
        name = "nix-config";
        authToken = "\${{ secrets.CACHIX_AUTH_TOKEN }}";
        extraPullNames = "nix-community";
      };
    };

    # Helper to create nix-fast-build step for a given attribute expression
    nix-fast-build = flakeAttr: {
      name = "nix-fast-build";
      run = "nix run '${flakeRef}#nix-fast-build' -- --no-nom --skip-cached --retries=3 --option accept-flake-config true --flake='${flakeRef}#${flakeAttr}'";
    };
  };

  # Common setup steps for build jobs
  setupSteps = [
    steps.checkout
    steps.nixInstaller
    steps.nixCache
    steps.cachix
  ];

  # Platforms to run flake check/show on (derived from all hosts)
  checkPlatforms =
    let
      allHosts = nixosHosts ++ darwinHosts ++ homeHosts;
      hostPlatforms = lib.unique (map (h: h.hostPlatform) allHosts);
    in
    map (p: {
      platform = p;
      inherit (platforms.${p}) os;
    }) hostPlatforms;

  flakeRef = "git+file:.";
in
{
  imports = [ inputs.actions-nix.flakeModules.default ];

  flake.actions-nix = {
    pre-commit.enable = true;

    defaultValues.jobs = {
      timeout-minutes = 60;
      runs-on = "ubuntu-24.04";
    };

    workflows = {
      ".github/workflows/ci.yaml" = {
        name = "ci";

        on = {
          push.branches = [
            "master"
            "try"
          ];
          pull_request = { };
          workflow_dispatch = { };
        };

        concurrency = {
          group = "ci-\${{ github.head_ref || github.ref_name }}";
          cancel-in-progress = "\${{ github.event_name == 'pull_request' }}";
        };

        # Minimal permissions for security - this workflow only needs to read code
        permissions = { };

        jobs = {
          # Flake check on all platforms
          flake-check = {
            name = "flake check (\${{ matrix.systems.platform }})";
            strategy.matrix.systems = checkPlatforms;
            runs-on = "\${{ matrix.systems.os }}";
            steps = setupSteps ++ [
              {
                name = "nix flake check";
                run = "nix flake check '${flakeRef}'";
              }
              {
                name = "nix flake show";
                run = "nix flake show '${flakeRef}'";
              }
            ];
          };

          # Build hosts directly (NixOS + home-manager on any platform)
          build = {
            name = "\${{ matrix.attrs.name }} (\${{ matrix.attrs.hostPlatform }})";
            strategy = {
              fail-fast = false;
              matrix.attrs = nixosHosts ++ homeHosts;
            };
            runs-on = "\${{ matrix.attrs.runsOn }}";
            steps = setupSteps ++ [ (steps.nix-fast-build "\${{ matrix.attrs.attr }}") ];
          };

          # Final check job - aggregates all results
          check = {
            runs-on = "ubuntu-24.04";
            needs = [
              "flake-check"
              "build"
              "build-linux-builder"
              "build-darwin-host"
            ];
            "if" = "always()";
            steps = [
              {
                uses = actions.alls-green;
                "with" = {
                  jobs = "\${{ toJSON(needs) }}";
                  allowed-skips = "build-linux-builder, build-darwin-host";
                };
              }
            ];
          };
        }
        // (lib.optionalAttrs (lib.length darwinHosts > 0) {
          # Build linux-builder for nix-darwin hosts (cross-compile on Linux)
          build-linux-builder = {
            name = "linux-builder for \${{ matrix.attrs.name }} (\${{ matrix.attrs.equivalentLinuxPlatform }})";
            strategy = {
              fail-fast = false;
              matrix.attrs = darwinHosts;
            };
            runs-on = "\${{ matrix.attrs.equivalentLinuxRunner }}";
            steps = setupSteps ++ [ (steps.nix-fast-build "\${{ matrix.attrs.linuxBuilderAttr }}") ];
          };

          # Build nix-darwin hosts (after linux-builder)
          build-darwin-host = {
            name = "\${{ matrix.attrs.name }} (\${{ matrix.attrs.hostPlatform }})";
            needs = [ "build-linux-builder" ];
            strategy = {
              fail-fast = false;
              matrix.attrs = darwinHosts;
            };
            runs-on = "\${{ matrix.attrs.runsOn }}";
            steps = setupSteps ++ [ (steps.nix-fast-build "\${{ matrix.attrs.attr }}") ];
          };
        });
      };

      # Regenerate workflows for Renovate PRs or manual trigger
      ".github/workflows/regenerate-workflows.yaml" = {
        name = "regenerate-workflows";

        on = {
          pull_request.paths = [
            "modules/flake-parts/actions.nix"
            "flake.lock"
          ];
          workflow_dispatch = { };
        };

        permissions = {
          contents = "write";
          pull-requests = "write";
        };

        jobs.regenerate = {
          runs-on = "ubuntu-24.04";
          # Only run for Renovate PRs or manual dispatch
          "if" = "github.actor == 'renovate[bot]' || github.event_name == 'workflow_dispatch'";
          steps = [
            (
              steps.checkout
              // {
                "with" = {
                  ref = "\${{ github.head_ref || github.ref_name }}";
                  token = "\${{ secrets.PAT }}";
                  fetch-depth = 2;
                };
              }
            )
            steps.nixInstaller
            steps.nixCache
            steps.cachix
            {
              name = "Regenerate workflows";
              run = "nix run .#render-workflows";
            }
            {
              name = "Amend commit with regenerated workflows";
              run = ''
                git config user.name "hatesegfault"
                git config user.email "bernardo+hatesegfault@meurer.org"
                git add .github/workflows/
                git diff --staged --quiet || git commit --amend --no-edit
                git push --force-with-lease
              '';
            }
            {
              uses = actions.automerge;
              "with" = {
                token = "\${{ secrets.PAT }}";
                pull-request-number = "\${{ github.event.pull_request.number }}";
                merge-method = "rebase";
              };
            }
          ];
        };
      };
    };
  };
}
