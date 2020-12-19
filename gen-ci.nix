{ lib
, writeText
, writeScriptBin
, jq

, hosts
}:
let
  mkGenericJob = extraSteps: {
    runs-on = "ubuntu-latest";
    steps = [
      { uses = "actions/checkout@v2"; }
      { uses = "cachix/install-nix-action@v12"; }
      {
        name = "AArch64";
        run = ''
          # first create the ssh config dir for root
          sudo mkdir -p /root/.ssh

          # now add the key for the builder
          echo "''${{ secrets.AARCH64_BOX_KEY }}" |
              sudo tee /root/.ssh/aarch64.community.nixos > /dev/null
          sudo chmod 0600 /root/.ssh/aarch64.community.nixos

          # and make it a known host
          echo "''${{ secrets.KNOWN_HOSTS }}" |
              sudo tee -a /root/.ssh/known_hosts > /dev/null

          # lastly register the builder with nix
          builder_cfg=(
            lovesegfault@aarch64.nixos.community # user/addr
            aarch64-linux                        # arch
            /root/.ssh/aarch64.community.nixos   # key
            64                                   # maxJobs
            1                                    # speed factor
            big-parallel                         # features
          )
          echo "''${builder_cfg[*]}" |
              sudo tee /etc/nix/machines > /dev/null
        '';
      }
      {
        uses = "cachix/cachix-action@v7";
        "with" = {
          name = "nix-config";
          signingKey = "'\${{ secrets.CACHIX_SIGNING_KEY }}'";
        };
      }
    ] ++ extraSteps;
  };

  mkHostJob = host: mkGenericJob [{
    name = "Build";
    run = ''
      nix run nixpkgs.nix-build-uncached -c \
        nix-build-uncached -E \
        "(builtins.getFlake (toString ./.)).deploy.nodes.${host}.profiles.system.path"
    '';
  }];

  ci = {
    on = {
      push.branches = [ "master" ];
      pull_request.branches = [ "**" ];
    };
    name = "CI";
    jobs = (lib.genAttrs hosts mkHostJob) // {
      preCommitChecks = mkGenericJob [{
        name = "pre-commit checks";
        run = "nix-build -A preCommitChecks";
      }];
      checkCI = mkGenericJob [{
        name = "ci up-to-date check";
        run = ''
          cp ./.github/workflows/ci.yml /tmp/ci.yml.old
          nix run nixpkgs.nixUnstable -c nix run .#gen-ci
          diff ./.github/workflows/ci.yml /tmp/ci.yml.old || exit 1
        '';
      }];
    };
  };
  generated = writeText "ci.yml" (builtins.toJSON ci);
in
writeScriptBin "gen-ci" ''
  cat ${generated} | ${jq}/bin/jq > ./.github/workflows/ci.yml
''
