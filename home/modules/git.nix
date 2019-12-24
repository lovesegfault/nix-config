{ pkgs, ... }: {
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    lfs.enable = false;
    signing = {
      key = "589412CE19DF582AE10A3320E421C74191EA186C";
      signByDefault = true;
    };
    userEmail = "meurerbernardo@gmail.com";
    userName = "Bernardo Meurer";
    extraConfig = {
      core.pager = "${pkgs.gitAndTools.delta}/bin/delta --dark";
      mergetool.prompt = true;
      difftool.prompt = true;
      github.user = "lovesegfault";
    };
  };
  programs.zsh.shellAliases = {
    g = "git";
    ga = "git add";
    gaa = "git add -A";
    gaap = "git add -A --patch";
    gap = "git add --patch";
    gch = "git checkout";
    gcl = "git clone";
    gco = "git commit";
    gcom = "git commit --message";
    gcoa = "git commit --amend";
    gdf = "git diff";
    gdfs = "git diff --staged";
    gdt = "git difftool";
    gdts = "git difftool --staged";
    gf = "git fetch --prune --all";
    gl = "git log --graph --abbrev-commit --decorate";
    gm = "git merge";
    gma = "git merge --abort";
    gmc = "git merge --continue";
    gpl = "git pull --rebase";
    gps = "git push";
    grb = "git rebase";
    grba = "git rebase --abort";
    grbc = "git rebase --continue";
    grbsn = "git rebase --exec 'git commit --amend --no-edit -n -S'";
    grs = "git restore";
    grss = "git restore --staged";
    gs = "git status";
  };
}
