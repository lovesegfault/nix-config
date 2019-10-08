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
    queries = {
      news = ''tags # "news"'';
      comics = ''tags # "comics"'';
      gentoo = ''tags # "gentoo"'';
      releases = ''tags # "releases"'';
    };
    reloadThreads = 12;
    reloadTime = 15;
    urls = [
      {
        url = "https://news.ycombinator.com/rss";
        tags = [ "~Hacker News" "news" ];
      }
      {
        url = "https://lwn.net/headlines/newrss";
        tags = [ "~LWN" "news" ];
      }
      {
        url = "http://n-gate.com/index.rss";
        tags = [ "~n-gate" "news" ];
      }
      {
        url = "https://www.phoronix.com/phoronix-rss.php";
        tags = [ "~Phoronix" "news" ];
      }
      {
        url = "https://www.quantamagazine.org/feed";
        tags = [ "~Quanta Magazine" "news" ];
      }
      {
        url = "https://stallman.org/rss/rss.xml";
        tags = [ "~Richard Stallman's Political Notes" "news" ];
      }
      {
        url = "https://rss.nytimes.com/services/xml/rss/nyt/HomePage.xml";
        tags = [ "~The New York Times" "news" ];
      }
      {
        url = "---";
        tags = [ ];
      }
      {
        url = "https://www.smbc-comics.com/rss.php";
        tags = [ "~Saturday Morning Breakfast Cereal" "comics" ];
      }
      {
        url = "https://xkcd.com/rss.xml";
        tags = [ "~XKCD" "comics" ];
      }
      {
        url = "---";
        tags = [ ];
      }
      {
        url =
          "https://bugs.gentoo.org/buglist.cgi?email1=bernardo%40standard.ai&emailreporter1=1&emailtype1=substring&list_id=4339928&query_format=advanced&resolution=---&title=Bug%20List&ctype=atom";
        tags = [ "~Gentoo Reported" "gentoo" ];
      }
      {
        url =
          "https://bugs.gentoo.org/buglist.cgi?email1=bernardo%40standard.ai&emailassigned_to1=1&emailtype1=substring&list_id=4339930&query_format=advanced&resolution=---&title=Bug%20List&ctype=atom";
        tags = [ "~Gentoo Assigned" "gentoo" ];
      }
      {
        url = "---";
        tags = [ ];
      }
      {
        url = "https://github.com/neovim/neovim/releases.atom";
        tags = [ "~neovim" "releases" ];
      }
      {
        url = "https://github.com/elementary/granite/releases.atom";
        tags = [ "~granite" "releases" ];
      }
      {
        url = "http://feeds.launchpad.net/libvterm/revisions.atom";
        tags = [ "~libvterm" "releases" ];
      }
      {
        url = "https://github.com/luvit/luv/releases.atom";
        tags = [ "~luv" "releases" ];
      }
      {
        url = "https://github.com/beetbox/confuse/releases.atom";
        tags = [ "~confuse" "releases" ];
      }
      {
        url = "https://github.com/beetbox/mediafile/releases.atom";
        tags = [ "~mediafile" "releases" ];
      }
      {
        url =
          "https://github.com/sphinx-contrib/sphinx-pretty-searchresults/releases.atom";
        tags = [ "~sphinx-pretty-searchresults" "releases" ];
      }
      {
        url = "https://github.com/emersion/grim/releases.atom";
        tags = [ "~grim" "releases" ];
      }
      {
        url = "https://github.com/emersion/slurp/releases.atom";
        tags = [ "~slurp" "releases" ];
      }
      {
        url = "https://github.com/Alexays/Waybar/releases.atom";
        tags = [ "~waybar" "releases" ];
      }
      {
        url = "https://github.com/FortAwesome/Font-Awesome/releases.atom";
        tags = [ "~font-awesome" "releases" ];
      }
      {
        url = "https://gitlab.gnome.org/GNOME/gexiv2/-/tags?format=atom";
        tags = [ "~gexiv2" "releases" ];
      }
      {
        url = "https://github.com/beetbox/beets/releases.atom";
        tags = [ "~beets" "releases" ];
      }
      {
        url = "https://github.com/AravisProject/aravis/releases.atom";
        tags = [ "~aravis" "releases" ];
      }
      {
        url = "---";
        tags = [ ];
      }
    ];
  };
}
