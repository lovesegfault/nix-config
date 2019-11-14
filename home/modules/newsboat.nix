{ config, pkgs, ... }: {
  programs.newsboat = {
    enable = true;
    autoReload = true;
    browser = "${pkgs.firefox}/bin/firefox";
    extraConfig = ''
      color background          color236   default
      color listnormal          color248   default
      color listnormal_unread   color6     default
      color listfocus           color236   color12
      color listfocus_unread    color15    color12
      color info                color248   color236
      color article             color248   default
      highlight article "^(Feed|Link):.*$" color6 default bold
      highlight article "^(Title|Date|Author):.*$" color6 default bold
      highlight article "https?://[^ ]+" color10 default underline
      highlight article "\\[[0-9]+\\]" color10 default bold
      highlight article "\\[image\\ [0-9]+\\]" color10 default bold
      highlight feedlist "^─.*$" color6 color236 bold
    '';
    reloadThreads = 12;
    reloadTime = 15;
    urls = [
      { url = ''"query:News:tags # \"news\""''; }
      { url = ''"query:Comics:tags # \"comics\""''; }
      { url = ''"query:Gentoo:tags # \"gentoo\""''; }
      { url = ''"query:Releases:tags # \"releases\""''; }
      {
        url = "---";
        tags = [ ];
      }
      {
        url = "https://news.ycombinator.com/rss";
        title = "Hacker News";
        tags = [ "news" ];
      }
      {
        url = "https://lwn.net/headlines/newrss";
        title = "LWN";
        tags = [ "news" ];
      }
      {
        url = "http://n-gate.com/index.rss";
        title = "n-gate";
        tags = [ "news" ];
      }
      {
        url = "https://www.phoronix.com/phoronix-rss.php";
        title = "Phoronix";
        tags = [ "news" ];
      }
      {
        url = "https://www.quantamagazine.org/feed";
        title = "Quanta Magazine";
        tags = [ "news" ];
      }
      {
        url = "https://stallman.org/rss/rss.xml";
        title = "Richard Stallman's Political Notes";
        tags = [ "news" ];
      }
      {
        url = "https://rss.nytimes.com/services/xml/rss/nyt/HomePage.xml";
        title = "The New York Times";
        tags = [ "news" ];
      }
      {
        url = "---";
        tags = [ ];
      }
      {
        url = "https://www.smbc-comics.com/rss.php";
        title = "Saturday Morning Breakfast Cereal";
        tags = [ "comics" ];
      }
      {
        url = "https://xkcd.com/rss.xml";
        title = "XKCD";
        tags = [ "comics" ];
      }
      {
        url = "---";
        tags = [ ];
      }
      {
        url =
          "https://bugs.gentoo.org/buglist.cgi?email1=bernardo%40standard.ai&emailreporter1=1&emailtype1=substring&list_id=4339928&query_format=advanced&resolution=---&title=Bug%20List&ctype=atom";
        title = "Gentoo Reported";
        tags = [ "gentoo" ];
      }
      {
        url =
          "https://bugs.gentoo.org/buglist.cgi?email1=bernardo%40standard.ai&emailassigned_to1=1&emailtype1=substring&list_id=4339930&query_format=advanced&resolution=---&title=Bug%20List&ctype=atom";
        title = "Gentoo Assigned";
        tags = [ "gentoo" ];
      }
      {
        url = "---";
        tags = [ ];
      }
      {
        url = "https://github.com/neovim/neovim/releases.atom";
        title = "neovim";
        tags = [ "releases" ];
      }
      {
        url = "https://github.com/elementary/granite/releases.atom";
        title = "granite";
        tags = [ "releases" ];
      }
      {
        url = "http://feeds.launchpad.net/libvterm/revisions.atom";
        title = "libvterm";
        tags = [ "releases" ];
      }
      {
        url = "https://github.com/luvit/luv/releases.atom";
        title = "luv";
        tags = [ "releases" ];
      }
      {
        url = "https://github.com/beetbox/confuse/releases.atom";
        title = "confuse";
        tags = [ "releases" ];
      }
      {
        url = "https://github.com/beetbox/mediafile/releases.atom";
        title = "mediafile";
        tags = [ "releases" ];
      }
      {
        url =
          "https://github.com/sphinx-contrib/sphinx-pretty-searchresults/releases.atom";
        title = "sphinx-pretty-searchresults";
        tags = [ "releases" ];
      }
      {
        url = "https://github.com/emersion/grim/releases.atom";
        title = "grim";
        tags = [ "releases" ];
      }
      {
        url = "https://github.com/emersion/slurp/releases.atom";
        title = "slurp";
        tags = [ "releases" ];
      }
      {
        url = "https://github.com/Alexays/Waybar/releases.atom";
        title = "waybar";
        tags = [ "releases" ];
      }
      {
        url = "https://github.com/FortAwesome/Font-Awesome/releases.atom";
        title = "font-awesome";
        tags = [ "releases" ];
      }
      {
        url = "https://gitlab.gnome.org/GNOME/gexiv2/-/tags?format=atom";
        title = "gexiv2";
        tags = [ "releases" ];
      }
      {
        url = "https://github.com/beetbox/beets/releases.atom";
        title = "beets";
        tags = [ "releases" ];
      }
      {
        url = "https://github.com/AravisProject/aravis/releases.atom";
        title = "aravis";
        tags = [ "releases" ];
      }
    ];
  };
}
