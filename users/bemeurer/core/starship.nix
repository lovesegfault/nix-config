{
  programs.starship.enable = true;

  xdg.configFile.starship = {
    target = "starship.toml";
    text = ''
      add_newline = false

      [nix_shell]
      use_name = true
    '';
  };
}
