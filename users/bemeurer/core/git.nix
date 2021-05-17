{ pkgs, ... }: {
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    lfs.enable = false;
    userEmail = "bernardo@meurer.org";
    userName = "Bernardo Meurer";
    extraConfig = {
      core.pager = "${pkgs.delta}/bin/delta --dark";
      difftool.prompt = true;
      github.user = "lovesegfault";
      mergetool.prompt = true;
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
    gcoan = "git commit --amend --no-edit";
    gdf = "git diff";
    gdfs = "git diff --staged";
    gdt = "git difftool";
    gdts = "git difftool --staged";
    gf = "git fetch --all --prune --tags";
    gl = "git log --decorate --pretty=format:'%C(auto)%h%d %C(green)(%as)%C(reset) %s'";
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
