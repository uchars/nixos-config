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
    vol = "amixer set Master --quiet";
    mute = "amixer set Master 1+ toggle --quiet";
    mirror = "xrandr --output eDP-1 --auto --same-as DP-4";
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
    lxde.lxrandr
    blueman
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
    mpv
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
    wezterm = true;
    tmux = true;
  };

  elira.gaming = {
    enable = true;
    emulation = true;
  };

  elira.wallpaper = {
    swww = true;
  };

  elira.fonts = {
    enable = true;
  };

  elira.browser = {
    enable = true;
    brave = true;
    firefox = true;
    tor = true;
  };

  home.file.".local/bin/dwmstatus.sh" = {
    executable = true;
    text = ''
            #!/bin/bash
      source $HOME/.config/alias.sh

      get_ram_usage() {
          total=$(grep MemTotal /proc/meminfo | awk '{print $2}')
          available=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
          used=$((total - available))
          total_mb=$((total / 1024))
          used_mb=$((used / 1024))
          echo "$used_mb/$total_mb MB"
      }

      while true; do
          BAT_CAPACITY=$(cat /sys/class/power_supply/BAT1/capacity)
          BAT_STATUS=$(cat /sys/class/power_supply/BAT1/status)
          SOUND_VOLUME=$(amixer sget Master | grep 'Right:' | awk -F'[][]' '{ print $2 }')
          SOUND_MUTED=$(amixer sget Master | grep 'Right:' | awk -F'[][]' '{ print $4 }')
          SPOTIFY_STR=""
          SERVICE="org.mpris.MediaPlayer2.spotify"
          if dbus-send --print-reply --type=method_call --dest=$SERVICE /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:org.mpris.MediaPlayer2 string:Identity >/dev/null 2>/dev/null; then
              SPOTIFY_STATE=$(dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'PlaybackStatus' | grep -oE '(Playing|Paused)')
              SPOTIFY_TITLE=$(dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:org.mpris.MediaPlayer2.Player string:Metadata | sed -n '/title/{n;p}' | cut -d \" -f 2)
              SPOTIFY_STR="($SPOTIFY_STATE) $SPOTIFY_TITLE |"
          fi
          if [ "$SOUND_MUTED" = "off" ]; then
              SOUND_MUTED="(muted)"
          else
              SOUND_MUTED=""
          fi
          xsetroot -name "$SPOTIFY_STR VOL: $SOUND_VOLUME$SOUND_MUTED | RAM: $(get_ram_usage) | BAT: $BAT_CAPACITY% ($BAT_STATUS) | $(date)"
          sleep 1
      done
    '';
  };

  elira.waybar = {
    enable = false;
    systemd = true;
    monitors = [
      "DP-4"
      "DP-5"
      "eDP-1"
    ];
  };

  elira.hyprland = {
    enable = false;
    terminal = "kitty";
    filebrowser = "dolphin";
    wallpaper = {
      daemon = "swww-daemon";
      cmd = "swww --no-resize";
      path = "~/Pictures/c4a05f73-fafd-4ad5-8d6a-d59667b19dc6_rw_1200.gif";
    };
  };
}
