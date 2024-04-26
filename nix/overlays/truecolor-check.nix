final: _:
{
  truecolor-check = final.callPackage
    (
      { writers }:
      writers.writePython3Bin "truecolor-check"
        { flakeIgnore = [ "E111" "E114" "E225" "E261" "E265" "E302" "E305" "E501" ]; }
        (builtins.readFile (final.__inputs.truecolor-check + "/colors.py"))
    )
    { };
}
