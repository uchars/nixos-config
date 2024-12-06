{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.elira.terminal = with lib; {
    enable = mkEnableOption "Terminal Things";
    wezterm = mkOption {
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
      cfg = config.elira.terminal;
    in
    lib.mkIf cfg.enable {
      home.packages = with pkgs; (if cfg.wezterm then [ wezterm ] else [ ]);

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
          set -s escape-time 0

          unbind C-b
          set-option -g prefix C-a
          bind-key C-a send-prefix
          set -g base-index 1
          set -g status-style 'bg=#333333 fg=#5eacd3'
          set-option -g renumber-windows on

          set-window-option -g mode-keys vi
          bind -T copy-mode-vi v send-keys -X begin-selection
          bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel 'xclip -in -selection clipboard'

          # vim-like pane switching
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

          if [[ $# -eq 1 ]]; then
              selected=$1
          else
              selected=$(find ~/src ~/.files ~/work ~/Documents/edu ~/Documents/notes ~/Documents/src -mindepth 0 -maxdepth 2 -type d | fzf)
          fi

          if [[ -z $selected ]]; then
              exit 0
          fi

          selected_name=$(basename "$selected" | tr . _)
          tmux_running=$(pgrep tmux)

          if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
              tmux new-session -s $selected_name -c $selected
              exit 0
          fi

          if ! tmux has-session -t=$selected_name 2>/dev/null; then
              tmux new-session -ds $selected_name -c $selected
          fi

          tmux switch-client -t $selected_name
        '';
      };

      home.file."./.config/wezterm/wezterm.lua" = {
        recursive = true;
        text = ''
          local wezterm = require("wezterm")
          local config = wezterm.config_builder()
          local launch_menu = {}

          config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }
          config.enable_tab_bar = true
          config.use_fancy_tab_bar = false
          config.tab_bar_style = {}
          config.audible_bell = "Disabled"
          config.window_close_confirmation = "AlwaysPrompt"
          config.default_workspace = "home"
          config.window_decorations = "TITLE"
          config.scrollback_lines = 3000
          config.window_background_opacity = 0.8
          config.window_padding = {
            left = 0,
            right = 0,
            top = 0,
            bottom = 0,
          }

          config.inactive_pane_hsb = { saturation = 0.5, brightness = 0.5 }
          config.disable_default_key_bindings = true
          config.leader = { key = "y", mods = "CTRL", timeout_milliseconds = 2000 }
          config.keys = {
            {
              key = "L",
              mods = "LEADER",
              action = wezterm.action.ShowLauncherArgs({ flags = "LAUNCH_MENU_ITEMS" }),
            },
            { key = "a",          mods = "LEADER|CTRL", action = wezterm.action.SendKey({ key = "a", mods = "CTRL" }) },
            { key = "phys:Space", mods = "ALT",         action = wezterm.action.ActivateCommandPalette },
            { key = "c",          mods = "LEADER",      action = wezterm.action.ActivateCopyMode },
            { key = "L",          mods = "LEADER",      action = wezterm.action.ShowDebugOverlay },
            {
              key = "s",
              mods = "LEADER",
              action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
            },
            {
              key = "v",
              mods = "LEADER",
              action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
            },
            { key = "h", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Left") },
            { key = "j", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Down") },
            { key = "k", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Up") },
            { key = "l", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Right") },
            { key = "q", mods = "LEADER", action = wezterm.action.CloseCurrentPane({ confirm = true }) },
            { key = "z", mods = "LEADER", action = wezterm.action.TogglePaneZoomState },
            {
              key = "v",
              mods = "CTRL",
              action = wezterm.action.PasteFrom("Clipboard"),
            },
            { key = "t", mods = "LEADER", action = wezterm.action.SpawnTab("CurrentPaneDomain") },
            { key = "[", mods = "LEADER", action = wezterm.action.ActivateTabRelative(-1) },
            { key = "]", mods = "LEADER", action = wezterm.action.ActivateTabRelative(1) },
            { key = "n", mods = "LEADER", action = wezterm.action.ShowTabNavigator },
            { key = "m", mods = "LEADER", action = wezterm.action.ActivateKeyTable({ name = "move_tab", one_shot = false }) },
            {
              key = "r",
              mods = "LEADER",
              action = wezterm.action.ActivateKeyTable({ name = "resize_pane", one_shot = false }),
            },
            {
              key = "e",
              mods = "LEADER",
              action = wezterm.action.PromptInputLine({
                description = wezterm.format({
                  { Attribute = { Intensity = "Bold" } },
                  { Foreground = { AnsiColor = "Fuchsia" } },
                  { Text = "Renaming Tab Title...:" },
                }),
                action = wezterm.action_callback(function(window, _, line)
                  if line then
                    window:active_tab():set_title(line)
                  end
                end),
              }),
            },
            { key = "w", mods = "LEADER", action = wezterm.action.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },
            {
              key = "W",
              mods = "LEADER",
              action = wezterm.action.PromptInputLine({
                description = wezterm.format({
                  { Attribute = { Intensity = "Bold" } },
                  { Foreground = { AnsiColor = "Fuchsia" } },
                  { Text = "Enter name for new workspace" },
                }),
                action = wezterm.action_callback(function(window, pane, line)
                  if line then
                    window:perform_action(
                      wezterm.action.SwitchToWorkspace({
                        name = line,
                      }),
                      pane
                    )
                  end
                end),
              }),
            },
          }

          config.key_tables = {
            resize_pane = {
              { key = "h",      action = wezterm.action.AdjustPaneSize({ "Left", 1 }) },
              { key = "j",      action = wezterm.action.AdjustPaneSize({ "Down", 1 }) },
              { key = "k",      action = wezterm.action.AdjustPaneSize({ "Up", 1 }) },
              { key = "l",      action = wezterm.action.AdjustPaneSize({ "Right", 1 }) },
              { key = "Escape", action = "PopKeyTable" },
              { key = "Enter",  action = "PopKeyTable" },
            },
            move_tab = {
              { key = "h",      action = wezterm.action.MoveTabRelative(-1) },
              { key = "j",      action = wezterm.action.MoveTabRelative(-1) },
              { key = "k",      action = wezterm.action.MoveTabRelative(1) },
              { key = "l",      action = wezterm.action.MoveTabRelative(1) },
              { key = "Escape", action = "PopKeyTable" },
              { key = "Enter",  action = "PopKeyTable" },
            },
          }

          for i = 1, 8 do
            table.insert(config.keys, {
              key = tostring(i),
              mods = "LEADER",
              action = wezterm.action.ActivateTab(i - 1),
            })
            table.insert(config.keys, {
              key = "F" .. tostring(i),
              action = wezterm.action.ActivateTab(i - 1),
            })
          end

          wezterm.on("update-right-status", function(window, _)
            window:set_right_status(window:active_workspace())
          end)

          return config
        '';
      };
    };
}
