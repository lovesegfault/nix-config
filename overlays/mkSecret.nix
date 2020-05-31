self: super:
with builtins; with self.lib;
{
  mkSecret = path: let
    name = tail (splitString "/" path);
    stub = toFile name "";
  in if pathExists path then path else warn "Using stub for secrets.${name}" stub;
}
