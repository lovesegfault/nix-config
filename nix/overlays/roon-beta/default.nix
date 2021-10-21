self: super: {
  lttng-ust_2_12 = self.callPackage ./lttng-ust.nix { };
  roon-server = self.callPackage ./roon-server.nix { lttng-ust = self.lttng-ust_2_12; };
}
