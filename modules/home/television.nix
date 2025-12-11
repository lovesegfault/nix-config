{ config, lib, ... }:
{
  programs = {
    nix-search-tv = {
      enable = true;
      enableTelevisionIntegration = false;
    };
    television = {
      enable = true;
      settings = {
        tick_rate = 50;
        default_channel = "files";
        shell_integration = {
          channel_triggers = {
            files = [
              "bat"
              "cat"
              "chmod"
              "chown"
              "cp"
              "gunzip"
              "gzip"
              "head"
              "less"
              "ln"
              "mv"
              "nano"
              "rm"
              "tail"
              "tar"
              "touch"
              "unzip"
              "vim"
              "xz"
              "zip"
            ];
            git-diff = [
              "git add"
              "git restore"
            ];
            git-log = [
              "git log"
              "git show"
            ];
            man = [ "man" ];
            nixpkgs = [ "nix shell" ];
          };
          keybindings = {
            smart_autocomplete = "ctrl-o";
            command_history = "ctrl-t";
          };
        };
      };
      channels = {
        files = {
          metadata = {
            name = "files";
            description = "A channel to select files and directories";
            requirements = [
              "fd"
              "bat"
            ];
          };
          source = {
            command = [
              "fd -t f"
              "fd -t f -H"
            ];
          };
          preview = {
            command = "bat -n --color=always '{}'";
            env = {
              BAT_THEME = "ansi";
            };
          };
          keybindings = {
            shortcut = "f1";
            f12 = "actions:edit";
            ctrl-up = "actions:goto_parent_dir";
          };
          actions.edit = {
            description = "Opens the selected entries with the default editor (falls back to vim)";
            command = "$${EDITOR:-vim} '{}'";
            # use `mode = "fork"` if you want to return to tv afterwards
            mode = "execute";
          };
          actions.goto_parent_dir = {
            description = "Re-opens tv in the parent directory";
            command = "tv files ..";
            mode = "execute";
          };
        };
        git-diff = {
          metadata = {
            name = "git-diff";
            description = "A channel to select files from git diff commands";
            requirements = [ "git" ];
          };
          source = {
            command = "git diff --name-only HEAD";
          };
          preview = {
            command = "git diff HEAD --color=always -- '{}'";
          };
        };
        git-log = {
          metadata = {
            name = "git-log";
            description = "A channel to select from git log entries";
            requirements = [ "git" ];
          };
          source = {
            command = "git log --graph --pretty=format:'%C(yellow)%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --color=always";
            output = "{strip_ansi|split: :1}";
            ansi = true;
          };
          preview = {
            command = "git show -p --stat --pretty=fuller --color=always '{strip_ansi|split: :1}' | head -n 1000";
          };
        };
        man-pages = {
          metadata = {
            name = "man-pages";
            description = "Browse and preview system manual pages";
            requirements = [
              "apropos"
              "man"
              "col"
            ];
          };
          source = {
            # List all man pages using apropos
            command = "apropos .";
          };
          preview = {
            # Show the man page for the selected entry
            command = "man '{0}' | col -bx";
            env = {
              "MANWIDTH" = "80";
            };
          };
          keybindings = {
            enter = "actions:open";
          };
          actions.open = {
            description = "Open the selected man page in the system pager";
            command = "man '{0}'";
            mode = "execute";
          };
          ui.preview_panel = {
            header = "{0}";
          };
        };
        nixpkgs = {
          metadata = {
            description = "Search nixpkgs";
            name = "nixpkgs";
            requirements = [
              "nix-search-tv"
              "sed"
            ];
          };
          preview = {
            command = "${lib.getExe config.programs.nix-search-tv.package} preview \"{}\"";
          };
          source = {
            command = "${lib.getExe config.programs.nix-search-tv.package} print nixpkgs";
          };
        };
      };
    };
  };
}
