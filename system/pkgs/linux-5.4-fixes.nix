{
  nixpkgs.overlays = [
    (
      self: super:
        let
          xfs-2038-patch = (
            builtins.fetchurl {
              url = "https://lkml.org/lkml/diff/2019/12/26/349/1";
              sha256 = "1jzxncv97w3ns60nk91b9b0a11bp1axng370qhv4fs7ik01yfsa4";
            }
          );
          i915-drm-patch = (
            builtins.fetchurl {
              url =
                "https://src.fedoraproject.org/rpms/kernel/raw/9607b5faaa81022ed8b97f517c766202f9680744/f/drm-i915-gt-Detect-if-we-miss-WaIdleLiteRestore.patch";
              sha256 = "1kpjzvrp72rccg1vng94w3f6y7505m9yapy4092hsr6666imcs9h";
            }
          );
          i915-cmd-patch = (
            builtins.fetchurl {
              url =
                "https://gitlab.freedesktop.org/drm/intel/uploads/6fa138a0bcc682eec509606411caac1c/revert-0546a29c.patch";
              sha256 = "0s4kbwl5pbzz8spqmj84zhafk4qmjkcz160xw7hqq30cn7h53wrm";
            }
          );
        in
          {
            xfs-2038-fix = {
              name = "xfs-2038-fix";
              patch = xfs-2038-patch;
            };
            i915-drm-fix = {
              name = "i915-drm-fix";
              patch = i915-drm-patch;
            };
            i915-cmd-fix = {
              name = "i915-cmd-fix";
              patch = i915-cmd-patch;
            };
          }
    )
  ];
}
