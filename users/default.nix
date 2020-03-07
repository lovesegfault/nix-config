let
  # I don't want to have to bring in lib just for this
  nameValuePair = name: value: { inherit name value; };
  genAttrs = names: f: builtins.listToAttrs (map (n: nameValuePair n (f n)) names);
  userDirs = builtins.attrNames (builtins.readDir ./.);
  users = genAttrs userDirs (path: ./. + "/${path}");
in {
  ops = with users; [ bemeurer ];
  all = builtins.attrNames users;
} // users
