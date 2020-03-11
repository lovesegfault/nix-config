{ lib ? import ./nix/lib.nix, pkgs ? import ./nix/nixpkgs.nix {} }:
with builtins; with lib;
let
  checkout = {
    name = "Checkout";
    uses = "actions/checkout@v2";
  };
  nix = {
    name = "Nix";
    uses = "cachix/install-nix-action@v7";
  };
  cachix = { skipNixBuild ? false, attributes ? null }: {
    name = "Cachix";
    uses = "cachix/cachix-action@v4";
    "with" = {
      inherit attributes skipNixBuild;
      name = "nix-config";
      signingKey = "'\${{ secrets.CACHIX_SIGNING_KEY }}'";
    };
  };
  aarch64 = {
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
        8                                    # speed factor
        big-parallel                         # features
      )
      echo "''${slave_cfg[*]}" |
          sudo tee /etc/nix/machines > /dev/null
    '';
  };
  hosts = (import ./. {}).hosts;
  mkJob = extraSteps: {
    runs-on = "ubuntu-latest";
    steps = [ checkout nix ] ++ extraSteps;
  };
  mkBuildStep = h: a: mkJob (
    optional (a == "aarch64-linux") aarch64
    ++ [ (cachix { attributes = h; }) ]
  );
  systemJobs = mapAttrs mkBuildStep hosts;
  ci = {
    on.push.branches = [ "*" ];
    name = "CI";
    jobs = systemJobs // {
      parsing = mkJob [
        {
          name = "Parsing";
          run = "find . -name \"*.nix\" -exec nix-instantiate --parse --quiet {} >/dev/null +";
        }
      ];
      formatting = mkJob [
        (cachix { skipNixBuild = true; })
        {
          name = "Formatting";
          run = "nix-shell --run 'find . -iname \"*.nix\" -not -path ./nix/sources.nix -exec nixpkgs-fmt --check {} +'";
        }
      ];
    };
  };
  generated = pkgs.writeText "ci.yml" (builtins.toJSON ci);
in
pkgs.writeShellScript "gen_ci" ''
  cp --dereference ${generated} ./.github/workflows/ci.yml
''
