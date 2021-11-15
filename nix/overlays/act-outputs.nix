final: prev: {
  act = final.buildGoModule rec {
    pname = "act";
    version = "unstable-2021-11-10";

    src = final.fetchFromGitHub {
      owner = "aboutte";
      repo = "act";
      rev = "21b7b7399bc15fa2c18287e774b5bb4cac6617fc";
      sha256 = "sha256-4AFj0hUZKgQDA24t6+lk4XSju512O4kH/0oByv/ds/Y=";
    };

    vendorSha256 = "sha256-m6sWeQ8LQVXccooeyytIVubq99+FCq+FiO/vOOdD0N4=";

    doCheck = false;

    ldflags = [ "-s" "-w" "-X main.version=${version}" ];

    inherit (prev.act) meta;
  };
}
