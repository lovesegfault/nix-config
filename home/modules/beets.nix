{ config, lib, pkgs, ... }:
let
  secret = ../../share/secrets/home/beets.nix;
  secret_settings =
    lib.optionalAttrs (builtins.pathExists secret) (import secret);
  normal_settings = rec {
    art_filename = "cover";
    asciify_paths = false;
    clutter = [ "Thumbs.DB" ".DS_Store" ];
    directory = "/srv/music";
    format_album = "$albumartist - $album";
    format_item = "$artist - $album - $title";
    format_raw_length = false;
    id3v23 = false;
    ignore = [ ".*" "*~" "System Volume Information" "lost+found" ];
    ignore_hidden = true;
    library = "${directory}/library.db";
    max_filename_length = 0;
    original_date = true;
    path_sep_replace = "_";
    per_disc_numbering = true;
    pluginpath = [ ];
    sort_album = "albumartist+ album+";
    sort_case_insensitive = true;
    sort_item = "artist+ album+ disc+ track+";
    statefile = "state.pickle";
    threaded = true;
    time_format = "%Y-%m-%d %H:%M:%S";
    timeout = 5.0;
    va_name = "Various Artists";
    verbose = 0;

    plugins = [
      "absubmit"
      "acousticbrainz"
      "badfiles"
      "check"
      "chroma"
      "edit"
      "embedart"
      "fetchart"
      "fromfilename"
      "info"
      "lastgenre"
      "lyrics"
      "mbsync"
      "missing"
      "scrub"
    ];

    absubmit = {
      auto = true;
      extractor = "${pkgs.essentia-extractor}/bin/streaming_extractor_music";
    };

    acoustid.apikey = "";

    embedart = { auto = true; };

    fetchart = {
      auto = true;
      cautious = false;
      enforce_ratio = "10%";
      fanarttv_key = "";
      google_key = "";
      maxwidth = 2000;
      minwidth = 900;
      sources = "filesystem fanarttv *";
    };

    "import" = {
      autotag = true;
      bell = true;
      copy = true;
      default_action = "apply";
      delete = false;
      detail = true;
      duplicate_action = "ask";
      flat = false;
      from_scratch = true;
      group_albums = false;
      hardlink = false;
      incremental = true;
      languages = [ "en" ];
      link = false;
      log = "${config.xdg.dataHome}/beets.log";
      move = true;
      none_rec_action = "ask";
      pretend = false;
      quiet = false;
      quiet_fallback = "skip";
      resume = "ask";
      search_ids = [ ];
      set_fields = { };
      singletons = false;
      timid = true;
      write = true;
    };

    lastgenre = {
      auto = true;
      canonical = true;
      fallback = "";
    };

    lyrics = {
      auto = true;
      fallback = "";
      google_API_key = "";
    };

    match = {
      ignored = [ ];
      medium_rec_thresh = 0.25;
      rec_gap_thresh = 0.25;
      required = [ ];
      strong_rec_thresh = 4.0e-2;
      track_length_grace = 10;
      track_length_max = 30;
      distance_weights = {
        album = 3.0;
        album_id = 5.0;
        albumdisambig = 0.5;
        artist = 3.0;
        catalognum = 0.5;
        country = 0.5;
        label = 0.5;
        media = 1.0;
        mediums = 1.0;
        missing_tracks = 0.9;
        source = 2.0;
        track_artist = 2.0;
        track_id = 5.0;
        track_index = 1.0;
        track_length = 2.0;
        track_title = 3.0;
        tracks = 2.0;
        unmatched_tracks = 0.6;
        year = 1.0;
      };

      max_rec = {
        missing_tracks = "medium";
        unmatched_tracks = "medium";
      };

      preferred = {
        countries = [ "US" "GB|UK" ];
        media = [ "Digital Media|File" "CD" ];
        original_year = true;
      };
    };

    musicbrainz = {
      host = "musicbrainz.org";
      ratelimit = 1;
      ratelimit_interval = 1.0;
      searchlimit = 5;
    };

    paths = {
      comp = "Various Artists/$album%aunique{}/$disc.$track $title";
      default = "$albumartist/$album%aunique{}/$disc.$track $title";
    };

    replace = {
      "[\\\\/]" = "_";
      "^\\." = "_";
      "[\\x00-\\x1f]" = "_";
      "[<>:\"\\?\\*\\|]" = "_";
      "\\.$" = "_";
      "\\s+$" = "";
      "^\\s+" = "";
      "^-" = "_";
    };

    ui = {
      color = true;
      length_diff_thresh = 10.0;
      terminal_width = 120;

      colors = {
        action = "blue";
        action_default = "turquoise";
        text_error = "red";
        text_highlight = "red";
        text_highlight_minor = "lightgray";
        text_success = "green";
        text_warning = "yellow";
      };
    };
  };
in {
  programs.beets = {
    enable = true;
    package = (pkgs.beets.override { enableCheck = true; });
    settings = (lib.recursiveUpdate normal_settings secret_settings);
  };
}
