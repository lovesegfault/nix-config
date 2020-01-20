{
  nixpkgs.overlays = [
    (self: super: {
      weechat = let
        aspell = super.aspellWithDicts
          (dicts: with dicts; [ en en-computers en-science ]);
      in (super.weechat.overrideAttrs (oldAttrs: {
        buildInputs = (oldAttrs.buildInputs or [ ]) ++ [ aspell ];
      })).override {
        configure = { availablePlugins, ... }: {
          init = ''
            /set env ASPELL_CONF "dict-dir ${aspell}/lib/aspell"
          '';
        };
      };
    })
  ];
}
