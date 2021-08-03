self: super:
{
  raspberrypifw = super.raspberrypifw.overrideAttrs (oldAttrs: rec {
    inherit (oldAttrs) pname;
    version = "1.20210727";
    name = "${pname}-${version}";

    src = self.fetchFromGitHub {
      owner = "raspberrypi";
      repo = "firmware";
      rev = version;
      sha256 = "0z33s84m4w4n8277b174jm385jbmjrq2wqqbqhmj4y9xvsqjc213";
    };
  });

  raspberrypiWirelessFirmware = super.raspberrypiWirelessFirmware.overrideAttrs (oldAttrs: rec {
    inherit (oldAttrs) pname;
    version = "2021-06-23";
    name = "${pname}-${version}";

    srcs = [
      (self.fetchFromGitHub {
        name = "bluez-firmware";
        owner = "RPi-Distro";
        repo = "bluez-firmware";
        rev = "e7fd166981ab4bb9a36c2d1500205a078a35714d";
        sha256 = "1dkg8mzn7n4afi50ibrda2s33nw2qj52jjjdv9w560q601gms47b";
      })
      (self.fetchFromGitHub {
        name = "firmware-nonfree";
        owner = "RPi-Distro";
        repo = "firmware-nonfree";
        rev = "00de3194a96397c913786945ac0af1fd6fbec45b";
        sha256 = "1xnr364dkiq6gmr21lcrj23hwc0g9y5qad8dm2maij647bgzp07r";
      })
    ];
  });

  raspberrypi-armstubs = super.raspberrypi-armstubs.overrideAttrs (oldAttrs: rec {
    inherit (oldAttrs) pname;
    version = "2021-07-05";
    name = "${pname}-${version}";

    src = self.fetchFromGitHub {
      owner = "raspberrypi";
      repo = "tools";
      rev = "2e59fc67d465510179155973d2b959e50a440e47";
      sha256 = "1ysdl4qldy6ldf8cm1igxjisi14xl3s2pi6cnqzpxb38sgihb1vy";
    };
  });

  libraspberrypi = super.libraspberrypi.overrideAttrs (oldAttrs: rec {
    inherit (oldAttrs) pname;
    version = "unstable-2021-06-23";
    name = "${pname}-${version}";

    src = self.fetchFromGitHub {
      owner = "raspberrypi";
      repo = "userland";
      rev = "97bc8180ad682b004ea224d1db7b8e108eda4397";
      sha256 = "0cnjc7w8ynayj90vlpl13xzm9izd8m5b4cvrq52si9vc6wlm4in5";
    };
  });

  linux_rpi4 = super.linux_rpi4.override {
    argsOverride =
      let
        modDirVersion = "5.10.52";
        tag = "1.20210727";
      in
      {
        version = "${modDirVersion}-${tag}";
        inherit modDirVersion;

        src = self.fetchFromGitHub {
          owner = "raspberrypi";
          repo = "linux";
          rev = tag;
          sha256 = "0nabl547y75n1yx4584gidlhfv3ajzgbxcrkfa5sb04jwj0d469k";
        };

        extraConfig = ''
          # ../drivers/gpu/drm/ast/ast_mode.c:851:18: error: initialization of 'void (*)(struct drm_crtc *, struct drm_atomic_state *)' from incompatible pointer type 'void (*)(struct drm_crtc *, struct drm_crtc_state *)' [-Werror=incompatible-pointer-types]
          #   851 |  .atomic_flush = ast_crtc_helper_atomic_flush,
          #       |                  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
          # ../drivers/gpu/drm/ast/ast_mode.c:851:18: note: (near initialization for 'ast_crtc_helper_funcs.atomic_flush')
          DRM_AST n
          # ../drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/amdgpu_dm.c: In function 'amdgpu_dm_atomic_commit_tail':
          # ../drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/amdgpu_dm.c:7757:4: error: implicit declaration of function 'is_hdr_metadata_different' [-Werror=implicit-function-declaration]
          #  7757 |    is_hdr_metadata_different(old_con_state, new_con_state);
          #       |    ^~~~~~~~~~~~~~~~~~~~~~~~~
          DRM_AMDGPU n
        '';
      };
  };
}
