{ lib, pkgs, ... }:
{
  programs.fish = {
    enable = true;
    interactiveShellInit = lib.mkMerge [
      (lib.mkBefore ''
        set -g fish_escape_delay_ms 300
        set -g fish_greeting
      '')
      (lib.mkAfter ''
        ${pkgs.nix-your-shell}/bin/nix-your-shell --nom fish | source

        fish_vi_key_bindings insert
      '')
    ];
    plugins = [
      {
        name = "autopair";
        inherit (pkgs.fishPlugins.autopair) src;
      }
    ];
  };
}
