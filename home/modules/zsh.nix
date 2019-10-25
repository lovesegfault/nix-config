{ config, pkgs, ... }: {
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
      path = ".local/share/zsh/history";
      save = 30000;
      share = true;
    };
    initExtra = ''
      bindkey "$${terminfo[khome]}" beginning-of-line
      bindkey "$${terminfo[kend]}" end-of-line
      bindkey "$${terminfo[kdch1]}" delete-char
      bindkey "^[[A" history-substring-search-up
      bindkey "^[[B" history-substring-search-down
      bindkey "^[[1;5C" forward-word
      bindkey "^[[1;3C" forward-word
      bindkey "^[[1;5D" backward-word
      bindkey "^[[1;3D" backward-word
    '';
    profileExtra = ''
      if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
        exec sway > /tmp/sway.log 2>&1
      fi
    '';
    shellAliases = {
      # misc
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
      l = "exa -bhlF";
      la = "exa -bhlFa";
      ls = "exa -bhlF";
    };
    plugins = [
      {
        name = "zsh-async";
        src = pkgs.fetchFromGitHub {
          owner = "mafredri";
          repo = "zsh-async";
          rev = "v1.7.2";
          sha256 = "0vl5dymd07mi42wgkh0c3q8vf76hls1759dirlh3ryrq6w9nrdbf";
        };
      }
      {
        name = "pure";
        file = "pure.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "sindresorhus";
          repo = "pure";
          rev = "v1.11.0";
          sha256 = "0vl5dymd07mi42wgkh0c3q8vf76hls1759dirlh3ryrq6w9nrdbf";
        };
      }
      {
        name = "fast-syntax-highlighting";
        src = pkgs.fetchFromGitHub {
          owner = "zdharma";
          repo = "fast-syntax-highlighting";
          rev = "v1.54";
          sha256 = "0vl5dymd07mi42wgkh0c3q8vf76hls1759dirlh3ryrq6w9nrdbf";
        };
      }
      {
        name = "history-search-multi-word";
        src = pkgs.fetchFromGitHub {
          owner = "zdharma";
          repo = "history-search-multi-word";
          rev = "ab2cb3444b543bd1f0f983956f9dbad4620368b8";
          sha256 = "0vl5dymd07mi42wgkh0c3q8vf76hls1759dirlh3ryrq6w9nrdbf";
        };
      }
    ];
  };
}
