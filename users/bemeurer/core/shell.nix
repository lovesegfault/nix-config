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
    export LESSHISTFILE="${config.xdg.dataHome}/less_history"
    export CARGO_HOME="${config.xdg.cacheHome}/cargo"
  '';

  historySize = 30000;
}
