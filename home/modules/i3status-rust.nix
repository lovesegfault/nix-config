{ config, pkgs, ... }: {
  xdg.configFile.i3status-rust = {
    target = "i3status-rust.toml";
    text = ''
      icons = "awesome"

      [theme]
      name = "slick"

      [[block]]
      block = "sound"

      [[block]]
      block = "backlight"

      [[block]]
      block = "net"
      device = "wlp0s20f3"
      ssid = true
      ip = true
      speed_up = false
      speed_down = false
      interval = 5

      [[block]]
      block = "disk_space"
      path = "/"
      alias = "/"
      info_type = "available"
      unit = "GB"
      interval = 20
      warning = 20.0
      alert = 10.0

      [[block]]
      block = "memory"
      display_type = "memory"
      format_mem = "{Mup}%"

      [[block]]
      block = "battery"
      interval = 10

      [[block]]
      block = "cpu"
      interval = 1

      [[block]]
      block = "temperature"
      collapsed = true
      interval = 5

      [[block]]
      block = "uptime"

      [[block]]
      block = "time"
      interval = 60
      format = "%a %d/%m %R"
    '';
  };
}
