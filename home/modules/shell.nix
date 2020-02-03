{ config, lib, pkgs, ... }: {
  aliases = {
    cat = "bat";
    # rust
    c = "cargo";
    cb = "cargo build";
    cbr = "cargo build --release";
    cch = "cargo check";
    cce = "cargo clean";
    cdo = "cargo doc";
    ccp = "cargo clippy";
    cr = "cargo run";
    crr = "cargo run --release";
    ct = "cargo test";
    ctr = "cargo test --release";
    # exa
    l = "exa --binary --header --long --classify --git";
    la = "l --all";
    ls = "l";
  };

  env = ''
    export CARGO_HOME="${config.xdg.cacheHome}/cargo"
  '' + lib.optionalString pkgs.stdenv.isDarwin ''
    export NIX_PATH="$HOME/.nix-defexpr/channels''${NIX_PATH:+:}$NIX_PATH"
    export PATH="$PATH:/usr/local/bin/"
  '';

  historySize = 30000;
}
