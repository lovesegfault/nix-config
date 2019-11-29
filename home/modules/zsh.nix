{ config, pkgs, ... }: {
  programs.starship.enableZshIntegration = true;

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    autocd = true;
    dotDir = ".config/zsh";
    history = {
      expireDuplicatesFirst = true;
      extended = true;
      ignoreDups = true;
      path = "${config.xdg.dataHome}/zsh/history";
      save = 30000;
      share = true;
    };
    initExtra = let editor = "${config.home.sessionVariables.EDITOR}";
    in ''
      bindkey "$${terminfo[khome]}" beginning-of-line
      bindkey "$${terminfo[kend]}" end-of-line
      bindkey "$${terminfo[kdch1]}" delete-char
      bindkey '\eOA' history-substring-search-up
      bindkey '\eOB' history-substring-search-down
      bindkey "^[[A" history-substring-search-up
      bindkey "^[[B" history-substring-search-down
      bindkey "$$terminfo[kcuu1]" history-substring-search-up
      bindkey "$$terminfo[kcud1]" history-substring-search-down
      bindkey "^[[1;5C" forward-word
      bindkey "^[[1;3C" forward-word
      bindkey "^[[1;5D" backward-word
      bindkey "^[[1;3D" backward-word

      bindkey -s "^O" '${editor} $(fzf -m)^M'
    '';
    sessionVariables = { RPROMPT = ""; };
    plugins = [
      {
        name = "fast-syntax-highlighting";
        file = "fast-syntax-highlighting.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "zdharma";
          repo = "fast-syntax-highlighting";
          rev = "bb2da8f833924acab543154a9ec636c6b6434140";
          sha256 = "1sb12nhzcfiqf57sclkpm691fwgns9h6kfyyv28bl9hqpyzicvxc";
        };
      }
      {
        name = "history-search-multi-word";
        file = "history-search-multi-word.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "zdharma";
          repo = "history-search-multi-word";
          rev = "0713e6dd8a8757d8caa100009487b520c15e94fa";
          sha256 = "0fmsy96f6kvzcnd2shb6s1qmymrf1ddqgf3l1zj1isd1fhzwqsnw";
        };
      }
      {
        name = "zsh-autopair";
        file = "zsh-autopair.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "hlissner";
          repo = "zsh-autopair";
          rev = "34a8bca0c18fcf3ab1561caef9790abffc1d3d49";
          sha256 = "1h0vm2dgrmb8i2pvsgis3lshc5b0ad846836m62y8h3rdb3zmpy1";
        };
      }
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "166c86c609a5398453f6386efd70c3cdb66b2058";
          sha256 = "1d2j6968w89ll1nf9wxjll6cbrwnaj0lxcf27kyy4sx12fd3nd5x";
        };
      }
      {
        name = "zsh-sudo";
        file = "sudo.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "hcgraf";
          repo = "zsh-sudo";
          rev = "d8084def6bb1bde2482e7aa636743f40c69d9b32";
          sha256 = "1dpm51w3wjxil8sxqw4qxim5kmf6afmkwz1yfhldpdlqm7rfwpi3";
        };
      }
      {
        name = "zsh-history-substring-search";
        file = "zsh-history-substring-search.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-history-substring-search";
          rev = "0f80b8eb3368b46e5e573c1d91ae69eb095db3fb";
          sha256 = "0y8va5kc2ram38hbk2cibkk64ffrabfv1sh4xm7pjspsba9n5p1y";
        };
      }
    ];
    shellAliases = {
      # misc
      tupd =
        "rsync -Pav --delete ~/documents/torrents/ viking.whatbox.ca:watch/";
      cat = "bat";
      # rust
      c = "cargo";
      cb = "cargo build";
      cbr = "cargo build --release";
      cc = "cargo check";
      ccl = "cargo clean";
      cdoc = "cargo doc";
      clp = "cargo clippy";
      cr = "cargo run";
      crr = "cargo run --release";
      ct = "cargo test";
      ctr = "cargo test --release";
      # git
      g = "git";
      ga = "git add";
      gaa = "git add -A";
      gaap = "git add -A --patch";
      gap = "git add --patch";
      gch = "git checkout";
      gcl = "git clone";
      gco = "git commit";
      gdf = "git diff";
      gdt = "git difftool";
      gf = "git fetch --prune --all";
      gl = "git log --graph --abbrev-commit --decorate";
      gm = "git merge";
      gma = "git merge --abort";
      gmc = "git merge --continue";
      gpl = "git pull --rebase";
      gps = "git push";
      gr = "git rebase";
      gra = "git rebase --abort";
      grc = "git rebase --continue";
      grsn = "git rebase --exec 'git commit --amend --no-edit -n -S'";
      gs = "git status";
      # exa
      l = "exa --binary --header --long --classify --git";
      la = "l --all";
      ls = "l";
    };
  };
}
