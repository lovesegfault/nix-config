# Single source of truth for tmux keybindings and the tmux-which-key menu.
#
# The which-key menu tree below is the only definition: entries that carry a
# `bind` also generate the `bind` lines for both tmux configs (home-manager and
# /etc/tmux.conf), grouped by menu section. modules/home/tmux consumes the
# rendered bind lines and the menu, modules/nixos/tmux.nix only the bind lines.
# The NixOS and home-manager module systems evaluate independently, so each
# sees its own copy of these identical, read-only values.
#
# Entry constructors (in-menu key, label, action — `bound` prefixes the global
# key, which may be a single key or a list of keys):
#   (bound "C-a" "a" "Last window" "last-window")     menu entry + global bind
#   (rootBound "M-h" "h" "Previous" "previous-window")    prefix-less (bind -n)
#   (stock "z" "Zoom" "resizep -Z")        stock tmux binding, label shows "(z)"
#   (item "C" "New here" "neww ...")       menu-only entry, no key in the label
#   (transientItem "h" "Left" "resizep -L")    menu-only, stays open after running
#   (submenu "w" "+Windows" [ ... ])       nested menu
#   sep                                    separator line
# Append `// { ... }` for the rare extras: `transient`, `comment` (emitted above
# the bind line), `defaultKey` (label override for stock entries), `macro`.
# Bindings that should not appear in the menu live in `extraBindings`.
{ lib, ... }:
let
  inherit (lib)
    concatLists
    concatMap
    concatStringsSep
    mkOption
    optional
    optionalAttrs
    optionalString
    toList
    types
    ;

  # Constructors.
  item = key: name: command: { inherit key name command; };
  stock =
    key: name: command:
    item key name command // { defaultKey = key; };
  transientItem =
    key: name: command:
    item key name command // { transient = true; };
  bound =
    bind: key: name: command:
    item key name command // { inherit bind; };
  rootBound =
    bind: key: name: command:
    bound bind key name command // { root = true; };
  submenu = key: name: items: { inherit key name items; };
  sep = {
    separator = true;
  };

  splitH = "split-window -h -c \"#{pane_current_path}\"";
  splitV = "split-window -v -c \"#{pane_current_path}\"";

  # The menu tree, and with it every keybinding. `reloadConfig` is the path the
  # reload binding sources, which differs between home-manager and NixOS.
  mkMenu = reloadConfig: [
    (bound ":" ":" "Run command" "command-prompt")
    (bound "C-a" "a" "Last window" "last-window")
    (bound ";" ";" "Last pane" "last-pane")
    (bound "[" "[" "Copy mode" "copy-mode")
    (bound "]" "]" "Paste" "paste-buffer")
    sep
    (submenu "w" "+Windows" [
      (bound "c" "c" "New" "new-window")
      (item "C" "New here" "neww -c #{pane_current_path}")
      (
        rootBound "M-h" "h" "Previous" "previous-window"
        // {
          comment = "Alt+h/l for prefix-less window navigation (Ctrl+hjkl is panes via vim-tmux-navigator)";
        }
      )
      (rootBound "M-l" "l" "Next" "next-window")
      (rootBound "M-H" "<" "Move left" "swap-window -d -t -1")
      (rootBound "M-L" ">" "Move right" "swap-window -d -t +1")
      (stock "w" "Choose" "choose-tree -Zw")
      sep
      (submenu "L" "+Layouts" [
        (bound "+" "+" "Main horizontal" "select-layout main-horizontal")
        (bound "=" "=" "Main vertical" "select-layout main-vertical")
        (item "t" "Tiled" "selectl tiled")
        (item "h" "Even horizontal" "selectl even-horizontal")
        (item "v" "Even vertical" "selectl even-vertical")
        (transientItem "n" "Next layout" "nextl")
      ])
      sep
      (stock "," "Rename" ''command-prompt -I "#W" "renamew -- \"%%\""'')
      (stock "&" "Kill" ''confirm -p "Kill window #W? (y/n)" killw'')
    ])
    (submenu "p" "+Panes" [
      (bound [ "v" ''\'' ] "v" "Split right" splitH)
      (bound "-" "-" "Split below" splitV)
      sep
      (bound "h" "h" "Left" "select-pane -L")
      (bound "j" "j" "Down" "select-pane -D")
      (bound "k" "k" "Up" "select-pane -U")
      (bound "l" "l" "Right" "select-pane -R")
      sep
      (stock "z" "Zoom" "resizep -Z")
      (bound "C-o" "o" "Rotate" "rotate-window" // { transient = true; })
      (bound "q" "q" "Numbers" "display-panes -d 0")
      (submenu "r" "+Resize" [
        (transientItem "h" "Left" "resizep -L")
        (transientItem "j" "Down" "resizep -D")
        (transientItem "k" "Up" "resizep -U")
        (transientItem "l" "Right" "resizep -R")
        (transientItem "H" "Left more" "resizep -L 10")
        (transientItem "J" "Down more" "resizep -D 10")
        (transientItem "K" "Up more" "resizep -U 10")
        (transientItem "L" "Right more" "resizep -R 10")
      ])
      (item "H" "Swap left" ''swapp -t "{left-of}"'')
      (item "J" "Swap down" ''swapp -t "{down-of}"'')
      (item "K" "Swap up" ''swapp -t "{up-of}"'')
      (item "L" "Swap right" ''swapp -t "{right-of}"'')
      (stock "!" "Break to window" "break-pane")
      sep
      (stock "m" "Mark" "selectp -m")
      (stock "M" "Unmark" "selectp -M")
      (item "C" "Capture" "capture-pane")
      (item "R" "Respawn" null // { macro = "restart-pane"; })
      (stock "x" "Kill" ''confirm -p "Kill pane #P? (y/n)" killp'')
    ])
    sep
    (submenu "s" "+Sessions" [
      (stock "s" "Choose" "choose-tree -Zs")
      (item "N" "New" "new")
      (stock "$" "Rename" ''command-prompt -I "#S" "rename-session -- \"%%\""'')
      (stock "d" "Detach" "detach")
    ])
    (submenu "b" "+Buffers" [
      (item "b" "Choose" "choose-buffer -Z")
      (stock "#" "List" "lsb")
      (stock "p" "Paste" "pasteb" // { defaultKey = "]"; })
    ])
    sep
    (bound "R" "R" "Reload config"
      "source-file ${reloadConfig} \\; display-message \"Config reloaded...\""
    )
    (bound "r" "r" "Refresh client" "refresh-client")
    (stock "T" "Time" "clock-mode" // { defaultKey = "t"; })
    (stock "~" "Show messages" "show-messages")
    (stock "?" "Keys" "list-keys -N")
  ];

  # Keybindings that intentionally have no menu entry.
  extraBindings = [
    {
      bind = "a";
      command = "send-prefix";
    }
  ];

  homeMenu = mkMenu "~/.config/tmux/tmux.conf";
  nixosMenu = mkMenu "/etc/tmux.conf";

  duplicates =
    list:
    lib.attrNames (
      lib.filterAttrs (_: count: count > 1) (
        lib.foldl' (acc: x: acc // { ${x} = (acc.${x} or 0) + 1; }) { } list
      )
    );

  # ---- bind lines -----------------------------------------------------------

  boundEntries =
    entries: concatMap (e: if e ? items then boundEntries e.items else optional (e ? bind) e) entries;

  # Bindings grouped per top-level menu entry (a section comment for submenus),
  # with the menu-less extras appended to the first group.
  bindGroups =
    menuTree:
    let
      topLevel = map (
        e:
        if e ? items then
          {
            comment = e.name;
            binds = boundEntries e.items;
          }
        else
          {
            binds = optional (e ? bind) e;
          }
      ) (lib.filter (e: !(e ? separator)) menuTree);
      general = {
        binds =
          (concatLists (lib.catAttrs "binds" (lib.filter (g: !(g ? comment)) topLevel))) ++ extraBindings;
      };
      sections = lib.filter (g: g ? comment && g.binds != [ ]) topLevel;
    in
    [ general ] ++ sections;

  escapeKey =
    key:
    if key == ";" then
      "';'"
    else if key == ''\'' then
      ''\\''
    else
      key;
  renderBind =
    e:
    concatStringsSep "\n" (
      (optional (e ? comment) "# ${e.comment}")
      ++ map (key: "bind ${optionalString (e.root or false) "-n "}${escapeKey key} ${e.command}") (
        toList e.bind
      )
    );
  renderGroup =
    g: concatStringsSep "\n" ((optional (g ? comment) "# ${g.comment}") ++ map renderBind g.binds);

  checkBinds =
    menuTree:
    let
      binds = boundEntries menuTree ++ extraBindings;
      keysOf = root: concatMap (e: toList e.bind) (lib.filter (e: (e.root or false) == root) binds);
      ctrlRoot = lib.filter (lib.hasPrefix "C-") (keysOf true);
    in
    assert lib.assertMsg (
      duplicates (keysOf false) == [ ]
    ) "tmux-bindings: duplicate prefix-table keys: ${toString (duplicates (keysOf false))}";
    assert lib.assertMsg (
      duplicates (keysOf true) == [ ]
    ) "tmux-bindings: duplicate root-table keys: ${toString (duplicates (keysOf true))}";
    assert lib.assertMsg (ctrlRoot == [ ])
      "tmux-bindings: prefix-less Ctrl bindings steal keys from TUIs, use Alt instead: ${toString ctrlRoot}";
    menuTree;

  renderBindLines =
    menuTree: concatStringsSep "\n\n" (map renderGroup (bindGroups (checkBinds menuTree)));

  # ---- which-key menu -------------------------------------------------------

  label =
    e:
    if e ? bind then
      "${e.name} (${concatStringsSep ", " (toList e.bind)})"
    else if e ? defaultKey then
      "${e.name} (${e.defaultKey})"
    else
      e.name;

  mkMenuItem =
    e:
    if e ? separator then
      e
    else if e ? items then
      {
        inherit (e) name key;
        menu = mkMenuItems e.items;
      }
    else
      {
        name = label e;
        inherit (e) key;
      }
      // (if e ? macro then { inherit (e) macro; } else { inherit (e) command; })
      // optionalAttrs (e.transient or false) { transient = true; };

  mkMenuItems =
    entries:
    let
      keys = map (e: e.key) (lib.filter (e: !(e ? separator)) entries);
    in
    assert lib.assertMsg (
      duplicates keys == [ ]
    ) "tmux-bindings: duplicate menu keys at one level: ${toString (duplicates keys)}";
    map mkMenuItem entries;

  whichKeyMenu = {
    command_alias_start_index = 200;
    keybindings.prefix_table = "Space";
    title = {
      style = "align=centre,bold";
      prefix = "tmux";
      prefix_style = "fg=green,align=centre,bold";
    };
    position = {
      x = "R";
      y = "P";
    };
    custom_variables = [
      {
        name = "log_info";
        value = "#[fg=green,italics] [info]#[default]#[italics]";
      }
    ];
    macros = [
      {
        name = "restart-pane";
        commands = [
          "display \"#{log_info} Restarting pane\""
          "respawnp -k -c #{pane_current_path}"
        ];
      }
    ];
    items = mkMenuItems homeMenu;
  };
in
{
  options.local.tmux = {
    bindLines = {
      home = mkOption {
        type = types.lines;
        readOnly = true;
        default = renderBindLines homeMenu;
        description = "Rendered tmux bind lines for the home-manager config.";
      };
      nixos = mkOption {
        type = types.lines;
        readOnly = true;
        default = renderBindLines nixosMenu;
        description = "Rendered tmux bind lines for the NixOS (/etc/tmux.conf) config.";
      };
    };
    whichKeyMenu = mkOption {
      type = types.attrs;
      readOnly = true;
      default = whichKeyMenu;
      description = "tmux-which-key menu definition derived from the menu tree.";
    };
  };
}
