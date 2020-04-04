{ sources ? import ./nix, lib ? sources.lib, pkgs ? sources.pkgs {} }:
with builtins; with lib;
let
  mkJob = extraSteps: {
    runs-on = "ubuntu-latest";
    steps = [
      {
        name = "Checkout";
        uses = "actions/checkout@v2";
      }
      {
        name = "Nix";
        uses = "cachix/install-nix-action@v8";
      }
    ] ++ extraSteps;
  };
  cachix = { skipNixBuild ? false, attributes ? null }: {
    name = "Cachix";
    uses = "cachix/cachix-action@v5";
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
  mkBuildStep = h: a: mkJob (
    optional (a == "aarch64-linux") aarch64
    ++ [ (cachix { attributes = h; }) ]
  );

  # FIXME: figure out what's wrong with the aarch64 build box
  hosts = filterAttrs (_:v: v != "aarch64-linux") (import ./hosts.nix);
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
          run = "nix-shell --run 'nixpkgs-fmt --check .'";
        }
      ];
    };
  };
  generated = pkgs.writeText "ci.yml" (builtins.toJSON ci);
in
pkgs.writeShellScript "gen_ci" ''
  cat ${generated} > ./.github/workflows/ci.yml
''
