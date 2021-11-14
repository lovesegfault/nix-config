{ pkgs, ... }: {
  # N.B. The main redshift configuration exists at the system level in
  # graphical/default.nix
  xdg.configFile."redshift/hooks/brightness.sh".source =
    let
      brightness = pkgs.writeShellApplication {
        name = "brightness.sh";

        runtimeInputs = with pkgs; [ brillo ];

        text = ''
          # Set brightness via brillo when redshift status changes

          # Set brightness values for each status.
          # Range from 1 to 100 is valid
          brightness_day=100
          brightness_transition=40
          brightness_night=5

          set_brightness() {
              brillo -e -S "$1"
          }

          if [ "$1" = period-changed ]; then
              case $3 in
                  night)
                      set_brightness $brightness_night
                      ;;
                  transition)
                      set_brightness $brightness_transition
                      ;;
                  daytime)
                      set_brightness $brightness_day
                      ;;
              esac
          fi
        '';
      };
    in
    "${brightness}/bin/brightness.sh";
}
