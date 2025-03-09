{
  pkgs,
  emacs_dots,
  inputs,
  username,
  ...
}:
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
    lock = "betterlockscreen -l";
    vpn = "openconnect --protocol=anyconnect vpn.uni-bremen.de";
    kus = "setxkbmap us";
    kger = "setxkbmap de";
    brightness = "xrandr --output eDP-1 --brightness";
  };
in
{
  programs.home-manager.enable = true;
  imports = [
    ./gnome.nix
    ./kde.nix
  ];
  nixpkgs.config.allowUnfree = true;
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";

  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    fzf
    lxde.lxrandr
    htop
    stack
    zathura
    syncthing
    texinfo
    autoconf
    gnumake
    dconf
    transmission_4
    spotify
    gimp
    vlc
    mpv
    unzip
    ethtool
    networkmanager
    yt-dlp
    openconnect
    dbus
    feh
    networkmanagerapplet
    pavucontrol
    mattermost-desktop
    inkscape
    bitwarden-desktop
    audacity
    anki
  ];

  services.flameshot = {
    enable = true;
    settings = {
      General = {
        showHelp = false;
      };
    };
  };

  services.picom.enable = true;

  services.nextcloud-client = {
    enable = true;
    startInBackground = true;
  };

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
      export PS1='\[\e[38;5;209;1m\][\[\e[22m\]\u@\H:\w\[\e[1m\]]> \[\e[0m\]'
    '';
  };

  home.sessionVariables = {
    EDITOR = "vim";
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
    jdkVersions = [ pkgs.jdk23 ];
  };

  elira.keyboard = {
    enable = true;
  };

  elira.terminal = {
    enable = true;
    alacritty = true;
    ghostty = true;
    tmux = true;
  };

  elira.gaming = {
    enable = true;
    emulation = true;
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

  elira.waybar = {
    enable = false;
    systemd = true;
    monitors = [
      "DP-4"
      "DP-5"
      "eDP-1"
    ];
  };

  home.file.".background-image" = {
    source = ./wallpaper.png;
  };

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome.gnome-themes-extra;
    };
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
