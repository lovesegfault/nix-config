final: prev: {
  nix-output-monitor = prev.nix-output-monitor.overrideAttrs (_: {
    src = final.fetchFromGitHub {
      owner = "maralorn";
      repo = "nix-output-monitor";
      rev = "0cb46615fb8187e4598feac4ccf8f27a06aae0b7";
      hash = "sha256-gFjy6lIr+mcoubIT+NufH2dqXiQmqKOlwue1OjW6n2g=";
      postFetch = ''
        rm -f $out/log.json
      '';
    };
  });
}
