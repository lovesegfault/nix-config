let
  audioDefaults = {
    "application/ogg" = "org.gnome.Lollypop.desktop";
    "application/vnd.apple.mpegurl" = "org.gnome.Lollypop.desktop";
    "application/x-ogg" = "org.gnome.Lollypop.desktop";
    "application/x-ogm-audio" = "org.gnome.Lollypop.desktop";
    "application/xspf+xml" = "org.gnome.Lollypop.desktop";
    "audio/aac" = "org.gnome.Lollypop.desktop";
    "audio/ac3" = "org.gnome.Lollypop.desktop";
    "audio/flac" = "org.gnome.Lollypop.desktop";
    "audio/m4a" = "org.gnome.Lollypop.desktop";
    "audio/mp3" = "org.gnome.Lollypop.desktop";
    "audio/mp4" = "org.gnome.Lollypop.desktop";
    "audio/mpeg" = "org.gnome.Lollypop.desktop";
    "audio/mpegurl" = "org.gnome.Lollypop.desktop";
    "audio/ogg" = "org.gnome.Lollypop.desktop";
    "audio/vnd.rn-realaudio" = "org.gnome.Lollypop.desktop";
    "audio/vorbis" = "org.gnome.Lollypop.desktop";
    "audio/x-aac" = "org.gnome.Lollypop.desktop";
    "audio/x-flac" = "org.gnome.Lollypop.desktop";
    "audio/x-m4a" = "org.gnome.Lollypop.desktop";
    "audio/x-mp3" = "org.gnome.Lollypop.desktop";
    "audio/x-mpeg" = "org.gnome.Lollypop.desktop";
    "audio/x-mpegurl" = "org.gnome.Lollypop.desktop";
    "audio/x-ms-wma" = "org.gnome.Lollypop.desktop";
    "audio/x-musepack" = "org.gnome.Lollypop.desktop";
    "audio/x-oggflac" = "org.gnome.Lollypop.desktop";
    "audio/x-opus+ogg" = "org.gnome.Lollypop.desktop";
    "audio/x-pn-realaudio" = "org.gnome.Lollypop.desktop";
    "audio/x-scpls" = "org.gnome.Lollypop.desktop";
    "audio/x-speex" = "org.gnome.Lollypop.desktop";
    "audio/x-vorbis" = "org.gnome.Lollypop.desktop";
    "audio/x-vorbis+ogg" = "org.gnome.Lollypop.desktop";
    "audio/x-wav" = "org.gnome.Lollypop.desktop";
    "x-content/audio-player" = "org.gnome.Lollypop.desktop";
  };
  chatDefaults = {
    "x-scheme-handler/mailto" = "thunderbird.desktop";
    "message/rfc822" = "thunderbird.desktop";
  };
  documentDefaults = {
    "application/vnd.comicbook-rar" = "org.gnome.Evince.desktop";
    "application/vnd.comicbook+zip" = "org.gnome.Evince.desktop";
    "application/x-cb7" = "org.gnome.Evince.desktop";
    "application/x-cbr" = "org.gnome.Evince.desktop";
    "application/x-cbt" = "org.gnome.Evince.desktop";
    "application/x-cbz" = "org.gnome.Evince.desktop";
    "application/x-ext-cb7" = "org.gnome.Evince.desktop";
    "application/x-ext-cbr" = "org.gnome.Evince.desktop";
    "application/x-ext-cbt" = "org.gnome.Evince.desktop";
    "application/x-ext-cbz" = "org.gnome.Evince.desktop";
    "application/x-ext-djv" = "org.gnome.Evince.desktop";
    "application/x-ext-djvu" = "org.gnome.Evince.desktop";
    "image/vnd.djvu+multipage" = "org.gnome.Evince.desktop";
    "application/x-bzdvi" = "org.gnome.Evince.desktop";
    "application/x-dvi" = "org.gnome.Evince.desktop";
    "application/x-ext-dvi" = "org.gnome.Evince.desktop";
    "application/x-gzdvi" = "org.gnome.Evince.desktop";
    "application/pdf" = "org.gnome.Evince.desktop";
    "application/x-bzpdf" = "org.gnome.Evince.desktop";
    "application/x-ext-pdf" = "org.gnome.Evince.desktop";
    "application/x-gzpdf" = "org.gnome.Evince.desktop";
    "application/x-xzpdf" = "org.gnome.Evince.desktop";
    "application/postscript" = "org.gnome.Evince.desktop";
    "application/x-bzpostscript" = "org.gnome.Evince.desktop";
    "application/x-gzpostscript" = "org.gnome.Evince.desktop";
    "application/x-ext-eps" = "org.gnome.Evince.desktop";
    "application/x-ext-ps" = "org.gnome.Evince.desktop";
    "image/x-bzeps" = "org.gnome.Evince.desktop";
    "image/x-eps" = "org.gnome.Evince.desktop";
    "image/x-gzeps" = "org.gnome.Evince.desktop";
    "image/tiff" = "org.gnome.Evince.desktop";
    "application/oxps" = "org.gnome.Evince.desktop";
    "application/vnd.ms-xpsdocument" = "org.gnome.Evince.desktop";
    "application/illustrator" = "org.gnome.Evince.desktop";
  };
  otherDefaults = {
    "x-scheme-handler/prusaslicer" = "PrusaSlicerURLProtocol.desktop";
  };
in
{
  xdg.mimeApps.defaultApplications =
    audioDefaults // chatDefaults // documentDefaults // otherDefaults;
}
