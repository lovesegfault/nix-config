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

      source $ZPLUG_HOME/init.zsh
      zplug "zplug/zplug", hook-build:"zplug --self-manage"
      zplug "zdharma/fast-syntax-highlighting", defer:2
      zplug "zdharma/history-search-multi-word", defer:2
      zplug "zsh-users/zsh-history-substring-search", defer:2
      zplug "zsh-users/zsh-completions", defer:2
      zplug "zsh-users/zsh-autosuggestions", defer:2
      zplug "hlissner/zsh-autopair", defer:2
      zplug "hcgraf/zsh-sudo"
      zplug "chisui/zsh-nix-shell"
      zplug "spwhitt/nix-zsh-completions", defer:2
      zplug "mafredri/zsh-async", from:github
      zplug "sindresorhus/pure", use:pure.zsh, from:github, as:theme
      zplug load
    '';
    localVariables = { ZPLUG_HOME = "$HOME/.zplug"; };
    profileExtra = ''
      if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
        exec sway > /tmp/sway.log 2>&1
      fi
    '';
    shellAliases = {
      c = "cargo";
      cat = "bat";
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
      l = "exa -bhlF";
      la = "exa -bhlFa";
      ls = "exa -bhlF";
    };
  };
}
