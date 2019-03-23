{ config, pkgs, ... }:

{
  programs.beets = {
    enable = true;
    settings = {
      art_filename = "cover";
      asciify_paths = "no";
      clutter = [ "Thumbs.DB" ".DS_Store" ];
      directory = "${config.home.homeDirectory}/music";
      format_album = "$albumartist - $album";
      format_item = "$artist - $album - $title";
      format_raw_length = "no";
      id3v23 = "no";
      ignore = [ ".*" "*~" "System Volume Information" "lost+found" ];
      ignore_hidden = "yes";
      library = "${config.programs.beets.settings.directory}/library.db";
      max_filename_length = 0;
      original_date = "yes";
      path_sep_replace = "_";
      per_disc_numbering = "yes";
      pluginpath = [];
      sort_album = "albumartist+ album+";
      sort_case_insensitive = "yes";
      sort_item = "artist+ album+ disc+ track+";
      statefile = "state.pickle";
      threaded = "yes";
      time_format = "%Y-%m-%d %H:%M:%S";
      timeout = 5.0;
      va_name = "Various Artists";
      verbose = 0;

      plugins = [
       "absubmit"
       "acousticbrainz"
       "badfiles"
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
       "thumbnails"
       "web"
      ];

      absubmit = {
        # FIXME: Write formula for essentia
        auto = "yes";
        extractor = "";
      };

      acoustid = { apikey = "***REMOVED***"; };

      embedart = { auto = "yes"; };

      fetchart = {
        auto= "yes";
        cautious = "no";
        enforce_ratio = "10%";
        fanarttv_key = "***REMOVED***";
        google_key = "***REMOVED***";
        maxwidth = 2000;
        minwidth = 900;
        sources = "filesystem fanarttv *";
      };

      "import" = {
        autotag = "yes";
        bell = "yes";
        copy = "yes";
        default_action = "apply";
        delete = "no";
        detail = "yes";
        duplicate_action = "ask";
        flat = "no";
        from_scratch = "yes";
        group_albums = "no";
        hardlink = "no";
        incremental = "yes";
        languages = [ "en" ];
        link = "no";
        log = "${config.xdg.dataHome}/beets/beets.log";
        move = "yes";
        none_rec_action = "ask";
        pretend = "no";
        quiet = "no";
        quiet_fallback = "skip";
        resume = "ask";
        search_ids = [];
        set_fields = {};
        singletons = "no";
        timid = "yes";
        write = "yes";
      };

      lastgenre = {
        auto = "yes";
        canonical = "yes";
        fallback = "";
      };

      lyrics = {
        auto = "yes";
        fallback = "";
        google_API_key = "***REMOVED***";
      };

      match = {
        ignored = [];
        medium_rec_thresh = 0.25;
        rec_gap_thresh = 0.25;
        required = [];
        strong_rec_thresh = 0.04;
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
          countries = ["US" "GB|UK"];
          media = [ "Digital Media|File" "CD" ];
          original_year = "yes";
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
        "[<>:\"\\?\\*\\|]"= "_";
        "\\.$" = "_";
        "\\s+$" = "";
        "^\\s+" = "";
        "^-" = "_";
      };

      ui = {
        color = "yes";
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
  };
}
