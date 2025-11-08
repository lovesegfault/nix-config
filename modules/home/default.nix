{
  # Default modules - manually maintained list
  # Consolidated packages in all-packages.nix to match old core/default.nix structure
  imports = [
    # External integrations - fonts come first
    ./stylix.nix
    ./nix.nix

    # Individual program configs (from old core/default.nix imports)
    # These configure programs.* but don't directly add to home.packages
    ./bash.nix
    ./btop.nix
    ./fish.nix
    ./git.nix
    ./htop.nix
    ./ssh.nix
    ./starship.nix
    ./tmux.nix
    ./xdg.nix
    ./zsh.nix

    # Infrastructure
    ./config-kind.nix
    ./me.nix  # Includes username, fullname, email, uid

    # Shell aliases and programs
    ./shell-aliases.nix
    ./programs.nix

    # Core system config
    ./core.nix

    # ALL package additions in one place (matches old core/default.nix body)
    # Replaces: neovim.nix, dev.nix, packages.nix
    ./all-packages.nix
  ];
}
