{ config, nixos-hardware, ... }:
{
  imports = [
    nixos-hardware.common-pc-ssd

    ../../core

    ../../hardware/rpi4.nix
    ../../hardware/nixos-aarch64-builder
    ../../hardware/no-mitigations.nix

    ../../users/bemeurer
  ];

  boot = {
    initrd.availableKernelModules = [ "nvme" ];
    kernelParams = [ "earlycon=pl011,mmio32,0xfe201000" "console=ttyAMA0,115200" ];
  };

  console.keyMap = "us";

  hardware = {
    deviceTree = {
      enable = true;
      overlays = [{
        name = "rpi-poe-plus-overlay";
        dtsText = ''
          /*
          * Overlay for the Raspberry Pi POE HAT.
          */
          /dts-v1/;
          /plugin/;

          / {
            compatible = "brcm,bcm2835";

            fragment@0 {
              target-path = "/";
              __overlay__ {
                fan0: rpi-poe-fan@0 {
                  compatible = "raspberrypi,rpi-poe-fan";
                  firmware = <&firmware>;
                  cooling-min-state = <0>;
                  cooling-max-state = <4>;
                  #cooling-cells = <2>;
                  cooling-levels = <0 1 10 100 255>;
                  status = "okay";
                };
              };
            };

            fragment@1 {
              target = <&cpu_thermal>;
              __overlay__ {
                trips {
                  trip0: trip0 {
                    temperature = <50000>;
                    hysteresis = <2000>;
                    type = "active";
                  };
                  trip1: trip1 {
                    temperature = <60000>;
                    hysteresis = <2000>;
                    type = "active";
                  };
                  trip2: trip2 {
                    temperature = <70000>;
                    hysteresis = <2000>;
                    type = "active";
                  };
                  trip3: trip3 {
                    temperature = <80000>;
                    hysteresis = <5000>;
                    type = "active";
                  };
                };
                cooling-maps {
                  map0 {
                    trip = <&trip0>;
                    cooling-device = <&fan0 0 1>;
                  };
                  map1 {
                    trip = <&trip1>;
                    cooling-device = <&fan0 1 2>;
                  };
                  map2 {
                    trip = <&trip2>;
                    cooling-device = <&fan0 2 3>;
                  };
                  map3 {
                    trip = <&trip3>;
                    cooling-device = <&fan0 3 4>;
                  };
                };
              };
            };

            fragment@2 {
              target-path = "/__overrides__";
              __overlay__ {
                poe_fan_temp0 =    <&trip0>,"temperature:0";
                poe_fan_temp0_hyst =  <&trip0>,"hysteresis:0";
                poe_fan_temp1 =    <&trip1>,"temperature:0";
                poe_fan_temp1_hyst =  <&trip1>,"hysteresis:0";
                poe_fan_temp2 =    <&trip2>,"temperature:0";
                poe_fan_temp2_hyst =  <&trip2>,"hysteresis:0";
                poe_fan_temp3 =    <&trip3>,"temperature:0";
                poe_fan_temp3_hyst =  <&trip3>,"hysteresis:0";
              };
            };

            fragment@3 {
              target-path = "/";
              __overlay__ {
                rpi_poe_power_supply: rpi-poe-power-supply@0 {
                  compatible = "raspberrypi,rpi-poe-power-supply";
                  firmware = <&firmware>;
                  status = "okay";
                };
              };
            };

            &fan0 {
              cooling-levels = <0 32 64 128 255>;
            };

            __overrides__ {
              poe_fan_temp0 =    <&trip0>,"temperature:0";
              poe_fan_temp0_hyst =  <&trip0>,"hysteresis:0";
              poe_fan_temp1 =    <&trip1>,"temperature:0";
              poe_fan_temp1_hyst =  <&trip1>,"hysteresis:0";
              poe_fan_temp2 =    <&trip2>,"temperature:0";
              poe_fan_temp2_hyst =  <&trip2>,"hysteresis:0";
              poe_fan_temp3 =    <&trip3>,"temperature:0";
              poe_fan_temp3_hyst =  <&trip3>,"hysteresis:0";
            };
          };
        '';
      }];
    };
    raspberry-pi."4" = {
      dwc2 = {
        enable = true;
        dr_mode = "host";
      };
      i2c1.enable = true;
      fkms-3d.enable = true;
    };
  };

  networking.hostName = "camus";

  nix.gc = {
    automatic = true;
    options = "-d";
  };

  systemd.network.networks.eth = {
    DHCP = "yes";
    matchConfig.MACAddress = "e4:5f:01:2a:4e:88";
  };

  time.timeZone = "America/Los_Angeles";

  age.secrets.rootPassword.file = ./password.age;
  users.users.root.passwordFile = config.age.secrets.rootPassword.path;

  swapDevices = [{ device = "/swap"; size = 2048; }];
}
