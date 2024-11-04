{ pkgs, emacs_dots, ... }:
let
  shAliases = {
    ll = "ls -l";
    ".." = "cd ..";
    l = "ls";
    v = "nvim";
    nv = "nvim";
    p = "ps aux | grep -i ";
    gs = "git status";
    gf = "git fetch --all";
    gwip = "git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit -m '[WIP]: $(date)'";
    gundo = "git reset HEAD~";
    gcm = "git-credential-manager";
    gl = "git log";
    stitle = "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:org.mpris.MediaPlayer2.Player string:Metadata | sed -n '/title/{n;p}' | cut -d '\"' -f 2";
    snext = "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next > /dev/null && stitle";
    sstate = "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'PlaybackStatus' | grep -oE '(Playing|Paused)'";
    sn = "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next > /dev/null && stitle";
    spause = "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Pause > /dev/null";
    stoggle = "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause > /dev/null";
    splay = "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Play > /dev/null";
    srep = "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Repeat > /dev/null && echo 'repeating stitle'";
    sprev = "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous > /dev/null && stitle";
    sp = "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous > /dev/null && stitle";
    yt = "mpv --ytdl-raw-options='cookies=$HOME/Downloads/yt_cookies.txt'";
    o = "xdg-open";
    ts = "~/.local/bin/tmux-sessionizer.sh";
  };
in
{
  programs.home-manager.enable = true;
  imports = [
    ./gnome.nix
    ./kde.nix
  ];
  nixpkgs.config.allowUnfree = true;
  home.username = "nils";
  home.homeDirectory = "/home/nils";

  home.stateVersion = "23.05";

  home.packages = with pkgs; [
    fzf
    htop
    stack
    zathura
    syncthing
    texinfo
    autoconf
    gnumake
    dconf
    transmission-qt
    spotify
    gimp
    vlc
    unzip
    ethtool
    yt-dlp
  ];

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };

  programs.bash = {
    enable = true;
    shellAliases = shAliases;
    bashrcExtra = ''
      export PATH="$PATH:~/.local/bin";
    '';
  };

  elira.editors = {
    enable = true;
    vscode = true;
    emacs = {
      enable = true;
      config_dir = "${emacs_dots}";
    };
  };

  elira.programming = {
    enable = true;
    rust = true;
    android = false;
    java = true;
    jdkVersions = [ pkgs.jdk19 ];
  };

  elira.keyboard = {
    enable = true;
  };

  elira.terminal = {
    enable = true;
    tmux = true;
  };

  elira.gaming = {
    enable = true;
    emulation = true;
  };

  elira.browser = {
    enable = true;
    brave = true;
    firefox = true;
    tor = true;
  };

  elira.waybar = {
    enable = true;
    systemd = true;
    monitors = [
      "DP-4"
      "eDP-1"
    ];
  };

  elira.hyprland = {
    enable = true;
    terminal = "kitty";
    filebrowser = "dolphin";
  };
}
