{ sources ? import ./nix, lib ? import sources.lib, pkgs ? import sources.nixpkgs { } }:
with builtins; with lib;
let
  mkGenericJob = extraSteps: {
    runs-on = "ubuntu-latest";
    steps = [
      {
        name = "Checkout";
        uses = "actions/checkout@v2";
      }
      {
        name = "Nix";
        uses = "cachix/install-nix-action@v9";
        "with" = {
          skip_adding_nixpkgs_channel = true;
        };
      }
      {
        name = "AArch64";
        run = ''
          # first create the ssh config dir for root
          sudo mkdir -p /root/.ssh

          # now add the key for the build slave
          echo "''${{ secrets.AARCH64_BOX_KEY }}" |
              sudo tee /root/.ssh/aarch64.community.nixos > /dev/null
          sudo chmod 0600 /root/.ssh/aarch64.community.nixos

          # and make it a known host
          echo "''${{ secrets.KNOWN_HOSTS }}" |
              sudo tee -a /root/.ssh/known_hosts > /dev/null

          # lastly register the build slave with nix
          slave_cfg=(
            lovesegfault@aarch64.nixos.community # user/addr
            aarch64-linux                        # arch
            /root/.ssh/aarch64.community.nixos   # key
            64                                   # maxJobs
            1                                    # speed factor
            big-parallel                         # features
          )
          echo "''${slave_cfg[*]}" |
              sudo tee /etc/nix/machines > /dev/null
        '';
      }
      {
        name = "Cachix Setup";
        uses = "cachix/cachix-action@v6";
        "with" = {
          name = "nix-config";
          signingKey = "'\${{ secrets.CACHIX_SIGNING_KEY }}'";
        };
      }
    ] ++ extraSteps;
  };

  mkSystemJob = attrToBuild: mkGenericJob [{
    name = "Nix Build";
    run = "nix-build -A ${attrToBuild}";
  }];

  systems = filter (e: e != "foucault") (attrNames (import ./default.nix { }).config.nodes);

  ci = {
    on = [ "pull_request" "push" ];
    name = "CI";
    jobs = (genAttrs systems mkSystemJob) // {
      parsing = mkGenericJob [{
        name = "Parsing";
        run = "find . -name \"*.nix\" -exec nix-instantiate --parse --quiet {} >/dev/null +";
      }];
      formatting = mkGenericJob [{
        name = "Formatting";
        run = "nix-shell --run 'nixpkgs-fmt --check .'";
      }];
    };
  };
  generated = pkgs.writeText "ci.yml" (builtins.toJSON ci);
in
pkgs.writeShellScript "gen_ci" ''
  cat ${generated} | ${pkgs.jq}/bin/jq > ./.github/workflows/ci.yml
''
