{ stdenv
, fetchFromGitHub
, writeScript
, glibcLocales
, diffPlugins
, python3Packages
, imagemagick
, gobject-introspection
, gst_all_1
, runtimeShell

  # Attributes needed for tests of the external plugins
, beets

, enableAbsubmit ? stdenv.lib.elem stdenv.hostPlatform.system essentia-extractor.meta.platforms
, essentia-extractor ? null
, enableAcousticbrainz ? true
, enableAcoustid ? true
, enableBadfiles ? true
, flac ? null
, mp3val ? null
, enableConvert ? true
, ffmpeg_3 ? null
, enableDiscogs ? true
, enableEmbyupdate ? true
, enableFetchart ? true
, enableGmusic ? true
, enableKeyfinder ? true
, keyfinder-cli ? null
, enableKodiupdate ? true
, enableLastfm ? true
, enableLoadext ? true
, enableMpd ? true
, enablePlaylist ? true
, enableReplaygain ? true
, bs1770gain ? null
, enableSonosUpdate ? true
, enableSubsonicupdate ? true
, enableThumbnails ? true
, enableWeb ? true

, bashInteractive
, bash-completion
}:

assert enableAbsubmit -> essentia-extractor != null;
assert enableAcoustid -> python3Packages.pyacoustid != null;
assert enableBadfiles -> flac != null && mp3val != null;
assert enableConvert -> ffmpeg_3 != null;
assert enableDiscogs -> python3Packages.discogs_client != null;
assert enableFetchart -> python3Packages.responses != null;
assert enableGmusic -> python3Packages.gmusicapi != null;
assert enableKeyfinder -> keyfinder-cli != null;
assert enableLastfm -> python3Packages.pylast != null;
assert enableMpd -> python3Packages.mpd2 != null;
assert enableReplaygain -> bs1770gain != null;
assert enableSonosUpdate -> python3Packages.soco != null;
assert enableThumbnails -> python3Packages.pyxdg != null;
assert enableWeb -> python3Packages.flask != null;

with stdenv.lib;
let
  optionalPlugins = {
    absubmit = enableAbsubmit;
    acousticbrainz = enableAcousticbrainz;
    badfiles = enableBadfiles;
    chroma = enableAcoustid;
    convert = enableConvert;
    discogs = enableDiscogs;
    embyupdate = enableEmbyupdate;
    fetchart = enableFetchart;
    gmusic = enableGmusic;
    keyfinder = enableKeyfinder;
    kodiupdate = enableKodiupdate;
    lastgenre = enableLastfm;
    lastimport = enableLastfm;
    loadext = enableLoadext;
    mpdstats = enableMpd;
    mpdupdate = enableMpd;
    playlist = enablePlaylist;
    replaygain = enableReplaygain;
    sonosupdate = enableSonosUpdate;
    subsonicupdate = enableSubsonicupdate;
    thumbnails = enableThumbnails;
    web = enableWeb;
  };

  pluginsWithoutDeps = [
    "beatport"
    "bench"
    "bpd"
    "bpm"
    "bucket"
    "cue"
    "duplicates"
    "edit"
    "embedart"
    "export"
    "filefilter"
    "freedesktop"
    "fromfilename"
    "ftintitle"
    "fuzzy"
    "hook"
    "ihate"
    "importadded"
    "importfeeds"
    "info"
    "inline"
    "ipfs"
    "lyrics"
    "mbcollection"
    "mbsubmit"
    "mbsync"
    "metasync"
    "missing"
    "permissions"
    "play"
    "plexupdate"
    "random"
    "rewrite"
    "scrub"
    "smartplaylist"
    "spotify"
    "the"
    "types"
    "zero"
  ];

  enabledOptionalPlugins = attrNames (filterAttrs (_: id) optionalPlugins);

  allPlugins = pluginsWithoutDeps ++ attrNames optionalPlugins;
  allEnabledPlugins = pluginsWithoutDeps ++ enabledOptionalPlugins;

  testShell = "${bashInteractive}/bin/bash --norc";
  completion = "${bash-completion}/share/bash-completion/bash_completion";

  # This is a stripped down beets for testing of the external plugins.
  externalTestArgs.beets = (beets.override {
    enableAlternatives = false;
    enableCopyArtifacts = false;
    enableExtraFiles = false;
  }).overrideAttrs (stdenv.lib.const {
    doInstallCheck = false;
  });

