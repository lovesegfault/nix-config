{ config, pkgs, flake, lib, ... }:
{
  # All package additions in one place to match old core/default.nix structure
  # This ensures they're added in exact order without interleaving from programs.*
  home.packages = with pkgs; [
    # From neovim.nix - must be first
    (flake.inputs.lovesegfault-vim-config.packages.${pkgs.stdenv.hostPlatform.system}.neovim.extend
      config.stylix.targets.nixvim.exportedModule)

    # From dev.nix - must be second
    git-lfs
    (lib.hiPrio nixpkgs-review)
    nix-update
    tmate
    upterm

    # From packages.nix - must be third
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
  ];

  # From neovim.nix
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  programs.git.settings.core.editor = "nvim";

  # From dev.nix
  home.extraOutputsToInstall = [ "doc" "devdoc" ];
  home.file.gdbinit = {
    target = ".gdbinit";
    text = ''
      set auto-load safe-path /
    '';
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    stdlib = ''
      : ''${XDG_CACHE_HOME:=$HOME/.cache}
      declare -A direnv_layout_dirs
      direnv_layout_dir() {
          echo "''${direnv_layout_dirs[$PWD]:=$(
              echo -n "$XDG_CACHE_HOME"/direnv/layouts/
              echo -n "$PWD" | shasum | cut -d ' ' -f 1
          )}"
      }
    '';
  };

  programs.gh = {
    enable = true;
    settings.git_protocol = "ssh";
  };
}
