{
  programs.starship = {
    enable = true;
    enableBashIntegration = false;
    enableFishIntegration = false;
  };

  xdg.configFile.starship = {
    target = "starship.toml";
    text = ''
      add_newline = false

      format = """\
        $username\
        $hostname\
        $directory\
        $git_branch\
        $git_commit\
        $git_state\
        $git_status\
        $package\
        $haskell\
        $python\
        $rust\
        $nix_shell\
        $line_break\
        $jobs\
        $character\
      """

      [git_status]
      disabled=true

      [nix_shell]
      use_name = true
    '';
  };
}
