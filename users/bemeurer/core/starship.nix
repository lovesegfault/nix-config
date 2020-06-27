{
  programs.starship.enable = true;

  xdg.configFile.starship = {
    target = "starship.toml";
    text = ''
      add_newline = false

      prompt_order = [
        "username",
        "hostname",
        "directory",
        "git_branch",
        "git_commit",
        "git_state",
        "git_status",
        "package",
        "haskell",
        "python",
        "rust",
        "nix_shell",
        "env_var",
        "line_break",
        "jobs",
        "character",
      ]

      [nix_shell]
      use_name = true

      [env_var]
      variable = "VIM_MODE_KEYMAP"
      default = "?"
      style = "bold green"
    '';
  };
}
