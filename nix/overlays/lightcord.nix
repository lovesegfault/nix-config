self: _: {
  lightcord = self.callPackage
    (
      { autoPatchelfHook
      , fetchzip
      , makeDesktopItem
      , stdenv
      , wrapGAppsHook
      , alsaLib
      , at-spi2-atk
      , at-spi2-core
      , atk
      , cairo
      , cups
      , dbus
      , expat
      , fontconfig
      , freetype
      , gdk-pixbuf
      , glib
      , gtk3
      , libcxx
      , libdrm
      , libnotify
      , libpulseaudio
      , libuuid
      , libX11
      , libXScrnSaver
      , libXcomposite
      , libXcursor
      , libXdamage
      , libXext
      , libXfixes
      , libXi
      , libXrandr
      , libXrender
      , libXtst
      , libxcb
      , mesa
      , nspr
      , nss
      , pango
      , systemd
      , libappindicator-gtk3
      , libdbusmenu
      , openssl
      , gcc-unwrapped
      }:
      stdenv.mkDerivation rec {
        pname = "lightcord";
        version = "0.1.5";

        src = fetchzip {
          url = "https://github.com/Lightcord/Lightcord/releases/download/${version}/lightcord-linux-x64.zip";
          sha256 = "sha256-lorjKF7RQHLt3e57CrPa4QqpztHQqsF+ijiJD5hJYTY=";
          stripRoot = false;
        };

        nativeBuildInputs = [
          alsaLib
          autoPatchelfHook
          cups
          libdrm
          libuuid
          libX11
          libXScrnSaver
          libXtst
          libxcb
          mesa.drivers
          nss
          wrapGAppsHook

          openssl
          gcc-unwrapped
        ];

        autoPatchelfIgnoreMissingDeps = true;
        dontWrapGApps = true;

        libPath = stdenv.lib.makeLibraryPath [
          libcxx
          systemd
          libpulseaudio
          stdenv.cc.cc
          alsaLib
          atk
          at-spi2-atk
          at-spi2-core
          cairo
          cups
          dbus
          expat
          fontconfig
          freetype
          gdk-pixbuf
          glib
          gtk3
          libnotify
          libX11
          libXcomposite
          libuuid
          libXcursor
          libXdamage
          libXext
          libXfixes
          libXi
          libXrandr
          libXrender
          libXtst
          nspr
          nss
          libxcb
          pango
          systemd
          libXScrnSaver
          libappindicator-gtk3
          libdbusmenu
          openssl
          gcc-unwrapped
        ];

        installPhase = ''
          mkdir -p $out/{bin,opt/lightcord,share/pixmaps}
          mv * $out/opt/lightcord
          chmod +x $out/opt/lightcord/lightcord
          patchelf --set-interpreter ${stdenv.cc.bintools.dynamicLinker} \
              $out/opt/lightcord/lightcord
          wrapProgram $out/opt/lightcord/lightcord \
              "''${gappsWrapperArgs[@]}" \
              --prefix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}/" \
              --prefix LD_LIBRARY_PATH : ${libPath}
          ln -s $out/opt/lightcord/lightcord $out/bin/
          ln -s $out/opt/lightcord/discord.png $out/share/pixmaps/${pname}.png
          ln -s "lightcord/share/applications" $out/share/
        '';

        desktopItem = makeDesktopItem {
          name = pname;
          exec = "lightcord";
          icon = pname;
          desktopName = "Lightcord";
          genericName = meta.description;
          categories = "Network;InstantMessaging;";
          mimeType = "x-scheme-handler/discord";
        };

        #passthru.updateScript = ./update-discord.sh;

        meta = with stdenv.lib; {
          description = "All-in-one cross-platform voice and text chat for gamers";
          homepage = "https://discordapp.com/";
          downloadPage = "https://discordapp.com/download";
          license = licenses.unfree;
          maintainers = with maintainers; [ ldesgoui MP2E tadeokondrak ];
          platforms = [ "x86_64-linux" ];
        };
      }
    )
    { };
}
