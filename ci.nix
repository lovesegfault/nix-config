rec {
  machines = import ./. {};
  x86_64 = with machines; [ abel cantor foucault peano ];
  aarch64 = with machines; [ bohr camus ];
  darwin = with machines; [ spinoza ];

  ci = [ x86_64 aarch64 ];
}
