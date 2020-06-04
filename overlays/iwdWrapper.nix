self: super: {
    iwd = super.iwd.overrideAttrs (oldAttrs: {
      postFixup = oldAttrs.postFixup + ''
        wrapProgram $out/libexec/iwd --set STATE_DIRECTORY /state/var/lib/iwd
      '';
    });
}
