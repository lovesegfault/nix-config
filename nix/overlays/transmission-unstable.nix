final: prev: {
  transmission_4 = prev.transmission_4.overrideAttrs (old: {
    version = "unstable-2024-11-12";

    src = final.fetchFromGitHub {
      owner = "transmission";
      repo = "transmission";
      rev = "7e4b4f10a1f90885c0bebb168eedffe153f1cf53";
      hash = "sha256-yk3alFUU3kO9FgBIZIYmHQ2MsECzQ2IsJO2ROX6/X/o=";
      fetchSubmodules = true;
    };

    patches = [ ];

    buildInputs = (old.buildInputs or [ ]) ++ [
      final.rapidjson
    ];

    postPatch = ''
      # Clean third-party libraries to ensure system ones are used.
      # Excluding gtest since it is hardcoded to vendored version. The rest of the listed libraries are not packaged.
      pushd third-party
      for f in *; do
          if [[ ! $f =~ googletest|wildmat|fast_float|wide-integer|jsonsl|small ]]; then
              rm -r "$f"
          fi
      done
      popd
      rm \
        cmake/FindFmt.cmake \
        cmake/FindUtfCpp.cmake \
        cmake/FindRapidJSON.cmake
      # Upstream uses different config file name.
      substituteInPlace CMakeLists.txt --replace 'find_package(UtfCpp)' 'find_package(utf8cpp)'

      # Use gettext even on Darwin
      substituteInPlace libtransmission/utils.h \
        --replace-fail '#if defined(HAVE_GETTEXT) && !defined(__APPLE__)' '#if defined(HAVE_GETTEXT)'
    '';

    postInstall =
      let
        apparmorRules = with final; apparmorRulesFromClosure { name = "transmission-daemon"; } ([
          curl
          libdeflate
          libevent
          libnatpmp
          libpsl
          miniupnpc
          openssl
          pcre
          zlib
        ]
        ++ lib.optionals true [ systemd ]
        ++ lib.optionals stdenv.hostPlatform.isLinux [ inotify-tools ]);
      in
      ''
        mkdir $apparmor
        cat >$apparmor/bin.transmission-daemon <<EOF
        include <tunables/global>
        $out/bin/transmission-daemon {
          include <abstractions/base>
          include <abstractions/nameservice>
          include <abstractions/ssl_certs>
          include "${apparmorRules}"
          r @{PROC}/sys/kernel/random/uuid,
          r @{PROC}/sys/vm/overcommit_memory,
          r @{PROC}/@{pid}/environ,
          r @{PROC}/@{pid}/mounts,
          rwk /tmp/tr_session_id_*,

          r $out/share/transmission/public_html/**,

          include <local/bin.transmission-daemon>
        }
        EOF
        install -Dm0444 -t $out/share/icons ../icons/transmission.ico
      '';


  });
}
