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
    gl = "git log --pretty=format:'%C(yellow)%h%Cred%d - %Creset%s%Cblue - [%cn]' --decorate";
    gll = "git log --pretty=format:'%C(yellow)%h%Cred%d - %Creset%s%Cblue - [%cn]' --decorate --numstat";
    diskspace = "du -S | sort -nr | more";
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
    #./kde.nix
  ];
  nixpkgs.config.allowUnfree = true;
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";

  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    fzf
    waybar
    swww
    wofi
    lxde.lxrandr
    htop
    stack
    zathura
    konsave
    syncthing
    ripgrep
    texinfo
    autoconf
    gnumake
    dconf
    transmission_4
    spotify
    gimp
    vlc
    krita
    mpv
    unzip
    ethtool
    id3v2
    networkmanager
    magic-vlsi
    yt-dlp
    libreoffice
    openconnect
    dbus
    feh
    networkmanagerapplet
    ripes
    pavucontrol
    mattermost-desktop
    inkscape
    bitwarden-desktop
    audacity
    anki
    thunderbird
    rofi-bluetooth
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

  services.dunst = {
    enable = true;
    settings = {
      global = {
        width = 300;
        height = 300;
        offset = "30x50";
        origin = "top-right";
        transparency = 10;
        font = "Droid Sans 9";
      };

      urgency_normal = {
        background = "#37474f";
        foreground = "#eceff1";
        timeout = 4;
      };
    };
  };

  programs.rofi = {
    enable = true;
    theme = "solarized";
    plugins = with pkgs; [
      # rofi-network-manager
      rofi-emoji
      rofi-bluetooth
    ];
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
      export PATH="$PATH:/home/sterz_n/.local/bin";
      export PS1='\[\e[38;5;209;1m\][\[\e[22m\]\u@\H:\w\[\e[1m\]]> \[\e[0m\]'
    '';
  };

  home.sessionVariables = {
    EDITOR = "vim";
  };

  settings.editors = {
    enable = true;
    vscode = true;
    emacs = {
      enable = true;
      config_dir = "${emacs_dots}";
    };
  };

  settings.programming = {
    enable = true;
    rust = true;
    latex = true;
    android = false;
    java = true;
    jdkVersions = [ pkgs.jdk21 ];
  };

  settings.keyboard = {
    enable = true;
  };

  settings.terminal = {
    enable = true;
    alacritty = true;
    ghostty = false;
    tmux = true;
  };

  settings.gaming = {
    enable = true;
    emulation = true;
  };

  settings.fonts = {
    enable = true;
  };

  settings.browser = {
    enable = true;
    brave = false;
    firefox = true;
    tor = true;
  };

  settings.waybar = {
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

  home.file."./.local/bin/rofi-kbdswitch" = {
    executable = true;
    text = ''
      #!/usr/bin/env sh
      #
      # Rofi powered menu to change X keyboard layout

      LAYOUTS=("us" "de" "fr" "es" "it" "ru")

      # Get current layout
      CURRENT_LAYOUT=$(setxkbmap -query | grep layout | awk '{print $2}')

      # Display menu and get selection
      SELECTION=$(
          printf "%s\n" "''${LAYOUTS[@]}"\
          | rofi -dmenu -p "Keyboard Layout (Current: $CURRENT_LAYOUT)"\
          -selected-row "''${LAYOUTS[@]/$CURRENT_LAYOUT/}.indexOf($CURRENT_LAYOUT)"\
      )

      # Change layout if selection was made
      if [ -n "$SELECTION" ]; then
          setxkbmap "$SELECTION"
      fi
    '';
  };

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome.gnome-themes-extra;
    };
  };
}
