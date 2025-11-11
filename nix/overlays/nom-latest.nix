final: prev: {
  nix-output-monitor = prev.nix-output-monitor.overrideAttrs (old: {
    src = final.fetchFromGitHub {
      owner = "maralorn";
      repo = "nix-output-monitor";
      rev = "698e6f3afdc9d68dd65d84df7b030499dbfaf84b";
      hash = "sha256-QwEVaUxvXEdx5icIZZYQQjvJO5j0+GeWtJvCJ/LZwpA=";
    };
  });
}
