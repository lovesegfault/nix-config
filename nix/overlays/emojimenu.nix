let
  emojimenu =
    { fetchurl
    , jq
    , runCommand
    , wl-clipboard
    , writeSaneShellScriptBin

    , cmd
    , extraInputs ? [ ]
    }:
    let
      emoji_json = fetchurl {
        name = "emojis.json";
        url = "https://raw.githubusercontent.com/github/gemoji/b1c7878afeb260d2ff6dc6655bf3aa7dee498e9c/db/emoji.json";
        sha256 = "sha256-bL+4ft3yzVUnVxDg7cwoS2hvbeqEKvhx77QjEgR+Yhk=";
      };
      emojis = runCommand "emojis.txt"
        { nativeBuildInputs = [ jq ]; } ''
        cat ${emoji_json} | jq -r '.[] | "\(.emoji) \t   \(.description)"' | sed -e 's,\\t,\t,g' > $out
      '';
    in
    writeSaneShellScriptBin {
      name = "emojimenu";

      buildInputs = [ wl-clipboard ] ++ extraInputs;

      src = ''
        emoji="$(${cmd} < ${emojis} | cut -f1 -d" ")"

        wl-copy -n <<< "$emoji"
      '';
    };
in
self: _: {
  emojimenu-wayland = self.callPackage emojimenu {
    cmd = ''wofi --show dmenu --cache-file="$XDG_CACHE_HOME/wofi/emojimenu" -d "allow_markup=false"'';
    extraInputs = [ self.wofi ];
  };

  emojimenu-x11 = self.callPackage emojimenu {
    cmd = ''rofi -cache-dir "$XDG_CACHE_HOME/rofi/emojimenu" -dmenu'';
    extraInputs = [ self.rofi ];
  };
}
