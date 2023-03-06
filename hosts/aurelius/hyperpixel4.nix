{ lib, ... }: {
  hardware.raspberry-pi."4".apply-overlays-dtmerge.enable = true;
  hardware.deviceTree.overlays = lib.mkAfter [
    {
      name = "vc4-kms-dpi-hyperpixel4-overlay";
      dtsText = ''
        /dts-v1/;
        /plugin/;

        #define GPIO_ACTIVE_HIGH 0
        #define GPIO_ACTIVE_LOW 1

        #define BCM2711_PUD_OFF     0
        #define BCM2711_PUD_DOWN    1
        #define BCM2711_PUD_UP      2

        &panel {
          compatible = "pimoroni,hyperpixel4";
        };

        / {
            compatible = "brcm,bcm2711";

            fragment@0 {
                target-path = "/";
                __overlay__ {
                    spi {
                        compatible = "spi-gpio";
                        #address-cells = <1>;
                        #size-cells = <0>;
                        pinctrl-0 = <&spi_pins>;
                        pinctrl-names = "default";

                        sck-gpios = <&gpio 27 GPIO_ACTIVE_HIGH>;
                        mosi-gpios = <&gpio 26 GPIO_ACTIVE_HIGH>;
                        cs-gpios = <&gpio 18 GPIO_ACTIVE_LOW>;
                        num-chipselects = <1>;
                        sck-idle-input;

                        panel: display@0 {
                            reg = <0>;
                            /* 100 kHz */
                            spi-max-frequency = <100000>;
                            backlight = <&backlight>;
                            rotation = <0>;

                            port {
                                panel_in: endpoint {
                                    remote-endpoint = <&dpi_out>;
                                };
                            };
                        };
                    };

                    backlight: backlight {
                        compatible = "gpio-backlight";
                        gpios = <&gpio 19 0>;
                    };
                };
            };

            fragment@1 {
                target = <&dpi>;
                __overlay__  {
                    status = "okay";

                    pinctrl-names = "default";
                    pinctrl-0 = <&dpi_18bit_cpadhi_gpio0>;

                    port {
                        dpi_out: endpoint {
                            remote-endpoint = <&panel_in>;
                        };
                    };
                };
            };

            fragment@2 {
                target = <&gpio>;
                __overlay__ {
                    spi_pins: hyperpixel4_spi_pins {
                        brcm,pins = <27 18 26>;
                        brcm,pull = <BCM2711_PUD_UP BCM2711_PUD_UP BCM2711_PUD_OFF>;
                        brcm,function = <0>;
                    };
                };
            };

            fragment@3 {
                target-path = "/";
                __overlay__ {
                    i2c_gpio: i2c@0 {
                        compatible = "i2c-gpio";
                        gpios = <&gpio 10 0 /* sda */
                             &gpio 11 0>; /* scl */
                        i2c-gpio,delay-us = <4>;        /* ~100 kHz */
                        #address-cells = <1>;
                        #size-cells = <0>;
                    };
                };
            };

            fragment@11 {
              target = <&i2c_gpio>;
              __overlay__ {
                  /* needed to avoid dtc warning */
                  #address-cells = <1>;
                  #size-cells = <0>;
                  ft6236_14: ft6236@14 {
                      compatible = "goodix,gt911";
                      reg = <0x14>;
                      interrupt-parent = <&gpio>;
                      interrupts = <27 2>;
                      touchscreen-size-x = <480>;
                      touchscreen-size-y = <800>;
                      touchscreen-x-mm = <51>;
                      touchscreen-y-mm = <85>;
                      touchscreen-inverted-y;
                      touchscreen-swapped-x-y;
                  };
                  ft6236_5d: ft6236@5d {
                      compatible = "goodix,gt911";
                      reg = <0x5d>;
                      interrupt-parent = <&gpio>;
                      interrupts = <27 2>;
                      touchscreen-size-x = <480>;
                      touchscreen-size-y = <800>;
                      touchscreen-x-mm = <51>;
                      touchscreen-y-mm = <85>;
                      touchscreen-inverted-y;
                      touchscreen-swapped-x-y;
                  };
                };
            };

            __overrides__ {
                rotate = <&panel>, "rotation:0";
                disable-touch = <0>,"-3-11";
                touchscreen-inverted-x = <&ft6236_14>,"touchscreen-inverted-x?",
                             <&ft6236_5d>,"touchscreen-inverted-x?";
                touchscreen-inverted-y = <&ft6236_14>,"touchscreen-inverted-y!",
                             <&ft6236_5d>,"touchscreen-inverted-y!";
                touchscreen-swapped-x-y = <&ft6236_14>,"touchscreen-swapped-x-y!",
                              <&ft6236_5d>,"touchscreen-swapped-x-y!";
            };
        };
      '';
    }
  ];
}
