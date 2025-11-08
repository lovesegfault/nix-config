{ pkgs, lib, ... }:
{
  # Use mkAfter to ensure these packages come AFTER neovim and dev in PATH
  home.packages = lib.mkAfter (with pkgs; [
    eza
    fd
    fzf
    jq
    macchina
    nh
    nix-closure-size
    nix-output-monitor
    ripgrep
    rsync
    truecolor-check
  ] ++ lib.optionals (!pkgs.stdenv.hostPlatform.isDarwin) [
    mosh
  ]);
}
