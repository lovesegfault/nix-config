{ config, pkgs, ... }:

{
  programs.zsh = rec {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    dotDir = ".config/zsh";
    history = {
      expireDuplicatesFirst = true;
      extended = true;
      ignoreDups = true;
      path = "${dotDir}/zsh_history";
      save = 10000;
      share = true;
      size = 10000;
    };
    initExtra = ''
      bindkey "''${terminfo[kdch1]}" delete-char
      bindkey "''${terminfo[kend]}" end-of-line
      bindkey "''${terminfo[khome]}" beginning-of-line
      bindkey "^[[1;3C" forward-word
      bindkey "^[[1;3D" backward-word
      bindkey "^[[1;5C" forward-word
      bindkey "^[[1;5D" backward-word
      bindkey "^[[A" history-substring-search-up
      bindkey "^[[B" history-substring-search-down
      bindkey -s "^O" 'nvim $(sk -m)^M'
      autoload -Uz promptinit && promptinit
    '';
    localVariables = {
      SPACESHIP_PROMPT_ADD_NEWLINE = false;
      SPACESHIP_PROMPT_SEPARATE_LINE = false;
    };
    plugins = [
      {
        name = "spaceship";
        file = "spaceship.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "denysdovhan";
          repo = "spaceship-prompt";
          rev = "d9f25e14e7bec4bef223fd8a9151d40b8aa868fa";
          sha256 = "0vl5dymd07mi42wgkh0c3q8vf76hls1759dirlh3ryrq6w9nrdbf";
         };
      }
      {
        name = "nix-shell";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "3f4dd5eebd7bc4f49768b63dd90ad874fb04dd16";
          sha256 = "03z89h8rrj8ynxnai77kmb5cx77gmgsfn6rhw77gaix2j3scr2kk";
        };
      }
      {
        name = "sudo";
        src = pkgs.fetchFromGitHub {
          owner = "hcgraf";
          repo = "zsh-sudo";
          rev = "d8084def6bb1bde2482e7aa636743f40c69d9b32";
          sha256 = "1dpm51w3wjxil8sxqw4qxim5kmf6afmkwz1yfhldpdlqm7rfwpi3";
        };
      }
      {
        name = "autopair";
        src = pkgs.fetchFromGitHub {
          owner = "hlissner";
          repo = "zsh-autopair";
          rev = "4039bf142ac6d264decc1eb7937a11b292e65e24";
          sha256 = "02pf87aiyglwwg7asm8mnbf9b2bcm82pyi1cj50yj74z4kwil6d1";
        };
      }
      {
        name = "zsh-history-substring-search";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-history-substring-search";
          rev = "47a7d416c652a109f6e8856081abc042b50125f4";
          sha256 = "1mvilqivq0qlsvx2rqn6xkxyf9yf4wj8r85qrxizkf0biyzyy4hl";
        };
      }
      {
        name = "zsh-tmux-rename";
        src = pkgs.fetchFromGitHub {
          owner = "sei40kr";
          repo = "zsh-tmux-rename";
          rev = "97b01835f412552621bb880b7a7fcde883c9db30";
          sha256 = "1wwbska7p7cs550na51m6bsv4d4881nnbh8kd5wln7njg1gzi164";
        };
      }
      {
        name = "fast-syntax-highlighting";
        src = pkgs.fetchFromGitHub {
          owner = "zdharma";
          repo = "fast-syntax-highlighting";
          rev = "6fafe6166e84cfaf6322440fcf59d30637f87d3a";
          sha256 = "19yylfq9vv3zqrwmsm3ibazb2ayaf665axp506xmxh77m8d81izj";
        };
      }
      {
        name = "history-search-multi-word";
        src = pkgs.fetchFromGitHub {
          owner = "zdharma";
          repo = "history-search-multi-word";
          rev = "159aaa5e723ab05b4fe930bb232835d98a0e745d";
          sha256 = "007h248zvw6vnwg2kcybxcr49y7xxxysdxhpw9hja8zp2yk45vr3";
        };
      }
      {
        name = "colors";
        src = pkgs.fetchFromGitHub {
          owner = "zpm-zsh";
          repo = "colors";
          rev = "d8afe625be9e3d4f2c5d26e8d8ef2aa9d586673b";
          sha256 = "0g3mw0q45kzdkldhv4w24wp6flmqw5hmfr6yxjpjmf07mnj3j4k9";
        };
      }
    ];
    shellAliases = {
      cb = "cargo build";
      cbr = "cargo build --release";
      cc = "cargo check";
      ccr="cargo check --release";
      cdoc = "cargo doc";
      cdocr="cargo doc --release";
      cr = "cargo run";
      crr="cargo run --release";
      ct = "cargo test";
      ctr="cargo test --release";
      ga = "git add";
      gaa = "git add -A";
      gaap = "git add -A --patch";
      gap = "git add --patch";
      gc = "git commit";
      gd = "git difftool";
      gf = "git fetch --prune";
      gl = "git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all";
      gm = "git merge";
      gp = "git push";
      gpl = "git pull --rebase";
      gr = "git rebase";
      gs = "git status --find-renames --show-stash";
      l = "${shellAliases.ls}";
      la ="exa -bhlFa";
      ls = "exa -bhlF";
      sync = "sync & watch -n 1 rg -e Dirty: /proc/meminfo";
    };
  };
}
