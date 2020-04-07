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
        "hg_branch",
        "package",
        "haskell",
        "julia",
        "python",
        "rust",
        "nix_shell",
        "line_break",
        "jobs",
        "character",
      ];

      [nix_shell]
      use_name = true
    '';
  };
}
