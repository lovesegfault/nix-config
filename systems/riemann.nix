{ lib, ... }:
{
  imports = [
    ../core
    ../core/resolved.nix

    ../hardware/rpi4.nix
    ../hardware/no-mitigations.nix

    ../users/bemeurer
  ];

  boot.loader = {
    generic-extlinux-compatible.enable = lib.mkForce false;
    raspberryPi = {
      enable = true;
      firmwareConfig = ''
        dtoverlay=vc4-fkms-v3d
      '';
      version = 4;
    };
  };

  fileSystems = lib.mkForce {
    "/boot" = {
      device = "/dev/disk/by-label/NIXOS_BOOT";
      fsType = "vfat";
    };
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
  };

  networking = {
    hostName = "riemann";
    wireless.iwd.enable = true;
  };

  systemd.network.networks = {
    lan = {
      DHCP = "yes";
      linkConfig.RequiredForOnline = "no";
      matchConfig.MACAddress = "dc:a6:32:b8:bb:aa";
    };
    wifi = {
      DHCP = "yes";
      matchConfig.MACAddress = "dc:a6:32:b8:bb:ab";
    };
  };

  time.timeZone = "America/Los_Angeles";

  networking.firewall.allowedTCPPorts = [ 5000 ];

  services.octoprint = {
    enable = true;
    plugins = plugins: with plugins; [
      bedlevelvisualizer
      displaylayerprogress
      printtimegenius
      themeify
      octoklipper
      octoprint-dashboard
    ];
    extraConfig = {
      accessControl.enabled = false;
      appearance.name = "Voron 0";
      serial = {
        port = "/run/klipper/tty";
        baudrate = "250000";
        autoconnect = true;
        disconnectOnErrors = false;
      };
      onlineCheck = {
        enabled = true;
        host = "1.1.1.1";
      };
    };
  };

  services.klipper = {
    enable = true;
    octoprintIntegration = true;
    settings = {
      mcu.serial = "/dev/serial/by-id/usb-Klipper_stm32f103xe_30FFDD055346323032890543-if00";
      "mcu displayEncoder" = {
        serial = "/dev/serial/by-id/usb-Klipper_stm32f042x6_2A001B0015434E5532373620-if00";
        restart_method = "command";
      };

      display = {
        lcd_type = "sh1106";
        i2c_mcu = "displayEncoder";
        i2c_bus = "i2c1a";
        encoder_pins = "^displayEncoder:PA4, ^displayEncoder:PA3";
        click_pin = "^!displayEncoder:PA1";
        kill_pin = "^!displayEncoder:PA5";
        vcomh = 31;
      };

      "neopixel displayStatus" = {
        pin = "displayEncoder:PA0";
        chain_count = 1;
        color_order_GRB = true;
        initial_RED = 0.2;
        initial_GREEN = 0.05;
        initial_BLUE = 0;
      };

      stepper_x = {
        dir_pin = "!PB12";
        enable_pin = "!PB14";
        step_pin = "PB13";

        endstop_pin = "PC0";
        position_endstop = 120;
        position_max = 120;

        homing_positive_dir = true;
        homing_retract_dist = 5;
        homing_speed = 70;
        second_homing_speed = 5;
        step_distance = "0.0125";
      };

      "tmc2209 stepper_x" = {
        tx_pin = "PC10";
        uart_address = 0;
        uart_pin = "PC11";

        hold_current = ".25";
        interpolate = true;
        microsteps = 16;
        run_current = ".25";
        sense_resistor = 0.110;
        stealthchop_threshold = 500;
      };

      stepper_y = {
        dir_pin = "!PB2";
        enable_pin = "!PB11";
        step_distance = "0.0125";
        step_pin = "PB10";

        endstop_pin = "PC1";
        position_endstop = 120;
        position_max = 120;

        homing_positive_dir = true;
        homing_retract_dist = 5;
        homing_speed = 70;
        second_homing_speed = 5;
      };

      "tmc2209 stepper_y" = {
        tx_pin = "PC10";
        uart_address = 2;
        uart_pin = "PC11";

        hold_current = ".25";
        interpolate = true;
        microsteps = 16;
        run_current = ".25";
        sense_resistor = 0.110;
        stealthchop_threshold = 500;
      };

      stepper_z = {
        dir_pin = "PC5";
        enable_pin = "!PB1";
        step_distance = "0.000625";
        step_pin = "PB0";

        endstop_pin = "PC2";
        position_endstop = 0;
        position_max = 120;
        position_min = -1;

        homing_positive_dir = false;
        homing_retract_dist = 3;
        homing_speed = 10;
        second_homing_speed = 3;
      };

      "tmc2209 stepper_z" = {
        tx_pin = "PC10";
        uart_address = 1;
        uart_pin = "PC11";

        hold_current = ".25";
        interpolate = true;
        microsteps = 16;
        run_current = ".25";
        sense_resistor = 0.110;
        stealthchop_threshold = 500;
      };

      extruder = {
        dir_pin = "!PB4";
        enable_pin = "!PD2";
        step_distance = "0.0024";
        step_pin = "PB3";

        filament_diameter = "1.750";
        nozzle_diameter = "0.400";

        control = "pid";
        heater_pin = "PC8";
        pid_Kd = 114;
        pid_Ki = "1.08";
        pid_Kp = "22.2";
        sensor_pin = "PA0";
        sensor_type = "SliceEngineering 450";

        max_extrude_cross_section = ".8";
        max_extrude_only_distance = 780;
        max_temp = 270;
        min_extrude_temp = 170;
        min_temp = 0;
        pressure_advance = "0.0";
        pressure_advance_smooth_time = 0.040;
      };

      "tmc2209 extruder" = {
        tx_pin = "PC10";
        uart_address = 3;
        uart_pin = "PC11";

        hold_current = "0.2";
        interpolate = true;
        microsteps = 16;
        run_current = "0.2";
        sense_resistor = "0.110";
        stealthchop_threshold = 500;
      };

      heater_bed = {
        heater_pin = "PC9";
        max_power = "1.0";
        max_temp = 120;
        min_temp = 0;

        sensor_pin = "PC3";
        sensor_type = "NTC 100K beta 3950";

        control = "pid";
        pid_kd = "363.769";
        pid_ki = "2.347";
        pid_kp = "58.437";
        smooth_time = "3.0";
      };

      printer = {
        kinematics = "corexy";
        max_accel = 2000;
        max_velocity = 250;
        max_z_accel = 30;
        max_z_velocity = 10;
        square_corner_velocity = "5.0";
      };

      "heater_fan hotend_fan" = {
        heater = "extruder";
        heater_temp = "50.0";
        kick_start_time = "0.5";
        max_power = "1.0";
        pin = "PA8";
        fan_speed = "1.0";
      };

      fan = {
        cycle_time = "0.010";
        kick_start_time = "0.5";
        off_below = "0.13";
        pin = "PC6";
      };

      idle_timeout.timeout = 1800;

      "static_digital_output usb_pullup_enable".pins = "!PA14";

      board_pins.aliases = "EXP1_1=PB5, EXP1_3=PA9, EXP1_5=PA10, EXP1_7=PB8, EXP1_9=<GND>, EXP1_2=PA15, EXP1_4=<RST>, EXP1_6=PB9, EXP1_8=PB15, EXP1_10=<5V>";
    };
  };
}
