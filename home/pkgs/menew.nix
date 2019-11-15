{ config, pkgs, ... }:
let
  alacritty = "${pkgs.alacritty}/bin/alacritty";
  fzf = "${pkgs.fzf}/bin/fzf";
  swaymsg = "${pkgs.sway}/bin/swaymsg";
in
{
  nixpkgs.overlays = [
    (self: super: {
      menew = super.writeScriptBin "menew" ''
        #!${super.stdenv.shell}

        set -o errexit
        set -o nounset
        set -o pipefail

        function parse_exec() {
          # Define the search pattern that specifies the block to search for within the .desktop file
          PATTERN="^\\\\[Desktop Entry\\\\]"
          # 1. We see a line starting [Desktop, but we're already searching: deactivate search again
          # 2. We see the specified pattern: start search
          # 3. We see an Exec= line during search: remove field codes and set variable
          # 3. We see a Path= line during search: set variable
          # 4. Finally, build command line
          awk -v pattern="''${PATTERN}" -v terminal_command="${alacritty}" -F= '
            BEGIN{a=0;exec=0;path=0}
               /^\[Desktop/{
                if(a){
                  a=0
                }
               }
              $0 ~ pattern{
               a=1
              }
              /^Terminal=/{
                sub("^Terminal=", "");
                if ($0 == "true") {
                  terminal=1
                }
              }
              /^Exec=/{
                if(a && !exec){
                  sub("^Exec=", "");
                  gsub(" ?%[cDdFfikmNnUuv]", "");
                  exec=$0;
                }
              }
              /^Path=/{
                if(a && !path){
                  path=$2
                }
               }

            END{
              if(path){
                printf "cd " path " && "
              }
              if (terminal){
                printf terminal_command " "
              }
              print exec
            }' "$1"
        }


        dir="${config.home.homeDirectory}/.nix-profile/share/applications"
        apps="$(find "$dir" -name "*.desktop" | rev | cut -f 1 -d / | cut -f 2- -d . | rev)"
        selected="$(echo "$apps" | ${fzf})"
        [ -z "$selected" ] && exit 1

        path="$dir/$selected.desktop"
        [ -f "$path" ] || exit 1

        cmd="$(parse_exec "$path")"
        [ -z "$cmd" ] && exit 1

        ${swaymsg} -t command exec "$cmd"
      '';
    })
  ];
}
