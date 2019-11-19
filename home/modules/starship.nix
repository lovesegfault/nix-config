{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  xdg.configFile.starship = {
    target = "starship.toml";
    text = ''
      add_newline = false

      [nix_shell]
      use_name = true
    '';
  };
}
