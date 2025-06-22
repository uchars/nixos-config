{
  pkgs,
    lib,
    config,
    inputs,
    ...
}:
{
  options.settings.terminal = with lib; {
    enable = mkEnableOption "Terminal Things";
    alacritty = mkOption {
      default = false;
      type = types.bool;
    };
    ghostty = mkOption {
      default = false;
      type = types.bool;
    };
    tmux = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config =
    let
    cfg = config.settings.terminal;
  in
    lib.mkIf cfg.enable {
      home.packages =
        with pkgs;
      (if cfg.alacritty then [ alacritty ] else [ ])
        ++ ( if cfg.ghostty then [ inputs.ghostty.packages.x86_64-linux.default ] else [ ]);

      programs.tmux = {
        enable = cfg.tmux;
        shortcut = "a";
        baseIndex = 1;
        newSession = true;
        escapeTime = 0;
        secureSocket = false;
        extraConfig = ''
          set -ga terminal-overrides ",screen-256color*:Tc"
          set-option -g default-terminal "screen-256color"
          set-option -g default-terminal "tmux-256color"
          set -s escape-time 0

          unbind C-b
          set-option -g prefix C-a
          bind-key C-a send-prefix
          set -g base-index 1
          set -g status-style 'bg=#333333 fg=#5eacd3'

          bind r source-file ~/.tmux.conf

          set-window-option -g mode-keys vi
          bind -T copy-mode-vi v send-keys -X begin-selection
          bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel 'xclip -in -selection clipboard'

          bind -r ^ last-window
          bind -r k select-pane -U
          bind -r j select-pane -D
          bind -r h select-pane -L
          bind -r l select-pane -R

          bind  c  new-window      -c "#{pane_current_path}"
          bind  %  split-window -h -c "#{pane_current_path}"
          bind '"' split-window -v -c "#{pane_current_path}"

          bind-key -r f run-shell "tmux neww tmux-sessionizer.sh"
          '';
      };

      home.file.".local/bin/tmux-sessionizer.sh" = {
        executable = true;
        text = ''
        #!/usr/bin/env bash
        # Taken and modified from https://github.com/ThePrimeagen/.dotfiles/blob/602019e902634188ab06ea31251c01c1a43d1621/bin/.local/scripts/tmux-sessionizer

        switch_to() {
          if [[ -z $TMUX ]]; then
            tmux attach-session -t $1
          else
            tmux switch-client -t $1
              fi
        }

        has_session() {
          tmux list-sessions | grep -q "^$1:"
        }

        hydrate() {
          if [ -f $2/.tmux-sessionizer ]; then
            tmux send-keys -t $1 "source $2/.tmux-sessionizer" c-M
              elif [ -f $HOME/.tmux-sessionizer ]; then
              tmux send-keys -t $1 "source $HOME/.tmux-sessionizer" c-M
              fi
        }

        if [[ $# -eq 1 ]]; then
          selected=$1
        else
          selected=$(find ~/.files ~/work ~/Documents ~/Documents/notes ~/Documents/src -mindepth 0 -maxdepth 2 -type d | fzf)
            fi

            if [[ -z $selected ]]; then
              exit 0
                fi

                selected_name=$(basename "$selected" | tr . _)
                tmux_running=$(pgrep tmux)

                if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
                  tmux new-session -s $selected_name -c $selected
                    hydrate $selected_name $selected
                    exit 0
                    fi

                    if ! has_session $selected_name; then
                      tmux new-session -ds $selected_name -c $selected
                        hydrate $selected_name $selected
                        fi

                        switch_to $selected_name
                        '';
      };

      home.file."./.config/alacritty/alacritty.toml" = {
        recursive = true;
        text = ''
          [window]
          decorations = "Full"
opacity = 0.8
            '';
      };

      home.file."./.config/ghostty/config" = {
        recursive = true;
        text = ''
#background = 282c34
#foreground = ffffff
          background-opacity = 0.8
          background-blur-radius = 60
          window-decoration = true
          copy-on-select = true
          macos-titlebar-style = hidden
          '';
      };

    };
}
