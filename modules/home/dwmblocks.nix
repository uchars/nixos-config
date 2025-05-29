{ pkgs, ... }:
let
  dwmblocks = pkgs.dwmblocks.overrideAttrs (old: {
    src = builtins.fetchGit {
      url = "https://github.com/uchars/dwmblocks.git";
      rev = "c763674011f44616f363ea8fd349426e435b877d";
    };
  });
in
{
  home.packages = [ dwmblocks ];
}