in
python3Packages.buildPythonApplication rec {
  pname = "beets-unstable";
  version = "2020-12-22";

  src = fetchFromGitHub {
    owner = "beetbox";
    repo = "beets";
    rev = "53dcb24d10788897f20c341774b474808ec2c0b6";
    sha256 = "sha256-P++NA13T2TRHW3Se10np8BSe/WRBYAKRte5xKoHKW50=";
  };

  propagatedBuildInputs = [
    python3Packages.confuse
    python3Packages.six
    python3Packages.enum34
    python3Packages.jellyfish
    python3Packages.mediafile
    python3Packages.munkres
    python3Packages.musicbrainzngs
    python3Packages.mutagen
    python3Packages.pyyaml
    python3Packages.unidecode
    python3Packages.gst-python
    python3Packages.pygobject3
    gobject-introspection
  ] ++ optional enableAbsubmit essentia-extractor
  ++ optional enableAcoustid python3Packages.pyacoustid
  ++ optional
    (enableFetchart
      || enableEmbyupdate
      || enableKodiupdate
      || enableLoadext
      || enablePlaylist
      || enableSubsonicupdate
      || enableAcousticbrainz)
    python3Packages.requests
  ++ optional enableConvert ffmpeg_3
  ++ optional enableDiscogs python3Packages.discogs_client
  ++ optional enableGmusic python3Packages.gmusicapi
  ++ optional enableKeyfinder keyfinder-cli
  ++ optional enableLastfm python3Packages.pylast
  ++ optional enableMpd python3Packages.mpd2
  ++ optional enableSonosUpdate python3Packages.soco
  ++ optional enableThumbnails python3Packages.pyxdg
  ++ optional enableWeb python3Packages.flask
  ;

  buildInputs = [
    imagemagick
  ] ++ (with gst_all_1; [
    gst-plugins-base
    gst-plugins-good
    gst-plugins-ugly
  ]);

  checkInputs = with python3Packages; [
    beautifulsoup4
    mock
    nose
    rarfile
    responses
    # Although considered as plugin dependencies, they are needed for the
    # tests, for disabling them via an override makes the build fail. see:
    # https://github.com/beetbox/beets/blob/master/setup.py
    pylast
    mpd2
    discogs_client
    pyxdg
  ];

  patches = [
    ./replaygain-default-bs1770gain.patch
    ./keyfinder-default-bin.patch
  ];

  postPatch = ''
    sed -i -e '/assertIn.*item.*path/d' test/test_info.py
    echo echo completion tests passed > test/rsrc/test_completion.sh

    sed -i -e '/^BASH_COMPLETION_PATHS *=/,/^])$/ {
      /^])$/i u"${completion}"
    }' beets/ui/commands.py
  '' + optionalString enableBadfiles ''
    sed -i -e '/self\.run_command(\[/ {
      s,"flac","${flac.bin}/bin/flac",
      s,"mp3val","${mp3val}/bin/mp3val",
    }' beetsplug/badfiles.py
  '' + optionalString enableConvert ''
    sed -i -e 's,\(util\.command_output(\)\([^)]\+\)),\1[b"${ffmpeg_3.bin}/bin/ffmpeg" if args[0] == b"ffmpeg" else args[0]] + \2[1:]),' beetsplug/convert.py
  '' + optionalString enableReplaygain ''
    sed -i -re '
      s!^( *cmd *= *b?['\'''"])(bs1770gain['\'''"])!\1${bs1770gain}/bin/\2!
    ' beetsplug/replaygain.py
    sed -i -e 's/if has_program.*bs1770gain.*:/if True:/' \
      test/test_replaygain.py
  '';

  postInstall = ''
    mkdir -p $out/share/zsh/site-functions
    cp extra/_beet $out/share/zsh/site-functions/
  '';

  doCheck = true;

  preCheck = ''
    find beetsplug -mindepth 1 \
      \! -path 'beetsplug/__init__.py' -a \
      \( -name '*.py' -o -path 'beetsplug/*/__init__.py' \) -print \
      | sed -n -re 's|^beetsplug/([^/.]+).*|\1|p' \
      | sort -u > plugins_available

     ${diffPlugins allPlugins "plugins_available"}
  '';

  checkPhase = ''
    runHook preCheck

    LANG=en_US.UTF-8 \
    LOCALE_ARCHIVE=${assert stdenv.isLinux; glibcLocales}/lib/locale/locale-archive \
    BEETS_TEST_SHELL="${testShell}" \
    BASH_COMPLETION_SCRIPT="${completion}" \
    HOME="$(mktemp -d)" nosetests -v

    runHook postCheck
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck

    tmphome="$(mktemp -d)"

    EDITOR="${writeScript "beetconfig.sh" ''
      #!${runtimeShell}
      cat > "$1" <<CFG
      plugins: ${concatStringsSep " " allEnabledPlugins}
      CFG
    ''}" HOME="$tmphome" "$out/bin/beet" config -e
    EDITOR=true HOME="$tmphome" "$out/bin/beet" config -e

    runHook postInstallCheck
  '';

  makeWrapperArgs = [ "--set GI_TYPELIB_PATH \"$GI_TYPELIB_PATH\"" "--set GST_PLUGIN_SYSTEM_PATH_1_0 \"$GST_PLUGIN_SYSTEM_PATH_1_0\"" ];

  meta = {
    description = "Music tagger and library organizer";
    homepage = "http://beets.io";
    license = licenses.mit;
    maintainers = with maintainers; [ aszlig domenkozar pjones ];
    platforms = platforms.linux;
  };
}
